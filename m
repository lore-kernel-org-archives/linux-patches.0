Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34B6229B05;
	Tue, 29 Apr 2025 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945363; cv=none; b=NPmS6ePMK3WijzuPpreiObivtZ0DgKjWp/vaMMGyNOoywsoSzu00n7ljZwpdsppuRi3Ky+tr7YwqzRIXdNJoeCdhEmFBzA4hVs99bfW/V69ogX2l+LCbmSqvbbgSbuqn9SOS6+LTAp/QqEl5bJTprWbcAT5gH6w+/4vHdcT95Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945363; c=relaxed/simple;
	bh=ckVsofM6W5Al0kpuSLevzSgnOl5E+MAiDQh90+mbHWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYy5d+Jof7DB683Ei/wYZH0amTR6nBBmQdbnQUBcS9oe8JbykSvW5X76Pmy68SqB/JOC2vBg4kzzpyUTZXDNZB7i2jkNINWLZZHAwCelURtzl4dod0VtBqxgWasNe8XIy70VjaBt2tskq/1zBbUnRGdwcircyh8Dr8T29kSz9/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4smMeRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4smMeRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87A9C4CEE3;
	Tue, 29 Apr 2025 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945363;
	bh=ckVsofM6W5Al0kpuSLevzSgnOl5E+MAiDQh90+mbHWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4smMeRIxeLb9g03pO0MvWBB/1Dreo5FtEJeMB51Pa3CwcTAXeQy7WSNDcPsyoUva
	 oljdhIJZcEe5Pe0rLOtRxuy0Tc4Y/X+W0Aet+zvUepVrvw1SR2Pv6C5WAWSHyvL3wf
	 etJCwT29Bea3tKuSYT3TxfPCenxq596i0lRR2hp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 057/179] wifi: mac80211: fix integer overflow in hwmp_route_info_get()
Date: Tue, 29 Apr 2025 18:39:58 +0200
Message-ID: <20250429161051.703848213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -360,6 +360,12 @@ u32 airtime_link_metric_get(struct ieee8
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
@@ -450,8 +456,8 @@ static u32 hwmp_route_info_get(struct ie
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
@@ -521,8 +527,8 @@ static u32 hwmp_route_info_get(struct ie
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


