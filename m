Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA415435A9E;
	Thu, 30 Jul 2026 15:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426928; cv=none; b=fcp9ITCzrCcwPOfPYqGHV8YeH7vvdQZibD8Zs77qszFRmcZep+SE4+ScNdN1fwcvHtoMXqDEw0neM7EEYqHHNtHHguQSV5xkItIOXl+WZo0hFEJmgWrtFKmc5ndpVRxEtY6mwtyrSLjZEKBLa9cGdzyeFym/gm9KS3wyhdi9MRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426928; c=relaxed/simple;
	bh=p/r2Y3KjOrg3zt+Ms8+4SusZKNQ1Ptx0h1kfkuHwtCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsqM07hhPluMDOo3YHmC07wZ4UFxRbeIEA0ffTTCDXa5V2D2XrHwFPjuAbfL7WOmCevRvZub6CyfV51HOlTPuHYpYyzNCgrRE6eRYhl9PYvAMqJodAFTiXVYCSW0EfpXfY7YJ4rMD/ZZ6UGfkVOntm7edg9KdoWwU5ygrV8LP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQnjyzMK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQnjyzMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B60E1F000E9;
	Thu, 30 Jul 2026 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426927;
	bh=aikdvjUobruwYOz4+6iqWazH3bgzt/DN969vH4itK1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQnjyzMKjJAfeAc+k+xpF195zHoyDLOQ/3hpZu+fKxmgRWIZAF5T0+7hxu4rbM30w
	 A40by5bOt6+3mxD0bwtTmv/ThkT4lx1TS5Joz5DVjdBc4X0Bx+JQN5Heu0qPqaQEhm
	 Pi/SVuP2rKvDeNxHFmhA95rR7QysaPqB/8pcpvlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 591/602] wifi: nl80211: fix nl80211_start_radar_detection return value
Date: Thu, 30 Jul 2026 16:16:23 +0200
Message-ID: <20260730141448.474524628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

commit 22159143ff99883667f340998cfbb52b4aaac14c upstream.

Since the wiphy_guard changes, rdev_start_radar_detection's return value
in nl80211_start_radar_detection is ignored and we always returned 0.

Fixes: f42d22d3f796 ("wifi: cfg80211: define and use wiphy guard")
Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20250109161040.325742-1-nico.escande@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |   37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10140,25 +10140,26 @@ static int nl80211_start_radar_detection
 
 	err = rdev_start_radar_detection(rdev, dev, &chandef, cac_time_ms,
 					 link_id);
-	if (!err) {
-		switch (wdev->iftype) {
-		case NL80211_IFTYPE_AP:
-		case NL80211_IFTYPE_P2P_GO:
-			wdev->links[0].ap.chandef = chandef;
-			break;
-		case NL80211_IFTYPE_ADHOC:
-			wdev->u.ibss.chandef = chandef;
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			wdev->u.mesh.chandef = chandef;
-			break;
-		default:
-			break;
-		}
-		wdev->links[link_id].cac_started = true;
-		wdev->links[link_id].cac_start_time = jiffies;
-		wdev->links[link_id].cac_time_ms = cac_time_ms;
+	if (err)
+		return err;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		wdev->links[0].ap.chandef = chandef;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		wdev->u.ibss.chandef = chandef;
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		wdev->u.mesh.chandef = chandef;
+		break;
+	default:
+		break;
 	}
+	wdev->links[link_id].cac_started = true;
+	wdev->links[link_id].cac_start_time = jiffies;
+	wdev->links[link_id].cac_time_ms = cac_time_ms;
 
 	return 0;
 }


