Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BCB76021;
	Mon, 29 Jan 2024 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548616; cv=none; b=I6vjE6nan5pYsePB8JkgqHKQ2ksALriZai7yiQrTs3b+culloyifUdz+R7swf0LAgmDVPzOni63paiqAh725gbjhSUuKhhWiQaRqa8YNLCQR6b8LVKeSxOc2hEUx834BaVqrglh6GwMgNcuYdahe/KxzSxrnOaOIIuas2LDY7KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548616; c=relaxed/simple;
	bh=NU+YpSeEFeFhsXtwx0M15dHvF76wwSy+rQAJhCHNl1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TicU9elh3gJMzy5I5z7Q4IdDRUSMNEsGlLwoDtxI9Dt4d64UxirE1DgN1YVcrAr4db8FWmKhS4hohbYJzIEVZ/2+3eJ6yNE62fwFEcpvZpwGNto9u/EsLV4+eF0+76+UejTdc4I+Efu0rDgH1fEImsD7IYOThR2Z8nUAkI+teZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pe2rzADF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pe2rzADF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7A6C43399;
	Mon, 29 Jan 2024 17:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548616;
	bh=NU+YpSeEFeFhsXtwx0M15dHvF76wwSy+rQAJhCHNl1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pe2rzADFsg8wlQCT9Bk0gjGvI9Brl/yPlEfNlYI9cCqu7PQNQZ9J0q7Owde1F4R8J
	 vb7OBmEU/Gu923JsV1TBo0AyUWrq7KUHVxC5oe8Sts5340frZBOpU1DfNOZPcHZ2oj
	 aFc/N/xxtFhG4pCwZ03haDloUhIFbSijHrwFt1AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/331] thermal: core: Store trip pointer in struct thermal_instance
Date: Mon, 29 Jan 2024 09:05:48 -0800
Message-ID: <20240129170023.172985976@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

[ Upstream commit 2c7b4bfadef08cc0995c24a7b9eb120fe897165f ]

Replace the integer trip number stored in struct thermal_instance with
a pointer to the relevant trip and adjust the code using the structure
in question accordingly.

The main reason for making this change is to allow the trip point to
cooling device binding code more straightforward, as illustrated by
subsequent modifications of the ACPI thermal driver, but it also helps
to clarify the overall design and allows the governor code overhead to
be reduced (through subsequent modifications).

The only case in which it adds complexity is trip_point_show() that
needs to walk the trips[] table to find the index of the given trip
point, but this is not a critical path and the interface that
trip_point_show() belongs to is problematic anyway (for instance, it
doesn't cover the case when the same cooling devices is associated
with multiple trip points).

This is a preliminary change and the affected code will be refined by
a series of subsequent modifications of thermal governors, the core and
the ACPI thermal driver.

