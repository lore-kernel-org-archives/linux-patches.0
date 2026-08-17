Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A292E3C76A0;
	Mon, 17 Aug 2026 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979430; cv=none; b=on3OKPuiWaAoA+mMgPZ3pMh0tNG6XjnaBplFH5eBh2JeDonVPlVGu7iE9Pxj4Mf8gv3O3Qt6Mh30wjaES81v0leaxdhLea4L3VHJ95Gw9goVDk4hdwzpAYwBWD5KM/3Gas4lzYNkjkM5o9TTCQOSXjUnSSIGlb4y9CANWrzAvkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979430; c=relaxed/simple;
	bh=lWj0YGiSadADqjnJBnMwDklD0JO6aI/hTzc0a+voBhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGHEIIX8tVoTkJ2A5bmRQ3d70E6F4txxeQl8NzJTvruIvxwneHPwK91bg7HQqhJ77EgQEocjEXo8ycJP5DvL2iUo6peWkdQoMqMSzE/iIcRF+k882fOHf8NEiJ+A2xEV03jWag1hHhKTnNdLIdefEffkOqlUOqMWi4cxYxUYqEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEiWHaGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEiWHaGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0714D1F000E9;
	Mon, 17 Aug 2026 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979429;
	bh=nfIcWO16fLyJ9mq4jQoVAoiei31Plf5pTeqIXa1pVaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEiWHaGIjZVa8TTr1tDo0Rl63xzjLx41Ji31cGHAZJG1NORifCNbKaMNOIwF928y3
	 j/HFmJmLbgEtGBrGSMsObh7YNur2BOT5G5+2zp+HnQOVP9d1Yjv7PW0VGp70YUEE6F
	 8hgT0ZnpRN82zoAga/LQhYnsNWyzvHQ9cpfBYfPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.1 222/609] wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
Date: Mon, 17 Aug 2026 15:28:38 +0200
Message-ID: <20260817132551.519892414@linuxfoundation.org>
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
@@ -1618,6 +1618,8 @@ bool mt7615_rx_check(struct mt76_dev *md
 
 	switch (type) {
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev))
+			return false;
 		mt7615_mac_tx_free(dev, data, len);
 		return false;
 	case PKT_TYPE_TXS:
@@ -1651,6 +1653,10 @@ void mt7615_queue_rx_skb(struct mt76_dev
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


