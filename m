Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F1A1DF98B;
	Mon, 23 Jun 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713278; cv=none; b=FbdpGG17acAUoIOyhtwvWlxjOcc5aTe0mBGbPnpKIkIgA7s3piZLeRD315don2y2/9mlZTouhihTWGBj1USzeHzekYbILqMeg6Yep38wVs3WCBbW+R6xYQA5FoBsDkdRykHVQBaX3CwLexn0p+Y1xfO33whBv1asyAJ98Ozh0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713278; c=relaxed/simple;
	bh=MGVe8HzDs09gf3X8m9VwF+C3+t0lsqwzmtrtXajBQUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYOAKlpmPjgJQUadAq8Z4zQoOrQ5MHTbXJFy8M+34fryCw0y786Bkovt2QJoRbnB+CXvib/VolOAjft2tvW2jz9s1ErqjrxqGQDn+GwDrkARcmV9Yq3eN5k5PAvAUMxPvtwRvjY7HZfg7FbLmQoH/br6Ja9GjUiCCwlC31jgv9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjgQ2BH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjgQ2BH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9384AC4CEEA;
	Mon, 23 Jun 2025 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713277;
	bh=MGVe8HzDs09gf3X8m9VwF+C3+t0lsqwzmtrtXajBQUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjgQ2BH4DpLbSv79YoM2e25ews0Pixlcca86k38vgOtpZzO6U7WxzlzMVlBMgvmmV
	 29xvG3FXU06DtVpT2XYFU9+YfAJuSrXIqLpMEse1Jn6hce4JUYgN1cZgCHThO+9O9b
	 ZwzJzUMOuoYTADQrAb8JrZ/JaaKtanFBYEeXmn6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 318/592] wifi: mt76: mt7996: drop fragments with multicast or broadcast RA
Date: Mon, 23 Jun 2025 15:04:36 +0200
Message-ID: <20250623130707.995396956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 80fda1cd7b0a1edd0849dc71403a070d0922118d ]

IEEE 802.11 fragmentation can only be applied to unicast frames.
Therefore, drop fragments with multicast or broadcast RA. This patch
addresses vulnerabilities such as CVE-2020-26145.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-4-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index d89c06f47997f..2108361543a0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -647,6 +647,14 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 		status->last_amsdu = amsdu_info == MT_RXD4_LAST_AMSDU_FRAME;
 	}
 
+	/* IEEE 802.11 fragmentation can only be applied to unicast frames.
+	 * Hence, drop fragments with multicast/broadcast RA.
+	 * This check fixes vulnerabilities, like CVE-2020-26145.
+	 */
+	if ((ieee80211_has_morefrags(fc) || seq_ctrl & IEEE80211_SCTL_FRAG) &&
+	    FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3) != MT_RXD3_NORMAL_U2M)
+		return -EINVAL;
+
 	hdr_gap = (u8 *)rxd - skb->data + 2 * remove_pad;
 	if (hdr_trans && ieee80211_has_morefrags(fc)) {
 		if (mt7996_reverse_frag0_hdr_trans(skb, hdr_gap))
-- 
2.39.5



