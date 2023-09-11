Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3592E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBD4C433C8;
	Mon, 11 Sep 2023 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440565;
	bh=QNpMX8HcGzBmvvAwqVRz/z/SExMqk0UqqqjJee9IidA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5fhzvjA0vdgRojytVDjNVd86z4dCTRXE1L/YQoGM4QNfvTAJMqReQK8SkU4pqmLl
	 zok9NMdjr6DlL+rc+MfcfqbzoAmpWMeVPrcjl7w8+VBGWlLKRf8vz+M9kftsB9p2pz
	 RM0hO311BNzZfzCAySkOG4LPC9Iy04XFxXQaRNYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 080/739] wifi: mt76: mt7996: fix header translation logic
Date: Mon, 11 Sep 2023 15:37:59 +0200
Message-ID: <20230911134653.349262818@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit c55b4e788f1dd6ca89cc97cf291d2a03b0b96de1 ]

When header translation failure is indicated, the hardware will insert
an extra 2-byte field containing the data length after the protocol
type field. This happens either when the LLC-SNAP pattern did not match,
or if a VLAN header was detected.

The previous commit accidentally breaks the logic, so reverts back.

Fixes: 27db47ab1f47 (wifi: mt76: mt7996: enable mesh HW amsdu/de-amsdu support)
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 9b0f6053e0fa6..25c5deb15d213 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -836,14 +836,19 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, struct sk_buff *skb)
 		skb_pull(skb, hdr_gap);
 		if (!hdr_trans && status->amsdu && !(ieee80211_has_a4(fc) && is_mesh)) {
 			pad_start = ieee80211_get_hdrlen_from_skb(skb);
-		} else if (hdr_trans && (rxd2 & MT_RXD2_NORMAL_HDR_TRANS_ERROR) &&
-			   get_unaligned_be16(skb->data + pad_start) == ETH_P_8021Q) {
+		} else if (hdr_trans && (rxd2 & MT_RXD2_NORMAL_HDR_TRANS_ERROR)) {
 			/* When header translation failure is indicated,
 			 * the hardware will insert an extra 2-byte field
 			 * containing the data length after the protocol
-			 * type field.
+			 * type field. This happens either when the LLC-SNAP
+			 * pattern did not match, or if a VLAN header was
+			 * detected.
 			 */
-			pad_start = 16;
+			pad_start = 12;
+			if (get_unaligned_be16(skb->data + pad_start) == ETH_P_8021Q)
+				pad_start += 4;
+			else
+				pad_start = 0;
 		}
 
 		if (pad_start) {
-- 
2.40.1



