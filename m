Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1274A14A08E;
	Thu,  5 Sep 2024 09:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529950; cv=none; b=hARq5H9R8emfx4SIZcFp7u3e3vleSUILCgBe63M0NICgh/Wd1U5uoUyAAYIhZIaQNB1Y5I+ztCH5s5ScgnwhIVlOQCJ8f/MRoQo+h+agOhifybiHYNX6MnLmwCdTeaYYfVM1zgJXJtvJEFs5ZO2T8hqMkI9hp3qYqUE97rJ7zGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529950; c=relaxed/simple;
	bh=uVWGiM77UPzAImtresMYS5KjV93ovd6eYiZ8479etzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYqwJ8ErpfwUR597m6l7XdoOaMmzfOQDj02g7PGHBSxoDiu4p+7KaxJjaerSj74IorFQH8WkgX0wkjoYe3GHZIYjb4RgiTzDNqM6/74iqX23KksHwkJO7Zl9O0rcy2TWZ7DmM2EvhZNp5H5f8tWb3dHnqzJC9gFahDiG9joF/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rW3FD4Me; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rW3FD4Me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70241C4CEC3;
	Thu,  5 Sep 2024 09:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529949;
	bh=uVWGiM77UPzAImtresMYS5KjV93ovd6eYiZ8479etzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW3FD4Mepzp8LzwKEI2VWz73UfUjLyGZl5++ptLkwiS6qOieZzRiTWjvP0UnG5Kse
	 dwDm9XxOFd/hrhAhP3BZXzyheJyyHIYy4ryePRkM5UelgDIOaTNk7ApKtkk1CMyZOL
	 T2HpKHKcXAWQ74IouQBPAwgPiOm3SyZYUI+lLdiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 156/184] thermal: trip: Use READ_ONCE() for lockless access to trip properties
Date: Thu,  5 Sep 2024 11:41:09 +0200
Message-ID: <20240905093738.435471543@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit a52641bc6293a24f25956a597e7f32148b0e2bb8 ]

When accessing trip temperature and hysteresis without locking, it is
better to use READ_ONCE() to prevent compiler optimizations possibly
affecting the read from being applied.

Of course, for the READ_ONCE() to be effective, WRITE_ONCE() needs to
be used when updating their values.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 6 +++---
 drivers/thermal/thermal_trip.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 88211ccdfbd6..5be6113e7c80 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -150,7 +150,7 @@ trip_point_temp_show(struct device *dev, struct device_attribute *attr,
 	if (sscanf(attr->attr.name, "trip_point_%d_temp", &trip_id) != 1)
 		return -EINVAL;
 
-	return sprintf(buf, "%d\n", tz->trips[trip_id].trip.temperature);
+	return sprintf(buf, "%d\n", READ_ONCE(tz->trips[trip_id].trip.temperature));
 }
 
 static ssize_t
@@ -174,7 +174,7 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 	trip = &tz->trips[trip_id].trip;
 
 	if (hyst != trip->hysteresis) {
-		trip->hysteresis = hyst;
+		WRITE_ONCE(trip->hysteresis, hyst);
 
 		thermal_zone_trip_updated(tz, trip);
 	}
@@ -194,7 +194,7 @@ trip_point_hyst_show(struct device *dev, struct device_attribute *attr,
 	if (sscanf(attr->attr.name, "trip_point_%d_hyst", &trip_id) != 1)
 		return -EINVAL;
 
-	return sprintf(buf, "%d\n", tz->trips[trip_id].trip.hysteresis);
+	return sprintf(buf, "%d\n", READ_ONCE(tz->trips[trip_id].trip.hysteresis));
 }
 
 static ssize_t
diff --git a/drivers/thermal/thermal_trip.c b/drivers/thermal/thermal_trip.c
index 49e63db68517..b4e7411b2fe7 100644
--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -152,7 +152,7 @@ void thermal_zone_set_trip_temp(struct thermal_zone_device *tz,
 	if (trip->temperature == temp)
 		return;
 
-	trip->temperature = temp;
+	WRITE_ONCE(trip->temperature, temp);
 	thermal_notify_tz_trip_change(tz, trip);
 
 	if (temp == THERMAL_TEMP_INVALID) {
-- 
2.43.0



