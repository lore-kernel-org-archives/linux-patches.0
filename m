Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6043BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQQlGKh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFA0C433C7;
	Wed, 15 Nov 2023 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076171;
	bh=BBDhtMHpW/ISBwAtcKUI0VzV+Pnt3Xd8EBtP2FOlu1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQQlGKh0vEF90xeoMbxznogfRwmgeTJDCqasXyzVRBlYs1n5ghe+fCvStucNSLw+L
	 RP/J7uGogrdrW24MehnJ/rH1PDFEcZKlD8NbOaKLduv+0cOgi5mD+2+t9AMYp7/c/P
	 rqL3uGZeh7f1G6UIYRvELQ1Lz0rrXsG1PeEXiEV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 120/550] thermal: core: Dont update trip points inside the hysteresis range
Date: Wed, 15 Nov 2023 14:11:44 -0500
Message-ID: <20231115191609.011103103@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit cf3986f8c01d355490d0ac6024391b989a9d1e9d ]

When searching for the trip points that need to be set, the nearest
higher trip point's temperature is used for the high trip, while the
nearest lower trip point's temperature minus the hysteresis is used for
the low trip. The issue with this logic is that when the current
temperature is inside a trip point's hysteresis range, both high and low
trips will come from the same trip point. As a consequence instability
can still occur like this:
* the temperature rises slightly and enters the hysteresis range of a
  trip point
* polling happens and updates the trip points to the hysteresis range
* the temperature falls slightly, exiting the hysteresis range, crossing
  the trip point and triggering an IRQ, the trip points are updated
* repeat

So even though the current hysteresis implementation prevents
instability from happening due to IRQs triggering on the same
temperature value, both ways, it doesn't prevent it from happening due
to an IRQ on one way and polling on the other.

To properly implement a hysteresis behavior, when inside the hysteresis
range, don't update the trip points. This way, the previously set trip
points will stay in effect, which will in a way remember the previous
state (if the temperature signal came from above or below the range) and
therefore have the right trip point already set.

The exception is if there was no previous trip point set, in which case
a previous state doesn't exist, and so it's sensible to allow the
hysteresis range as trip points.

The following logs show the current behavior when running on a real
machine:

[  202.524658] thermal thermal_zone0: new temperature boundaries: -2147483647 < x < 40000
   203.562817: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=36986 temp=37979
[  203.562845] thermal thermal_zone0: new temperature boundaries: 37000 < x < 40000
   204.176059: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=37979 temp=40028
[  204.176089] thermal thermal_zone0: new temperature boundaries: 37000 < x < 100000
   205.226813: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=40028 temp=38652
[  205.226842] thermal thermal_zone0: new temperature boundaries: 37000 < x < 40000

And with this patch applied:

[  184.933415] thermal thermal_zone0: new temperature boundaries: -2147483647 < x < 40000
   185.981182: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=36986 temp=37872
   186.744685: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=37872 temp=40058
[  186.744716] thermal thermal_zone0: new temperature boundaries: 37000 < x < 100000
   187.773284: thermal_temperature: thermal_zone=vpu0-thermal id=0 temp_prev=40058 temp=38698

Fixes: 060c034a9741 ("thermal: Add support for hardware-tracked trip points")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Co-developed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_trip.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_trip.c b/drivers/thermal/thermal_trip.c
index 907f3a4d7bc8c..21736e02fa360 100644
--- a/drivers/thermal/thermal_trip.c
+++ b/drivers/thermal/thermal_trip.c
@@ -57,6 +57,7 @@ void __thermal_zone_set_trips(struct thermal_zone_device *tz)
 {
 	struct thermal_trip trip;
 	int low = -INT_MAX, high = INT_MAX;
+	bool same_trip = false;
 	int i, ret;
 
 	lockdep_assert_held(&tz->lock);
@@ -65,6 +66,7 @@ void __thermal_zone_set_trips(struct thermal_zone_device *tz)
 		return;
 
 	for (i = 0; i < tz->num_trips; i++) {
+		bool low_set = false;
 		int trip_low;
 
 		ret = __thermal_zone_get_trip(tz, i , &trip);
@@ -73,18 +75,31 @@ void __thermal_zone_set_trips(struct thermal_zone_device *tz)
 
 		trip_low = trip.temperature - trip.hysteresis;
 
-		if (trip_low < tz->temperature && trip_low > low)
+		if (trip_low < tz->temperature && trip_low > low) {
 			low = trip_low;
+			low_set = true;
+			same_trip = false;
+		}
 
 		if (trip.temperature > tz->temperature &&
-		    trip.temperature < high)
+		    trip.temperature < high) {
 			high = trip.temperature;
+			same_trip = low_set;
+		}
 	}
 
 	/* No need to change trip points */
 	if (tz->prev_low_trip == low && tz->prev_high_trip == high)
 		return;
 
+	/*
+	 * If "high" and "low" are the same, skip the change unless this is the
+	 * first time.
+	 */
+	if (same_trip && (tz->prev_low_trip != -INT_MAX ||
+	    tz->prev_high_trip != INT_MAX))
+		return;
+
 	tz->prev_low_trip = low;
 	tz->prev_high_trip = high;
 
-- 
2.42.0



