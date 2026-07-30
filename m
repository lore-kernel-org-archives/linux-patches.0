Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4E3409121;
	Thu, 30 Jul 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424665; cv=none; b=CLUZGzFaYyke9MzoEqCnPNalPW20tGCK7ecxkLgWoxduwgPOP4zZrr9uBWtAkrGzYn5L5SohuS1C71twPT/5wYZfb/gI42z+i3+AvtcUyaeumXFiPCVp986Df6RiZlSX0CtI+/hvpmuNz0eh7A73k9bjKUokqEG/KS77eO17K+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424665; c=relaxed/simple;
	bh=SCZUlGjLjsgb4+0+zdkstvwUwU87h/g4j1UVYY3Br3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkDk0ZrBXqcMI7nF9yUr6Ga/QdLFErOPCh9NzF9qUXi2OTueUkeX65ufWqe780eMRlZqayZQWB3xwwyGFX3Gk+k/CX1sM5cqySGCjGGmRTxabyytJFJXLyPfy59aZblQ5GZFdjurZ4TorrivSEhHvHyeaNj10800+MLpI9OOPlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ETEhHjuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ETEhHjuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4B1F00A3A;
	Thu, 30 Jul 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424663;
	bh=ZsfeXt6U4xA8q3+myueb47G2J5tjQwc6d/yav1MVsoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ETEhHjuoezq8LfJb8LYAWBVslmXoE/USRVWkOeNWXfFAEvkEX4tVarmE9d/sND/oZ
	 Upn2tTRcxjpKxsqwDiO7dubgzoGd5/xnd8Xn0uYy2ywbIzVLSE/I8J+A9KWARCqWFT
	 3jit0himbfM6rtVjDFHs6UCUVaoUtAVyxXCZAspQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 456/675] wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
Date: Thu, 30 Jul 2026 16:13:06 +0200
Message-ID: <20260730141454.824947270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit 39afc46c0243d10b7795e6e6cf4ae91f41732120 upstream.

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7615_rx_check() and
mt7615_queue_rx_skb() dispatch it to mt7615_mac_tx_free() on every bus.
mt7615_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on the mt7663 USB and SDIO
buses it is NULL, so a TXRX_NOTIFY there calls a NULL pointer in the RX
worker. Same defect as the mt7921 and mt7925 patches in this series.

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: eb99cc95c3b6 ("mt76: mt7615: introduce mt7663u support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260627191336.20223-4-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1601,6 +1601,8 @@ bool mt7615_rx_check(struct mt76_dev *md
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev))
+			return false;
 		mt7615_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
@@ -1634,6 +1636,10 @@ void mt7615_queue_rx_skb(struct mt76_dev
 		dev_kfree_skb(skb);
 		break;
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev)) {
+			dev_kfree_skb(skb);
+			break;
+		}
 		mt7615_mac_tx_free(dev, skb->data, skb->len);
 		dev_kfree_skb(skb);
 		break;


