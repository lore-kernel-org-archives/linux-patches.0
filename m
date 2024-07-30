Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D499166315;
	Tue, 30 Jul 2024 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360818; cv=none; b=EZodbBpvXRqaon5ZfKZxIf4rkXhYUOiWX5ayvksAhJ4BUaJD5YE8ww4U3rMIIl09vuGYPusW6DPBkrV5YyCX1K3WQOIJzB03eSnX0Oa4VadLxvPtxAaRq3ElX9QPFbqW97BLv2+pZixYoFy1YKvUVB6SevoUIigdxXuOs5TxaLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360818; c=relaxed/simple;
	bh=t6DbzTOemxmtETTtSAFzBAh7PfOZ3b/vdkYHx5HPPys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK7KPzGtu5xUalZG6SqTxGSPPKw/IPWi2JRs8I4KJE9xES8964QhxvyfVJsYUhj+E3zl26NcxqD/Z/lYdir087kv1UKIfNar4UYO+kh+/QRUBGD4q30mWfn4TwdzgOMCCkKguXpxPAC4EtghwaLft2RL37bN66itYFTILADMtI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ka1pPn6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ka1pPn6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AABC4AF0E;
	Tue, 30 Jul 2024 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360817;
	bh=t6DbzTOemxmtETTtSAFzBAh7PfOZ3b/vdkYHx5HPPys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ka1pPn6z6sfXcKwVzfKzI6lunVx7xFEOtLZEQb/JWC4yv3DJtggd3Iq5SbqMJ3gz6
	 EwZFlYY8bnlvvmbexHnDdj0iMCwGjIsAU+N+43Jxsj6n7UG2GiDOtC/CP5/G0Tdmuh
	 GkB1NyDq2lClSE5RfV1mekROCgBWLBqThxH1C7p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Yan <tom.ty89@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 801/809] thermal: core: Back off when polling thermal zones on errors
Date: Tue, 30 Jul 2024 17:51:17 +0200
Message-ID: <20240730151756.618149993@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit f7c1b0e4ae47e67c6f9af84568a5f4a80638ccd8 ]

