Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12BA1F12F1;
	Wed,  6 Nov 2024 12:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896755; cv=none; b=QE40IGnMq0Z6l+71P34PDLn1f3kBVJTRzYV9EC5mN26WYKnmY9ME4UO9L5PhenVVdu1gxZtCPGbn4UF4/ck/Og2zuY/296QP5mCeEF6SuLeyjkE47GdeG23S5eH/ekY00FpbT69e5dvWMGLizWzWFGvhkp1r3fbrSKwPN10+4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896755; c=relaxed/simple;
	bh=ExFwaZGuI2iOtVlfnAOVI0zpdOE81GT1ki6Gl+cq0oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9KKGgsuy6R8wbp12pDwsYZrxq9uh7nlR5VW8Z67gxWT3NcAzseonsH3485iEwV12RLcJoXHwDV0DFPcqMV9uI7NWK5uq3aZtfQOcD1D/rWi0WdfKgarmslbk7C3SGvx3ZRMj9yeuTOeaLzdDcQyr4dPyB7w6+a3sFTkVbSBaA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLnu9Edi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLnu9Edi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2466C4CECD;
	Wed,  6 Nov 2024 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896754;
	bh=ExFwaZGuI2iOtVlfnAOVI0zpdOE81GT1ki6Gl+cq0oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLnu9Ediq9e/yQyvw1IldUDRNgPVecadSYHC+acUGGgdQndeZ09FfLphyzbdsw4t0
	 3fqD65t0J7XUpOVjjEk3Ag5jE+6BCDfmDUSEa9Nq1IYcQis4zD/0a8TS89G5wVCSEq
	 QL0tW+deD2qlbJE9dn/ZkprpJGPyNjkWzGpPQxF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/110] wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys
Date: Wed,  6 Nov 2024 13:04:26 +0100
Message-ID: <20241106120304.854197630@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6b089594a9f3f..3df4695caef6c 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -918,6 +918,26 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
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
@@ -937,16 +957,13 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
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
@@ -964,17 +981,8 @@ _ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
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



