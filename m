Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC8B1754B;
	Mon, 27 May 2024 19:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836750; cv=none; b=T0S9eNX8AG4oAUB6847RgvPYkZBBrJWXzudIvR5d+3uTOlz46CZLdteujXBQ9IKi00dGNpVuPhv9rDuFh1urPgDU7g9fm6JVLemM3cBRHEECFIU1kurxr1YMMTN7jUPHcVEEf/LrbQfddDzEwPB+hy0ZqRViYgWSKgu5L7F1Qfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836750; c=relaxed/simple;
	bh=Iolbk4e944JGd2mxRJHb1weECeihcurNPCaLy3QtAKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UslShi8Y5YsLPnw2asu1p04Tbamypi/slxYWl9Z2kDDoBIIdHpP3tijJ0oSh1QW6SsJR5ZZNZwdR28kn5lm2Aq+IKffFnouRgiy1iKzTwcJYdQ3HfCIZ7udqBRVCq7oYBaXrYaXp4b84BOY8xRkTW6sDa8nHZii6AYo+bpmzc8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PI5NcUqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PI5NcUqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222C0C32781;
	Mon, 27 May 2024 19:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836750;
	bh=Iolbk4e944JGd2mxRJHb1weECeihcurNPCaLy3QtAKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI5NcUqWJaLq1Yxq3Qcn5lPhWKnBXNY/BqmvPlVlewKJ/b3Bs/CE+zNidjz39i46i
	 VWAqCidrC7erSYX+sxvp1IOiuE29qj/ybJ+d2sslwZd+VeoVtfJ60MRcAb+HoxeB64
	 p4wJAN4V+8ef7BaO6zpnDjcxO/gfvhAM80iLuNvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 172/427] thermal/debugfs: Avoid excessive updates of trip point statistics
Date: Mon, 27 May 2024 20:53:39 +0200
Message-ID: <20240527185618.332027297@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 0a293c77580581c4b058eb40287acadac6ffd14a ]

Since thermal_debug_update_temp() is called before invoking
thermal_debug_tz_trip_down() for the trips that were crossed by the
zone temperature on the way up, it updates the statistics for them
as though the current zone temperature was above the low temperature
of each of them.  However, if a given trip has just been crossed on the
way down, the zone temperature is in fact below its low temperature,
but this is handled by thermal_debug_tz_trip_down() running after the
update of the trip statistics.

The remedy is to call thermal_debug_update_temp() after
thermal_debug_tz_trip_down() has been invoked for all of the
trips in question, but then thermal_debug_tz_trip_up() needs to
be adjusted, so it does not update the statistics for the trips
that has just been crossed on the way up, as that will be taken
care of by thermal_debug_update_temp() down the road.

Modify the code accordingly.

Fixes: 7ef01f228c9f ("thermal/debugfs: Add thermal debugfs information for mitigation episodes")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c    | 3 ++-
 drivers/thermal/thermal_debugfs.c | 7 -------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 34a31bc720230..015d41a9a368b 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -431,7 +431,6 @@ static void update_temperature(struct thermal_zone_device *tz)
 	trace_thermal_temperature(tz);
 
 	thermal_genl_sampling_temp(tz->id, temp);
-	thermal_debug_update_temp(tz);
 }
 
 static void thermal_zone_device_check(struct work_struct *work)
@@ -475,6 +474,8 @@ void __thermal_zone_device_update(struct thermal_zone_device *tz,
 	for_each_trip(tz, trip)
 		handle_thermal_trip(tz, trip);
 
+	thermal_debug_update_temp(tz);
+
 	monitor_thermal_zone(tz);
 }
 
diff --git a/drivers/thermal/thermal_debugfs.c b/drivers/thermal/thermal_debugfs.c
index 5693cc8b231aa..47ab95b3699e9 100644
--- a/drivers/thermal/thermal_debugfs.c
+++ b/drivers/thermal/thermal_debugfs.c
@@ -555,7 +555,6 @@ void thermal_debug_tz_trip_up(struct thermal_zone_device *tz,
 	struct tz_episode *tze;
 	struct tz_debugfs *tz_dbg;
 	struct thermal_debugfs *thermal_dbg = tz->debugfs;
-	int temperature = tz->temperature;
 	int trip_id = thermal_zone_trip_id(tz, trip);
 	ktime_t now = ktime_get();
 
@@ -624,12 +623,6 @@ void thermal_debug_tz_trip_up(struct thermal_zone_device *tz,
 
 	tze = list_first_entry(&tz_dbg->tz_episodes, struct tz_episode, node);
 	tze->trip_stats[trip_id].timestamp = now;
-	tze->trip_stats[trip_id].max = max(tze->trip_stats[trip_id].max, temperature);
-	tze->trip_stats[trip_id].min = min(tze->trip_stats[trip_id].min, temperature);
-	tze->trip_stats[trip_id].count++;
-	tze->trip_stats[trip_id].avg = tze->trip_stats[trip_id].avg +
-		(temperature - tze->trip_stats[trip_id].avg) /
-		tze->trip_stats[trip_id].count;
 
 unlock:
 	mutex_unlock(&thermal_dbg->lock);
-- 
2.43.0



