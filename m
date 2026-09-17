Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31544E2F08;
	Thu, 17 Sep 2026 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661016; cv=none; b=PEJk4Ak8aCDRDJ8Hnm6i878lae37vWKOrNKEUYIbJ5IYv4bXhwgJuu5p3aV/rTKgmyESGVt7HXEiIgCPu0RtgzF/GHzmDYjm9UouCVASM3OYI++dDreDnUxqIjuW2CxME93QQa/Dpd+NV5y92qjsf8/zXsDtl/5zNkB8KeqYEUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661016; c=relaxed/simple;
	bh=QC2zDP00j1s+BEVkQLvvl5xQBSTD7LRI7sG42uNuiSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HfjTvsQF6wCOWFMRGMcIM05rRWgYmi+kt7iGn2kTZZTbmwdYWk1GSL4OL4PM28QIHDGCQwdQoKxgD9SyxEKnmqNVi1YKrfQ/dp4ci7lFU1RUW/4hx5LCv35cRTZ45lIib9Q+1b8eORKtWWfI9KA62v/94rA/wfqxs7koK+rj2AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsm1KDFN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsm1KDFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053881F000FF;
	Thu, 17 Sep 2026 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661015;
	bh=lzUyPjTOYxnJYwJF+HtaI85EkfOOOAGSwGEYBT7h0tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lsm1KDFNNXPWFpw9m2kx8aU7VtvBHKDQ+geAhToBfta4SUh6q2nMZa4V6V2vp9epC
	 dtY5+RKAwROOlNfGlRSPGoct5dcfyWvpjmuNdsQQKKOqqjJzSVQ1h4XdW8djdwL0nv
	 AL4infVil3GeZZcjnBj9MD9RMGAAt6MMJRPBonAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0054/1250] wifi: mac80211: avoid out-of-bounds access in monitor
Date: Thu, 17 Sep 2026 15:57:29 +0100
Message-ID: <20260917151553.400836589@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 03c41203ee5a833a9d7a7630be190830cede29d8 ]

In NAN, we don't know on what band the frame will be sent. Therefore we
set info->band to NUM_NL80211_BANDS. However, this leads to out-of-bound
access in ieee80211_add_tx_radiotap_header when we try to access the
sbands array.

Fix it by not accessing the array if the band is NUM_NL80211_BANDS.
This means that we will not report rate info for legacy rate in NAN.
But nobody really cares about it.

Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260504101829.346c9893d136.I15919027597c04ec35c6217db6e52e2a605e5cfc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/status.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 4b38aa0e902a8..8716eda8317d1 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2021-2025  Intel Corporation
+ * Copyright 2021-2026  Intel Corporation
  */
 
 #include <linux/export.h>
@@ -295,9 +295,10 @@ ieee80211_add_tx_radiotap_header(struct ieee80211_local *local,
 						 RATE_INFO_FLAGS_VHT_MCS |
 						 RATE_INFO_FLAGS_HE_MCS)))
 			legacy_rate = status_rate->rate_idx.legacy;
-	} else if (info->status.rates[0].idx >= 0 &&
-		 !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
-						  IEEE80211_TX_RC_VHT_MCS))) {
+	} else if (info->band < NUM_NL80211_BANDS &&
+		   info->status.rates[0].idx >= 0 &&
+		   !(info->status.rates[0].flags & (IEEE80211_TX_RC_MCS |
+						    IEEE80211_TX_RC_VHT_MCS))) {
 		struct ieee80211_supported_band *sband;
 
 		sband = local->hw.wiphy->bands[info->band];
-- 
2.53.0



