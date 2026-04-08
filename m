Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761825A321;
	Wed,  8 Apr 2026 19:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775675003; cv=none; b=G3zjIKlINwaYTKOZmsEF9TIWk7k6XJuxOZGyXpDBfXbpP4oCoAArU12Ih8t56ntPPVKTdxN9p4gAWIX7haGBm74KRcXcJ2PaiN39+7W+rvEYLRTlkYi0ZoVxWj86O7r265cezFSFHza6PxJ5QT9wwfOYASGC4hUZMBK8LDo1zz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775675003; c=relaxed/simple;
	bh=uegrjh7h4nvi7PWoCBmIDP+CxTvB+q+24t5/Qs/ViKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1jnVtoTu385el+2SAfdZZaQMvGg6QuQMaxiJWcbuONkYReL5eVu9LZh8gNYlJUaPP0eibWk9ZxzV9tns9hibcMr69UIf/K5GZQWFgDOzdknvxOI4AtSeRE+wHV+MeiXH9YIE7m1PnxdUA9lOnFp+9fpWMNINvpiAA/xDUAPdhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1JZxMM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1JZxMM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEFFC19421;
	Wed,  8 Apr 2026 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775675002;
	bh=uegrjh7h4nvi7PWoCBmIDP+CxTvB+q+24t5/Qs/ViKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1JZxMM+zpWJolEHGLXvj2oJYYWh/yLEoEK+LsZHrfQgq2NuEwNi+dpXmcXOOTy0W
	 9ihKSdPjmALoqH5+wrcsDzz2ziNrcKxD33/ftb4eMJAP2cPeDwv7fq2XpRN9SZywIX
	 i/8Y2Vdpf/nGVT8AClPq3IUsGa3It4Ky1H0aW35I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3b3852c6031d0f30dfaf@syzkaller.appspotmail.com,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.19 285/311] thermal: core: Address thermal zone removal races with resume
Date: Wed,  8 Apr 2026 20:04:45 +0200
Message-ID: <20260408175950.022943176@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 45b859b0728267a6199ee5002d62e6c6f3e8c89d upstream.

Since thermal_zone_pm_complete() and thermal_zone_device_resume()
re-initialize the poll_queue delayed work for the given thermal zone,
the cancel_delayed_work_sync() in thermal_zone_device_unregister()
may miss some already running work items and the thermal zone may
be freed prematurely [1].

There are two failing scenarios that both start with
running thermal_pm_notify_complete() right before invoking
thermal_zone_device_unregister() for one of the thermal zones.

In the first scenario, there is a work item already running for
the given thermal zone when thermal_pm_notify_complete() calls
thermal_zone_pm_complete() for that thermal zone and it continues to
run when thermal_zone_device_unregister() starts.  Since the poll_queue
delayed work has been re-initialized by thermal_pm_notify_complete(), the
running work item will be missed by the cancel_delayed_work_sync() in
thermal_zone_device_unregister() and if it continues to run past the
freeing of the thermal zone object, a use-after-free will occur.

In the second scenario, thermal_zone_device_resume() queued up by
thermal_pm_notify_complete() runs right after the thermal_zone_exit()
called by thermal_zone_device_unregister() has returned.  The poll_queue
delayed work is re-initialized by it before cancel_delayed_work_sync() is
called by thermal_zone_device_unregister(), so it may continue to run
after the freeing of the thermal zone object, which also leads to a
use-after-free.

Address the first failing scenario by ensuring that no thermal work
items will be running when thermal_pm_notify_complete() is called.
For this purpose, first move the cancel_delayed_work() call from
thermal_zone_pm_complete() to thermal_zone_pm_prepare() to prevent
new work from entering the workqueue going forward.  Next, switch
over to using a dedicated workqueue for thermal events and update
the code in thermal_pm_notify() to flush that workqueue after
thermal_pm_notify_prepare() has returned which will take care of
all leftover thermal work already on the workqueue (that leftover
work would do nothing useful anyway because all of the thermal zones
have been flagged as suspended).

The second failing scenario is addressed by adding a tz->state check
to thermal_zone_device_resume() to prevent it from re-initializing
the poll_queue delayed work if the thermal zone is going away.

Note that the above changes will also facilitate relocating the suspend
and resume of thermal zones closer to the suspend and resume of devices,
respectively.

