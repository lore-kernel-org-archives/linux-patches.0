Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19021A6195;
	Tue, 30 Jul 2024 16:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357017; cv=none; b=in6t6WlRC8YqTBco9dbfo7YyJSp1PPJzX6vW7WQZli+b+McsHm5ZAcqF0d7AzoReLAcTtkpswTO1dzmNDGhHwvtEuGZowyuZvOa7BCusdL3zLGwFg+V6ZUEL2O3NyOdc3AHTUFvP8nEi95hGkwMl8WIiI1PZbcS3Brn6D2uAiCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357017; c=relaxed/simple;
	bh=u11sX8BmBXa3YXMSxpfDmqrPZCfNGh2Yo7CbQXrbJVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGg2HHgnpYTFuk1rUfFjqzBGTCd7HHBGqTjUpGDTon9m3Twu35KKcsEBupwLdaup8DbDqJmA/6u9MpviJAw5Wsk0pW4hvxE7mevWPV7S2h/JbF8GK1B5w15HfoviSaT11ZSZtzg6zKEzevR1DOvCuNM4mb5d6Y2TokmxmbQaO+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKgPAIjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKgPAIjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D90C32782;
	Tue, 30 Jul 2024 16:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357017;
	bh=u11sX8BmBXa3YXMSxpfDmqrPZCfNGh2Yo7CbQXrbJVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKgPAIjbP/iJhGxvG20t1Sc5cSmWmthwL7yoULSxGwv9qtDF9NQztym/7KOl6h7C5
	 vltVh8rsb1BBp22VUpLdrpk1ZIAbpm/clDrQNLAfmHyc9llnt93yrTknmrHm2LQ75W
	 AafponIaIlteMRc+BzkqN1FhKKv+V+MK0X4Jqr2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 210/809] wifi: mac80211: correcty limit wider BW TDLS STAs
Date: Tue, 30 Jul 2024 17:41:26 +0200
Message-ID: <20240730151732.900814429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0b2d9d9aec2be212a28b7d14b5462c56d9adc3a3 ]

When updating a channel context, the code can apply wider
bandwidth TDLS STA channel definitions to each and every
channel context used by the device, an approach that will
surely lead to problems if there is ever more than one.

Restrict the wider BW TDLS STA consideration to only TDLS
STAs that are actually related to links using the channel
context being updated.

Fixes: 0fabfaafec3a ("mac80211: upgrade BW of TDLS peers when possible")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240612143707.1ad989acecde.I5c75c94d95c3f4ea84f8ff4253189f4b13bad5c3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 380695fdc32fa..e6a7ff6ca6797 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -775,13 +775,24 @@ void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 
 	/* TDLS peers can sometimes affect the chandef width */
 	list_for_each_entry(sta, &local->sta_list, list) {
+		struct ieee80211_sub_if_data *sdata = sta->sdata;
 		struct ieee80211_chan_req tdls_chanreq = {};
+		int tdls_link_id;
+
 		if (!sta->uploaded ||
 		    !test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW) ||
 		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
 		    !sta->tdls_chandef.chan)
 			continue;
 
+		tdls_link_id = ieee80211_tdls_sta_link_id(sta);
+		link = sdata_dereference(sdata->link[tdls_link_id], sdata);
+		if (!link)
+			continue;
+
+		if (rcu_access_pointer(link->conf->chanctx_conf) != conf)
+			continue;
+
 		tdls_chanreq.oper = sta->tdls_chandef;
 
 		/* note this always fills and returns &tmp if compat */
-- 
2.43.0



