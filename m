Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094815696E;
	Wed,  5 Feb 2025 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763963; cv=none; b=ZRFfT6lHQ/ZpbSWWpGI/7zife8lCoe63lI+GCSIzBZvc1NjODYrahxY7+ABULqHVqjHry+eMVKudtbPmnWh6onX2Qp5KHuHYmig/cM6fxlQ5/JQo7I35EIIk/r5sE/DbXATjRfEX1mn93Ph5kqhQUSlnlBxi4lRRBQa6FcYQKMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763963; c=relaxed/simple;
	bh=Xwtfu7RbZOX/C8pwOTw3yTwwosx0T6VPijoM0bC5EUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCTGJb2rZlVp7sJr7m/+nFyTK1tqAZuKpx+NFlY6bK9ckbmkQHg3cw2J4dUfjnJVdnB556FyxL2v/tMPQU+uxraHfzAZlmTj8nJ2QvpKPRsSaoghcRYZj9hBcXBdNK2nl7wchI7b618Goc6tesEYbfdPNBAmfLiSvPHi+nBpydQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=knjXEcJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="knjXEcJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AEEC4CED6;
	Wed,  5 Feb 2025 13:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763962;
	bh=Xwtfu7RbZOX/C8pwOTw3yTwwosx0T6VPijoM0bC5EUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knjXEcJJO1zAEVAGaRI7lBMC48dAckYmXpvtNx2ETg1sJmTSWNUljQmSEz1oL16Nf
	 Dzbnll+/S0tsfkgwW8PS1QHGMIKXkErbvCgP9PrQCyZCWwTP4RBrSYSCjC5E9yt0A+
	 Y9xkE3AwFs84lv/9QGQTxstAORwvXMCTDbqMja2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/393] wifi: mt76: mt7915: fix omac index assignment after hardware reset
Date: Wed,  5 Feb 2025 14:40:42 +0100
Message-ID: <20250205134424.999074790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit cd043bbba6f9b71ebe0781d1bd2107565363c4b9 ]

Reset per-phy mac address slot mask in order to avoid leaking entries.

Fixes: 8a55712d124f ("wifi: mt76: mt7915: enable full system reset support")
Link: https://patch.msgid.link/20241230194202.95065-12-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 55c52c2d97b09..92d7dc8e3cc55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1439,9 +1439,11 @@ static void
 mt7915_mac_full_reset(struct mt7915_dev *dev)
 {
 	struct mt76_phy *ext_phy;
+	struct mt7915_phy *phy2;
 	int i;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
+	phy2 = ext_phy ? ext_phy->priv : NULL;
 
 	dev->recovery.hw_full_reset = true;
 
@@ -1470,6 +1472,9 @@ mt7915_mac_full_reset(struct mt7915_dev *dev)
 
 	memset(dev->mt76.wcid_mask, 0, sizeof(dev->mt76.wcid_mask));
 	dev->mt76.vif_mask = 0;
+	dev->phy.omac_mask = 0;
+	if (phy2)
+		phy2->omac_mask = 0;
 
 	i = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7915_WTBL_STA);
 	dev->mt76.global_wcid.idx = i;
-- 
2.39.5



