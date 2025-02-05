Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E198815198D;
	Wed,  5 Feb 2025 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764777; cv=none; b=G3b73Y/FNhDVB3VtseigvB1+RYmMR9eZYMkpytl+gxz3ILnGgECA5q3di5aW13+6L5Z/FcFTfJrw8xSToCsihCegQXFL+nU+ueqfmOnypnjipLuFDhgvEY5RR1ct67V1SZw54TmRr83swFWUblPwplTWfTOcdovdkL8moB5bFt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764777; c=relaxed/simple;
	bh=h59i6n/24j6t1aVZ89szr0mvx/YsBPfZybnKYn+RqF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8i4lnFlcKZs9kIE87GG3IhAGE44VVIMW4EnQTjSvDV80/LgSMAfNU+atmC5SlwihVpYsQIzHqegxSB4k2cD6Q0gXVNw4/FBmrtE8FhrHs+1K2mQMk4KIysA5AIz/8VMZ2dctZmmd+MEJMjWvhld+L1tZnGa09uh3Dz5rXbEp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdCblQ4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdCblQ4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CFFC4CED1;
	Wed,  5 Feb 2025 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764776;
	bh=h59i6n/24j6t1aVZ89szr0mvx/YsBPfZybnKYn+RqF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdCblQ4WYGaVw1WSGXfassB6yxQZ9s5DVG0iCnnQkCT/kJ40RPVTbbbvDnvwNY+gY
	 3n7WmFp2yAXf7MOa5/aoOwpo0fKyAWVVzSbpW5nT5zeOu0mWsch2LXInw9X9RN0DQ4
	 +UpZAulLUcixcD5CX9fiqT62EUiYoElLTwN9CNAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/590] wifi: mt76: mt7915: Fix mesh scan on MT7916 DBDC
Date: Wed,  5 Feb 2025 14:38:32 +0100
Message-ID: <20250205134501.291498557@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d75e8dea1fbdc..b7884772e2f40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -619,8 +619,9 @@ static void mt7915_bss_info_changed(struct ieee80211_hw *hw,
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



