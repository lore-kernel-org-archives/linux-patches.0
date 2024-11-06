Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB9F1EF08E;
	Wed,  6 Nov 2024 12:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897304; cv=none; b=GBS10i0lwBohZ/sQxh24m5hHgW7imR7hfTP9sE3El6RHY34mSkqzHqcSlY6NkOo70eBCV6b1Q0R/WEJJW8YAy5fB/00FTQcZYtaCVIovvnBWoi4LLum2cv4aQ7LzmCFNVHmiqEJMweKSpF7nH0vZXXV2D8xwhRP9hPL0ZgRjJFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897304; c=relaxed/simple;
	bh=DHTxNp4sCUiU9l4pkrouOboEbHb81B/vVvBThnEUuDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCSrRBoo5RrqUluwSmR9bzbuM82/ycANnSsUMWsRmPFsD0Y82972GXrivLpXl3Hy56/WCUfqoFS2WOAfXVhJCCxLBj4KhtZR1SAOp/QaFaYPwALtgt6ABx4AMBkWiL0zaXmSCQ4beEKnW80nrw2xGGDl86zGiW860UrYjBo258Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9xRcKaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9xRcKaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C99C4CECD;
	Wed,  6 Nov 2024 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897303;
	bh=DHTxNp4sCUiU9l4pkrouOboEbHb81B/vVvBThnEUuDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9xRcKaIB2DsYdtqkTMlynZB3JlGtD98FXVYwBynxIGqqfIj2Z4vFJtW+BTQ7D+Px
	 513lUvqsJvjefcXxDygZ+YkI46nC2QFQtnv8/qbBhmm467a2+zvNdmNstd6NLoa1vO
	 8Q8tyiwlhlFwDywa/EnPBYHE2iQsqC3ylQH7FRQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.6 001/151] thermal: core: Make thermal_zone_device_unregister() return after freeing the zone
Date: Wed,  6 Nov 2024 13:03:09 +0100
Message-ID: <20241106120308.881358118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

[ Upstream commit 4649620d9404d3aceb25891c24bab77143e3f21c ]

Make thermal_zone_device_unregister() wait until all of the references
to the given thermal zone object have been dropped and free it before
returning.

This guarantees that when thermal_zone_device_unregister() returns,
there is no leftover activity regarding the thermal zone in question
which is required by some of its callers (for instance, modular driver
code that wants to know when it is safe to let the module go away).

Subsequently, this will allow some confusing device_is_registered()
checks to be dropped from the thermal sysfs and core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-and-tested-by: Lukasz Luba <lukasz.luba@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: 827a07525c09 ("thermal: core: Free tzp copy along with the thermal zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 6 +++++-
 include/linux/thermal.h        | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index dee3022539cf7..5a9068e8f050d 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -800,7 +800,7 @@ static void thermal_release(struct device *dev)
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
 		mutex_destroy(&tz->lock);
-		kfree(tz);
+		complete(&tz->removal);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
 			    sizeof("cooling_device") - 1)) {
 		cdev = to_cooling_device(dev);
@@ -1294,6 +1294,7 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	INIT_LIST_HEAD(&tz->thermal_instances);
 	ida_init(&tz->ida);
 	mutex_init(&tz->lock);
+	init_completion(&tz->removal);
 	id = ida_alloc(&thermal_tz_ida, GFP_KERNEL);
 	if (id < 0) {
 		result = id;
@@ -1480,6 +1481,9 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	put_device(&tz->device);
 
 	thermal_notify_tz_delete(tz_id);
+
+	wait_for_completion(&tz->removal);
+	kfree(tz);
 }
 EXPORT_SYMBOL_GPL(thermal_zone_device_unregister);
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 4012f440bfdcc..2e9d18ba46531 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -115,6 +115,7 @@ struct thermal_cooling_device {
  * @id:		unique id number for each thermal zone
  * @type:	the thermal zone device type
  * @device:	&struct device for this thermal zone
+ * @removal:	removal completion
  * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
  * @trip_type_attrs:	attributes for trip points for sysfs: trip type
  * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
@@ -156,6 +157,7 @@ struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
 	struct device device;
+	struct completion removal;
 	struct attribute_group trips_attribute_group;
 	struct thermal_attr *trip_temp_attrs;
 	struct thermal_attr *trip_type_attrs;
-- 
2.43.0



