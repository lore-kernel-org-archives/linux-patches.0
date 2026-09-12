Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FA5364049;
	Sat, 12 Sep 2026 08:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201306; cv=none; b=LFJ+xDNZ58097YNrzl2z+rRWQbnxcu947F+qksDc90ZksbXHT0uQh33SD/KxQ9YV5MD3xKszq17IPSRv+B0UnAlDO3pZjnGAO+eakJo/o+4pyDYNJ0WPaeV3DrfkDEcmZNYNg4pG0XpqZZSjAdV320yCtCI6kDsaCcGytmipwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201306; c=relaxed/simple;
	bh=EYsslzrOdaXs6mfXiebxfF1eaEV1GZ1sCeFwFKkC1+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alyFywpH/w4XwtrHvDlFYgAZtq1w1G2cPzXhtwY44K2bQNB+MAcNTSbguR22G6shdeaY9U2DhxzGZm7VwiSo8XGDJ7ZJGjbgj0VInoy/AhxlbWsUHAbRQs4z+RruIk6xHi1mvgjH/4AzzBERlodLuhjm13/VOwwZ4PiVGKuacyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgeWQfb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgeWQfb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8439A1F000FF;
	Sat, 12 Sep 2026 08:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201304;
	bh=VX1XyyX6tWqU8l/2ELJL6iUJNNINJHFTDsgoBEfuffA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgeWQfb1L5Y/+c/qBSydRslyd2tmKSEyPeobTD0F2ntrgWt3e+IPPMe1JLzOEABuv
	 ZjpGZtTwr9Y0MKp0m8h8vCUtRQ3FmFGi5dVKgxRbow7OJaE7ptUqWJUKDH9zRmIpur
	 KN/RKeEL0SHw0i2RbLhT6GB0LUp4kYgxj37o4kKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0970/1815] wifi: mac80211: disconnect on CSA to channel 0
Date: Sat, 12 Sep 2026 08:45:20 +0200
Message-ID: <20260912065711.748802933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ec622750e1c9d..880f4625775dc 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -227,7 +227,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 {
 	enum nl80211_band new_band = current_band;
 	int new_freq;
-	u8 new_chan_no = 0, new_op_class = 0;
+	int new_chan_no = -1, new_op_class = -1;
 	struct ieee80211_channel *new_chan;
 	struct cfg80211_chan_def new_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
@@ -256,7 +256,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		new_op_class = ext_chansw_elem->new_operating_class;
 
 		if (!ieee80211_operating_class_to_band(new_op_class, &new_band)) {
-			new_op_class = 0;
+			new_op_class = -1;
 			if (!unprot_action)
 				sdata_info(sdata,
 					   "cannot understand ECSA IE operating class, %d, ignoring\n",
@@ -268,14 +268,14 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
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
@@ -349,7 +349,8 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
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



