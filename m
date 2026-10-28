Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208451;
	b=Z4e5xxCaxEjPj1VP9dEnOhK/BU0I4JjNF6hPrBSZEqbQ9gP7AgLCZgjL2x45NfvcBevy
	 8VnKn/dbZfN/T7RfLwue07IU8/MeD51ekCFkJvaTDOVlVn6pCr3oCdCt3WXD3BEedq2+0
	 CrH7ajBE7z0HxcWegCt9lFVWl9l0Z4QpLAokBVd2mRReNW6GHvu1g8gDN1+Iyc8I0c4Ao
	 dgeONW6Hj+rAfWlGTPWZpUfv+LRoiqavSnswGTwfEMbT/XfJDfSTvwUw0cmVBWMfsFmY/
	 4+8U2hHV3vmOHQTxE3ohLqAEvNJcoaC41fB/MWnpaRvgx0jHIjeDwyhnPPQohbxBd5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4RJWDxqnf1z2rVshUrQN6oIp4MoQI49E/xpRrd/2M4=;
	b=0n4ylAJeJ332s26x+0uT/bJF117X2BX3gCWDVecLk/+yQQxBQtNdSVQ2riVLiVZn5L1F
	 NARPk1HzCcU4/l8Zy/PxyD7PqmI8teniLG6qw2aqpJVmGORkvQwb+TwAvWWlNaAm6WsaJ
	 hRSX/EEHhPzO322pJsFT5bknENbsTFRYagTsu/FhIDPTFRyVCcFMmVcYhx195+KqQL+l2
	 cOkVHqOLY1QPgceFxYWTAfylanKQfUq8k+3IRUfZjMcPRd+PoSOI+2pFZTf8LiCzPy61V
	 4fGBJX11eiV3hoJFxj+5Z3CJyRVQmzlIxBxzrqfFCR6M/tUX+jdUf2eFI+5K33+Zq/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o80s6pjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5F9606A31A;
	Wed, 28 Oct 2026 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o80s6pjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA07B1F01825;
	Wed, 28 Oct 2026 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208451;
	bh=f4RJWDxqnf1z2rVshUrQN6oIp4MoQI49E/xpRrd/2M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o80s6pjl6mGG7/kK88+/kjiHlnhEK89+22pDwCsqTjA1afMjTQxJkezl6AMt4vOMj
	 SlsmcLX20RlqvUFBIvDbMNVwaX5p2R8vuVBr3gT+eH7v2gShpQTwd8g/Wa0vyqHdMz
	 HMZ5N/n5P7anL2e2DgFKyo2Jtm+F+CPJijvqXgMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/516] net: ena: fix MMIO read buffer leak on probe failure
Date: Wed, 28 Oct 2026 17:54:36 +0100
Message-ID: <20261028170006.451191046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ adjusted context for missing PHC, devlink, and customer-metrics cleanup in Linux 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d054ad138d5f0..221315404cfcc 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4356,6 +4356,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_com_mmio_reg_read_request_destroy(ena_dev);
 err_free_region:
 	ena_release_bars(ena_dev, pdev);
 err_free_ena_dev:
-- 
2.53.0



