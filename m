Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B851F8924;
	Tue,  3 Dec 2024 15:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240189; cv=none; b=ga40Prp+e1K3/ubvW/wi+dYikvK/Cs9HV/CSZiAnpd7bkkC0lIahRBR1m7uG9Z4Dix2dgPvGglF3uLUe2dFyRPOXWUnJvw+JwSH95Quzl5inkft5o8+SFeYNX2y0yQG5x1ztktOiLRCgPyufdHxSeAlKgdzR81HOSilX7yPOsv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240189; c=relaxed/simple;
	bh=4tss0yVgSyGYmVJVtH3zzs7/I7wSAt9Jntf5E5cH0II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCq7pHGqSY9wfb0UWYa4C0USK+dt5QyBq6yWa/youdWGoMJNpnoDKUKs2hTuKwz5fcSBtzb/qBKx4Sp+4JKuKciQ9fx4VoVJ7uISdxmXYL5bBw7mGcxrhcNIBTteffcKowfaFq6kBwqZnFLutTvLkesspMWaTLkVhu0CyvfdWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R81TVK0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R81TVK0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB82C4CECF;
	Tue,  3 Dec 2024 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240189;
	bh=4tss0yVgSyGYmVJVtH3zzs7/I7wSAt9Jntf5E5cH0II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R81TVK0W2JGwYV+CN3CC+HRNEzSg35OWsU3FMmPFcOPBauho73KKUe8mK07oar0B3
	 jVsS8KRFk08bZJzBu2nuLDXZWgCV6XqUmBOJszBVZzlEOcfAekjIRXLNuIUVCkLQVr
	 9onjxoZK7Ro8YmTJT5OG4q1FnAjBkPyUdv1IBRkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/826] thermal: core: Mark thermal zones as initializing to start with
Date: Tue,  3 Dec 2024 15:36:20 +0100
Message-ID: <20241203144745.542542498@linuxfoundation.org>
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

[ Upstream commit 7837fa8115e0273d3cfbd3d17b3f7b7291ceac08 ]

After thermal_zone_device_register_with_trips() has called
device_register() and it has registered the new thermal zone device
with the driver core, user space may access its sysfs attributes and,
among other things, it may enable the thermal zone before it is ready.

To address this, introduce a new thermal zone state flag for
initialization and set it before calling device_register() in
thermal_zone_device_register_with_trips().  This causes
__thermal_zone_device_update() to return early until the new flag
is cleared.

To clear it when the thermal zone is ready, introduce a new
function called thermal_zone_init_complete() that will also invoke
__thermal_zone_device_update() after clearing that flag (both under the
thernal zone lock) and make thermal_zone_device_register_with_trips()
call the new function instead of checking need_update and calling
thermal_zone_device_update() when it is set.

After this change, if user space enables the thermal zone prematurely,
__thermal_zone_device_update() will return early for it until
thermal_zone_init_complete() is called.  In turn, if the thermal zone
is not enabled by user space before thermal_zone_init_complete() is
called, the __thermal_zone_device_update() call in it will return early
because the thermal zone has not been enabled yet, but that function
will be invoked again by thermal_zone_device_set_mode() when the thermal
zone is enabled and it will not return early this time.

The checking of need_update is not necessary any more because the
__thermal_zone_device_update() calls potentially triggered by cooling
device binding take place before calling thermal_zone_init_complete(),
so they all will return early, which means that
thermal_zone_init_complete() must call __thermal_zone_device_update()
in case the thermal zone is enabled prematurely by user space.

Fixes: 203d3d4aa482 ("the generic thermal sysfs driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/9360231.CDJkKcVGEf@rjwysocki.net
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 16 +++++++++++++---
 drivers/thermal/thermal_core.h |  1 +
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index c3225fbe5c185..b5538df3c4685 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1332,6 +1332,16 @@ int thermal_zone_get_crit_temp(struct thermal_zone_device *tz, int *temp)
 }
 EXPORT_SYMBOL_GPL(thermal_zone_get_crit_temp);
 
+static void thermal_zone_init_complete(struct thermal_zone_device *tz)
+{
+	mutex_lock(&tz->lock);
+
+	tz->state &= ~TZ_STATE_FLAG_INIT;
+	__thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+
+	mutex_unlock(&tz->lock);
+}
+
 /**
  * thermal_zone_device_register_with_trips() - register a new thermal zone device
  * @type:	the thermal zone device type
@@ -1451,6 +1461,8 @@ thermal_zone_device_register_with_trips(const char *type,
 	tz->passive_delay_jiffies = msecs_to_jiffies(passive_delay);
 	tz->recheck_delay_jiffies = THERMAL_RECHECK_DELAY;
 
+	tz->state = TZ_STATE_FLAG_INIT;
+
 	/* sys I/F */
 	/* Add nodes that are always present via .groups */
 	result = thermal_zone_create_device_groups(tz);
@@ -1504,9 +1516,7 @@ thermal_zone_device_register_with_trips(const char *type,
 
 	mutex_unlock(&thermal_list_lock);
 
-	/* Update the new thermal zone and mark it as already updated. */
-	if (atomic_cmpxchg(&tz->need_update, 1, 0))
-		thermal_zone_device_update(tz, THERMAL_EVENT_UNSPECIFIED);
+	thermal_zone_init_complete(tz);
 
 	thermal_notify_tz_create(tz);
 
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 79c52adf6b7f8..421522a2bb9d4 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -63,6 +63,7 @@ struct thermal_governor {
 
 #define	TZ_STATE_FLAG_SUSPENDED	BIT(0)
 #define	TZ_STATE_FLAG_RESUMING	BIT(1)
+#define	TZ_STATE_FLAG_INIT	BIT(2)
 
 #define TZ_STATE_READY		0
 
-- 
2.43.0



