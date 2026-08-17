Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E892D0C7E;
	Mon, 17 Aug 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977267; cv=none; b=GaabczEbmm/hj068mHTDDesFAxpghUFuHNmvcvSwZpZEjA8wb32k//im3cUVCfS3gcN3/jOQJyvXby5KHHUpE+p7rlYMfV1IWGdEgnCixp1hbvOfNAfmyIMpzp6GQxOZE/MPG69OAtdPzg/vluPpXtKZeLsF9VMO/l6w06ZQDkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977267; c=relaxed/simple;
	bh=V+pokWywnNMbiN9KOXDLP5UslsmKaMtfdUCLf5blHro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9OTupznn6xq6x+Cs/ZZYA3AGz5Xjs9LNMI1VnIdogWtINCMuUbt6EzgYchUUiIV0G+jFT9MHcwNFkyn4NsdGFHLyJUmBqeiNgPX7DbUIa30t/fDZZng2IlMQVoikH7ZfnRm7Xa4/V+TIKDe1vSW9zYk6gHPtYvoFFKl8Jt1u7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXh1Hxuv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXh1Hxuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4771F000E9;
	Mon, 17 Aug 2026 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977266;
	bh=0Uc95s5DdkFrB7PAIRGP0MZOqBE8Ks3snQD8uPfLpQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXh1HxuvnSnY3TaoAE5lf4EY+GSSvESqawyjT9ZRkRflSFg/Q5cYU2bCwqh3A1CW3
	 8oXU7QW3v7wvL0u0ikFCd3alSdIiaMxrmlss9ayQROVQNzVNTJefOxNEiFa18IdvuR
	 l3AiEPPHqDgt/6M+uzpA03vmuXDItafP+IdOokgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/456] wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
Date: Mon, 17 Aug 2026 15:30:22 +0200
Message-ID: <20260817132549.188342809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ No mt7615_rx_check() on this tree, so only the mt7615_queue_rx_skb()
  hunk applies, and mt7615_mac_tx_free() takes the skb rather than
  (data, len), so the guard frees it here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 2f0ba8a75d71bc..ee90ec27f09faa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1601,6 +1601,10 @@ void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 		dev_kfree_skb(skb);
 		break;
 	case PKT_TYPE_TXRX_NOTIFY:
+		if (!mt76_is_mmio(mdev)) {
+			dev_kfree_skb(skb);
+			break;
+		}
 		mt7615_mac_tx_free(dev, skb);
 		break;
 	case PKT_TYPE_RX_EVENT:
-- 
2.53.0



