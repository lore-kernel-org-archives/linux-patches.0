Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468DF33DEF9;
	Wed, 30 Sep 2026 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796016; cv=none; b=L0OC0aaynZvdoDOI9VopBiHzhMTBx8O1+EHBDwwCKo6ygP6dbMnZhjGuAnfGcwNJVH9XoSHuo9BIGmO4xWFN+MCX3dLHk9w4DEQD3ILn0POrECOvxJx0lhu+6E1HCaGpoyvxZBRF2W1xIshJ58WnPohmsbE81fgIPsFu86LxWjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796016; c=relaxed/simple;
	bh=0kLjo9r1K0WeGdK9u08pUqGvAtqGliv/yBKMBBJESM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1bQ0uFI2BiVVP0o7LDJc/tgWkih1gobnf14/Q2HB1SDwB//0AClHJEg14Tvx99X2iCJCsFTyLCqUI3QI/wMc/LoWcpLGLmilgqVoGiu+zvcvonX4YdZtocT++U8f4rQVS31F0kM8Xh9aeTweYzeL0ZFUweKSPKCWkqLUC01ZHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXjojdYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXjojdYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14A51F000FF;
	Wed, 30 Sep 2026 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796015;
	bh=ma5bAGL5lRSFbAKDU0+iEiH9rvPLU1UZ/gJadiGfvks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXjojdYl0OlcFwxkvL7dr2CHWoWZ6JDGgksd1w5sNuNACo+rZVW+yhHhzoydTB9BL
	 uFgHbSvMZv054mN4/pXegezOS1LkfNoYmTUJXSLhOnjCe4ND9G0NLP1GnHPXtS1oJW
	 lUYw6LVWv5mUUP+2gPMPCu4flc6e1qQYbmpTX8Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56a1a45a9a2c04d425ff@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0757/1193] wifi: mac80211: suppress chanctx warning for debugfs reset
Date: Wed, 30 Sep 2026 17:24:01 +0200
Message-ID: <20260930152451.072266723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bf29d085e0eba92388518719d044f4702a8c6644 ]

Before suspend all the channel contexts should removed, so the
warning makes sense and should be there, but during reset the
same code is called without first removing. Limit the check to
the real suspend case.

Assisted-by: LLM
Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Reported-by: syzbot+56a1a45a9a2c04d425ff@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56a1a45a9a2c04d425ff
Link: https://patch.msgid.link/20260904165722.fe46395e310b.Ic4aaa95bd9d0ceb6a3cd7d84c425afee7d7d3dd7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         | 2 +-
 net/mac80211/debugfs.c     | 2 +-
 net/mac80211/ieee80211_i.h | 2 +-
 net/mac80211/pm.c          | 8 +++++---
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16270bea49a2f..046853c67e903 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2804,7 +2804,7 @@ static int ieee80211_set_txq_params(struct wiphy *wiphy,
 static int ieee80211_suspend(struct wiphy *wiphy,
 			     struct cfg80211_wowlan *wowlan)
 {
-	return __ieee80211_suspend(wiphy_priv(wiphy), wowlan);
+	return __ieee80211_suspend(wiphy_priv(wiphy), wowlan, false);
 }
 
 static int ieee80211_resume(struct wiphy *wiphy)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index bd7c5dfeaa8c5..0392f3b28263a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -417,7 +417,7 @@ static ssize_t reset_write(struct file *file, const char __user *user_buf,
 
 	rtnl_lock();
 	wiphy_lock(local->hw.wiphy);
-	__ieee80211_suspend(&local->hw, NULL);
+	__ieee80211_suspend(&local->hw, NULL, true);
 	ret = __ieee80211_resume(&local->hw);
 	wiphy_unlock(local->hw.wiphy);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 639268d70f96d..6013e021f5e49 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2231,7 +2231,7 @@ int ieee80211_reconfig(struct ieee80211_local *local);
 void ieee80211_stop_device(struct ieee80211_local *local);
 
 int __ieee80211_suspend(struct ieee80211_hw *hw,
-			struct cfg80211_wowlan *wowlan);
+			struct cfg80211_wowlan *wowlan, bool reset);
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 0ccb5701c7f39..65e0c7bd33b23 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -18,7 +18,8 @@ static void ieee80211_sched_scan_cancel(struct ieee80211_local *local)
 	cfg80211_sched_scan_stopped_locked(local->hw.wiphy, 0);
 }
 
-int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
+int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan,
+			bool reset)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -167,9 +168,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/*
 	 * We disconnected on all interfaces before suspend, all channel
-	 * contexts should be released.
+	 * contexts should be released, but on 'reset' debugfs that's
+	 * not true so don't check there.
 	 */
-	WARN_ON(!list_empty(&local->chanctx_list));
+	WARN_ON(!reset && !list_empty(&local->chanctx_list));
 
 	/* stop hardware - this must stop RX */
 	ieee80211_stop_device(local);
-- 
2.53.0



