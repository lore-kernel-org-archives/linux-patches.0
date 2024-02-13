Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95C75FF07;
	Tue, 13 Feb 2024 17:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845773; cv=none; b=c3/QS5P3XRP9GK7CReGs/gw40AM9GK5c29Wgbb+U4/7IC/BVOhxGulvpRKQ6KtlrLI21ABIgtMU4nBX9PXQEPKJnrqzLGLKshABxL7Gi1obJIPljbSmnLwJgQpYzOcI80l4mREkHjQfMbYC9jOd/9SGoWyUnUy7oOlkWpQG/EQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845773; c=relaxed/simple;
	bh=+a3lap5ID5px9n7y7XIxbnXGYd8tgNrIoRhNE1nJiUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRGm7MsbUZxt+Wn1VGHM6JD3Hkhqqqp44WnmeJB12p+krpWwmP3cbGJIwQcsQPFjkx8dQgGd2/48RMNU9PTjzg0eVugm7rJCeJRbtfA+CtGrGfpt285Dj4tAk4uTIyrFt5TLl4KovOWlCp2leF2VcWUUNQ+ELPNFiHFflz8qX7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRYAfS+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRYAfS+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6743DC433F1;
	Tue, 13 Feb 2024 17:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845772;
	bh=+a3lap5ID5px9n7y7XIxbnXGYd8tgNrIoRhNE1nJiUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRYAfS+F3DmXre2ehS+s2j3KdoWhdofpLoHZHoPkMqAUQdVBn7QELrY5/lipMLp6f
	 ub1KwoGsiVxr/yTPY9NY2Z0kV/q/CuehtnetEClG1WbSQSuwN2rJFGZu7oGhfYdI5v
	 st2mWlK5eVnXtBiiF9QDNU/trBrgS78BrIWHmYNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	coldolt <andypalmadi@gmail.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 025/124] wifi: mac80211: improve CSA/ECSA connection refusal
Date: Tue, 13 Feb 2024 18:20:47 +0100
Message-ID: <20240213171854.465398008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 35e2385dbe787936c793d70755a5177d267a40aa ]

As mentioned in the previous commit, we pretty quickly found
that some APs have ECSA elements stuck in their probe response,
so using that to not attempt to connect while CSA is happening
we never connect to such an AP.

Improve this situation by checking more carefully and ignoring
the ECSA if cfg80211 has previously detected the ECSA element
being stuck in the probe response.

Additionally, allow connecting to an AP that's switching to a
channel it's already using, unless it's using quiet mode. In
this case, we may just have to adjust bandwidth later. If it's
actually switching channels, it's better not to try to connect
in the middle of that.

Reported-by: coldolt <andypalmadi@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/CAJvGw+DQhBk_mHXeu6RTOds5iramMW2FbMB01VbKRA4YbHHDTA@mail.gmail.com/
Fixes: c09c4f31998b ("wifi: mac80211: don't connect to an AP while it's in a CSA process")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240129131413.cc2d0a26226e.I682c016af76e35b6c47007db50e8554c5a426910@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 103 ++++++++++++++++++++++++++++++++------------
 1 file changed, 76 insertions(+), 27 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dcdaab19efbd..bbe36d87ac59 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7288,6 +7288,75 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	return err;
 }
 
+static bool ieee80211_mgd_csa_present(struct ieee80211_sub_if_data *sdata,
+				      const struct cfg80211_bss_ies *ies,
+				      u8 cur_channel, bool ignore_ecsa)
+{
+	const struct element *csa_elem, *ecsa_elem;
+	struct ieee80211_channel_sw_ie *csa = NULL;
+	struct ieee80211_ext_chansw_ie *ecsa = NULL;
+
+	if (!ies)
+		return false;
+
+	csa_elem = cfg80211_find_elem(WLAN_EID_CHANNEL_SWITCH,
+				      ies->data, ies->len);
+	if (csa_elem && csa_elem->datalen == sizeof(*csa))
+		csa = (void *)csa_elem->data;
+
+	ecsa_elem = cfg80211_find_elem(WLAN_EID_EXT_CHANSWITCH_ANN,
+				       ies->data, ies->len);
+	if (ecsa_elem && ecsa_elem->datalen == sizeof(*ecsa))
+		ecsa = (void *)ecsa_elem->data;
+
+	if (csa && csa->count == 0)
+		csa = NULL;
+	if (csa && !csa->mode && csa->new_ch_num == cur_channel)
+		csa = NULL;
+
+	if (ecsa && ecsa->count == 0)
+		ecsa = NULL;
+	if (ecsa && !ecsa->mode && ecsa->new_ch_num == cur_channel)
+		ecsa = NULL;
+
+	if (ignore_ecsa && ecsa) {
+		sdata_info(sdata,
+			   "Ignoring ECSA in probe response - was considered stuck!\n");
+		return csa;
+	}
+
+	return csa || ecsa;
+}
+
+static bool ieee80211_mgd_csa_in_process(struct ieee80211_sub_if_data *sdata,
+					 struct cfg80211_bss *bss)
+{
+	u8 cur_channel;
+	bool ret;
+
+	cur_channel = ieee80211_frequency_to_channel(bss->channel->center_freq);
+
+	rcu_read_lock();
+	if (ieee80211_mgd_csa_present(sdata,
+				      rcu_dereference(bss->beacon_ies),
+				      cur_channel, false)) {
+		ret = true;
+		goto out;
+	}
+
+	if (ieee80211_mgd_csa_present(sdata,
+				      rcu_dereference(bss->proberesp_ies),
+				      cur_channel, bss->proberesp_ecsa_stuck)) {
+		ret = true;
+		goto out;
+	}
+
+	ret = false;
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 /* config hooks */
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req)
@@ -7296,7 +7365,6 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_auth_data *auth_data;
 	struct ieee80211_link_data *link;
-	const struct element *csa_elem, *ecsa_elem;
 	u16 auth_alg;
 	int err;
 	bool cont_auth;
@@ -7339,21 +7407,10 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->assoc_data)
 		return -EBUSY;
 
-	rcu_read_lock();
-	csa_elem = ieee80211_bss_get_elem(req->bss, WLAN_EID_CHANNEL_SWITCH);
-	ecsa_elem = ieee80211_bss_get_elem(req->bss,
-					   WLAN_EID_EXT_CHANSWITCH_ANN);
-	if ((csa_elem &&
-	     csa_elem->datalen == sizeof(struct ieee80211_channel_sw_ie) &&
-	     ((struct ieee80211_channel_sw_ie *)csa_elem->data)->count != 0) ||
-	    (ecsa_elem &&
-	     ecsa_elem->datalen == sizeof(struct ieee80211_ext_chansw_ie) &&
-	     ((struct ieee80211_ext_chansw_ie *)ecsa_elem->data)->count != 0)) {
-		rcu_read_unlock();
+	if (ieee80211_mgd_csa_in_process(sdata, req->bss)) {
 		sdata_info(sdata, "AP is in CSA process, reject auth\n");
 		return -EINVAL;
 	}
-	rcu_read_unlock();
 
 	auth_data = kzalloc(sizeof(*auth_data) + req->auth_data_len +
 			    req->ie_len, GFP_KERNEL);
@@ -7662,7 +7719,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data;
-	const struct element *ssid_elem, *csa_elem, *ecsa_elem;
+	const struct element *ssid_elem;
 	struct ieee80211_vif_cfg *vif_cfg = &sdata->vif.cfg;
 	ieee80211_conn_flags_t conn_flags = 0;
 	struct ieee80211_link_data *link;
@@ -7685,23 +7742,15 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	cbss = req->link_id < 0 ? req->bss : req->links[req->link_id].bss;
 
-	rcu_read_lock();
-	ssid_elem = ieee80211_bss_get_elem(cbss, WLAN_EID_SSID);
-	if (!ssid_elem || ssid_elem->datalen > sizeof(assoc_data->ssid)) {
-		rcu_read_unlock();
+	if (ieee80211_mgd_csa_in_process(sdata, cbss)) {
+		sdata_info(sdata, "AP is in CSA process, reject assoc\n");
 		kfree(assoc_data);
 		return -EINVAL;
 	}
 
-	csa_elem = ieee80211_bss_get_elem(cbss, WLAN_EID_CHANNEL_SWITCH);
-	ecsa_elem = ieee80211_bss_get_elem(cbss, WLAN_EID_EXT_CHANSWITCH_ANN);
-	if ((csa_elem &&
-	     csa_elem->datalen == sizeof(struct ieee80211_channel_sw_ie) &&
-	     ((struct ieee80211_channel_sw_ie *)csa_elem->data)->count != 0) ||
-	    (ecsa_elem &&
-	     ecsa_elem->datalen == sizeof(struct ieee80211_ext_chansw_ie) &&
-	     ((struct ieee80211_ext_chansw_ie *)ecsa_elem->data)->count != 0)) {
-		sdata_info(sdata, "AP is in CSA process, reject assoc\n");
+	rcu_read_lock();
+	ssid_elem = ieee80211_bss_get_elem(cbss, WLAN_EID_SSID);
+	if (!ssid_elem || ssid_elem->datalen > sizeof(assoc_data->ssid)) {
 		rcu_read_unlock();
 		kfree(assoc_data);
 		return -EINVAL;
-- 
2.43.0



