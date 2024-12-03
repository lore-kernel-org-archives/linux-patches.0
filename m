Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D0B1F7578;
	Tue,  3 Dec 2024 14:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237924; cv=none; b=h52FS8zk3I517i8bn2GkzJLb0tSIn3ihVk8MZIfpQpJfY/+9vOTBfR9w/xa1D/PhHX9vABJSX9urMUmd2euQmlLjzUoNOVDh9QVLWRLwUgtp/Rc1Y5ooXN34mcDu9M4hwQrPXBxWWRbFxhRxSdlCY2vmzZkdfkHWPyXjWWzhdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237924; c=relaxed/simple;
	bh=ifoGt1ce3PnesxtRq6M8E+QshLzUQI7r4ohgztzF0So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fwk/wfhenyqkAo8+1h8QMvz6Co8flrKHNoGEop/7q1iJQK/6ay3zrZqMDVysr4HX0WPK3ox69gPGIcfMF0vwvuU6bLjAq85e0N8eAiFErSQ9PUtAqCQUCMRRo7h0ilPDseviNRChL1mx25dLT1CeIgWINyQYr3MT1hdKh0Tvgrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ahH3iKq6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ahH3iKq6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF0FC4CECF;
	Tue,  3 Dec 2024 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237924;
	bh=ifoGt1ce3PnesxtRq6M8E+QshLzUQI7r4ohgztzF0So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ahH3iKq66rNUKvBxS5bvQ4xPJTOfSrFdGdk+23RdryZ2HNT+iBZBN+DKSRbYl9GCL
	 CMlpR9EkBC1OnvwGYpq6vETnFPkmaitXd+nKi3Y8XDal+4x0A2t/aABQrbXjamqWNb
	 ECQwSHc+/ttFaM+8qRJdZvXr3Pu8gM5L3+UBTGdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 101/817] thermal: core: Represent suspend-related thermal zone flags as bits
Date: Tue,  3 Dec 2024 15:34:33 +0100
Message-ID: <20241203143959.649220592@linuxfoundation.org>
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
index 728eca88a56af..7218bcbaf656e 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -553,7 +553,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 	LIST_HEAD(way_up_list);
 	int temp, ret;
 
-	if (tz->suspended || tz->mode != THERMAL_DEVICE_ENABLED)
+	if (tz->state != TZ_STATE_READY || tz->mode != THERMAL_DEVICE_ENABLED)
 		return;
 
 	ret = __thermal_zone_get_temp(tz, &temp);
@@ -1693,7 +1693,7 @@ static void thermal_zone_device_resume(struct work_struct *work)
 
 	mutex_lock(&tz->lock);
 
-	tz->suspended = false;
+	tz->state &= ~(TZ_STATE_FLAG_SUSPENDED | TZ_STATE_FLAG_RESUMING);
 
 	thermal_debug_tz_resume(tz);
 	thermal_zone_device_init(tz);
@@ -1701,7 +1701,6 @@ static void thermal_zone_device_resume(struct work_struct *work)
 	__thermal_zone_device_update(tz, THERMAL_TZ_RESUME);
 
 	complete(&tz->resume);
-	tz->resuming = false;
 
 	mutex_unlock(&tz->lock);
 }
@@ -1710,7 +1709,7 @@ static void thermal_zone_pm_prepare(struct thermal_zone_device *tz)
 {
 	mutex_lock(&tz->lock);
 
-	if (tz->resuming) {
+	if (tz->state & TZ_STATE_FLAG_RESUMING) {
 		/*
 		 * thermal_zone_device_resume() queued up for this zone has not
 		 * acquired the lock yet, so release it to let the function run
@@ -1723,7 +1722,7 @@ static void thermal_zone_pm_prepare(struct thermal_zone_device *tz)
 		mutex_lock(&tz->lock);
 	}
 
-	tz->suspended = true;
+	tz->state |= TZ_STATE_FLAG_SUSPENDED;
 
 	mutex_unlock(&tz->lock);
 }
@@ -1735,7 +1734,7 @@ static void thermal_zone_pm_complete(struct thermal_zone_device *tz)
 	cancel_delayed_work(&tz->poll_queue);
 
 	reinit_completion(&tz->resume);
-	tz->resuming = true;
+	tz->state |= TZ_STATE_FLAG_RESUMING;
 
 	/*
 	 * Replace the work function with the resume one, which will restore the
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index e93a7641736ed..1cf722ba4b71d 100644
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



