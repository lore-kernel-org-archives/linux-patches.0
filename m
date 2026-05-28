Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC1F298CB2;
	Thu, 28 May 2026 20:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001033; cv=none; b=IB8mMHuveU4Ti8waHno2ouyMiP1vG+pyzPkhvrRG1zJH7rbbgVFCtAtDbB8UKO+CZ4uOVnn3Uho+hyZ6EsvI0pjFDDNG+7tE+pqrtP23UgVintenSDP49M2MyfNRI80oSCAyS+6N86jUg/naYHhybD45DKeNKviyNibmWsY+pBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001033; c=relaxed/simple;
	bh=1lN5BeaTrHGraADESByk+8c1Kx67XJgTgZBUNa8G6lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipM0LSRMHl1D+s7pEc2HWRBJZ9FPjLdGbAgHxYaKKzxTuQVyE2AI+doOFW+b3nUH8nD+v89R14nVMMV4VUF8b5Qo6aSgG6m/8Z0vZR6eESU1XxEPZktNkdN2zqAhVpponqSTi1ZzsgyZop5l+x+XTc/Z457WByQwG6M1E2OQY74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCbOq7Nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCbOq7Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4061F000E9;
	Thu, 28 May 2026 20:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001031;
	bh=jPoexo3GgnRBqQqlaBvY5DhBN6FL0q/fjVFe/YQjxMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JCbOq7NhEr+Q8Pp4AqIMZHLyPOPg5PTL8xZcGL6d3/vvL5WtyYuQF13ybSDG7yv26
	 AMB6UEF7gmQXImxEMGBHXgQCbYiMyUm48ip5sUquS0/gBwKnxz3eAZzDCPfUXchYfF
	 Z3rxty5Xs1Jfb/jE+pXMVkV1IGz6Od7BmgBWvV1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/272] wifi: mac80211: fix MLE defragmentation
Date: Thu, 28 May 2026 21:50:31 +0200
Message-ID: <20260528194636.301195158@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a74e893f30db64cdce0fc7a96d3baa417bcd55f5 ]

If either reconf or EPCS multi-link element (MLE) is contained in
a non-transmitted profile, the defragmentation routine is called
with a pointer to the defragmented copy, but the original elements.

This is incorrect for two reasons:
 - if the original defragmentation was needed, it will not find the
   correct data
 - if the original frame is at a higher address, the parsing will
   potentially overrun the heap data (though given the layout of
   the buffers, only into the new defragmentation buffer, and then
   it has to stop and fail once that's filled with copied data.

Fix it by tracking the container along with the pointer and in
doing so also unify the two almost identical defragmentation
routines.

Fixes: 4d70e9c5488d ("wifi: mac80211: defragment reconfiguration MLE when parsing")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260508091031.8a6c34613178.I4de16ebbce2d27f2f8f98fc49949c7a376c2fe8d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/parse.c | 71 +++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 922ea9a6e2412..530f01575bc17 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -34,6 +34,13 @@
 #include "led.h"
 #include "wep.h"
 
+struct ieee80211_elem_defrag {
+	const struct element *elem;
+	/* container start/len */
+	const u8 *start;
+	size_t len;
+};
+
 struct ieee80211_elems_parse {
 	/* must be first for kfree to work */
 	struct ieee802_11_elems elems;
@@ -41,11 +48,7 @@ struct ieee80211_elems_parse {
 	/* The basic Multi-Link element in the original elements */
 	const struct element *ml_basic_elem;
 
-	/* The reconfiguration Multi-Link element in the original elements */
-	const struct element *ml_reconf_elem;
-
-	/* The EPCS Multi-Link element in the original elements */
-	const struct element *ml_epcs_elem;
+	struct ieee80211_elem_defrag ml_reconf, ml_epcs;
 
 	bool multi_link_inner;
 	bool skip_vendor;
@@ -162,10 +165,14 @@ ieee80211_parse_extension_element(u32 *crc,
 				}
 				break;
 			case IEEE80211_ML_CONTROL_TYPE_RECONF:
-				elems_parse->ml_reconf_elem = elem;
+				elems_parse->ml_reconf.elem = elem;
+				elems_parse->ml_reconf.start = params->start;
+				elems_parse->ml_reconf.len = params->len;
 				break;
 			case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
-				elems_parse->ml_epcs_elem = elem;
+				elems_parse->ml_epcs.elem = elem;
+				elems_parse->ml_epcs.start = params->start;
+				elems_parse->ml_epcs.len = params->len;
 				break;
 			default:
 				break;
@@ -950,46 +957,27 @@ ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
 				      sub->start, sub->len);
 }
 
-static void
-ieee80211_mle_defrag_reconf(struct ieee80211_elems_parse *elems_parse)
-{
-	struct ieee802_11_elems *elems = &elems_parse->elems;
-	ssize_t ml_len;
-
-	ml_len = cfg80211_defragment_element(elems_parse->ml_reconf_elem,
-					     elems->ie_start,
-					     elems->total_len,
-					     elems_parse->scratch_pos,
-					     elems_parse->scratch +
-						elems_parse->scratch_len -
-						elems_parse->scratch_pos,
-					     WLAN_EID_FRAGMENT);
-	if (ml_len < 0)
-		return;
-	elems->ml_reconf = (void *)elems_parse->scratch_pos;
-	elems->ml_reconf_len = ml_len;
-	elems_parse->scratch_pos += ml_len;
-}
-
-static void
-ieee80211_mle_defrag_epcs(struct ieee80211_elems_parse *elems_parse)
+static const void *
+ieee80211_mle_defrag(struct ieee80211_elems_parse *elems_parse,
+		     struct ieee80211_elem_defrag *defrag,
+		     size_t *out_len)
 {
-	struct ieee802_11_elems *elems = &elems_parse->elems;
+	const void *ret;
 	ssize_t ml_len;
 
-	ml_len = cfg80211_defragment_element(elems_parse->ml_epcs_elem,
-					     elems->ie_start,
-					     elems->total_len,
+	ml_len = cfg80211_defragment_element(defrag->elem,
+					     defrag->start, defrag->len,
 					     elems_parse->scratch_pos,
 					     elems_parse->scratch +
 						elems_parse->scratch_len -
 						elems_parse->scratch_pos,
 					     WLAN_EID_FRAGMENT);
 	if (ml_len < 0)
-		return;
-	elems->ml_epcs = (void *)elems_parse->scratch_pos;
-	elems->ml_epcs_len = ml_len;
+		return NULL;
+	ret = elems_parse->scratch_pos;
+	*out_len = ml_len;
 	elems_parse->scratch_pos += ml_len;
+	return ret;
 }
 
 struct ieee802_11_elems *
@@ -1069,9 +1057,12 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 		_ieee802_11_parse_elems_full(&sub, elems_parse, NULL);
 	}
 
-	ieee80211_mle_defrag_reconf(elems_parse);
-
-	ieee80211_mle_defrag_epcs(elems_parse);
+	elems->ml_reconf = ieee80211_mle_defrag(elems_parse,
+						&elems_parse->ml_reconf,
+						&elems->ml_reconf_len);
+	elems->ml_epcs = ieee80211_mle_defrag(elems_parse,
+					      &elems_parse->ml_epcs,
+					      &elems->ml_epcs_len);
 
 	if (elems->tim && !elems->parse_error) {
 		const struct ieee80211_tim_ie *tim_ie = elems->tim;
-- 
2.53.0



