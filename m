Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8169D477E3B;
	Mon, 31 Aug 2026 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184418; cv=none; b=UpZHySTz+hZ6flvD/02f9La8q0z2NmpiFTlfkF+oW0npHjVKxB4CYatiGhwDT08zBj73zM6cBjBlUgo/WJno78UQJNMdAr7o9ng0Rq4tuOGVslfp4+/zHZoE3LRCBCDjfwiInBim6sA+TaIQTEuQnHarkz37Qj+PYBZkcYzGHLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184418; c=relaxed/simple;
	bh=wNV11fEeBTxcYyMdZEbDOwuWky82aDhornSs1Hna9NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS3ilSR7KbuR4/q8+Z5jULQzaN7gy8r57IWZAoPEnGcynMDeAXqZWlZczz43mP8AklfD/EhXQWGd504RBOFefnr3HyZrVnnp13EuBfVK33si2gMSm6wTficJnxoXrBRr+Q/M7Pf1xHB1XIw3rZe+UsXtlzDA+SLK2yp0PnDq4PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cIPaO9BV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cIPaO9BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B391F000E9;
	Mon, 31 Aug 2026 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184417;
	bh=z6zgxZNW298Xn9H2lG/JsQCJSn9js89OhetWyFkCNLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIPaO9BVy210wvNSt4MiOKiyMyfQ+jVkezpBKRtQ7GJ9PysUeQ/qbdD/KdH/SI+cC
	 kaZpfsR1/PUsW/trmmf8dTjCthmSZxhxW+TNMd6UQ+u4XxtuyBM++0cWoVInkQf8yR
	 GbtYYKlgR+/bhkVOons67OUp0QcQxQMETXuawHAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 98/99] wifi: mt76: mt7925: ensure tx headroom in usb_sdio_tx_prepare_skb
Date: Mon, 31 Aug 2026 15:35:07 +0200
Message-ID: <20260831133404.565361126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit ef3e34874d2332d0f63e72c2c35ce5c93568c125 upstream.

mt7925_usb_sdio_tx_prepare_skb() pushes a TX descriptor and a USB
header onto every skb and assumes the headroom for them is already
there. That holds for locally generated traffic, where mac80211
reserves hw->extra_tx_headroom, but forwarded frames are sent through
ieee80211_8023_xmit(), which does not reserve it. Bridge a wired
interface to an mt7925u AP and the first forwarded frame that arrives
short panics the kernel:

 skbuff: skb_under_panic: len:415 put:4 tail:0x19b end:0x640 dev:wlan1
 kernel BUG at net/core/skbuff.c:212!
 Call trace:
  skb_panic+0x58/0x60 (P)
  skb_push+0x58/0x60
  mt7925_usb_sdio_tx_prepare_skb+0xf8/0x1b8 [mt7925_common]
  mt76u_tx_queue_skb+0xa0/0x1f8 [mt76_usb]
  __mt76_tx_queue_skb+0x54/0xe8 [mt76]
  mt76_txq_schedule.part.0+0x204/0x478 [mt76]
  mt76_txq_schedule_all+0x50/0x80 [mt76]
  mt792x_tx_worker+0x68/0x100 [mt792x_lib]
  __mt76_worker_fn+0x84/0x150 [mt76]

Whether a given setup hits it depends on how much headroom the ingress
netdev leaves in its rx skbs. Reproduced on a Raspberry Pi 5 bridging
onboard ethernet to a Netgear A9000; originally reported on an MT7986
router running OpenWrt. Nick Morrow's testing on a Pi 4 (bcmgenet),
which leaves more headroom, helped narrow the trigger to the ingress
path.

The same bug was fixed on mt7921 by commit 98c4d0abf5c4 ("mt76:
mt7921: don't assume adequate headroom for SDIO headers"), but mt7925
was copied from mt7921 without the fix. Add the same guard here.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Cc: stable@vger.kernel.org
Link: https://github.com/morrownr/mt76/issues/52
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260715023348.59506-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1432,6 +1432,10 @@ int mt7925_usb_sdio_tx_prepare_skb(struc
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
+	err = skb_cow_head(skb, MT_SDIO_TXD_SIZE + MT_SDIO_HDR_SIZE);
+	if (err)
+		return err;
+
 	if (sta) {
 		struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 


