Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624069;
	b=qOgLZ49dYfeQ2WnRvGGjkunR7FmMxiV6GItHsjvqeSPV6Q8JxNn5TdMbcIz/K2odgcCB
	 NON5TkQGo2ZWi8AvcJUwVorZyTO+10YafLkRZ2tGx4DkVkKsNpRa39hH35r6GX/8jc1tW
	 ViJOWrcZ/JCL5xabN3gsQB1/SiRZ6xJRp6ibQgeBwsTJqFR+s97jHEVxwLIVfxosxqzDp
	 l8DRspz7Ntnt834Q1F0FTUZnFHks3LBVqaqg/VNc95FO/pqoKsiqftmsRvCNh0o03Vpuc
	 tB2qkEqGqWvePxSi5dvCtNQ8Sdx+ae6M8lRWW7rMjfpCd7IYIhWqsbelwPMP8Wzcrdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkOVhEITHgkSlMRx1sIIlE0t4xk/izdRi2Gi84mH4X8=;
	b=En27pXjz364LnXMj0QMLc9eGfYyQd3GU9j3EEY1NgJZEBk5sjof/YnyCC5x44hd7+/Ta
	 0gHzvVi7PEaDyGiFE4heCAft34dq+yt93l1xrSbx9MkQpL5CMlZ8AW0JPVWHaY55wTUk+
	 H9TKx1oBgLSLPOuc9e1V4tNlcicwuNT3AIwE62k5eTlEGCwRb3DzBvCETF4DAMldM5sX0
	 /k9Q06aaB/RP3B9/7RNXkWw3b5qNCaq7AST/cmUi5WalzRkelTlGQLKMvzGXfyh81xybK
	 kvYK9l/YRfggdV2FO1BzUM47ZDb+m9e6lUvgZ8hZQCTCQDMcUDov1A5b+qyrYuNV32Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVvfqyVx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5029606A31E;
	Wed, 25 Nov 2026 16:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVvfqyVx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92AB71F000C0;
	Wed, 25 Nov 2026 16:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624069;
	bh=hkOVhEITHgkSlMRx1sIIlE0t4xk/izdRi2Gi84mH4X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVvfqyVxNmJs+2QZZM3Iz4v92Lfa3FL+xRcMe+4oa12wacnniUeo0eAXy+Uq+dS2i
	 M39d0LSgMS8pvDcPorHbd0Arw1U4FViRcacSj/jj9rDEDquFfsavtXg064FHgctLbG
	 kJqYxbGZ6KLj1JQaIGx0+CuX/5VFYL4l1NPIJKTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/816] net: ethernet: mtk_wed: fix reset condition for rx wdma
Date: Wed, 25 Nov 2026 15:27:02 +0100
Message-ID: <20261125143850.934433402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 7180a42d8e616f919dcff4b90a13b9a5ecea665b ]

In mtk_wdma_rx_reset, currently only resets the CPU index of the rings
that doesn't have a descriptor. This is wrong because no descriptor
means the ring is not configured.

Also mtk_wed_start makes sure that all rx_wdma rings are set up this
would lead to no ring getting their CPU index reset.

Fix this by inverting the reset condition so allocated rings will be
reset.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724172040.1653-1-hujy652%40gmail.com
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-2-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 544bf35990c17..c2c684fbbb164 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -250,7 +250,7 @@ mtk_wdma_rx_reset(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
-		if (dev->rx_wdma[i].desc)
+		if (!dev->rx_wdma[i].desc)
 			continue;
 
 		wdma_w32(dev,
-- 
2.53.0



