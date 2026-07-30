Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B221FE44A;
	Thu, 30 Jul 2026 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422773; cv=none; b=sB6GJyNGj5dYJ0Lp1+U/3IPmp8SDiyEMmNKiiLIJnIOBbVu9lU/qOiOJd+gqXz6b7oEgkdK/P2QONOxxB11jHAOnOVOuJU9yNwEHBxhTGiMu/N5w3PZqNFqBwAsWTWVlEizPCdIcUy0XQ6w9Xl+HJAGwGJ+aA3PW33CJsx2aq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422773; c=relaxed/simple;
	bh=SdPHUWKMncNjmDmeeawou0KHTGs4e83XjL83/ZHBMVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6F/2txFLDb9/lzEcQEf4icNIFhGJAfDVjt/K8V1xk0sw65380/uMiLZHwmwR8QvGHGUepP6bspU4JFlVmCLfj3dCTH59WOL6C9pIqDXrOTeNG6AhOJiHSD+1c5GJCLFLbYnMP9uTUE0ahJ1bHbnfp9gd2iaEA9EWObGl8alK3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8Clu+NP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8Clu+NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805C51F00A3A;
	Thu, 30 Jul 2026 14:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422772;
	bh=DNMMYb9lFexRHbBCIks7Lr2OA6JcpB3qWLQtrWR+rw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8Clu+NP0zsO3agUdJDe3rgIT5wvmDucr/i3tW/NOK/S8b81mzyYXBu0sJMdbv1QE
	 E/P/aN9I6RBPjmHraVN2dcKOkgnDHuytUzSDrFqtGXFT2PNtaxFeOM7JpmtyJ7mVYO
	 DUtmmSLNSpt8gtkh9doxHurDJVfVQ/StCr79CZfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.1 549/744] wifi: mt76: mt7925: drop TXRX_NOTIFY on non-mmio buses
Date: Thu, 30 Jul 2026 16:13:42 +0200
Message-ID: <20260730141455.944325709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit feeff151c83e7f0ffcdedcad5343852d23d1f6e1 upstream.

PKT_TYPE_TXRX_NOTIFY is an mmio-only event, but mt7925_rx_check() and
mt7925_queue_rx_skb() dispatch it to mt7925_mac_tx_free() on every bus.
mt7925_mac_tx_free() cleans the DMA tx queues with
mt76_queue_tx_cleanup(), which calls queue_ops->tx_cleanup(). Only the
mmio queue ops implement that callback; on USB it is NULL, so a
TXRX_NOTIFY there calls a NULL pointer in the RX worker:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:0x0
  Call Trace:
   mt7925_mac_tx_free+0x58/0x350 [mt7925_common]
   mt7925_rx_check+0xe2/0x130 [mt7925_common]
   mt76u_rx_worker+0x1b9/0x620 [mt76_usb]

Drop the event on non-mmio buses via mt76_is_mmio(), as in
commit 5683e1488aa9 ("wifi: mt76: connac: do not check WED status for
non-mmio devices").

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260627191336.20223-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1194,8 +1194,9 @@ bool mt7925_rx_check(struct mt76_dev *md
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
-		mt7925_mac_tx_free(dev, data, len); /* mmio */
+		if (!mt76_is_mmio(mdev))
+			return false;
+		mt7925_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
 		for (rxd += 4; rxd + 12 <= end; rxd += 12)
@@ -1231,7 +1232,10 @@ void mt7925_queue_rx_skb(struct mt76_dev
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
-		/* PKT_TYPE_TXRX_NOTIFY can be received only by mmio devices */
+		if (!mt76_is_mmio(mdev)) {
+			napi_consume_skb(skb, 1);
+			break;
+		}
 		mt7925_mac_tx_free(dev, skb->data, skb->len);
 		napi_consume_skb(skb, 1);
 		break;


