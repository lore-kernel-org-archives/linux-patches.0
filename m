Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C95470E80;
	Mon, 31 Aug 2026 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184147; cv=none; b=C34lK1zUm1u8qrRe85g5zCQQ+KfDTyJ9HWHyoN5f/5fJ+Twfwf2DTM/wHLLzmIRxWqy+8CId8ObFF/NL5zckqMh8bo4Ky3CA1YBgnr6iDtR0Yx1w1PWN4trezBIgKRRJYX6qrdXCMyqBVwntKJWkILfEL0xVFiYqZ5B0z+5qo4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184147; c=relaxed/simple;
	bh=7VQrG02b9vXc4lZOV6Mg2/7U4fbBDBfmnVQuv5vwPyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9tZBjd0wJ7QgVx6jYoh2N4rhoW7Y9XF7nrXE6hYdfi3xkLQRwDV7iDZFVPIo5yWws2lr59OXE7929sf/OAa3bVxwgsH2ofo6PIgzBhRJ98O1fLnfgTwqS6D5s4lviA9TZk2v0ZiW4E19G1KxYu2Vq3WuAnxKZeDo4C0RkM5Bho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQ8I1hYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQ8I1hYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AA81F00A3F;
	Mon, 31 Aug 2026 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184144;
	bh=NDIfb4snk+OPsY3GiGcuo+KltBwNFKsg3/2r1wvs4FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQ8I1hYV2xwFWlbqaLduYXR6+/Hai5GAQ/YZCp1+h6LReWMhktDxX1EpolkBDt/Ow
	 O1YaKnk4opdK1x4p7+R5WXjBkzVSMfqUS2+FibuogbE/WvDlKG5vZGjAifLArS0gFW
	 WQJInFdtYT6l0hSrGFLUsbUkl5/V3AHov7M2noKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 82/83] wifi: mt76: mt7925: ensure tx headroom in usb_sdio_tx_prepare_skb
Date: Mon, 31 Aug 2026 15:34:58 +0200
Message-ID: <20260831133403.566530378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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
@@ -1425,6 +1425,10 @@ int mt7925_usb_sdio_tx_prepare_skb(struc
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
+	err = skb_cow_head(skb, MT_SDIO_TXD_SIZE + MT_SDIO_HDR_SIZE);
+	if (err)
+		return err;
+
 	if (sta) {
 		struct mt792x_sta *msta = (struct mt792x_sta *)sta->drv_priv;
 


