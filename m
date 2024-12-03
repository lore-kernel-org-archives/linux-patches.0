Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38081F6691;
	Tue,  3 Dec 2024 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238402; cv=none; b=CSP7dnqGhO8Qkzlt5qg3b8v4nQkDdDBeQ1c+9LcpecW16ZavkT+68x/CJoazi/nKjmyFUIVG0iFHbFzzL2viZH6oFOoRsgV1Zv7Hjx7or/kqk8xOlPFFWFZf4sEr30gU6TVEWHB7oCYhz9XOqC6xa0//9FPLFEyyljnspsb2pl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238402; c=relaxed/simple;
	bh=Ua63dryGmgxMDRoM+ctls4w7qKPCUxFogohmhj2vkwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnezzGUHmBj/96jcYaoAOJHNiOEkPxXEvOY5ePOvIbUfBlgTav2hD1aheoI58V/wyamhCDlN6Hs/nvQtQoddiam8NvsPqV/5QHjSqvk0FXjcBnW100y+o8szVsByCr/BAA1/f/SIeMZx4HBTdmIOtwcNA3cNHrDwUY/Nf1VXPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEHiPfll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEHiPfll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E197DC4CECF;
	Tue,  3 Dec 2024 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238401;
	bh=Ua63dryGmgxMDRoM+ctls4w7qKPCUxFogohmhj2vkwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEHiPflljkqxFl9ouwms2gxGUWpXwAHLJZB910lyC4bhM1fvbpGY70OvXTRu8/UOY
	 sCh9lt6f9vVcHb0B5U78vk92xbc5JmLC2nfqkZNDlQx2/3FEVkEF+WpqY7AE3QHXA9
	 zVh8NiLoQ7tcyiZvHOFCftjhwtL8GUfoqer+A/Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 264/817] wifi: cfg80211: check radio iface combination for multi radio per wiphy
Date: Tue,  3 Dec 2024 15:37:16 +0100
Message-ID: <20241203144006.093842803@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit bd9813d13be439851a7ff3e6372e53caa6e387a6 ]

Currently, wiphy_verify_combinations() fails for the multi-radio per wiphy
due to the condition check on new global interface combination that DFS
only works on one channel. In a multi-radio scenario, new global interface
combination encompasses the capabilities of all radio combinations, so it
supports more than one channel with DFS. For multi-radio per wiphy,
interface combination verification needs to be performed for radio specific
interface combinations. This is necessary as the new global interface
combination combines the capabilities of all radio combinations.

Fixes: a01b1e9f9955 ("wifi: mac80211: add support for DFS with multiple radios")
Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Link: https://patch.msgid.link/20240917140239.886083-1-quic_periyasa@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 64 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 10 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index b2b512923ecee..263c91e91fc39 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -603,16 +603,20 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 }
 EXPORT_SYMBOL(wiphy_new_nm);
 
-static int wiphy_verify_combinations(struct wiphy *wiphy)
+static
+int wiphy_verify_iface_combinations(struct wiphy *wiphy,
+				    const struct ieee80211_iface_combination *iface_comb,
+				    int n_iface_comb,
+				    bool combined_radio)
 {
 	const struct ieee80211_iface_combination *c;
 	int i, j;
 
-	for (i = 0; i < wiphy->n_iface_combinations; i++) {
+	for (i = 0; i < n_iface_comb; i++) {
 		u32 cnt = 0;
 		u16 all_iftypes = 0;
 
-		c = &wiphy->iface_combinations[i];
+		c = &iface_comb[i];
 
 		/*
 		 * Combinations with just one interface aren't real,
@@ -625,9 +629,13 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 		if (WARN_ON(!c->num_different_channels))
 			return -EINVAL;
 
-		/* DFS only works on one channel. */
-		if (WARN_ON(c->radar_detect_widths &&
-			    (c->num_different_channels > 1)))
+		/* DFS only works on one channel. Avoid this check
+		 * for multi-radio global combination, since it hold
+		 * the capabilities of all radio combinations.
+		 */
+		if (!combined_radio &&
+		    WARN_ON(c->radar_detect_widths &&
+			    c->num_different_channels > 1))
 			return -EINVAL;
 
 		if (WARN_ON(!c->n_limits))
@@ -648,13 +656,21 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 			if (WARN_ON(wiphy->software_iftypes & types))
 				return -EINVAL;
 
-			/* Only a single P2P_DEVICE can be allowed */
-			if (WARN_ON(types & BIT(NL80211_IFTYPE_P2P_DEVICE) &&
+			/* Only a single P2P_DEVICE can be allowed, avoid this
+			 * check for multi-radio global combination, since it
+			 * hold the capabilities of all radio combinations.
+			 */
+			if (!combined_radio &&
+			    WARN_ON(types & BIT(NL80211_IFTYPE_P2P_DEVICE) &&
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
-			/* Only a single NAN can be allowed */
-			if (WARN_ON(types & BIT(NL80211_IFTYPE_NAN) &&
+			/* Only a single NAN can be allowed, avoid this
+			 * check for multi-radio global combination, since it
+			 * hold the capabilities of all radio combinations.
+			 */
+			if (!combined_radio &&
+			    WARN_ON(types & BIT(NL80211_IFTYPE_NAN) &&
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
@@ -693,6 +709,34 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	return 0;
 }
 
+static int wiphy_verify_combinations(struct wiphy *wiphy)
+{
+	int i, ret;
+	bool combined_radio = false;
+
+	if (wiphy->n_radio) {
+		for (i = 0; i < wiphy->n_radio; i++) {
+			const struct wiphy_radio *radio = &wiphy->radio[i];
+
+			ret = wiphy_verify_iface_combinations(wiphy,
+							      radio->iface_combinations,
+							      radio->n_iface_combinations,
+							      false);
+			if (ret)
+				return ret;
+		}
+
+		combined_radio = true;
+	}
+
+	ret = wiphy_verify_iface_combinations(wiphy,
+					      wiphy->iface_combinations,
+					      wiphy->n_iface_combinations,
+					      combined_radio);
+
+	return ret;
+}
+
 int wiphy_register(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-- 
2.43.0



