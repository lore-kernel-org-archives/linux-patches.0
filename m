Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937A2B9A6;
	Thu,  3 Jul 2025 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555011; cv=none; b=ilmuUwxmsBxn978r5/1gHMsu1GSiTXnjdnzgiNNXDD+edXWN5FG1MIjkHkklBNGjaLTv+qMYxtEIudGbGEjIeOrISzHA4+tyc11TDQ2j31vE43dxFd7hVA1gUyEUXTmP3W3iNruZE8AI+Jg8UbhQGsEYb90o+fEFO1anowcI3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555011; c=relaxed/simple;
	bh=hZAmVJaZ33Cmq0Vw0cV71Jb0S6WlSJ7NEEIZqjmEWss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSAOSjs9VCKgkWAHnxZV0EGkE28S/BdLwtXCrJg3XLX3ROjJuKbumvQJhHj5QtdKf/onVT5bi06yFRvZPxpXF415Tm7nYnRq9uvaARV3CDSTfiJ3dE9r7m51229brI2irWXj0Wrz9YW1m0FmdjciwisrlJeAkDLYynPyrUg6cKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtOZzAZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtOZzAZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29367C4CEE3;
	Thu,  3 Jul 2025 15:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555011;
	bh=hZAmVJaZ33Cmq0Vw0cV71Jb0S6WlSJ7NEEIZqjmEWss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtOZzAZmkU/IlUZPCbdgRJvuWB7XSaGQ6+RulvZ0RpLEYBXZlfC6XMlC4YuHChYd4
	 6GBQLnPOky/OYHIF3PHxKdYM/CkgB6buC4bphHjoySs4OIlAtrKKDE+QjkjBt6SN5n
	 TLeISNXfWjUWyfYGD3sMNbqAEK2zyCOKuwX0MnBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 148/263] wifi: mac80211: finish link init before RCU publish
Date: Thu,  3 Jul 2025 16:41:08 +0200
Message-ID: <20250703144010.291450634@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d87c3ca0f8f1ca4c25f2ed819e954952f4d8d709 ]

Since the link/conf pointers can be accessed without any
protection other than RCU, make sure the data is actually
set up before publishing the structures.

Fixes: b2e8434f1829 ("wifi: mac80211: set up/tear down client vif links properly")
Link: https://patch.msgid.link/20250624130749.9a308b713c74.I4a80f5eead112a38730939ea591d2e275c721256@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index d40c2bd3b50b0..4f7b7d0f64f24 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -93,9 +93,6 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 	if (link_id < 0)
 		link_id = 0;
 
-	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
-	rcu_assign_pointer(sdata->link[link_id], link);
-
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		struct ieee80211_sub_if_data *ap_bss;
 		struct ieee80211_bss_conf *ap_bss_conf;
@@ -145,6 +142,9 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_link_debugfs_add(link);
 	}
+
+	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
+	rcu_assign_pointer(sdata->link[link_id], link);
 }
 
 void ieee80211_link_stop(struct ieee80211_link_data *link)
-- 
2.39.5



