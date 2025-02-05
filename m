Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC72149DE8;
	Wed,  5 Feb 2025 13:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763815; cv=none; b=kB19JwPCPBgJY0OyApe8nYT5vaf+cN/U0Ba/cR73wR1eYqiGm9uEzmQzGm19rux5s8yHRjhsL5VkQI4H5axfWelOyzg6co/mLDTK22fIczo0NuyOw/q8gwYDLOUeQNYMgcE6WKemXdSDlCkMu6hZN1MWNBWu+JiYF2+1oEZIEhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763815; c=relaxed/simple;
	bh=qM8FfnsHoF6xKrPMiXs9E9H8nWL3IzV/NcR6O5hQXuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFJlESrp4SVJmK10TzGW2OcMzhl+WBD2Z06QyZ9KpYrgDlfpvBHe7Y/50hbZHb5bvlDF1mr/8TCDfWfv4IgE/HtU1ds+cbDq+GrAS5uHY4dX4oVStgo3w4DeAK8F2/71gDRqytpKDZ+HdESzBKxSD1CMKbVTmVD0DupWi4/IFXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GnIZlSke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GnIZlSke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F33C4CED1;
	Wed,  5 Feb 2025 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763815;
	bh=qM8FfnsHoF6xKrPMiXs9E9H8nWL3IzV/NcR6O5hQXuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnIZlSkehegPNMQ73ViCLW9C3Vcyn/NLPbAPg76OIEMas/L6G3ZUn5jUm6UUdIu2F
	 OTgjY0nmlNvy3AS99fAyhRTJHU4fSIFQjSey49dmC9OtINmo+HaX8jjP6xU8YY2YgH
	 Ok4dRsZV7pNxiKLNP5VRtmyNhpJ8LeTQGCK8lkEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/393] wifi: mt76: mt7915: Fix mesh scan on MT7916 DBDC
Date: Wed,  5 Feb 2025 14:40:27 +0100
Message-ID: <20250205134424.429879254@linuxfoundation.org>
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

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit f21b77cb556296116b1cce1d62295d13e35da574 ]

commit c4f075582304 ("wifi: mt76: mt7915: fix command timeout in AP stop
period") changes the behavior of mt7915_bss_info_changed() in mesh mode
when enable_beacon becomes false: it calls mt7915_mcu_add_bss_info(...,
false) and mt7915_mcu_add_sta(..., false) while the previous code
didn't.  These sends mcu commands that apparently confuse the firmware.

This breaks scanning while in mesh mode on AsiaRF MT7916 DBDC-based cards:
scanning works but no mesh frames get sent afterwards and the firmware
seems to be hosed.  It breaks on MT7916 DBDC but not on MT7915 DBDC.

Fixes: c4f075582304 ("wifi: mt76: mt7915: fix command timeout in AP stop period")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://patch.msgid.link/20240927085350.4594-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 4fd5fd555191a..d2429247c3b66 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -614,8 +614,9 @@ static void mt7915_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC)
 		set_bss_info = vif->cfg.assoc;
 	if (changed & BSS_CHANGED_BEACON_ENABLED &&
+	    info->enable_beacon &&
 	    vif->type != NL80211_IFTYPE_AP)
-		set_bss_info = set_sta = info->enable_beacon;
+		set_bss_info = set_sta = 1;
 
 	if (set_bss_info == 1)
 		mt7915_mcu_add_bss_info(phy, vif, true);
-- 
2.39.5



