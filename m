Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085B1F6698;
	Tue,  3 Dec 2024 14:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237610; cv=none; b=GMB4zIP78B88KvMNkyaRN4ZzJNMO8laWweY+mRIBwQzZwCXk6yzx4Ai8phlDr4q3vXTEhfRSh9ELQzNEsH81sRcMTscOrApIfqLE1/zgmA96wmDnGY0Fw9vm5Xe73uh3eKq771I9WF85eAhHkbnG2l/9XFCqrhUTscOVJADQmdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237610; c=relaxed/simple;
	bh=JiSnIzOal+Pav3ceDYVQ3Be8uuZur/6vHYNrfelAjlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=POonbXO+WdSGo0PSkoYh418L9q5T8kwds4WgiwCVxgx0mbBkzHWDY3VfzfyriTd/dyl9Z9BVriCW4or3Jd0OE5b/5BHxVCrnZTffrfFzRtE5j2yTUrWrwICOWumumt6vQaT0LUwbvRBfNt3NEJeC+xXanitCxtRsXNOk/IYeKsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYSaTBx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYSaTBx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9380CC4CECF;
	Tue,  3 Dec 2024 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237610;
	bh=JiSnIzOal+Pav3ceDYVQ3Be8uuZur/6vHYNrfelAjlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYSaTBx3nH7JbL259S0Uu65bn0wYr+wiJT8LUNIzRA5e/mjtWGuboTvGaCR7dic4m
	 Ls/n/1BriAdWTPwtOQ6eAKB08hYVm2zVSvb+iI+mYFmuucxKmkxAssZ4zUTCVsVto8
	 UUHS09rg3QyK3/ACVcTH2YkoKe5YA7MdWgGjA+vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Remi Pommarel <repk@triplefau.lt>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 002/817] wifi: cfg80211: Add wiphy_delayed_work_pending()
Date: Tue,  3 Dec 2024 15:32:54 +0100
Message-ID: <20241203143955.714324907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

From: Remi Pommarel <repk@triplefau.lt>

[ Upstream commit 68d0021fe7231eec0fb84cd110cf62a6e782b72d ]

Add wiphy_delayed_work_pending() to check if any delayed work timer is
pending, that can be used to be sure that wiphy_delayed_work_queue()
won't postpone an already pending delayed work.

Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Link: https://patch.msgid.link/20240924192805.13859-2-repk@triplefau.lt
[fix return value kernel-doc]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 44 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.c    |  7 +++++++
 2 files changed, 51 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 192d72c8b4654..702653448d2fc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6129,6 +6129,50 @@ void wiphy_delayed_work_cancel(struct wiphy *wiphy,
 void wiphy_delayed_work_flush(struct wiphy *wiphy,
 			      struct wiphy_delayed_work *dwork);
 
+/**
+ * wiphy_delayed_work_pending - Find out whether a wiphy delayable
+ * work item is currently pending.
+ *
+ * @wiphy: the wiphy, for debug purposes
+ * @dwork: the delayed work in question
+ *
+ * Return: true if timer is pending, false otherwise
+ *
+ * How wiphy_delayed_work_queue() works is by setting a timer which
+ * when it expires calls wiphy_work_queue() to queue the wiphy work.
+ * Because wiphy_delayed_work_queue() uses mod_timer(), if it is
+ * called twice and the second call happens before the first call
+ * deadline, the work will rescheduled for the second deadline and
+ * won't run before that.
+ *
+ * wiphy_delayed_work_pending() can be used to detect if calling
+ * wiphy_work_delayed_work_queue() would start a new work schedule
+ * or delayed a previous one. As seen below it cannot be used to
+ * detect precisely if the work has finished to execute nor if it
+ * is currently executing.
+ *
+ *      CPU0                                CPU1
+ * wiphy_delayed_work_queue(wk)
+ *  mod_timer(wk->timer)
+ *                                     wiphy_delayed_work_pending(wk) -> true
+ *
+ * [...]
+ * expire_timers(wk->timer)
+ *  detach_timer(wk->timer)
+ *                                     wiphy_delayed_work_pending(wk) -> false
+ *  wk->timer->function()                          |
+ *   wiphy_work_queue(wk)                          | delayed work pending
+ *    list_add_tail()                              | returns false but
+ *    queue_work(cfg80211_wiphy_work)              | wk->func() has not
+ *                                                 | been run yet
+ * [...]                                           |
+ *  cfg80211_wiphy_work()                          |
+ *   wk->func()                                    V
+ *
+ */
+bool wiphy_delayed_work_pending(struct wiphy *wiphy,
+				struct wiphy_delayed_work *dwork);
+
 /**
  * enum ieee80211_ap_reg_power - regulatory power for an Access Point
  *
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c9ebf9449fcc3..b2b512923ecee 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1705,6 +1705,13 @@ void wiphy_delayed_work_flush(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL_GPL(wiphy_delayed_work_flush);
 
+bool wiphy_delayed_work_pending(struct wiphy *wiphy,
+				struct wiphy_delayed_work *dwork)
+{
+	return timer_pending(&dwork->timer);
+}
+EXPORT_SYMBOL_GPL(wiphy_delayed_work_pending);
+
 static int __init cfg80211_init(void)
 {
 	int err;
-- 
2.43.0



