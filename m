Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624072;
	b=dUYf8AY5KbLgp/OOQeohqtI9ngZ81bo9UePDX2ue1fqBbUjzzZfeCnR7qYhyJwVTsr5A
	 Qs6PoPnh/OsLTiNTIDfNamivjK5ks1qR8f+yhzuXyKBhgw6qU0/GVJvFBCpETxpKPiLj5
	 F7BtJ/DkmEMiHO3ec0aUz2tizwZpafZpaJ/4gGrjBvI83RkHmcCyhahfpQV3h5P9V36Ve
	 UtlqyI4yOfZ/d3uMYkIjtcBK+UECXQEMzBRXISWqLdOI+VFAzZJexaQRX75LUjR3Mpt05
	 dgmFiOEIRNgouIP1TVaXicLZBlHr7BqF1Ac5FHPAU8YwrlUqcNnx2sKS4yuRz993lfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7YP/JoEvP8B4qHIsd+6H8YL3SsoC9Ndux/grht1O04=;
	b=N6ww5f9W/lxWk+OstP39aQiJTbPJ+kldure5Mq1MxNcxNb/Io4KYO5PQa2o+3zDszoxR
	 r6RBvj3cp/BKb+MoQU+qIaNOYK8Cuir7M9NRt+/6L7lKMzxqy5/yGuwyw3Nwiw1dhYZOj
	 fHctDxTkzQC+MVJdto1H23+34Ld0pt4nzEfwT5AVqLI4qb5KCqx05vOz4NGn0cxEjQrCo
	 v0KntTt6o2QFximUKcaPGil25Ch14uM8ioiHQ3m1EU/vwew2O7C1hHH9DyoUrDJnzhJMq
	 +fsHKhVRQquG4dB6w8tiuLyktlPdHl2y8b34gKVAz2gOItFA6H8ROLyKIy+soR1gCSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fig0j71V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD9A606A321;
	Wed, 25 Nov 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fig0j71V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158ED1F000D0;
	Wed, 25 Nov 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624072;
	bh=d7YP/JoEvP8B4qHIsd+6H8YL3SsoC9Ndux/grht1O04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fig0j71VZMNTFD6F7CN0FJs31hiGZ1g8p+EoWW6zI0iuiTcEznthQsCvftvW1oJM5
	 sHWzcIjmmGgsel7xpfgqPtf6HMOPI6Bm8asWXkiubt8mM7sOQlGMzQLh+5QG+WZJhh
	 VUT+kRkOM/KVRN0dPS7guIWfEox8ecoJQCZJ/d4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/816] net: ethernet: mtk_wed: free up rings during detach
Date: Wed, 25 Nov 2026 15:27:03 +0100
Message-ID: <20261125143850.958173241@linuxfoundation.org>
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
index c2c684fbbb164..005b653a7e3a9 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -942,6 +942,14 @@ mtk_wed_free_ring(struct mtk_wed_device *dev, struct mtk_wed_ring *ring)
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



