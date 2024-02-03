Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244A13AC0;
	Sat,  3 Feb 2024 04:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933745; cv=none; b=a8MPR6psgMYbeL34zDKyJlkZjkagx0Z0i6yxnhZP/l4oDqeXZtKNbRZYbZz+f99vptukjuJfvJEMXqiRDPBRLdEQ5lnetM1qJqLyImGRZgwJyD7tlpXd1S7xDZ8WLDO7oS7IshepAtoiMwIYHBXFMnB5wn3uT3tV+6ogfo6o57I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933745; c=relaxed/simple;
	bh=oZSDejc1y/TSO8e4BvpySOawGSXREhDafFXgbzjXWNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw3+t8usChWffG09qGwTXrxYaezywKWFeh4F3uviF1DGID+I+4vVE6IkuI83SpHFcIFdRL0gXBXL5VKePCVkhVSEch7emadGDBG7PDthHbcvlH5XkFiLk+WTME3Cbd0IrovdNxhYSMyFrDf549EMtBNZEYFr/cw3H7uM9Dz57OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsmVMA+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsmVMA+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5251BC43390;
	Sat,  3 Feb 2024 04:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933744;
	bh=oZSDejc1y/TSO8e4BvpySOawGSXREhDafFXgbzjXWNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsmVMA+lHi0eMUsOq4TjXuKhYxy/hEZX35DtiB1J7tSSXZtkxQUTgMQfGZvDucr3d
	 1R6WoarVtS9BtMAnlf7Rd2lovPxMIXdqwmO9N/NQ/4T+2RsP/z5yav5MPGeLjdIk+Y
	 U1d+YWMZ/U+G6o7W5pO0wSaiDLxJzis4YmbTxbls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Ye <bo.ye@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 029/353] thermal: core: Fix thermal zone suspend-resume synchronization
Date: Fri,  2 Feb 2024 20:02:27 -0800
Message-ID: <20240203035404.701418237@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 4e814173a8c4f432fd068b1c796f0416328c9d99 ]

There are 3 synchronization issues with thermal zone suspend-resume
during system-wide transitions:

 1. The resume code runs in a PM notifier which is invoked after user
    space has been thawed, so it can run concurrently with user space
    which can trigger a thermal zone device removal.  If that happens,
    the thermal zone resume code may use a stale pointer to the next
    list element and crash, because it does not hold thermal_list_lock
    while walking thermal_tz_list.

 2. The thermal zone resume code calls thermal_zone_device_init()
    outside the zone lock, so user space or an update triggered by
    the platform firmware may see an inconsistent state of a
    thermal zone leading to unexpected behavior.

 3. Clearing the in_suspend global variable in thermal_pm_notify()
    allows __thermal_zone_device_update() to continue for all thermal
    zones and it may as well run before the thermal_tz_list walk (or
    at any point during the list walk for that matter) and attempt to
    operate on a thermal zone that has not been resumed yet.  It may
    also race destructively with thermal_zone_device_init().

To address these issues, add thermal_list_lock locking to
thermal_pm_notify(), especially arount the thermal_tz_list,
make it call thermal_zone_device_init() back-to-back with
__thermal_zone_device_update() under the zone lock and replace
in_suspend with per-zone bool "suspend" indicators set and unset
under the given zone's lock.

Link: https://lore.kernel.org/linux-pm/20231218162348.69101-1-bo.ye@mediatek.com/
Reported-by: Bo Ye <bo.ye@mediatek.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 30 +++++++++++++++++++++++-------
 include/linux/thermal.h        |  2 ++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 1bc7ba459406..45f51727410c 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -37,8 +37,6 @@ static LIST_HEAD(thermal_governor_list);
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
-static atomic_t in_suspend;
-
 static struct thermal_governor *def_governor;
 
 /*
@@ -405,7 +403,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 {
 	const struct thermal_trip *trip;
 
-	if (atomic_read(&in_suspend))
+	if (tz->suspended)
 		return;
 
 	if (WARN_ONCE(!tz->ops->get_temp,
@@ -1514,17 +1512,35 @@ static int thermal_pm_notify(struct notifier_block *nb,
 	case PM_HIBERNATION_PREPARE:
 	case PM_RESTORE_PREPARE:
 	case PM_SUSPEND_PREPARE:
-		atomic_set(&in_suspend, 1);
+		mutex_lock(&thermal_list_lock);
+
+		list_for_each_entry(tz, &thermal_tz_list, node) {
+			mutex_lock(&tz->lock);
+
+			tz->suspended = true;
+
+			mutex_unlock(&tz->lock);
+		}
+
+		mutex_unlock(&thermal_list_lock);
 		break;
 	case PM_POST_HIBERNATION:
 	case PM_POST_RESTORE:
 	case PM_POST_SUSPEND:
-		atomic_set(&in_suspend, 0);
+		mutex_lock(&thermal_list_lock);
+
 		list_for_each_entry(tz, &thermal_tz_list, node) {
+			mutex_lock(&tz->lock);
+
+			tz->suspended = false;
+
 			thermal_zone_device_init(tz);
-			thermal_zone_device_update(tz,
-						   THERMAL_EVENT_UNSPECIFIED);
+			__thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+
+			mutex_unlock(&tz->lock);
 		}
+
+		mutex_unlock(&thermal_list_lock);
 		break;
 	default:
 		break;
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index cee814d5d1ac..1da1739d75d9 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -149,6 +149,7 @@ struct thermal_cooling_device {
  * @node:	node in thermal_tz_list (in thermal_core.c)
  * @poll_queue:	delayed work for polling
  * @notify_event: Last notification event
+ * @suspended: thermal zone suspend indicator
  */
 struct thermal_zone_device {
 	int id;
@@ -181,6 +182,7 @@ struct thermal_zone_device {
 	struct list_head node;
 	struct delayed_work poll_queue;
 	enum thermal_notify_event notify_event;
+	bool suspended;
 };
 
 /**
-- 
2.43.0



