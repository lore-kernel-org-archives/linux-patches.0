Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08EE1DF736;
	Wed,  6 Nov 2024 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895868; cv=none; b=Ue/0jFXvlg/Us8NYAK769/TbVuLOIXFXAMo5sgyWDNtK7iJ2WZFbQz+hz8S9eTu43LUcjNpgaEwpCUCORb5bA83doP/dTByWiIcNBslutiI6iU4UtcEZIZLPkMSgrPSmj64MvjjKqUYbNQg1wXP9/53J2TKckK2KoE9/WWvBeYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895868; c=relaxed/simple;
	bh=AxqRf3AB1eT2zFBMQSZF/1Y3Rk73CWjxO1dc3i3yaQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbAB6b4qIfCmAzgriBrKXmxOIHvFuHU/0BLpfEHp8fBBC+fJutnWZiJgGEE7kbLY4l12hnsJKDtUbw9GoO3J/mBK9C13ob4ojGr9wdFPXJIY25MYH6a6+RPGtA0UuN6tEWrUGXcdv98tQPWH6acucr5qnSPm0T675n6jEe+rILI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nccZJpcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nccZJpcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C4DC4CECD;
	Wed,  6 Nov 2024 12:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895865;
	bh=AxqRf3AB1eT2zFBMQSZF/1Y3Rk73CWjxO1dc3i3yaQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nccZJpcGQRPcsv5FqZET7QAi5cUJXcZOLtjn2JEITz2xdYts5Ndcc0EGps1UFw3d2
	 1vEw6HRhv4inVnUUvaOVlITm4KYKo3FuvJMXs3GeOwIwTAdTRGgiN9B39I/aJvHi53
	 eep3yyqjufhl9fmBfVAnAn/2XEWwdTt9ag5WxXG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/245] wifi: mac80211: skip non-uploaded keys in ieee80211_iter_keys
Date: Wed,  6 Nov 2024 13:01:04 +0100
Message-ID: <20241106120319.520206088@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index eecdd2265eaa6..e45b5f56c4055 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -987,6 +987,26 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 	}
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
@@ -1005,16 +1025,13 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
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
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
@@ -1031,17 +1048,8 @@ _ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
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



