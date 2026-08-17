Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F7F44237B;
	Mon, 17 Aug 2026 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979433; cv=none; b=VYuonJL42tLHhgN/scCejPyh2LH2Z/wooXXcwbScG2e5Hl06ZSmVBXG2kI4w+GyUNhxAWlqprK9VWTOFq0imdgmMGlUVPSxykNI3s39PufwzrKnzburxrUYfWfXmEdGUwo2oiYQ8lYWaFvH0Z4HkCXo4U3+AYA/9yE8Uo7hvMOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979433; c=relaxed/simple;
	bh=//XCzSVP+/XSt1akq4zEkucfN8BeIfEckHuylkM4iJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TexfI/9XzEGQf+P+lPzGyrimmhepCLhsRZCYqc37OuE8JoSyoAA9wAiAU2LAOoZRV0CTa5247xrltTq+P4YGcLOacRhyPFrydh3HT5juZPn66y1eDJXrCY2acIS724FY8y7SL+ZB6d6cfLyo74MrlAXdTt87NHGBK3JgRd4kMLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5dFL9eT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5dFL9eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23081F000E9;
	Mon, 17 Aug 2026 15:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979432;
	bh=hTyWpPyqHe8f7asIvHXHld2cdQqa6z1/9To9Xw7bg6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5dFL9eT0kkFOqqnTDlrDvWU+y/iH7cCEYitd8ZDMAQZy70nfEeCvnE4NIsVf6Qh6
	 2zoCMte92VLeSHRSjrpTqxWH0S1PoS7o13WgFaRPf7CeM/KmyThagAZ8qGXd/kcFd7
	 iyA5p6W4aIzeesgR1RfrlVsVqv/a7H7cX2c6P4tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 223/609] wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses
Date: Mon, 17 Aug 2026 15:28:39 +0200
Message-ID: <20260817132551.551894505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit da4082e91acabc1498611ed8ccc53f0610baefc6 upstream.

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7921_rx_check() and
mt7921_queue_rx_skb() dispatch it to mt7921_mac_tx_free() on every bus.
mt7921_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on USB and SDIO it is NULL, so
a TXRX_NOTIFY there calls a NULL pointer in the RX worker:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:0x0
  Call Trace:
   mt7921_mac_tx_free+0x64/0x310 [mt7921_common]
   mt7921_rx_check+0x5f/0xf0 [mt7921_common]
   mt76u_rx_worker+0x1b9/0x620 [mt76_usb]

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260627191336.20223-2-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -678,8 +678,9 @@ bool mt7921_rx_check(struct mt76_dev *md
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
-		mt7921_mac_tx_free(dev, data, len); /* mmio */
+		if (!mt76_is_mmio(mdev))
+			return false;
+		mt7921_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
 		for (rxd += 2; rxd + 8 <= end; rxd += 8)
@@ -708,7 +709,10 @@ void mt7921_queue_rx_skb(struct mt76_dev
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
+		if (!mt76_is_mmio(mdev)) {
+			napi_consume_skb(skb, 1);
+			break;
+		}
 		mt7921_mac_tx_free(dev, skb->data, skb->len);
 		napi_consume_skb(skb, 1);
 		break;


