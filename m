Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8408DF76;
	Tue, 11 Nov 2025 01:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824942; cv=none; b=dvkUARugJrzb2d6BM5vZKendGucCOrMiOZ2+Hhbz/HqYvE844xbxe13cE1Sytj9N/xpPJeLYJ+720wORQq293Kr0uC15yxcwcwelwKMhv8klvcr6GvBWp8jZ16iCw2qQv3yRSryWc3ym7sILTgnOfDjQuc0kR7nP0L0YflkO45M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824942; c=relaxed/simple;
	bh=OtyaIMsCE/cCW36OS7hWVD3DLnxGCSGlWuiBFC2uPos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkR4gcg1T3P6oQyOMXxHuWYrZJe4I6c+sguZuRZYd28J9v3Pns0lX+gc73TucgXcXiUdEEKg632K/dfssJhii+vMZo427v3BC98xAc/+m1DmgTI2eH2L2/U9Kqcl5lV3H5vT/5pXetUJ+eQPahx2ScFtPVELu0nMpym/yI/bCpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiuLYD6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiuLYD6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A668C113D0;
	Tue, 11 Nov 2025 01:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824942;
	bh=OtyaIMsCE/cCW36OS7hWVD3DLnxGCSGlWuiBFC2uPos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiuLYD6RnZmgqiVnThVMeAGygWUsGRoLyIXYpaHqjqqtStaKuvnP1Cwr7tRqU2Lg0
	 HrzLem7lnTMQeUP/j5jvSQVYI5ttTmh+kRxrtwyeaCpiPR62UnA6/sLT3ZAraZY8E7
	 LVbSfZDSZcZMaVWX/q2b9o+MDtRWgqtT265nQwy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 602/849] wifi: mac80211: Track NAN interface start/stop
Date: Tue, 11 Nov 2025 09:42:52 +0900
Message-ID: <20251111004550.976688309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 8f79d2f13dd3b0af00a5303d4ff913767dd7684e ]

In case that NAN is started, mark the device as non idle,
and set LED triggering similar to scan and ROC. Set the
device to idle once NAN is stopped.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250908140015.2711d62fce22.I9b9f826490e50967a66788d713b0eba985879873@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c         | 20 +++++++++++++++++---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       |  9 +++++++++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e5e82e0b48ff1..4a8de319857e9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -320,6 +320,9 @@ static int ieee80211_start_nan(struct wiphy *wiphy,
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
+	if (sdata->u.nan.started)
+		return -EALREADY;
+
 	ret = ieee80211_check_combinations(sdata, NULL, 0, 0, -1);
 	if (ret < 0)
 		return ret;
@@ -329,12 +332,18 @@ static int ieee80211_start_nan(struct wiphy *wiphy,
 		return ret;
 
 	ret = drv_start_nan(sdata->local, sdata, conf);
-	if (ret)
+	if (ret) {
 		ieee80211_sdata_stop(sdata);
+		return ret;
+	}
 
-	sdata->u.nan.conf = *conf;
+	sdata->u.nan.started = true;
+	ieee80211_recalc_idle(sdata->local);
 
-	return ret;
+	sdata->u.nan.conf.master_pref = conf->master_pref;
+	sdata->u.nan.conf.bands = conf->bands;
+
+	return 0;
 }
 
 static void ieee80211_stop_nan(struct wiphy *wiphy,
@@ -342,8 +351,13 @@ static void ieee80211_stop_nan(struct wiphy *wiphy,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
+	if (!sdata->u.nan.started)
+		return;
+
 	drv_stop_nan(sdata->local, sdata);
+	sdata->u.nan.started = false;
 	ieee80211_sdata_stop(sdata);
+	ieee80211_recalc_idle(sdata->local);
 }
 
 static int ieee80211_nan_change_conf(struct wiphy *wiphy,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 140dc7e32d4aa..7d1e93f51a67b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -977,11 +977,13 @@ struct ieee80211_if_mntr {
  * struct ieee80211_if_nan - NAN state
  *
  * @conf: current NAN configuration
+ * @started: true iff NAN is started
  * @func_lock: lock for @func_inst_ids
  * @function_inst_ids: a bitmap of available instance_id's
  */
 struct ieee80211_if_nan {
 	struct cfg80211_nan_conf conf;
+	bool started;
 
 	/* protects function_inst_ids */
 	spinlock_t func_lock;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index abc8cca54f4e1..a7873832d4fa6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -107,6 +107,7 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
 {
 	bool working, scanning, active;
 	unsigned int led_trig_start = 0, led_trig_stop = 0;
+	struct ieee80211_sub_if_data *iter;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
@@ -117,6 +118,14 @@ static u32 __ieee80211_recalc_idle(struct ieee80211_local *local,
 	working = !local->ops->remain_on_channel &&
 		  !list_empty(&local->roc_list);
 
+	list_for_each_entry(iter, &local->interfaces, list) {
+		if (iter->vif.type == NL80211_IFTYPE_NAN &&
+		    iter->u.nan.started) {
+			working = true;
+			break;
+		}
+	}
+
 	scanning = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
 		   test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning);
 
-- 
2.51.0



