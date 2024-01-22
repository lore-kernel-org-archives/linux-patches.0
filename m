Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7013A252;
	Tue, 23 Jan 2024 00:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969429; cv=none; b=rFK/xOVkwFkWiJ4B+iwXdL4j5n754fzDQpxIGzzibvLuGPc6ZNe06bBQYJNQwcYB9gPGSe9ZnksRmxy/DsoR7o9w+irv4JEjjS9v7uXdtxioB4pn1DwtdYod/8AEdxNOxP4pszA6tSOCP8D6/DDVnpeETkgO5M2MZOhXoelFYCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969429; c=relaxed/simple;
	bh=UZIyXKO32peRk58C+ByQPmUiuH6DJkAJh3n5ET3h0to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4s5MwdNXLhcnofVQaCV68amSAIYtmYy5ECgfx5BXmedrwKO8MVrvcbC2PP6CBDr/w57xPOvy7bHGdFmEgS9IEyHOizmjzjuPhk70RmFs9W/MnVBlpq4T43zKRaHqBM0RtnDoKiQp5ncn2vBc1sWt/53YFYPBh7xnKKZ1rUQ8kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDxEpf9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDxEpf9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C2BC433F1;
	Tue, 23 Jan 2024 00:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969429;
	bh=UZIyXKO32peRk58C+ByQPmUiuH6DJkAJh3n5ET3h0to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDxEpf9dSl+Cr7oqa0ZArldZcKB8wYsF6h9biG+KeO5uKF3gLFcRR033R/gJqj9ZD
	 iXKTZYKszlcy7BWXWw/kjYNTXVb/2LJt5iCbMttG9dOk5EkeyZHbQpg3B90K7yJsO+
	 tiUMXztqko9WotdYazLqMfBOa4BopbdnoOjprttI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayala Beker <ayala.beker@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 215/641] wifi: mac80211: fix advertised TTLM scheduling
Date: Mon, 22 Jan 2024 15:51:59 -0800
Message-ID: <20240122235824.673507099@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit b1a23f8ae0d76ad32fe36682730c050251275b0b ]

Handle a case of time overflow, where the switch time might
be smaller than the partial TSF in the beacon.
Additionally, apply advertised TTLM earlier in order to be
ready on time on the newly activated links.

Fixes: 702e80470a33 ("wifi: mac80211: support handling of advertised TID-to-link mapping")
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231220133549.15079c34e5c8.I0dd50bcceff5953080cdd7aee5118b72c78c6507@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 49 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8998cf01b7a..dcdaab19efbd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -43,6 +43,9 @@
 #define IEEE80211_ASSOC_TIMEOUT_SHORT	(HZ / 10)
 #define IEEE80211_ASSOC_MAX_TRIES	3
 
+#define IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS msecs_to_jiffies(100)
+#define IEEE80211_ADV_TTLM_ST_UNDERFLOW 0xff00
+
 static int max_nullfunc_tries = 2;
 module_param(max_nullfunc_tries, int, 0644);
 MODULE_PARM_DESC(max_nullfunc_tries,
@@ -5946,6 +5949,13 @@ ieee80211_parse_adv_t2l(struct ieee80211_sub_if_data *sdata,
 	pos++;
 
 	ttlm_info->switch_time = get_unaligned_le16(pos);
+
+	/* Since ttlm_info->switch_time == 0 means no switch time, bump it
+	 * by 1.
+	 */
+	if (!ttlm_info->switch_time)
+		ttlm_info->switch_time = 1;
+
 	pos += 2;
 
 	if (control & IEEE80211_TTLM_CONTROL_EXPECTED_DUR_PRESENT) {
@@ -6040,25 +6050,46 @@ static void ieee80211_process_adv_ttlm(struct ieee80211_sub_if_data *sdata,
 		}
 
 		if (ttlm_info.switch_time) {
-			u32 st_us, delay = 0;
-			u32 ts_l26 = beacon_ts & GENMASK(25, 0);
+			u16 beacon_ts_tu, st_tu, delay;
+			u32 delay_jiffies;
+			u64 mask;
 
 			/* The t2l map switch time is indicated with a partial
-			 * TSF value, convert it to TSF and calc the delay
-			 * to the start time.
+			 * TSF value (bits 10 to 25), get the partial beacon TS
+			 * as well, and calc the delay to the start time.
+			 */
+			mask = GENMASK_ULL(25, 10);
+			beacon_ts_tu = (beacon_ts & mask) >> 10;
+			st_tu = ttlm_info.switch_time;
+			delay = st_tu - beacon_ts_tu;
+
+			/*
+			 * If the switch time is far in the future, then it
+			 * could also be the previous switch still being
+			 * announced.
+			 * We can simply ignore it for now, if it is a future
+			 * switch the AP will continue to announce it anyway.
+			 */
+			if (delay > IEEE80211_ADV_TTLM_ST_UNDERFLOW)
+				return;
+
+			delay_jiffies = TU_TO_JIFFIES(delay);
+
+			/* Link switching can take time, so schedule it
+			 * 100ms before to be ready on time
 			 */
-			st_us = ieee80211_tu_to_usec(ttlm_info.switch_time);
-			if (st_us > ts_l26)
-				delay = st_us - ts_l26;
+			if (delay_jiffies > IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS)
+				delay_jiffies -=
+					IEEE80211_ADV_TTLM_SAFETY_BUFFER_MS;
 			else
-				continue;
+				delay_jiffies = 0;
 
 			sdata->u.mgd.ttlm_info = ttlm_info;
 			wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 						  &sdata->u.mgd.ttlm_work);
 			wiphy_delayed_work_queue(sdata->local->hw.wiphy,
 						 &sdata->u.mgd.ttlm_work,
-						 usecs_to_jiffies(delay));
+						 delay_jiffies);
 			return;
 		}
 	}
-- 
2.43.0