Fixes: 5a5efdaffda5 ("thermal: core: Resume thermal zones asynchronously")
Reported-by: syzbot+3b3852c6031d0f30dfaf@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=3b3852c6031d0f30dfaf
Reported-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Closes: https://lore.kernel.org/linux-pm/20260324-thermal-core-uaf-init_delayed_work-v1-1-6611ae76a8a1@igalia.com/ [1]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Tested-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/6267615.lOV4Wx5bFT@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -41,6 +41,8 @@ static struct thermal_governor *def_gove
 
 static bool thermal_pm_suspended;
 
+static struct workqueue_struct *thermal_wq __ro_after_init;
+
 /*
  * Governor section: set of functions to handle thermal governors
  *
@@ -313,7 +315,7 @@ static void thermal_zone_device_set_poll
 	if (delay > HZ)
 		delay = round_jiffies_relative(delay);
 
-	mod_delayed_work(system_freezable_power_efficient_wq, &tz->poll_queue, delay);
+	mod_delayed_work(thermal_wq, &tz->poll_queue, delay);
 }
 
 static void thermal_zone_recheck(struct thermal_zone_device *tz, int error)
@@ -1781,6 +1783,10 @@ static void thermal_zone_device_resume(s
 
 	guard(thermal_zone)(tz);
 
+	/* If the thermal zone is going away, there's nothing to do. */
+	if (tz->state & TZ_STATE_FLAG_EXIT)
+		return;
+
 	tz->state &= ~(TZ_STATE_FLAG_SUSPENDED | TZ_STATE_FLAG_RESUMING);
 
 	thermal_debug_tz_resume(tz);
@@ -1807,6 +1813,9 @@ static void thermal_zone_pm_prepare(stru
 	}
 
 	tz->state |= TZ_STATE_FLAG_SUSPENDED;
+
+	/* Prevent new work from getting to the workqueue subsequently. */
+	cancel_delayed_work(&tz->poll_queue);
 }
 
 static void thermal_pm_notify_prepare(void)
@@ -1825,8 +1834,6 @@ static void thermal_zone_pm_complete(str
 {
 	guard(thermal_zone)(tz);
 
-	cancel_delayed_work(&tz->poll_queue);
-
 	reinit_completion(&tz->resume);
 	tz->state |= TZ_STATE_FLAG_RESUMING;
 
@@ -1836,7 +1843,7 @@ static void thermal_zone_pm_complete(str
 	 */
 	INIT_DELAYED_WORK(&tz->poll_queue, thermal_zone_device_resume);
 	/* Queue up the work without a delay. */
-	mod_delayed_work(system_freezable_power_efficient_wq, &tz->poll_queue, 0);
+	mod_delayed_work(thermal_wq, &tz->poll_queue, 0);
 }
 
 static void thermal_pm_notify_complete(void)
@@ -1859,6 +1866,11 @@ static int thermal_pm_notify(struct noti
 	case PM_RESTORE_PREPARE:
 	case PM_SUSPEND_PREPARE:
 		thermal_pm_notify_prepare();
+		/*
+		 * Allow any leftover thermal work items already on the
+		 * worqueue to complete so they don't get in the way later.
+		 */
+		flush_workqueue(thermal_wq);
 		break;
 	case PM_POST_HIBERNATION:
 	case PM_POST_RESTORE:
@@ -1891,9 +1903,16 @@ static int __init thermal_init(void)
 	if (result)
 		goto error;
 
+	thermal_wq = alloc_workqueue("thermal_events",
+				      WQ_FREEZABLE | WQ_POWER_EFFICIENT | WQ_PERCPU, 0);
+	if (!thermal_wq) {
+		result = -ENOMEM;
+		goto unregister_netlink;
+	}
+
 	result = thermal_register_governors();
 	if (result)
-		goto unregister_netlink;
+		goto destroy_workqueue;
 
 	thermal_class = kzalloc(sizeof(*thermal_class), GFP_KERNEL);
 	if (!thermal_class) {
@@ -1920,6 +1939,8 @@ static int __init thermal_init(void)
 
 unregister_governors:
 	thermal_unregister_governors();
+destroy_workqueue:
+	destroy_workqueue(thermal_wq);
 unregister_netlink:
 	thermal_netlink_exit();
 error:


