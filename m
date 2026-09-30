Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4623CF688;
	Wed, 30 Sep 2026 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788298; cv=none; b=YV/vsv/A+PgcbAgkRaNXm4Ar3vsrdVeCmKCCiDSkFx8DaB3aMaKtj2mLC2LMMEAsmZFDMQy/wvSpdq33mOez8mTTpHziGhgfb4gNTmwIacMhGL4PWYnJozhb8Vhd7h9Ux+TMFgfGgvIv2MQTfNOWxh3yYg8iVBuT+8SE6CSm/e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788298; c=relaxed/simple;
	bh=sv4Izr4jtiYWz7/VhIz5sZ0u63T/xYB7tYu9HKWphis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta4UYRpvYgbhIcO6QLJryPCL6qiMSZmIjYLCkaACDjmdTYiJ1y/KVGNiFyYNce7tWSOfHiZEWpjGNV2Djf5ZIdG7CcjvM/lb+CIAbGDwsbE4+gJZbF3KHCN9pesxw+lWt0v6o88ZAhje8pBe0NMqrYk5zcQLR8jvzQKKv8QWjbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxkhrG+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxkhrG+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603A1F00898;
	Wed, 30 Sep 2026 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788297;
	bh=cc/14K+CZ79jZvqH/9J6ytEktVWa5EAdRfKtuhY8WVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xxkhrG+WNNQbTF2xXxpAxMZMdJ0a4OUA3A8yYyaZnESp3EYeSU94DXA1YUfktS1ib
	 ammYO2aKDxrsk6cP3xoRdBAkGwarFoUDZy62SDG8lciuyLLFbD76cZV1ADehhzpVn8
	 I+10XVyRqPbEaHZUFtHDrOsPAHiOtgFkHEn+qMAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/877] wifi: mac80211: mesh: reset the CSA state when leaving
Date: Wed, 30 Sep 2026 17:16:27 +0200
Message-ID: <20260930152416.379381318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit 860134b3af77970e006feab7e5decb8c84771c7f ]

ifmsh->csa is allocated in ieee80211_mesh_csa_beacon() and only freed
in ieee80211_mesh_finish_csa(), i.e. when the channel switch completes.
Leaving the mesh while a switch is still pending therefore leaks it.

Additionally, ifmsh->csa_role and ifmsh->chsw_ttl have their state leak
in this case, so things can get mixed up in addition to the memory
leak.

Refactor the reset and call it in ieee80211_stop_mesh() to fix it all.

Assisted-by: LLM
Reported-by: syzbot+f5752cd6b94fe38be666@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f5752cd6b94fe38be666
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Link: https://patch.msgid.link/20260908122838.201719-20-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 4c601b9cb3bb2..258c865921784 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1217,6 +1217,21 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
+static void ieee80211_mesh_reset_csa(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct mesh_csa_settings *csa;
+
+	/* Reset the TTL value and Initiator flag */
+	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
+	ifmsh->chsw_ttl = 0;
+
+	/* Remove the CSA and MCSP elements from the beacon */
+	csa = sdata_dereference(ifmsh->csa, sdata);
+	RCU_INIT_POINTER(ifmsh->csa, NULL);
+	kfree_rcu(csa, rcu_head);
+}
+
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1227,6 +1242,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* abort any running channel switch */
 	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_mesh_reset_csa(sdata);
 	ieee80211_vif_unblock_queues_csa(sdata);
 
 	/* flush STAs and mpaths on this iface */
@@ -1531,19 +1547,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata, u64 *changed)
 {
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct mesh_csa_settings *tmp_csa_settings;
-	int ret = 0;
+	int ret;
 
-	/* Reset the TTL value and Initiator flag */
-	ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
-	ifmsh->chsw_ttl = 0;
+	ieee80211_mesh_reset_csa(sdata);
 
-	/* Remove the CSA and MCSP elements from the beacon */
-	tmp_csa_settings = sdata_dereference(ifmsh->csa, sdata);
-	RCU_INIT_POINTER(ifmsh->csa, NULL);
-	if (tmp_csa_settings)
-		kfree_rcu(tmp_csa_settings, rcu_head);
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret)
 		return -EINVAL;
-- 
2.53.0