The general functionality is not expected to be affected by this change.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: e95fa7404716 ("thermal: gov_power_allocator: avoid inability to reset a cdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c       | 23 ++++++++---------------
 drivers/thermal/gov_fair_share.c      |  5 +++--
 drivers/thermal/gov_power_allocator.c | 11 ++++++++---
 drivers/thermal/gov_step_wise.c       | 16 +++++++---------
 drivers/thermal/thermal_core.c        | 15 ++++++++++-----
 drivers/thermal/thermal_core.h        |  4 +++-
 drivers/thermal/thermal_helpers.c     |  5 ++++-
 drivers/thermal/thermal_sysfs.c       |  3 ++-
 drivers/thermal/thermal_trip.c        | 15 +++++++++++++++
 9 files changed, 60 insertions(+), 37 deletions(-)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index 1b121066521f..49cdfaa3a927 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -13,28 +13,21 @@
 
 #include "thermal_core.h"
 
-static int thermal_zone_trip_update(struct thermal_zone_device *tz, int trip_id)
+static int thermal_zone_trip_update(struct thermal_zone_device *tz, int trip_index)
 {
-	struct thermal_trip trip;
+	const struct thermal_trip *trip = &tz->trips[trip_index];
 	struct thermal_instance *instance;
-	int ret;
-
-	ret = __thermal_zone_get_trip(tz, trip_id, &trip);
-	if (ret) {
-		pr_warn_once("Failed to retrieve trip point %d\n", trip_id);
-		return ret;
-	}
 
-	if (!trip.hysteresis)
+	if (!trip->hysteresis)
 		dev_info_once(&tz->device,
 			      "Zero hysteresis value for thermal zone %s\n", tz->type);
 
 	dev_dbg(&tz->device, "Trip%d[temp=%d]:temp=%d:hyst=%d\n",
-				trip_id, trip.temperature, tz->temperature,
-				trip.hysteresis);
+				trip_index, trip->temperature, tz->temperature,
+				trip->hysteresis);
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
-		if (instance->trip != trip_id)
+		if (instance->trip != trip)
 			continue;
 
 		/* in case fan is in initial state, switch the fan off */
@@ -52,10 +45,10 @@ static int thermal_zone_trip_update(struct thermal_zone_device *tz, int trip_id)
 		 * enable fan when temperature exceeds trip_temp and disable
 		 * the fan in case it falls below trip_temp minus hysteresis
 		 */
-		if (instance->target == 0 && tz->temperature >= trip.temperature)
+		if (instance->target == 0 && tz->temperature >= trip->temperature)
 			instance->target = 1;
 		else if (instance->target == 1 &&
-			 tz->temperature <= trip.temperature - trip.hysteresis)
+			 tz->temperature <= trip->temperature - trip->hysteresis)
 			instance->target = 0;
 
 		dev_dbg(&instance->cdev->device, "target=%d\n",
diff --git a/drivers/thermal/gov_fair_share.c b/drivers/thermal/gov_fair_share.c
index 03c2daeb6ee8..2abeb8979f50 100644
--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -49,7 +49,7 @@ static long get_target_state(struct thermal_zone_device *tz,
 /**
  * fair_share_throttle - throttles devices associated with the given zone
  * @tz: thermal_zone_device
- * @trip: trip point index
+ * @trip_index: trip point index
  *
  * Throttling Logic: This uses three parameters to calculate the new
  * throttle state of the cooling devices associated with the given zone.
@@ -65,8 +65,9 @@ static long get_target_state(struct thermal_zone_device *tz,
  *	(Heavily assumes the trip points are in ascending order)
  * new_state of cooling device = P3 * P2 * P1
  */
-static int fair_share_throttle(struct thermal_zone_device *tz, int trip)
+static int fair_share_throttle(struct thermal_zone_device *tz, int trip_index)
 {
+	const struct thermal_trip *trip = &tz->trips[trip_index];
 	struct thermal_instance *instance;
 	int total_weight = 0;
 	int total_instance = 0;
diff --git a/drivers/thermal/gov_power_allocator.c b/drivers/thermal/gov_power_allocator.c
index 8642f1096b91..1faf55446ba2 100644
--- a/drivers/thermal/gov_power_allocator.c
+++ b/drivers/thermal/gov_power_allocator.c
@@ -90,12 +90,14 @@ static u32 estimate_sustainable_power(struct thermal_zone_device *tz)
 	u32 sustainable_power = 0;
 	struct thermal_instance *instance;
 	struct power_allocator_params *params = tz->governor_data;
+	const struct thermal_trip *trip_max_desired_temperature =
+			&tz->trips[params->trip_max_desired_temperature];
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		struct thermal_cooling_device *cdev = instance->cdev;
 		u32 min_power;
 
-		if (instance->trip != params->trip_max_desired_temperature)
+		if (instance->trip != trip_max_desired_temperature)
 			continue;
 
 		if (!cdev_is_power_actor(cdev))
@@ -383,12 +385,13 @@ static int allocate_power(struct thermal_zone_device *tz,
 {
 	struct thermal_instance *instance;
 	struct power_allocator_params *params = tz->governor_data;
+	const struct thermal_trip *trip_max_desired_temperature =
+			&tz->trips[params->trip_max_desired_temperature];
 	u32 *req_power, *max_power, *granted_power, *extra_actor_power;
 	u32 *weighted_req_power;
 	u32 total_req_power, max_allocatable_power, total_weighted_req_power;
 	u32 total_granted_power, power_range;
 	int i, num_actors, total_weight, ret = 0;
-	int trip_max_desired_temperature = params->trip_max_desired_temperature;
 
 	num_actors = 0;
 	total_weight = 0;
@@ -564,12 +567,14 @@ static void allow_maximum_power(struct thermal_zone_device *tz, bool update)
 {
 	struct thermal_instance *instance;
 	struct power_allocator_params *params = tz->governor_data;
+	const struct thermal_trip *trip_max_desired_temperature =
+			&tz->trips[params->trip_max_desired_temperature];
 	u32 req_power;
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		struct thermal_cooling_device *cdev = instance->cdev;
 
-		if ((instance->trip != params->trip_max_desired_temperature) ||
+		if ((instance->trip != trip_max_desired_temperature) ||
 		    (!cdev_is_power_actor(instance->cdev)))
 			continue;
 
diff --git a/drivers/thermal/gov_step_wise.c b/drivers/thermal/gov_step_wise.c
index 1050fb4d94c2..849dc1ec8d27 100644
--- a/drivers/thermal/gov_step_wise.c
+++ b/drivers/thermal/gov_step_wise.c
@@ -81,26 +81,24 @@ static void update_passive_instance(struct thermal_zone_device *tz,
 
 static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip_id)
 {
+	const struct thermal_trip *trip = &tz->trips[trip_id];
 	enum thermal_trend trend;
 	struct thermal_instance *instance;
-	struct thermal_trip trip;
 	bool throttle = false;
 	int old_target;
 
-	__thermal_zone_get_trip(tz, trip_id, &trip);
-
 	trend = get_tz_trend(tz, trip_id);
 
-	if (tz->temperature >= trip.temperature) {
+	if (tz->temperature >= trip->temperature) {
 		throttle = true;
-		trace_thermal_zone_trip(tz, trip_id, trip.type);
+		trace_thermal_zone_trip(tz, trip_id, trip->type);
 	}
 
 	dev_dbg(&tz->device, "Trip%d[type=%d,temp=%d]:trend=%d,throttle=%d\n",
-				trip_id, trip.type, trip.temperature, trend, throttle);
+		trip_id, trip->type, trip->temperature, trend, throttle);
 
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
-		if (instance->trip != trip_id)
+		if (instance->trip != trip)
 			continue;
 
 		old_target = instance->target;
@@ -114,11 +112,11 @@ static void thermal_zone_trip_update(struct thermal_zone_device *tz, int trip_id
 		/* Activate a passive thermal instance */
 		if (old_target == THERMAL_NO_TARGET &&
 			instance->target != THERMAL_NO_TARGET)
-			update_passive_instance(tz, trip.type, 1);
+			update_passive_instance(tz, trip->type, 1);
 		/* Deactivate a passive thermal instance */
 		else if (old_target != THERMAL_NO_TARGET &&
 			instance->target == THERMAL_NO_TARGET)
-			update_passive_instance(tz, trip.type, -1);
+			update_passive_instance(tz, trip->type, -1);
 
 		instance->initialized = true;
 		mutex_lock(&instance->cdev->lock);
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 2de524fb7be5..1494ffa59754 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -606,7 +606,7 @@ struct thermal_zone_device *thermal_zone_get_by_id(int id)
 /**
  * thermal_zone_bind_cooling_device() - bind a cooling device to a thermal zone
  * @tz:		pointer to struct thermal_zone_device
- * @trip:	indicates which trip point the cooling devices is
+ * @trip_index:	indicates which trip point the cooling devices is
  *		associated with in this thermal zone.
  * @cdev:	pointer to struct thermal_cooling_device
  * @upper:	the Maximum cooling state for this trip point.
@@ -626,7 +626,7 @@ struct thermal_zone_device *thermal_zone_get_by_id(int id)
  * Return: 0 on success, the proper error value otherwise.
  */
 int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
-				     int trip,
+				     int trip_index,
 				     struct thermal_cooling_device *cdev,
 				     unsigned long upper, unsigned long lower,
 				     unsigned int weight)
@@ -635,12 +635,15 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	struct thermal_instance *pos;
 	struct thermal_zone_device *pos1;
 	struct thermal_cooling_device *pos2;
+	const struct thermal_trip *trip;
 	bool upper_no_limit;
 	int result;
 
-	if (trip >= tz->num_trips || trip < 0)
+	if (trip_index >= tz->num_trips || trip_index < 0)
 		return -EINVAL;
 
+	trip = &tz->trips[trip_index];
+
 	list_for_each_entry(pos1, &thermal_tz_list, node) {
 		if (pos1 == tz)
 			break;
@@ -745,7 +748,7 @@ EXPORT_SYMBOL_GPL(thermal_zone_bind_cooling_device);
  * thermal_zone_unbind_cooling_device() - unbind a cooling device from a
  *					  thermal zone.
  * @tz:		pointer to a struct thermal_zone_device.
- * @trip:	indicates which trip point the cooling devices is
+ * @trip_index:	indicates which trip point the cooling devices is
  *		associated with in this thermal zone.
  * @cdev:	pointer to a struct thermal_cooling_device.
  *
@@ -756,13 +759,15 @@ EXPORT_SYMBOL_GPL(thermal_zone_bind_cooling_device);
  * Return: 0 on success, the proper error value otherwise.
  */
 int thermal_zone_unbind_cooling_device(struct thermal_zone_device *tz,
-				       int trip,
+				       int trip_index,
 				       struct thermal_cooling_device *cdev)
 {
 	struct thermal_instance *pos, *next;
+	const struct thermal_trip *trip;
 
 	mutex_lock(&tz->lock);
 	mutex_lock(&cdev->lock);
+	trip = &tz->trips[trip_index];
 	list_for_each_entry_safe(pos, next, &tz->thermal_instances, tz_node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 			list_del(&pos->tz_node);
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index de884bea28b6..024e82ebf592 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -87,7 +87,7 @@ struct thermal_instance {
 	char name[THERMAL_NAME_LENGTH];
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
-	int trip;
+	const struct thermal_trip *trip;
 	bool initialized;
 	unsigned long upper;	/* Highest cooling state for this trip point */
 	unsigned long lower;	/* Lowest cooling state for this trip point */
@@ -119,6 +119,8 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 void __thermal_zone_set_trips(struct thermal_zone_device *tz);
 int __thermal_zone_get_trip(struct thermal_zone_device *tz, int trip_id,
 			    struct thermal_trip *trip);
+int thermal_zone_trip_id(struct thermal_zone_device *tz,
+			 const struct thermal_trip *trip);
 int __thermal_zone_get_temp(struct thermal_zone_device *tz, int *temp);
 
 /* sysfs I/F */
diff --git a/drivers/thermal/thermal_helpers.c b/drivers/thermal/thermal_helpers.c
index 4d66372c9629..c1d0af73c85d 100644
--- a/drivers/thermal/thermal_helpers.c
+++ b/drivers/thermal/thermal_helpers.c
@@ -42,14 +42,17 @@ int get_tz_trend(struct thermal_zone_device *tz, int trip_index)
 
 struct thermal_instance *
 get_thermal_instance(struct thermal_zone_device *tz,
-		     struct thermal_cooling_device *cdev, int trip)
+		     struct thermal_cooling_device *cdev, int trip_index)
 {
 	struct thermal_instance *pos = NULL;
 	struct thermal_instance *target_instance = NULL;
+	const struct thermal_trip *trip;
 
 	mutex_lock(&tz->lock);
 	mutex_lock(&cdev->lock);
 
+	trip = &tz->trips[trip_index];
+
 	list_for_each_entry(pos, &tz->thermal_instances, tz_node) {
 		if (pos->tz == tz && pos->trip == trip && pos->cdev == cdev) {
 			target_instance = pos;
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 4e6a97db894e..eef40d4f3063 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -943,7 +943,8 @@ trip_point_show(struct device *dev, struct device_attribute *attr, char *buf)
 	instance =
 	    container_of(attr, struct thermal_instance, attr);
 
-	return sprintf(buf, "%d\n", instance->trip);
+	return sprintf(buf, "%d\n",
+		       thermal_zone_trip_id(instance->tz, instance->trip));
 }
 
 ssize_t
diff --git a/drivers/thermal/thermal_trip.c b/drivers/thermal/thermal_trip.c
index 4b3a9e77c039..6e5cebd1e63a 100644
--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -172,3 +172,18 @@ int thermal_zone_set_trip(struct thermal_zone_device *tz, int trip_id,
 
 	return 0;
 }
+
+int thermal_zone_trip_id(struct thermal_zone_device *tz,
+			 const struct thermal_trip *trip)
+{
+	int i;
+
+	lockdep_assert_held(&tz->lock);
+
+	for (i = 0; i < tz->num_trips; i++) {
+		if (&tz->trips[i] == trip)
+			return i;
+	}
+
+	return -ENODATA;
+}
-- 
2.43.0



