Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F281EF092;
	Wed,  6 Nov 2024 12:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897307; cv=none; b=fFQsSnUUBviWRA9FrWkKzsqWpfND5HVdwG2uR2/PoXKOqq6JCbba4mj8EDO41Rh8uVXQA0UK72dR/lDc7QSB1aKqIy2mtUJCDd4y20CB3djUym2jNkyf+HTYYq3HusXOHVAvM7ZZ48x6UdbhWJUuslVNBtRNAFaW4Qv97Tbc2KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897307; c=relaxed/simple;
	bh=w38eJx8AUCs9VMu6dTxHt6pj/H93b5RjIbz9Wr5390s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx/53eevKA7YO4wOxr6ZUr/DqMCa7thF9767RneSTRvPUPENYz9Ob8xCTIiibppjhfZflo/jvmh/Fej7SchU7JNWMUTMWZw/1TmtxWmnt1NZniuyo9hOdMkq/NCiaNXqMPskhI7fQlQlCloIdfBxT73WtyA+4dZIhn+2FRylSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdrzcIIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdrzcIIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79332C4CECD;
	Wed,  6 Nov 2024 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897306;
	bh=w38eJx8AUCs9VMu6dTxHt6pj/H93b5RjIbz9Wr5390s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vdrzcIIbZo9+cYZbOR1+yfQkENmu3cNBA90tay45Q5karg01o4evcMCl4Ha6gS58J
	 XYBlumtRleTa93YSkS2jAPbr2boXBTmhj2Q8M3xjkDJwfLm2HTqy4knWFleoAF42HN
	 OUoEDAQK0ZnsnTROy2vYkaFe1d8/70xQq3kYNSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/151] wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys
Date: Wed,  6 Nov 2024 13:03:18 +0100
Message-ID: <20241106120309.123402662@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 52009b419355195912a628d0a9847922e90c348c ]

Sync iterator conditions with ieee80211_iter_keys_rcu.

Fixes: 830af02f24fb ("mac80211: allow driver to iterate keys")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20241006153630.87885-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/key.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index a2db0585dce0d..f5f1eb87797a4 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -989,6 +989,26 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
+static void
+ieee80211_key_iter(struct ieee80211_hw *hw,
+		   struct ieee80211_vif *vif,
+		   struct ieee80211_key *key,
+		   void (*iter)(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct ieee80211_key_conf *key,
+				void *data),
+		   void *iter_data)
+{
+	/* skip keys of station in removal process */
+	if (key->sta && key->sta->removed)
+		return;
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		return;
+	iter(hw, vif, key->sta ? &key->sta->sta : NULL,
+	     &key->conf, iter_data);
+}
+
 void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 void (*iter)(struct ieee80211_hw *hw,
@@ -1008,16 +1028,13 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 	if (vif) {
 		sdata = vif_to_sdata(vif);
 		list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
-			iter(hw, &sdata->vif,
-			     key->sta ? &key->sta->sta : NULL,
-			     &key->conf, iter_data);
+			ieee80211_key_iter(hw, vif, key, iter, iter_data);
 	} else {
 		list_for_each_entry(sdata, &local->interfaces, list)
 			list_for_each_entry_safe(key, tmp,
 						 &sdata->key_list, list)
-				iter(hw, &sdata->vif,
-				     key->sta ? &key->sta->sta : NULL,
-				     &key->conf, iter_data);
+				ieee80211_key_iter(hw, &sdata->vif, key,
+						   iter, iter_data);
 	}
 	mutex_unlock(&local->key_mtx);
 }
@@ -1035,17 +1052,8 @@ _ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
 {
 	struct ieee80211_key *key;
 
-	list_for_each_entry_rcu(key, &sdata->key_list, list) {
-		/* skip keys of station in removal process */
-		if (key->sta && key->sta->removed)
-			continue;
-		if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
-			continue;
-
-		iter(hw, &sdata->vif,
-		     key->sta ? &key->sta->sta : NULL,
-		     &key->conf, iter_data);
-	}
+	list_for_each_entry_rcu(key, &sdata->key_list, list)
+		ieee80211_key_iter(hw, &sdata->vif, key, iter, iter_data);
 }
 
 void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
-- 
2.43.0



