Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551E71D015C;
	Wed,  2 Oct 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877121; cv=none; b=q5l/JsxUKjsyRMnMAhfgrt8hV529VZDb513YBYJWIT1LCJZzCBwZqCNhby7BprBuF1R0zsp5zuNiDC2zP7l8RCdyN0mE1SP6eydw0QVt+kuXJO77LJSdGerb8JK7a0yxycmxrCaEsW8SDINa2xlZMoq8iWq5R23h2IpluYXftFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877121; c=relaxed/simple;
	bh=YffQKji9eW3Lbd6RVmUrkck7R6g99YErQjhu5Mm0+Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws44wLs+9kpYM0pfSbEEIh7HweVwIgBSLVv3HfVwuBnh9LQNm203Bq873tzn9dTmPxas0QKxP1o55tLwaRTIYHfEX2ZW9+KyTBjl+UoWJxZcblf7anRrWZkxLTlvYtZOTN2BQo/eLBI5nMvau1hjYGr/J0pKqYGGdjSqfOi9JD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTIE7Jzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTIE7Jzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5C8C4CEC2;
	Wed,  2 Oct 2024 13:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877121;
	bh=YffQKji9eW3Lbd6RVmUrkck7R6g99YErQjhu5Mm0+Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTIE7JzyniGQ6pce1xDfDP0Ik2QdKTC13NuFa8giEAMqO1Z1HOmykWPvn4kfrob63
	 v3tbg+rrhlbq3Sih5xrCySEiPZsvHXsuKH9/X3SmTEtvUsY9abDLJrbBK9VyJumPfg
	 61ttNmatt2NZR2NtDY5JlXNBBRLRLKIXIQpFf6Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 672/695] thermal: sysfs: Add sanity checks for trip temperature and hysteresis
Date: Wed,  2 Oct 2024 15:01:10 +0200
Message-ID: <20241002125849.334663608@linuxfoundation.org>
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

[ Upstream commit 874b6476fa888e79e41daf7653384c8d70927b90 ]

Add sanity checks for new trip temperature and hysteresis values to
trip_point_temp_store() and trip_point_hyst_store() to prevent trip
point threshold from falling below THERMAL_TEMP_INVALID.

However, still allow user space to pass THERMAL_TEMP_INVALID as the
new trip temperature value to invalidate the trip if necessary.

Also allow the hysteresis to be updated when the temperature is invalid
to allow user space to avoid having to adjust hysteresis after a valid
temperature has been set, but in that case just change the value and do
nothing else.

Fixes: be0a3600aa1e ("thermal: sysfs: Rework the handling of trip point updates")
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/12528772.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 50 +++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index 2709455486776..d628dd67be5cc 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -111,18 +111,26 @@ trip_point_temp_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&tz->lock);
 
-	if (temp != trip->temperature) {
-		if (tz->ops.set_trip_temp) {
-			ret = tz->ops.set_trip_temp(tz, trip, temp);
-			if (ret)
-				goto unlock;
-		}
+	if (temp == trip->temperature)
+		goto unlock;
 
-		thermal_zone_set_trip_temp(tz, trip, temp);
+	/* Arrange the condition to avoid integer overflows. */
+	if (temp != THERMAL_TEMP_INVALID &&
+	    temp <= trip->hysteresis + THERMAL_TEMP_INVALID) {
+		ret = -EINVAL;
+		goto unlock;
+	}
 
-		__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
+	if (tz->ops.set_trip_temp) {
+		ret = tz->ops.set_trip_temp(tz, trip, temp);
+		if (ret)
+			goto unlock;
 	}
 
+	thermal_zone_set_trip_temp(tz, trip, temp);
+
+	__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
+
 unlock:
 	mutex_unlock(&tz->lock);
 
@@ -152,15 +160,33 @@ trip_point_hyst_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&tz->lock);
 
-	if (hyst != trip->hysteresis) {
-		thermal_zone_set_trip_hyst(tz, trip, hyst);
+	if (hyst == trip->hysteresis)
+		goto unlock;
+
+	/*
+	 * Allow the hysteresis to be updated when the temperature is invalid
+	 * to allow user space to avoid having to adjust hysteresis after a
+	 * valid temperature has been set, but in that case just change the
+	 * value and do nothing else.
+	 */
+	if (trip->temperature == THERMAL_TEMP_INVALID) {
+		WRITE_ONCE(trip->hysteresis, hyst);
+		goto unlock;
+	}
 
-		__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
+	if (trip->temperature - hyst <= THERMAL_TEMP_INVALID) {
+		ret = -EINVAL;
+		goto unlock;
 	}
 
+	thermal_zone_set_trip_hyst(tz, trip, hyst);
+
+	__thermal_zone_device_update(tz, THERMAL_TRIP_CHANGED);
+
+unlock:
 	mutex_unlock(&tz->lock);
 
-	return count;
+	return ret ? ret : count;
 }
 
 static ssize_t
-- 
2.43.0



