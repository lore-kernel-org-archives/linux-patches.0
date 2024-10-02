Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7931CF5C6;
	Wed,  2 Oct 2024 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877115; cv=none; b=HTL7fk9xSpa0yofBfXYWDLTY3R2lTf+1iqE3AWDXkleEo2FGieCnWasekSSMFFwqqq+CNW2RK5EWPGL/oN1tJEafACJZmqySLuzkihRj0GfAeb9hLne4vbFkJeycxY+5Q86u9kcAf+bNLHgvn6xohx9pGweIy8j0tRMtOVDZ28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877115; c=relaxed/simple;
	bh=GmiL9WVgJXcbi9acGhUHSv9pRO4/AelWTS7IkLZplHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQJDd3/pLFs6ibWl0c//RtHQAg2VFsfCXTe0HzScEGSPoqeuv8wlMg1KnFz3am2ttCaAN+Uige2M4gm1ntYnZPCnVMkLMA0lU6Q3S2GrveH/BnTk177ajSjvJExjX5l/GeuyB26QRUh4I+07HfhnKOnBr9d+IvX0W+Uban0+XMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FiZid1yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FiZid1yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA568C4CEC2;
	Wed,  2 Oct 2024 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877115;
	bh=GmiL9WVgJXcbi9acGhUHSv9pRO4/AelWTS7IkLZplHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiZid1yiNqZvSJ0MvlxlidiC2s0ueZCCNKwzeRNCUDi7V5McZHdRj7Pi9RCWYeLL0
	 /J0qDwdNCyyT3f6BWb1JrMBhr4A0aW+vfWvtkgYv2wB67pnD6YaddjEEIlBpGW9YBj
	 hjxLnsS9iqYDu6jpVWADUc9W6HHX64QwTHh6kDqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 670/695] thermal: sysfs: Get to trips via attribute pointers
Date: Wed,  2 Oct 2024 15:01:08 +0200
Message-ID: <20241002125849.254864960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

[ Upstream commit afd84fb10ced3caf53769ba734ea237bde0f69e3 ]

The  _store() and _show() functions for sysfs attributes corresponding
to trip point parameters (type, temperature and hysteresis) read the
trip ID from the attribute name and then use the trip ID as the index
in the given thermal zone's trips table to get to the trip object they
want.

Instead of doing this, make them use the attribute pointer they get
as the second argument to get to the trip object embedded in the same
struct thermal_trip_desc as the struct device_attribute pointed to by
it, which is much more straightforward and less overhead.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/114841552.nniJfEyVGO@rjwysocki.net
Stable-dep-of: 874b6476fa88 ("thermal: sysfs: Add sanity checks for trip temperature and hysteresis")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 54 ++++++++++++---------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index f12d5d47da9bd..11a34b9fe153d 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/container_of.h>
 #include <linux/sysfs.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -78,39 +79,38 @@ mode_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+#define thermal_trip_of_attr(_ptr_, _attr_)				\
+	({ 								\
+		struct thermal_trip_desc *td;				\
+									\
+		td = container_of(_ptr_, struct thermal_trip_desc,	\
+				  trip_attrs._attr_.attr);		\
+		&td->trip;						\
+	})
+
 static ssize_t
 trip_point_type_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
-	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip_id;
-
-	if (sscanf(attr->attr.name, "trip_point_%d_type", &trip_id) != 1)
-		return -EINVAL;
+	struct thermal_trip *trip = thermal_trip_of_attr(attr, type);
 
-	return sprintf(buf, "%s\n", thermal_trip_type_name(tz->trips[trip_id].trip.type));
+	return sprintf(buf, "%s\n", thermal_trip_type_name(trip->type));
 }
 
 static ssize_t
 trip_point_temp_store(struct device *dev, struct device_attribute *attr,
 		      const char *buf, size_t count)
 {
+	struct thermal_trip *trip = thermal_trip_of_attr(attr, temp);
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	struct thermal_trip *trip;
-	int trip_id, ret;
-	int temp;
+	int ret, temp;
 
 	ret = kstrtoint(buf, 10, &temp);
 	if (ret)
 		return -EINVAL;
 
-	if (sscanf(attr->attr.name, "trip_point_%d_temp", &trip_id) != 1)
-		return -EINVAL;
-
 	mutex_lock(&tz->lock);
 
-	trip = &tz->trips[trip_id].trip;
-
 	if (temp != trip->temperature) {
 		if (tz->ops.set_trip_temp) {
 			ret = tz->ops.set_trip_temp(tz, trip, temp);
@@ -133,35 +133,25 @@ static ssize_t
 trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
-	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip_id;
+	struct thermal_trip *trip = thermal_trip_of_attr(attr, temp);
 
-	if (sscanf(attr->attr.name, "trip_point_%d_temp", &trip_id) != 1)
-		return -EINVAL;
-
-	return sprintf(buf, "%d\n", READ_ONCE(tz->trips[trip_id].trip.temperature));
+	return sprintf(buf, "%d\n", READ_ONCE(trip->temperature));
 }
 
 static ssize_t
 trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 		      const char *buf, size_t count)
 {
+	struct thermal_trip *trip = thermal_trip_of_attr(attr, hyst);
 	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	struct thermal_trip *trip;
-	int trip_id, ret;
-	int hyst;
+	int ret, hyst;
 
 	ret = kstrtoint(buf, 10, &hyst);
 	if (ret || hyst < 0)
 		return -EINVAL;
 
-	if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip_id) != 1)
-		return -EINVAL;
-
 	mutex_lock(&tz->lock);
 
-	trip = &tz->trips[trip_id].trip;
-
 	if (hyst != trip->hysteresis) {
 		WRITE_ONCE(trip->hysteresis, hyst);
 
@@ -177,13 +167,9 @@ static ssize_t
 trip_point_hyst_show(struct device *dev, struct device_attribute *attr,
 		     char *buf)
 {
-	struct thermal_zone_device *tz = to_thermal_zone(dev);
-	int trip_id;
-
-	if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip_id) != 1)
-		return -EINVAL;
+	struct thermal_trip *trip = thermal_trip_of_attr(attr, hyst);
 
-	return sprintf(buf, "%d\n", READ_ONCE(tz->trips[trip_id].trip.hysteresis));
+	return sprintf(buf, "%d\n", READ_ONCE(trip->hysteresis));
 }
 
 static ssize_t
-- 
2.43.0



