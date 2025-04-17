Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8ABE2566FF;
	Thu, 17 Apr 2025 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913261; cv=none; b=djhLZMQy6eHz0sSxVNw6tmeJ+09I3aNWCOvjlnF4h3/Npby2kkyE3lnb8U6ao8S8SBnfRz2+3DsulJiq2nsahPFdiRJKU6TELY5iZkCiZlhocof5+ezmYPpADp9kkU+4z5wdguJMgiAWRlMr+5V8VZOizzGe/oX2R5tJ5UzkSu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913261; c=relaxed/simple;
	bh=3LuBvToVrtX+4nRQ38huJpLc9U6q7paOTCnrxvR13Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuCGWi0zjjoTPOHjqb9MEgBffd2/aWW5zpoZgTeMxstxMqMMDUOqqjKtIo+wTzrbwWkHFUbUHq/XPhbdf9JT3LFDDH7cPItSXwQ+sqsOfw/sEYbB0abWICnVMpe3GEnVXzWaGErxIyghh4ITV3/TuDAWDXBDIchL0HDv8ztE3pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bc3b236d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bc3b236d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1871DC4CEE4;
	Thu, 17 Apr 2025 18:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913261;
	bh=3LuBvToVrtX+4nRQ38huJpLc9U6q7paOTCnrxvR13Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bc3b236dvpoGEM3leQi55rMOHDDTLBDDkD9k6cVNwOSgps4hS85856ezvXh3FiA42
	 f9t7q9y6sCgyNL+5Nz+1TZL9M1zE29ftfHKzgbSdmQ81G+2iM0uQEqJbGDMGtjq4BJ
	 VMsaD8hlzgiN80NDGlT73tlLql5v3nJpjdWknUQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.14 280/449] wifi: mac80211: fix integer overflow in hwmp_route_info_get()
Date: Thu, 17 Apr 2025 19:49:28 +0200
Message-ID: <20250417175129.335257996@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit d00c0c4105e5ab8a6a13ed23d701cceb285761fa upstream.

Since the new_metric and last_hop_metric variables can reach
the MAX_METRIC(0xffffffff) value, an integer overflow may occur
when multiplying them by 10/9. It can lead to incorrect behavior.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: a8d418d9ac25 ("mac80211: mesh: only switch path when new metric is at least 10% better")
Cc: stable@vger.kernel.org
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Link: https://patch.msgid.link/20250212082124.4078236-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_hwmp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -367,6 +367,12 @@ u32 airtime_link_metric_get(struct ieee8
 	return (u32)result;
 }
 
+/* Check that the first metric is at least 10% better than the second one */
+static bool is_metric_better(u32 x, u32 y)
+{
+	return (x < y) && (x < (y - x / 10));
+}
+
 /**
  * hwmp_route_info_get - Update routing info to originator and transmitter
  *
@@ -458,8 +464,8 @@ static u32 hwmp_route_info_get(struct ie
 				    (mpath->sn == orig_sn &&
 				     (rcu_access_pointer(mpath->next_hop) !=
 						      sta ?
-					      mult_frac(new_metric, 10, 9) :
-					      new_metric) >= mpath->metric)) {
+					      !is_metric_better(new_metric, mpath->metric) :
+					      new_metric >= mpath->metric))) {
 					process = false;
 					fresh_info = false;
 				}
@@ -533,8 +539,8 @@ static u32 hwmp_route_info_get(struct ie
 			if ((mpath->flags & MESH_PATH_FIXED) ||
 			    ((mpath->flags & MESH_PATH_ACTIVE) &&
 			     ((rcu_access_pointer(mpath->next_hop) != sta ?
-				       mult_frac(last_hop_metric, 10, 9) :
-				       last_hop_metric) > mpath->metric)))
+				      !is_metric_better(last_hop_metric, mpath->metric) :
+				       last_hop_metric > mpath->metric))))
 				fresh_info = false;
 		} else {
 			mpath = mesh_path_add(sdata, ta);


