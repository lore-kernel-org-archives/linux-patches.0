Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6865932ABC0;
	Thu, 28 May 2026 20:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999117; cv=none; b=OmoeSoyRZhse8wB1DxTMBMUrgZ6KhgvJ5+lR8SRf2h1kuGQjUPnfzeauR7cxRaqv2+gMuBjEnHGrSpPDUHTuVaxVVYhyTtqFmPHpiJ6Ppp8jcB9/J3T449JQkqcgtbArTApVgaC0YDBVXMS1mSQYacpFW/Ll/nhaTM/LDSptk8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999117; c=relaxed/simple;
	bh=2QRbvSyU7VZYT8cv/q03oD92S0DXEaKbrfuW7N9c+wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Euuwo3IE6nDiHYGVF7OI7AS6/V/qwktKNTfttQ8rAqkM0iDliXmDKFzVY6YFNf+CLGdxVEPpGWTwSxnkN5XvmChXKbbzT0FMQiP/15Xo+K2D9/Scs7Vo6/NcLRTJVHRng/jHgbT43+yzCbXt9qsixHh/BnHAG/qFBR0EnDemsdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6vyWMrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6vyWMrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D8A1F000E9;
	Thu, 28 May 2026 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999116;
	bh=pC/X1bznQmGnIlIbK5pFg3wcj98jAs/SLp0XppucG4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6vyWMrBjmHeWYvCe84Q4gQySjCbA1zmUj6pN9SzJtpckmSNHjoLc5zrpJBZUwiBO
	 kyUCM+zHh5W1iIfxx81MRJCbRIcSQK4AI9+bMAHWNsE6GSZaPqTxO7+X1dBdsZyJdT
	 G4/7VEo59vY1Wlq+gcjMsNkClXwU9pKeLdBbO3A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 414/461] wifi: mac80211: fix multi-link element inheritance
Date: Thu, 28 May 2026 21:49:03 +0200
Message-ID: <20260528194659.476844169@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fe2d61a5d2849ee75dd4deeb2fe35f78d80721f8 ]

When parsing a beacon, mac80211 erroneously inherits any
reconfiguration or EPCS multi-link elements from the outer
elements into the multi-BSSID profile that's requested, if
connected to a non-transmitted BSS, unless that profile
has a non-inheritance element.

This also happens if parsing a multi-BSSID profile that
doesn't have a non-inheritance element.

Fix this by having an empty non-inheritance element so
cfg80211_is_element_inherited() is invoked in these cases
and causes the parser to skip the elements that should
never be inherited.

Fixes: cf36cdef10e2 ("wifi: mac80211: Add support for parsing Reconfiguration Multi Link element")
Fixes: 24711d60f849 ("wifi: mac80211: Support parsing EPCS ML element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20260508091032.92184c0a3f08.I3c43b0b63d2cef8a4ddddaef1c2faaeb1de711ad@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/parse.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 666cdd5fd0ea5..77894d9971135 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -34,6 +34,15 @@
 #include "led.h"
 #include "wep.h"
 
+static const u8 empty_non_inheritance[] = {
+	WLAN_EID_EXTENSION, 1, WLAN_EID_EXT_NON_INHERITANCE,
+	/*
+	 * cfg80211_is_element_inherited() hardcodes elements that
+	 * cannot be inherited, so we just need an empty one to be
+	 * calling it at all.
+	 */
+};
+
 struct ieee80211_elem_defrag {
 	const struct element *elem;
 	/* container start/len */
@@ -923,7 +932,7 @@ ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
 {
 	struct ieee802_11_elems *elems = &elems_parse->elems;
 	struct ieee80211_mle_per_sta_profile *prof;
-	const struct element *tmp;
+	const struct element *tmp, *ret;
 	ssize_t ml_len;
 	const u8 *end;
 
@@ -993,8 +1002,17 @@ ieee80211_prep_mle_link_parse(struct ieee80211_elems_parse *elems_parse,
 	sub->from_ap = params->from_ap;
 	sub->link_id = -1;
 
-	return cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
-				      sub->start, sub->len);
+	ret = cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+				     sub->start, sub->len);
+	if (ret)
+		return ret;
+
+	/*
+	 * Since we know we want and found a profile, apply an empty
+	 * non-inheritance if the profile didn't have one, so that any
+	 * element that shouldn't be inherited by spec isn't.
+	 */
+	return (const void *)empty_non_inheritance;
 }
 
 static const void *
@@ -1030,6 +1048,7 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 	size_t scratch_len = 3 * params->len;
 	bool multi_link_inner = false;
 
+	BUILD_BUG_ON(sizeof(empty_non_inheritance) != empty_non_inheritance[1] + 2);
 	BUILD_BUG_ON(offsetof(typeof(*elems_parse), elems) != 0);
 
 	/* cannot parse for both a specific link and non-transmitted BSS */
@@ -1077,6 +1096,17 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 
 		non_inherit = cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
 						     sub.start, nontx_len);
+		/*
+		 * If it's a non-transmitted BSS, we shouldn't pick
+		 * any elements in the outer parsing that shouldn't
+		 * be inherited. If the profile has a non-inheritance
+		 * element this automatically happens, but if not then
+		 * provide an empty one so that the hard-coded elements
+		 * in cfg80211_is_element_inherited() are ignored, but
+		 * it must be called.
+		 */
+		if (params->bss->transmitted_bss && !non_inherit)
+			non_inherit = (const void *)empty_non_inheritance;
 	} else {
 		/* must always parse to get elems_parse->ml_basic_elem */
 		non_inherit = ieee80211_prep_mle_link_parse(elems_parse, params,
-- 
2.53.0



