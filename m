Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210706;
	b=YbDhY1Iv7qWpA3JwMHipsbqhNot/yQ5kVMWr6giobWfmIVwMSuFdL8oAboTvdYqhCIC1
	 p+VP+9ZXrepwwZEev3imgAOx4j5bGmzMOppA3x9HIUiYNuD7kQjW4MCwVmgcSdETYTlRG
	 8Ad9j5iz6kjEpsXEEJc91+5ailQvTae5Qx89VKedb+KMse7QirVRTPf5tO4m4PZQJI/2M
	 ZDw0U9l2DEKXX9NqoietcXG/QTjt4AwgxJRaBgz6EoVnY7qGcGlqFPHG3v42q5zap3GP0
	 XO5IoIUYaoJRjY6f6vgRMrR6xpygQjCTQoLplE+Gf06pHhC42vxt2ciejg8+c0zhtag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ouDuyE4b4D+0lGgIaua9rlk/ef5hoWHGgzo/dOdwxO8=;
	b=nlzK8ZEMfaWd0P5jGGxyUf8qZGWgn88HY2nBBAn8HpHVJFWBltNMo2Xmvlk7/eJevljc
	 C9yUUO+AaCQFFqb4w35AOSbCGC+9q0PBElTCOSKFHCnvqH9oLNawVNcSI1h0wjggrqduo
	 gIjAQx15Ak5DAxgvAuiZxlLc82Deor9jvF63BIihV4HPZZPjSgL/IulbCuRpNRxGox142
	 KAjvrtv3Illk61bPeyeJdogJFsAVUUEFx7YCXT1FWgg8VNgyy4X9Skg+DZ4ojJT6ByQIR
	 bOAtU0BOfc6ppE70bSkB0dkI8HZBKIRnPQr/uwKSQR0SUayRv4pWgxmDyxCHZdNSJdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtwGfpfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9662D606A31A;
	Wed, 28 Oct 2026 18:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtwGfpfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A4C1F01825;
	Wed, 28 Oct 2026 18:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210706;
	bh=ouDuyE4b4D+0lGgIaua9rlk/ef5hoWHGgzo/dOdwxO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtwGfpfAfhrvyIMC2037WtdSrxiAVHFNZTTMwk1pn9obZcHHCGbBZacgKRbN0gX1a
	 p76mWLH9C5n94JhftTf27OH9X3JVtPxjwtvzmTAezvnOvqnFhQbCpf8uu2GqPnpH1J
	 /qLHpVzy7WwAKzfZhtByE87dg2fBw/aCTr2V2uRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/571] net: ena: fix MMIO read buffer leak on probe failure
Date: Wed, 28 Oct 2026 17:54:26 +0100
Message-ID: <20261028170010.842850262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9476b4468862927297c94c440863cd8ed1e7cc83 ]

ena_device_init() initializes the MMIO read mechanism with
ena_com_mmio_reg_read_request_init(), which allocates a coherent DMA
buffer for MMIO read responses.

The normal removal path releases this buffer through
ena_com_mmio_reg_read_request_destroy(). However, if ena_probe() fails
after ena_device_init() succeeds, the error path destroys the admin
resources and eventually frees ena_dev without destroying the MMIO read
request, leaving the coherent DMA buffer allocated.

Call ena_com_mmio_reg_read_request_destroy() in the probe error path
before releasing the remaining device resources.

This issue was found by manual code inspection.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260921154202.471662-3-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjusted cleanup context due to missing PHC, devlink, and customer-metrics code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index be030e50ecb71..5831f7bd81c23 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4517,6 +4517,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_com_mmio_reg_read_request_destroy(ena_dev);
 err_netdev_destroy:
 	free_netdev(netdev);
 err_free_region:
-- 
2.53.0



