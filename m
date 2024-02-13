Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF711EB22;
	Tue, 13 Feb 2024 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845784; cv=none; b=rgfZTUYhNT0XMeUtUD3iP1+dJqSYcPhfBcvyWCGzGRKqbNU/Lwvzy1phsAupqVU08INFmW6IhmeSyjOLNPuf9bAWfzaAahELIF4gGQhN9ITU792fB17yAwzrumRWe5yONofuFVCr+jbJW5EwliIdM9O3FttqRlha2Pv6qwBj8DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845784; c=relaxed/simple;
	bh=8WGA5cyXmNYbXEolk7AGz5SYtmkoFdngU3WdA0zBKPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyAApv3Yt9DYKujUwvPCTV+7DrnOjVR5WQ3g8Dg7DCg2o9uO63Oin1dsRPbMuzVuZRyLDTfxvLBwXt5BhwVktHeqnyIN4CqmMy5utA73HZSY4YJdtxoI62CyZDFpA0g6cOyd/JxNoSojrB1xLrqleve+0ckXpToVXRjZ+ZM9Z8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9dTmEwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9dTmEwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80CC433F1;
	Tue, 13 Feb 2024 17:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845784;
	bh=8WGA5cyXmNYbXEolk7AGz5SYtmkoFdngU3WdA0zBKPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9dTmEwXkVcxklexwBOrwN7YFTJP56+RW3JfUfGUJ+Jre7n83ljWtqTpK+W8cGSfV
	 jO+x23CZU9VEyLDpnA6Mfbw4DDD/we4SVfEJetWE+hLhogaVyWsaPNXiuPsOGlATJi
	 eucL8O6i9LabnF0CneVtT+W0tIRR+c9IOJg8xBpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 027/124] wifi: mac80211: fix unsolicited broadcast probe config
Date: Tue, 13 Feb 2024 18:20:49 +0100
Message-ID: <20240213171854.523739287@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 178e9d6adc4356c2f1659f575ecea626e7fbd05a ]

There's a bug in ieee80211_set_unsol_bcast_probe_resp(), it tries
to return BSS_CHANGED_UNSOL_BCAST_PROBE_RESP (which has the value
1<<31) in an int, which makes it negative and considered an error.
Fix this by passing the changed flags to set separately.

Fixes: 3b1c256eb4ae ("wifi: mac80211: fixes in FILS discovery updates")
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://msgid.link/20240129195729.965b0740bf80.I6bc6f5236863f686c17d689be541b1dd2633c417@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index eb1d3ef84353..bfb06dea43c2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2022 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -987,7 +987,8 @@ static int
 ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_unsol_bcast_probe_resp *params,
 				     struct ieee80211_link_data *link,
-				     struct ieee80211_bss_conf *link_conf)
+				     struct ieee80211_bss_conf *link_conf,
+				     u64 *changed)
 {
 	struct unsol_bcast_probe_resp_data *new, *old = NULL;
 
@@ -1011,7 +1012,8 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(link->u.ap.unsol_bcast_probe_resp, NULL);
 	}
 
-	return BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;
+	*changed |= BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;
+	return 0;
 }
 
 static int ieee80211_set_ftm_responder_params(
@@ -1450,10 +1452,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	err = ieee80211_set_unsol_bcast_probe_resp(sdata,
 						   &params->unsol_bcast_probe_resp,
-						   link, link_conf);
+						   link, link_conf, &changed);
 	if (err < 0)
 		goto error;
-	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata, link_conf);
 	if (err) {
@@ -1525,10 +1526,9 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 	err = ieee80211_set_unsol_bcast_probe_resp(sdata,
 						   &params->unsol_bcast_probe_resp,
-						   link, link_conf);
+						   link, link_conf, &changed);
 	if (err < 0)
 		return err;
-	changed |= err;
 
 	if (beacon->he_bss_color_valid &&
 	    beacon->he_bss_color.enabled != link_conf->he_bss_color.enabled) {
-- 
2.43.0



