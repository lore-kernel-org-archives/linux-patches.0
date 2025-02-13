Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AF3156C71;
	Thu, 13 Feb 2025 14:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458705; cv=none; b=NapTtfQ8p51GltfGkV+f3w0QUuKVgIHeZ8HJ/PBzmRHAbgr/LHY1uEkEPyBcFbylzX1GFxWkKT5+exlRoNm+Zg9z9NBQZtzov0WP9G0xYmY4W2bpw2rl0CPUapJ9/k5JRXyO9BjOEpsCcIc2XHBPYfMcFWaTxNP/g40BHP0+x/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458705; c=relaxed/simple;
	bh=IXTwsyQUp84lizxnXK7HYEmuJgvm+prr3xawzyu4UwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXvB16mZwghVa0mu/2m4p7WafQ9gEIErIhVK+SezkXnPrBCLr47dxveun2UwrCVBOTyKOBNOz8sDQRZhE5EFrY/CtxN3VzvfSCVHiqBgYBelPlY08pgSzWBik1fOYpDZ1kTk3xRTJCmAh9MMOokDjlsRqkrYNCPtPAC5jCmkI5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPeuT55U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPeuT55U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68294C4CED1;
	Thu, 13 Feb 2025 14:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458704;
	bh=IXTwsyQUp84lizxnXK7HYEmuJgvm+prr3xawzyu4UwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPeuT55UA7Jmz75nI50KHMoDkUHLzn4G9kDIIlTHOhqhyQAnVt51aq5mRcIPMQWXY
	 IYcIZmbW2SKhSGgKr5wGrUllk8uiormO5SalToWpgKAQ4s9Wov+ObY/pcgGFmS//oO
	 ZQ9AolNNOJ5iMk9fl224OYGBDUmTEc1TgA8mM/ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 054/443] wifi: ath12k: ath12k_mac_op_set_key(): fix uninitialized symbol ret
Date: Thu, 13 Feb 2025 15:23:39 +0100
Message-ID: <20250213142442.706792465@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit ad969bc9ee73fa9eda6223be2a7c0c6caf937d71 ]

Dan reported that in some cases the ret variable could be uninitialized. Fix
that by removing the out label entirely and returning zero explicitly on
succesful cases.

Also remove the unnecessary else branches to follow more the style used in
ath12k and now it's easier to see the error handling.

No functional changes.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/7e7afd00-ad84-4744-8d94-416bab7e7dd9@stanley.mountain/
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20241126171139.2350704-10-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 57 +++++++++++++++------------
 1 file changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index ef2736fb5f53f..e8639ad8761a2 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4378,6 +4378,7 @@ static int ath12k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (sta) {
 		ahsta = ath12k_sta_to_ahsta(sta);
+
 		/* For an ML STA Pairwise key is same for all associated link Stations,
 		 * hence do set key for all link STAs which are active.
 		 */
@@ -4400,41 +4401,47 @@ static int ath12k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				if (ret)
 					break;
 			}
-		} else {
-			arsta = &ahsta->deflink;
-			arvif = arsta->arvif;
-			if (WARN_ON(!arvif)) {
-				ret = -EINVAL;
-				goto out;
-			}
 
-			ret = ath12k_mac_set_key(arvif->ar, cmd, arvif, arsta, key);
-		}
-	} else {
-		if (key->link_id >= 0 && key->link_id < IEEE80211_MLD_MAX_NUM_LINKS) {
-			link_id = key->link_id;
-			arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
-		} else {
-			link_id = 0;
-			arvif = &ahvif->deflink;
+			return 0;
 		}
 
-		if (!arvif || !arvif->is_created) {
-			cache = ath12k_ahvif_get_link_cache(ahvif, link_id);
-			if (!cache)
-				return -ENOSPC;
+		arsta = &ahsta->deflink;
+		arvif = arsta->arvif;
+		if (WARN_ON(!arvif))
+			return -EINVAL;
 
-			ret = ath12k_mac_update_key_cache(cache, cmd, sta, key);
+		ret = ath12k_mac_set_key(arvif->ar, cmd, arvif, arsta, key);
+		if (ret)
+			return ret;
 
+		return 0;
+	}
+
+	if (key->link_id >= 0 && key->link_id < IEEE80211_MLD_MAX_NUM_LINKS) {
+		link_id = key->link_id;
+		arvif = wiphy_dereference(hw->wiphy, ahvif->link[link_id]);
+	} else {
+		link_id = 0;
+		arvif = &ahvif->deflink;
+	}
+
+	if (!arvif || !arvif->is_created) {
+		cache = ath12k_ahvif_get_link_cache(ahvif, link_id);
+		if (!cache)
+			return -ENOSPC;
+
+		ret = ath12k_mac_update_key_cache(cache, cmd, sta, key);
+		if (ret)
 			return ret;
-		}
 
-		ret = ath12k_mac_set_key(arvif->ar, cmd, arvif, NULL, key);
+		return 0;
 	}
 
-out:
+	ret = ath12k_mac_set_key(arvif->ar, cmd, arvif, NULL, key);
+	if (ret)
+		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int
-- 
2.39.5



