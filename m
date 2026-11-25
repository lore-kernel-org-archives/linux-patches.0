Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621022;
	b=djhchlDShvG/vRM+K9n4ka4+ExqYYxDlELz5yPSSFantRu7QcSlnVqYIb8RsPgQSnE8e
	 esK8njgB9otyzKP8WN5yRgg9dCJBpYbfNWBqyy7lsRS7ykTIU6tj/PT2TzqufJ5j4ixRs
	 BK/RsIck3W05jwNfK0nbm+CLfp5pTT9xTQLIQzpDFJRTN17yyO1fZ/FSQbRZkaqrQVndG
	 0H5OnfGSiNbjaHaw2EPwgpgjxb9WF5ViUojr/Zjl4ZxV2VY4V/ZTxSafJdQ75fhXUCANy
	 aHbyrbr5yY/9qLp4F0bo9w8DWX1QcuqTiHlON81P5f+CKGi/fOQ8Zh+Frghyo5O2hhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ejkJ829O/dZVLhghSUn07Qr6MnoCClvrc9xcH8JHbls=;
	b=gPpxO1U1KSq18su3An+fIFeWr9l233qzQgI9rI/7XHkgdQecrWBQeGIJWQBRmFfBG2lv
	 qAtJfE4PscGesL7L0ObCQt/ftzQpk6vRIF33tqoRPe/SPHdUNnlMtZ6dqeX5Pk21fkY6H
	 0WbOyCh6H4kJJKC8AaPI/RXkwHQPjmvasf1mdV7WDN9DbUJVyCR8MF4TR/1amOQFWL3y9
	 u4nn2ddNxjB2tFHN3Csf7tM1NiZqEIb04zXpUulEWKBlE0LtqpYvUefA/7Hj6lZtAjiUD
	 RjFLaB98BXJON6ZmIFgURSTMlv9YuJQ5lF42qW5iGleA7Sy1an61c9Ce7iv7Siqc35w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rL1S9PCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D1606A682;
	Wed, 25 Nov 2026 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rL1S9PCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB79C1F000EF;
	Wed, 25 Nov 2026 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621022;
	bh=ejkJ829O/dZVLhghSUn07Qr6MnoCClvrc9xcH8JHbls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rL1S9PCMPayxlvo6ihp9N/t6W8WlDuZuHoF+/apx5j3CXN74ZDx6zME7vpflBD0/I
	 0OD89nvRFPgA+DYwFq/FcZNpQRo1yaCwbnIffyFVtXlfVhEYNkaQhZVHtSpHz4neDK
	 /jt/5l0NRcNSuYlQMff/rMC7nvQ1RW+fRfFzb3o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/990] net: ethernet: mtk_wed: free up rings during detach
Date: Wed, 25 Nov 2026 15:24:22 +0100
Message-ID: <20261125143824.314846531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 5b8d12512cbd3495dbd8c38e8047bb5d716f0f3f ]

During __mtk_wed_detach, rx_ring and tx_wdma aren't freed up.

Fix this by add them to mtk_wed_free_rx_rings.

This patch is pulled from mtk-openwrt-feeds to address Sashiko's review
and edit to rely on ring->desc instead of an extra flag.

Link: https://github.com/mediatek/mtk-openwrt-feeds/blob/main/25.12/files/target/linux/mediatek/patches-6.12/999-wed-04-Fix-reinsert-wifi-module-cause-memory-leak-issue.patch
Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/message/179000700034.2160803.10594281691384015089%40kernel.org
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-3-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 202ab2f34d56a..e81a62c6029c2 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -949,6 +949,14 @@ mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
 static void
 mtk_wed_free_rx_rings(struct mtk_wed_device *dev)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->rx_ring); i++)
+		mtk_wed_free_ring(dev, &dev->rx_ring[i]);
+
+	for (i = 0; i < ARRAY_SIZE(dev->tx_wdma); i++)
+		mtk_wed_free_ring(dev, &dev->tx_wdma[i]);
+
 	mtk_wed_free_rx_buffer(dev);
 	mtk_wed_free_ring(dev, &dev->rro.ring);
 }
-- 
2.53.0



