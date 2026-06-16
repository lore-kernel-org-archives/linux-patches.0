Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116F169AD2;
	Tue, 16 Jun 2026 17:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632062; cv=none; b=tlvAiauRx5oQ5GYaL5qhdrXwh5VylzNp2f9kQIkdCYZcEsGow9fYsp1RCP6SW/4ir0yzq5+cFqRWMiM0f7fKj02UMysM/4Bvw1ljhos6Q05cbsTBtIOOkZ/sjtD6jPB9hiUqDzb9CzmELjTFFg9/XhfHeVPFRJ7dK2EofMxpeZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632062; c=relaxed/simple;
	bh=URF75w1GIqnEhrQsizzGXf/tL7mLcRdlfn1e2UtuhVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFTCMNZoAhyAHiy83KjQDqwxtFvVh1Uasu+P/xxC0A20n9mEvG7xscjP64WnAOkfia20H+ZfP5G4YY/xvo0QDFxt2A6SRTL8TOlKzAz14G48F2656ZPX/nt3CUm/hZlQfIOUqqFl+Hxn0pyY/E0nI13uMOOKDsub8Smzn1lTqi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVBoG0Ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVBoG0Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C47B1F000E9;
	Tue, 16 Jun 2026 17:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632061;
	bh=1sc8pSEZESWAyMwhRqyWm7xr5Tnt3HljhLAgA1d+3rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVBoG0Oxm7zp3bZivnDRRpL6VPo0cnu9lCIPmB2WcA2CD2+cgX3PgBR0dnsFmcUgX
	 WGZorbkd9WIlzOyQxS3QUlJK67JbWKdS8EkgSHJdqsqDZfsOj6fhUiIfc0/QjSv35w
	 r9p/zPZrDD6DqXhrOZX1sloh9y7IuBtc0bdIgbWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 306/522] net: mv643xx: fix OF node refcount
Date: Tue, 16 Jun 2026 20:27:33 +0530
Message-ID: <20260616145140.195852458@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 4aacf509e537a711fa71bca9f234e5eb6968850e upstream.

Platform devices created with platform_device_alloc() call
platform_device_release() when the last reference to the device's
kobject is dropped. This function calls of_node_put() unconditionally.
This works fine for devices created with platform_device_register_full()
but users of the split approach (platform_device_alloc() +
platform_device_add()) must bump the reference of the of_node they
assign manually. Add the missing call to of_node_get().

Cc: stable@vger.kernel.org
Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602073414.22500-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2781,7 +2781,7 @@ static int mv643xx_eth_shared_of_add_por
 		goto put_err;
 	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	ppdev->dev.of_node = pnp;
+	ppdev->dev.of_node = of_node_get(pnp);
 
 	ret = platform_device_add_resources(ppdev, &res, 1);
 	if (ret)


