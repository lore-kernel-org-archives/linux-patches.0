Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6635187DE;
	Wed, 30 Sep 2026 17:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788258; cv=none; b=OGWxm9Tz3kgnkV9AIUCztRJiGOalaWCKOtM8K6xppC1IQ5WjvD/UY4GYV8ezw7uCRePgz0WvnHBG1kiO9Y3IsvCFddMWnERyMCt93cMq8gJsPyZMbcwlsWUiFmVn8M1cnFddtic/tzeqrHegMwMHBOOhnt6eir0agE7rJwFJuF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788258; c=relaxed/simple;
	bh=vV/Q8+frWuxx5Irv80ZjLR5arhlOAKlyOccCUYIX/9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zoe4JkBHERW0F5LrBfsSKOFyMzhMtnp5sRW4o3y7mL31Pj2/suQ3SPwNl9VDTtiDm4QH/00Q83mp6lRqH7CstIhSFYpv2sO55e5dyEWJIeqv6piQdN8Bk0xQqukahr++i3V1ks9i5qwufEpUEfHUlTmVU8Q8fMgAmG1CkXBSA5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqLMQhap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqLMQhap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199621F000FF;
	Wed, 30 Sep 2026 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788257;
	bh=LnJ/r0+vsk/n/xH/+Up2xmMVsxW+Dv4Bh4wf2M1qxJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zqLMQhapkLdRV5vyhEypvAUkPKne+j2rjFILp6Cx9xWXYwfunaOBa7YxWM46X1l40
	 dHJS7g0C0dzApxVJOBguhmDfBpLYYbukIHP++ZegDTnBSyeDkYOXzEbVErNNB1xl8V
	 KBcGiIyh6QKxutyceLkyhDgVpGqL/EUtmHldfRB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/877] wifi: mac80211: use vif radio mask to limit ibss scan frequencies
Date: Wed, 30 Sep 2026 17:16:10 +0200
Message-ID: <20260930152416.018296965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 32ee616a7f8c36fa3ab00985ebd038c3487e721f ]

Reject frequencies not supported by any radio that the vif is allowed to
use.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/9d5c0b6b00a7ecef6a0ac6de765c0af00c8bb0e1.1728462320.git-series.nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: a7491b7efbd9 ("wifi: mac80211: don't warn when an IBSS has no channel to scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8675d2e99c564..07ce9cd35dab2 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1180,14 +1180,14 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				unsigned int n_channels)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret = -EBUSY, i, n_ch = 0;
+	int i, n_ch = 0;
 	enum nl80211_band band;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
 	/* busy scanning */
 	if (local->scan_req)
-		goto unlock;
+		return -EBUSY;
 
 	/* fill internal scan request */
 	if (!channels) {
@@ -1204,7 +1204,9 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 				    &local->hw.wiphy->bands[band]->channels[i];
 
 				if (tmp_ch->flags & (IEEE80211_CHAN_NO_IR |
-						     IEEE80211_CHAN_DISABLED))
+						     IEEE80211_CHAN_DISABLED) ||
+				    !cfg80211_wdev_channel_allowed(&sdata->wdev,
+								   tmp_ch))
 					continue;
 
 				local->int_scan_req->channels[n_ch] = tmp_ch;
@@ -1213,21 +1215,23 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (WARN_ON_ONCE(n_ch == 0))
-			goto unlock;
+			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
 	} else {
 		for (i = 0; i < n_channels; i++) {
 			if (channels[i]->flags & (IEEE80211_CHAN_NO_IR |
-						  IEEE80211_CHAN_DISABLED))
+						  IEEE80211_CHAN_DISABLED) ||
+			    !cfg80211_wdev_channel_allowed(&sdata->wdev,
+							   channels[i]))
 				continue;
 
 			local->int_scan_req->channels[n_ch] = channels[i];
 			n_ch++;
 		}
 
-		if (WARN_ON_ONCE(n_ch == 0))
-			goto unlock;
+		if (n_ch == 0)
+			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
 	}
@@ -1237,9 +1241,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 	memcpy(local->int_scan_req->ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
 	local->int_scan_req->ssids[0].ssid_len = ssid_len;
 
-	ret = __ieee80211_start_scan(sdata, sdata->local->int_scan_req);
- unlock:
-	return ret;
+	return __ieee80211_start_scan(sdata, sdata->local->int_scan_req);
 }
 
 void ieee80211_scan_cancel(struct ieee80211_local *local)
-- 
2.53.0



