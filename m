Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0A41F9A9C;
	Tue,  3 Dec 2024 15:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240186; cv=none; b=mRDMNTrjrNINfJh2DafIQKvr2lUdhTc3wn490QEf/ca3OpV3gNqLpA4nm96pB46Vf0JCHY4EsXUQcFjoN+ryOvJCJHOznVityFRW9lqAiQ7uGH23Uvc+BBOS0KjesFLTn1iKoIlatjK59P4Enk3c2TsP9+U01QMk8XZ05IvP2s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240186; c=relaxed/simple;
	bh=3ux6sdDZ0kMM8a1n+A6IcKUxryHV9jp9nxScgoxyNMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK+5aYe6ogV1yuJElTpdo/7RHGa2D6lj4LIivNTlDNt5umef1tfO+W4ZhjATYXiGBHuiEfxW+IEvJ2/BOW4yc0TlRsDjGKNlWGK70hVB5FGU9BMC1FwApZ2qIXOMvmGZPphRGTYbUEHPefyuGHUKwvDweEpYB1SdvK6lwBfKlXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvjLir/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvjLir/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74DFC4CECF;
	Tue,  3 Dec 2024 15:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240186;
	bh=3ux6sdDZ0kMM8a1n+A6IcKUxryHV9jp9nxScgoxyNMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvjLir/U9Z5oLyRYhth2fmWCCXdCSBAVz6tbEmzzWcFn4s+ti2vna3EFrp37wnOW0
	 eo8Gc8sE5sWtnny8eY+GIqwRGYErWZ5lTGb3NjQgbK3DgcDr9c5laT+XahJcvlqC+Z
	 l2PuDnDfTXYHrjB8KXRdYuB1Kq1k7w6U9YlI9Ovw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/826] thermal: core: Represent suspend-related thermal zone flags as bits
Date: Tue,  3 Dec 2024 15:36:19 +0100
Message-ID: <20241203144745.504716121@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 26c9ab8090cda1eb3d42f491cc32d227404897da ]

Instead of using two separate fields in struct thermal_zone_device for
representing flags related to thermal zone suspend, represent them
explicitly as bits in one u8 "state" field.

Subsequently, that field will be used for addressing race conditions
related to thermal zone initialization and exit.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/7733910.EvYhyI6sBW@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Stable-dep-of: 7837fa8115e0 ("thermal: core: Mark thermal zones as initializing to start with")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 11 +++++------
 drivers/thermal/thermal_core.h | 11 +++++++----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9198861916969..c3225fbe5c185 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -547,7 +547,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 	int low = -INT_MAX, high = INT_MAX;
 	int temp, ret;
 
-	if (tz->suspended || tz->mode != THERMAL_DEVICE_ENABLED)
+	if (tz->state != TZ_STATE_READY || tz->mode != THERMAL_DEVICE_ENABLED)
 		return;
 
 	ret = __thermal_zone_get_temp(tz, &temp);
@@ -1662,7 +1662,7 @@ static void thermal_zone_device_resume(struct work_struct *work)
 
 	mutex_lock(&tz->lock);
 
-	tz->suspended = false;
+	tz->state &= ~(TZ_STATE_FLAG_SUSPENDED | TZ_STATE_FLAG_RESUMING);
 
 	thermal_debug_tz_resume(tz);
 	thermal_zone_device_init(tz);
@@ -1670,7 +1670,6 @@ static void thermal_zone_device_resume(struct work_struct *work)
 	__thermal_zone_device_update(tz, THERMAL_TZ_RESUME);
 
 	complete(&tz->resume);
-	tz->resuming = false;
 
 	mutex_unlock(&tz->lock);
 }
@@ -1679,7 +1678,7 @@ static void thermal_zone_pm_prepare(struct thermal_zone_device *tz)
 {
 	mutex_lock(&tz->lock);
 
-	if (tz->resuming) {
+	if (tz->state & TZ_STATE_FLAG_RESUMING) {
 		/*
 		 * thermal_zone_device_resume() queued up for this zone has not
 		 * acquired the lock yet, so release it to let the function run
@@ -1692,7 +1691,7 @@ static void thermal_zone_pm_prepare(struct thermal_zone_device *tz)
 		mutex_lock(&tz->lock);
 	}
 
-	tz->suspended = true;
+	tz->state |= TZ_STATE_FLAG_SUSPENDED;
 
 	mutex_unlock(&tz->lock);
 }
@@ -1704,7 +1703,7 @@ static void thermal_zone_pm_complete(struct thermal_zone_device *tz)
 	cancel_delayed_work(&tz->poll_queue);
 
 	reinit_completion(&tz->resume);
-	tz->resuming = true;
+	tz->state |= TZ_STATE_FLAG_RESUMING;
 
 	/*
 	 * Replace the work function with the resume one, which will restore the
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index a64d39b1c86b2..79c52adf6b7f8 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -61,6 +61,11 @@ struct thermal_governor {
 	struct list_head	governor_list;
 };
 
+#define	TZ_STATE_FLAG_SUSPENDED	BIT(0)
+#define	TZ_STATE_FLAG_RESUMING	BIT(1)
+
+#define TZ_STATE_READY		0
+
 /**
  * struct thermal_zone_device - structure for a thermal zone
  * @id:		unique id number for each thermal zone
@@ -100,8 +105,7 @@ struct thermal_governor {
  * @node:	node in thermal_tz_list (in thermal_core.c)
  * @poll_queue:	delayed work for polling
  * @notify_event: Last notification event
- * @suspended: thermal zone suspend indicator
- * @resuming:	indicates whether or not thermal zone resume is in progress
+ * @state: 	current state of the thermal zone
  * @trips:	array of struct thermal_trip objects
  */
 struct thermal_zone_device {
@@ -134,8 +138,7 @@ struct thermal_zone_device {
 	struct list_head node;
 	struct delayed_work poll_queue;
 	enum thermal_notify_event notify_event;
-	bool suspended;
-	bool resuming;
+	u8 state;
 #ifdef CONFIG_THERMAL_DEBUGFS
 	struct thermal_debugfs *debugfs;
 #endif
-- 
2.43.0



