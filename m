Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6018F1CF5C6;
	Wed,  2 Oct 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877118; cv=none; b=JqtWPIaBdrnMFtWlVcwiDHt2qKJsv+s0Q2Dr+Ph+lVk47RRQVZQBpYh+spFqPQsZ9BE23CQ9npQh7Y/ieymSdWuIxh9QjlmSqNiSDzIIYUoFUMziGrHXLHJE1NTNRXNDku2DCxhNIK0yRVOasJnklzATtNghZJ9/rXzPucLeUC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877118; c=relaxed/simple;
	bh=AGsGrPNZaJWQq/rDqWzFpa2M7dDtx+KVYLKKrxW+b1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0JF85C+a/0eN47MSv6cPrVP+IGAHmJ71giei2ft3HNLzD+V2j+kiJ/8KtlDhYuYZHqaiv8Z5SS3sgNAsp409kVGY1ZaSs4EbVBKnr019KbWuDi7upfA51XnTA86++ln5QXONJ4TPg0HlpRclOR+Ce2UHUldSMU3pfiW9WS3hSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPVQUgNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPVQUgNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA30AC4CEC2;
	Wed,  2 Oct 2024 13:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877118;
	bh=AGsGrPNZaJWQq/rDqWzFpa2M7dDtx+KVYLKKrxW+b1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPVQUgNrkZeqXCcz42KM7TPZZCEyyTwtgnzmfLx+g9zYI/xBjzqwD/sEU5r8B7Hv+
	 QeuTF8mGR5zWXe5Aywe/idFIeOIPkjm29w3BcNgQYsQ61ZPTYNW8yZV+YpwSlLxoVZ
	 2BT9+Hgk3lUKfk4ClsMxhW8Wk62RKKVq1jRVBB/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 671/695] thermal: sysfs: Refine the handling of trip hysteresis changes
Date: Wed,  2 Oct 2024 15:01:09 +0200
Message-ID: <20241002125849.294282988@linuxfoundation.org>
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

[ Upstream commit 107280e1371f1ba183be1ac88e91ec60cad33c18 ]

Change trip_point_hyst_store() and replace thermal_zone_trip_updated()
with thermal_zone_set_trip_hyst() to follow the trip_point_temp_store()
code pattern for more consistency.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5508466.Sb9uPGUboI@rjwysocki.net
Stable-dep-of: 874b6476fa88 ("thermal: sysfs: Add sanity checks for trip temperature and hysteresis")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.h  | 4 ++--
 drivers/thermal/thermal_sysfs.c | 4 ++--
 drivers/thermal/thermal_trip.c  | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 5be8bef41b926..3c8e2bca87f2d 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -263,11 +263,11 @@ const char *thermal_trip_type_name(enum thermal_trip_type trip_type);
 void thermal_zone_set_trips(struct thermal_zone_device *tz);
 int thermal_zone_trip_id(const struct thermal_zone_device *tz,
 			 const struct thermal_trip *trip);
-void thermal_zone_trip_updated(struct thermal_zone_device *tz,
-			       const struct thermal_trip *trip);
 int __thermal_zone_get_temp(struct thermal_zone_device *tz, int *temp);
 void thermal_zone_trip_down(struct thermal_zone_device *tz,
 			    const struct thermal_trip *trip);
+void thermal_zone_set_trip_hyst(struct thermal_zone_device *tz,
+				struct thermal_trip *trip, int hyst);
 
 /* sysfs I/F */
 int thermal_zone_create_device_groups(struct thermal_zone_device *tz);
diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 11a34b9fe153d..2709455486776 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -153,9 +153,9 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&tz->lock);
 
 	if (hyst != trip->hysteresis) {
-		WRITE_ONCE(trip->hysteresis, hyst);
+		thermal_zone_set_trip_hyst(tz, trip, hyst);
 
-		thermal_zone_trip_updated(tz, trip);
+		__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
 	}
 
 	mutex_unlock(&tz->lock);
diff --git a/drivers/thermal/thermal_trip.c b/drivers/thermal/thermal_trip.c
index 06a0554ddc389..fa5ac9b512312 100644
--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -138,11 +138,11 @@ int thermal_zone_trip_id(const struct thermal_zone_device *tz,
 	return trip_to_trip_desc(trip) - tz->trips;
 }
 
-void thermal_zone_trip_updated(struct thermal_zone_device *tz,
-			       const struct thermal_trip *trip)
+void thermal_zone_set_trip_hyst(struct thermal_zone_device *tz,
+				struct thermal_trip *trip, int hyst)
 {
+	WRITE_ONCE(trip->hysteresis, hyst);
 	thermal_notify_tz_trip_change(tz, trip);
-	__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
 }
 
 void thermal_zone_set_trip_temp(struct thermal_zone_device *tz,
-- 
2.43.0



