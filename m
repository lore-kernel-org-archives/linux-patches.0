Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6C8446AC;
	Mon,  1 Apr 2024 16:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987542; cv=none; b=JakVNbv2be4OlJUpir8CovV6kPwyH9x3A/NglCPwUMFx7rfUJ9JwMRtwy8vZR4YVOPJSn7npVq+2OZv2C5uXe3zhiIoNjJqBg4BZwENGLZF6fQob7BeeJN9bkf8xU8Q2I2dUrrLna2HdSo1OAx0HQTDpZ5zI6jOnbWv1AbU0dBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987542; c=relaxed/simple;
	bh=+U89dGBWdFfd88jIQNbvQ1uJBHBV6Ikz53JrhE8ATjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IaX+FeYwnf1ZY47bGGkcPrets8siL4SEyN903mLsQveXySStCzrQn1veWmzkpBZMOxYvySdZaZyh7uK9e2vqJ7EMItlukq60mdKbesF+5O8RU4cO1f1V4rqnQVYgY+tb+koIDoTBG2YxBI7hBy9Id4Rg94J5k8UJAlbOhCTdgBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1akve0aB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1akve0aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2654C433C7;
	Mon,  1 Apr 2024 16:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987542;
	bh=+U89dGBWdFfd88jIQNbvQ1uJBHBV6Ikz53JrhE8ATjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1akve0aB7vMRDVik0Db8EMc9bxCJ1nYEjENNFoNEJgJngWmSgU6+yga2b1EHHqxpt
	 5g7+pKcwT69ZGPGsos9u8+PAlrmwUBAqJUylhzU7MO5L3q6d3bCxa7URjCDsxiw2Wm
	 7xtBgKiDzNajcQAke+NS8Y+PgjqzHVo/DSvvkkjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.8 318/399] Revert "thermal: core: Dont update trip points inside the hysteresis range"
Date: Mon,  1 Apr 2024 17:44:44 +0200
Message-ID: <20240401152558.675311146@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Lezcano <daniel.lezcano@linaro.org>

commit f67cf45deedb118af302534643627ce59074e8eb upstream.

It has been reported the commit cf3986f8c01d3 introduced a regression
when the temperature is wavering in the hysteresis region. The
mitigation stops leading to an uncontrolled temperature increase until
reaching the critical trip point.

Here what happens:

 * 'throttle' is when the current temperature is greater than the trip
   point temperature
 * 'target' is the mitigation level
 * 'passive' is positive when there is a mitigation, zero otherwise
 * these values are computed in the step_wise governor

Configuration:

 trip point 1: temp=95°C, hyst=5°C (passive)
 trip point 2: temp=115°C, hyst=0°C (critical)
 governor: step_wise

 1. The temperature crosses the way up the trip point 1 at 95°C

   - trend=raising
   - throttle=1, target=1
   - passive=1
   - set_trips: low=90°C, high=115°C

 2. The temperature decreases but stays in the hysteresis region at
    93°C

   - trend=dropping
   - throttle=0, target=0
   - passive=1

   Before cf3986f8c01d3
   - set_trips: low=90°C, high=95°C

   After cf3986f8c01d3
   - set_trips: low=90°C, high=115°C

 3. The temperature increases a bit but stays in the hysteresis region
    at 94°C (so below the trip point 1 temp 95°C)

   - trend=raising
   - throttle=0, target=0
   - passive=1

   Before cf3986f8c01d3
   - set_trips: low=90°C, high=95°C

   After cf3986f8c01d3
   - set_trips: low=90°C, high=115°C

 4. The temperature decreases but stays in the hysteresis region at
    93°C

   - trend=dropping
   - throttle=0, target=THERMAL_NO_TARGET
   - passive=0

   Before cf3986f8c01d3
   - set_trips: low=90°C, high=95°C

   After cf3986f8c01d3
   - set_trips: low=90°C, high=115°C

At this point, the 'passive' value is zero, there is no mitigation,
the temperature is in the hysteresis region, the next trip point is
115°C. As 'passive' is zero, the timer to monitor the thermal zone is
disabled. Consequently if the temperature continues to increase, no
mitigation will happen and it will reach the 115°C trip point and
reboot.

Before the optimization, the high boundary would have been 95°C, thus
triggering the mitigation again and rearming the polling timer.

The optimization make sense but given the current implementation of
the step_wise governor collaborating via this 'passive' flag with the
core framework it can not work.

>From a higher perspective it seems like there is a problem between the
governor which sets a variable to be used by the core framework. That
sounds akward and it would make much more sense if the core framework
controls the governor and not the opposite. But as the devil hides in
the details, there are some subtilities to be addressed before.

Elaborating those would be out of the scope this changelog. So let's
stay simple and revert the change first to fixup all broken mobile
platforms.

This reverts commit cf3986f8c01d3 ("thermal: core: Don't update trip
points inside the hysteresis range") and takes a conflict with commit
0c0c4740c9d26 ("0c0c4740c9d2 thermal: trip: Use for_each_trip() in
__thermal_zone_set_trips()") in drivers/thermal/thermal_trip.c into
account.

Fixes: cf3986f8c01d3 ("thermal: core: Don't update trip points inside the hysteresis range")
Reported-by: Manaf Meethalavalappu Pallikunhi <quic_manafm@quicinc.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Cc: 6.7+ <stable@vger.kernel.org> # 6.7+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_trip.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -65,7 +65,6 @@ void __thermal_zone_set_trips(struct the
 {
 	const struct thermal_trip *trip;
 	int low = -INT_MAX, high = INT_MAX;
-	bool same_trip = false;
 	int ret;
 
 	lockdep_assert_held(&tz->lock);
@@ -74,36 +73,22 @@ void __thermal_zone_set_trips(struct the
 		return;
 
 	for_each_trip(tz, trip) {
-		bool low_set = false;
 		int trip_low;
 
 		trip_low = trip->temperature - trip->hysteresis;
 
-		if (trip_low < tz->temperature && trip_low > low) {
+		if (trip_low < tz->temperature && trip_low > low)
 			low = trip_low;
-			low_set = true;
-			same_trip = false;
-		}
 
 		if (trip->temperature > tz->temperature &&
-		    trip->temperature < high) {
+		    trip->temperature < high)
 			high = trip->temperature;
-			same_trip = low_set;
-		}
 	}
 
 	/* No need to change trip points */
 	if (tz->prev_low_trip == low && tz->prev_high_trip == high)
 		return;
 
-	/*
-	 * If "high" and "low" are the same, skip the change unless this is the
-	 * first time.
-	 */
-	if (same_trip && (tz->prev_low_trip != -INT_MAX ||
-	    tz->prev_high_trip != INT_MAX))
-		return;
-
 	tz->prev_low_trip = low;
 	tz->prev_high_trip = high;
 


