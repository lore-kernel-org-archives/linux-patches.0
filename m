Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993DE1118B;
	Sat,  3 Feb 2024 04:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933495; cv=none; b=I8+Z8ud89s/UpuDg4GtOs+9Cf+7pgk7qT3nOFbFi9b4GkriKyA5rTSsoomCFqakEMws6htXW3SsjEcvaMg5xcZUKjwiO35eSWwK8d7w9LXrLgmQWeaI61uVIpyZS0Qpm/3FPnnVREhR+T9zEtusJff+FeEXmGQnx2dnkEZkFfzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933495; c=relaxed/simple;
	bh=nu766SimR8VrCemGXDtCZD6Gf7m8KSOgYJCUTQoklG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3GDl5A+64pe8AxppxUTGEK0fzd+RR0e9BaJbQYPsCGb3I9WJJXLVdGihbqEI+flOM/fgQjzl2T8kpWDSDCl7sc3a9Qko3cTwdXs0PNo5KnJwzwyxG6WYmOtN2TCRr9Y0QG3Sn+98P/VVQRD8XflH/55xTP1Ks82CP1cs1yR9Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLqAFN2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLqAFN2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DC6C43399;
	Sat,  3 Feb 2024 04:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933495;
	bh=nu766SimR8VrCemGXDtCZD6Gf7m8KSOgYJCUTQoklG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLqAFN2nsFrL6Fi7iTSgxlbVyK56tVbOU8CIgzqFU9mb1RNDYEfJ6svXJFVG6hyE3
	 v5Oi6XKHMPKrQ01QgLHVpKwNnB0YEEEV1N3S+PE00dn6LpK/JJkZkur6fBONDOcvO4
	 WapkZywfxzVMrJnIewHBIxZlsV9Lx/1S3I3UxRRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Ye <bo.ye@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/322] thermal: core: Fix thermal zone suspend-resume synchronization
Date: Fri,  2 Feb 2024 20:02:02 -0800
Message-ID: <20240203035359.860066050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 1494ffa59754..dee3022539cf 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -37,8 +37,6 @@ static LIST_HEAD(thermal_governor_list);
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
 
-static atomic_t in_suspend;
-
 static struct thermal_governor *def_governor;
 
 /*
@@ -409,7 +407,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 {
 	int count;
 
-	if (atomic_read(&in_suspend))
+	if (tz->suspended)
 		return;
 
 	if (WARN_ONCE(!tz->ops->get_temp,
@@ -1532,17 +1530,35 @@ static int thermal_pm_notify(struct notifier_block *nb,
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
index a5ae4af955ff..4012f440bfdc 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -150,6 +150,7 @@ struct thermal_cooling_device {
  * @node:	node in thermal_tz_list (in thermal_core.c)
  * @poll_queue:	delayed work for polling
  * @notify_event: Last notification event
+ * @suspended: thermal zone suspend indicator
  */
 struct thermal_zone_device {
 	int id;
@@ -183,6 +184,7 @@ struct thermal_zone_device {
 	struct list_head node;
 	struct delayed_work poll_queue;
 	enum thermal_notify_event notify_event;
+	bool suspended;
 };
 
 /**
-- 
2.43.0



