Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A1537E2E7;
	Sat, 12 Sep 2026 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217008; cv=none; b=ri8bPxozu9y/jeWIYebzvKeyzPQGCl6lvjR0gGHyl+d+FA8GNQQv7bD2YLaxO/kAur4Vd8Z3kh890ksqJKC9+8o/xPOzohvo/dy7J9rurJwed5e5hGxhpcRY0iFueDegPTZg8d2rWGlP9zVS4y4Z1I8ZziH1B8A2amIvONz3xNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217008; c=relaxed/simple;
	bh=pxWNhGURkuZPfzkPVkRkjo9grgk9slKd9D+OZ7Qy3tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwRSBFjl8qXEaxVcc18Y6jEiV2/Bxd9/yQw8VzSTndJrHoEfl+T6gsDjK2mB6SXxvN8W+l95XqkwTeYvo3qgrvmDAeQlcbRq8H86dxxJ5c0GahFkV5FUnEOPyrP6pt3nrJF02zRspwcV/536LvHRhcQMSy0zU1k/wTMnav4uSXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXKe0ruM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXKe0ruM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3961F000FF;
	Sat, 12 Sep 2026 12:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217007;
	bh=YKgCIRFS7jruczOAh+yjd+6pYnSjDCaYHGTbxoO6hXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXKe0ruMyLUkmMH8Tc6ajXePNaeMJQ5c1Cv8AQKIZMIHjzLP6nQqcfP7L8Gw725a2
	 hUNxUhGWgpcwgVly+0jhgDn3FSddL2QG9WmnfkUC8ETW3QLbGsvq29CMa2Wqwa4YFc
	 N30HseDmctQ9HyBL3cjZth/hF/WeHLnBMG7B4+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0853/1376] wifi: mac80211: disconnect on CSA to channel 0
Date: Sat, 12 Sep 2026 08:54:39 +0200
Message-ID: <20260912065626.570044725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit cf57f0a674cc3e3cda1a789359cc1238b61b9d7d ]

The refactor for the CSA parsing erroneously equates channel
zero and no information present, leading it to ignore a CSA
on an AP that advertises a switch to that (invalid) channel.
This leads to not disconnecting, which we should. For Intel
devices, this can lead to a firmware crash.

Fix this by using an int type for the channel number as well
as the opclass, and using a (negative) value that cannot be
encoded in the element to indicate it's not present.

Fixes: 21c3f8f95554 ("wifi: mac80211: refactor STA CSA parsing flows")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260802111213.3bc833515e40.I255c37c31ca8b0b34e351cf254e16b6071dd8fb3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/spectmgmt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 073ff9e0f3970..1bdb241e1fd5e 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -228,7 +228,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 {
 	enum nl80211_band new_band = current_band;
 	int new_freq;
-	u8 new_chan_no = 0, new_op_class = 0;
+	int new_chan_no = -1, new_op_class = -1;
 	struct ieee80211_channel *new_chan;
 	struct cfg80211_chan_def new_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
@@ -257,7 +257,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		new_op_class = ext_chansw_elem->new_operating_class;
 
 		if (!ieee80211_operating_class_to_band(new_op_class, &new_band)) {
-			new_op_class = 0;
+			new_op_class = -1;
 			if (!unprot_action)
 				sdata_info(sdata,
 					   "cannot understand ECSA IE operating class, %d, ignoring\n",
@@ -269,14 +269,14 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!new_op_class && elems->ch_switch_ie) {
+	if (new_op_class < 0 && elems->ch_switch_ie) {
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
 		csa_ie->count = elems->ch_switch_ie->count;
 		csa_ie->mode = elems->ch_switch_ie->mode;
 	}
 
 	/* nothing here we understand */
-	if (!new_chan_no)
+	if (new_chan_no < 0)
 		return 1;
 
 	/* Mesh Channel Switch Parameters Element */
@@ -360,7 +360,8 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				get_unaligned_le16(bwi->info.optional);
 	} else if (!wide_bw_chansw_ie || !wbcs_elem_to_chandef(wide_bw_chansw_ie,
 							       &new_chandef)) {
-		if (!ieee80211_operating_class_to_chandef(new_op_class, new_chan,
+		if (new_op_class < 0 ||
+		    !ieee80211_operating_class_to_chandef(new_op_class, new_chan,
 							  &new_chandef))
 			new_chandef = csa_ie->chanreq.oper;
 	}
-- 
2.53.0