Commit a8a261774466 ("thermal: core: Call monitor_thermal_zone() if zone
temperature is invalid") introduced a polling mechanism by which the
thermal core attampts to get a valid temperature value for thermal zones
where the .get_temp() callback returns errors to start with (for
example, due to initialization ordering woes).  However, this polling is
carried out periodically ad infinitum and every iteration of it causes
a message to be printed to the kernel log which means a lot of log noise
on systems where there are thermal zones that never get ready for some
reason.  It is also not really useful to continuously poll thermal zones
that never respond.

To address this, modify the thermal core to increase the delay between
consecutive thermal zone temperature checks after every check that fails
until it reaches a certain maximum value.  At that point, the thermal
zone in question will be disabled, but user space will be able to
reenable it if it believes that the failure is transient.

Also change the code to print messages regarding failed temperature
checks to the kernel log only twice, once when the thermal zone's
.get_temp() callback returns an error for the first time and once when
disabling the given thermal zone.  In addition, a dev_crit() message
will be printed at that point if the given thermal zone contains a
critical trip point to notify the system operator about the situation.

Fixes: a8a261774466 ("thermal: core: Call monitor_thermal_zone() if zone temperature is invalid")
Link: https://lore.kernel.org/linux-acpi/CAGnHSE=RyPK++UG0-wAtVKgeJxe0uzFYgLxm+RUOKKoQquW=Ow@mail.gmail.com/
Reported-by: Tom Yan <tom.ty89@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2962033.e9J7NaK4W3@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 58 +++++++++++++++++++++++++++++++---
 drivers/thermal/thermal_core.h | 10 ++++--
 2 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 657c57a40b4d4..f2d31bc48f529 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -288,6 +288,28 @@ static int __thermal_zone_device_set_mode(struct thermal_zone_device *tz,
 	return 0;
 }
 
+static void thermal_zone_broken_disable(struct thermal_zone_device *tz)
+{
+	struct thermal_trip_desc *td;
+
+	dev_err(&tz->device, "Unable to get temperature, disabling!\n");
+	/*
+	 * This function only runs for enabled thermal zones, so no need to
+	 * check for the current mode.
+	 */
+	__thermal_zone_device_set_mode(tz, THERMAL_DEVICE_DISABLED);
+	thermal_notify_tz_disable(tz);
+
+	for_each_trip_desc(tz, td) {
+		if (td->trip.type == THERMAL_TRIP_CRITICAL &&
+		    td->trip.temperature > THERMAL_TEMP_INVALID) {
+			dev_crit(&tz->device,
+				 "Disabled thermal zone with critical trip point\n");
+			return;
+		}
+	}
+}
+
 /*
  * Zone update section: main control loop applied to each zone while monitoring
  * in polling mode. The monitoring is done using a workqueue.
@@ -308,6 +330,34 @@ static void thermal_zone_device_set_polling(struct thermal_zone_device *tz,
 		cancel_delayed_work(&tz->poll_queue);
 }
 
+static void thermal_zone_recheck(struct thermal_zone_device *tz, int error)
+{
+	if (error == -EAGAIN) {
+		thermal_zone_device_set_polling(tz, THERMAL_RECHECK_DELAY);
+		return;
+	}
+
+	/*
+	 * Print the message once to reduce log noise.  It will be followed by
+	 * another one if the temperature cannot be determined after multiple
+	 * attempts.
+	 */
+	if (tz->recheck_delay_jiffies == THERMAL_RECHECK_DELAY)
+		dev_info(&tz->device, "Temperature check failed (%d)\n", error);
+
+	thermal_zone_device_set_polling(tz, tz->recheck_delay_jiffies);
+
+	tz->recheck_delay_jiffies += max(tz->recheck_delay_jiffies >> 1, 1ULL);
+	if (tz->recheck_delay_jiffies > THERMAL_MAX_RECHECK_DELAY) {
+		thermal_zone_broken_disable(tz);
+		/*
+		 * Restore the original recheck delay value to allow the thermal
+		 * zone to try to recover when it is reenabled by user space.
+		 */
+		tz->recheck_delay_jiffies = THERMAL_RECHECK_DELAY;
+	}
+}
+
 static void monitor_thermal_zone(struct thermal_zone_device *tz)
 {
 	if (tz->mode != THERMAL_DEVICE_ENABLED)
@@ -504,10 +554,7 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 
 	ret = __thermal_zone_get_temp(tz, &temp);
 	if (ret) {
-		if (ret != -EAGAIN)
-			dev_info(&tz->device, "Temperature check failed (%d)\n", ret);
-
-		thermal_zone_device_set_polling(tz, msecs_to_jiffies(THERMAL_RECHECK_DELAY_MS));
+		thermal_zone_recheck(tz, ret);
 		return;
 	} else if (temp <= THERMAL_TEMP_INVALID) {
 		/*
@@ -519,6 +566,8 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 		goto monitor;
 	}
 
+	tz->recheck_delay_jiffies = THERMAL_RECHECK_DELAY;
+
 	tz->last_temperature = tz->temperature;
 	tz->temperature = temp;
 
@@ -1450,6 +1499,7 @@ thermal_zone_device_register_with_trips(const char *type,
 
 	thermal_set_delay_jiffies(&tz->passive_delay_jiffies, passive_delay);
 	thermal_set_delay_jiffies(&tz->polling_delay_jiffies, polling_delay);
+	tz->recheck_delay_jiffies = THERMAL_RECHECK_DELAY;
 
 	/* sys I/F */
 	/* Add nodes that are always present via .groups */
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 5afd541d54b0b..56113c9db5755 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -67,6 +67,8 @@ struct thermal_governor {
  * @polling_delay_jiffies: number of jiffies to wait between polls when
  *			checking whether trip points have been crossed (0 for
  *			interrupt driven systems)
+ * @recheck_delay_jiffies: delay after a failed attempt to determine the zone
+ * 			temperature before trying again
  * @temperature:	current temperature.  This is only for core code,
  *			drivers should use thermal_zone_get_temp() to get the
  *			current temperature
@@ -108,6 +110,7 @@ struct thermal_zone_device {
 	int num_trips;
 	unsigned long passive_delay_jiffies;
 	unsigned long polling_delay_jiffies;
+	unsigned long recheck_delay_jiffies;
 	int temperature;
 	int last_temperature;
 	int emul_temperature;
@@ -137,10 +140,11 @@ struct thermal_zone_device {
 #define THERMAL_TEMP_INIT	INT_MIN
 
 /*
- * Default delay after a failing thermal zone temperature check before
- * attempting to check it again.
+ * Default and maximum delay after a failed thermal zone temperature check
+ * before attempting to check it again (in jiffies).
  */
-#define THERMAL_RECHECK_DELAY_MS	250
+#define THERMAL_RECHECK_DELAY		msecs_to_jiffies(250)
+#define THERMAL_MAX_RECHECK_DELAY	(120 * HZ)
 
 /* Default Thermal Governor */
 #if defined(CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE)
-- 
2.43.0



