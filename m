Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A731CF28B;
	Wed,  2 Oct 2024 13:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875350; cv=none; b=UaTF9RHf5MpTW4j/PXAmrB7c0T0caFu0drJtuTZNWUjXDwhHrD/021pTkYOE09X7NzHhRv4yHTwGFJSiuUQvTabi4xy7Er8dlib5eW3nYwfOEbx8PoCWRSBBqvbyLBB0kb2Ew2BioZ/3GjdZ0bkPNqfXbs4HbViOS2GlCb9onVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875350; c=relaxed/simple;
	bh=0EKSIzj5Dm3QjFeYfIue2BVvbNUZ3hmAdHSoqCoAN5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/VnT/J/oKkwYXNiTSijMuAXsDoZpzfHBrj/bDuU6D0dYAWh9Ta5dvg3PrEja7r1oB8qIE6HH4CHqtRJtqV1fCwB4WzTIuBKL1qYI0zUNmEpp8NTdgLVfUY6gpIdUHizbLIN6C+HRi/trtr7ZJYSblahIYeAaa28xzpYzWUrPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tSRxekFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tSRxekFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05D7C4CEC5;
	Wed,  2 Oct 2024 13:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875350;
	bh=0EKSIzj5Dm3QjFeYfIue2BVvbNUZ3hmAdHSoqCoAN5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSRxekFBJpSOY8pkfQvkW4AS/UTbPPWautAiae05a49gIhWmGBOLkIMEX0Wwzvm1B
	 HQwJyxxICB0+rVZBw0iHNSjU7Uno6kElUXRsCPWNrwD5DC50j7V1QjlU0e9OdGL4bS
	 VaSc2qfGhV70+pe1Vn5vhWAVlD+mbP36GgpKuI7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 072/695] thermal: gov_bang_bang: Adjust states of all uninitialized instances
Date: Wed,  2 Oct 2024 14:51:10 +0200
Message-ID: <20241002125825.356075789@linuxfoundation.org>
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

[ Upstream commit 15cb56bd529868d9242b22812fc69bd144bfdc94 ]

If a cooling device is registered after a thermal zone it should be
bound to and the trip point it should be bound to has already been
crossed by the zone temperature on the way up, the cooling device's
state may need to be adjusted, but the Bang-bang governor will not
do that because its .manage() callback only looks at thermal instances
for trip points whose thresholds are below or at the zone temperature.

Address this by updating bang_bang_manage() to look at all of the
uninitialized thermal instances and setting their target states in
accordance with the position of the zone temperature with respect to
the threshold of the given trip point.

Fixes: 5f64b4a1ab1b ("thermal: gov_bang_bang: Add .manage() callback")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/6103874.lOV4Wx5bFT@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index daed67d19efb8..863e7a4272e66 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -92,23 +92,21 @@ static void bang_bang_manage(struct thermal_zone_device *tz)
 
 	for_each_trip_desc(tz, td) {
 		const struct thermal_trip *trip = &td->trip;
+		bool turn_on;
 
-		if (tz->temperature >= td->threshold ||
-		    trip->temperature == THERMAL_TEMP_INVALID ||
+		if (trip->temperature == THERMAL_TEMP_INVALID ||
 		    trip->type == THERMAL_TRIP_CRITICAL ||
 		    trip->type == THERMAL_TRIP_HOT)
 			continue;
 
 		/*
-		 * If the initial cooling device state is "on", but the zone
-		 * temperature is not above the trip point, the core will not
-		 * call bang_bang_control() until the zone temperature reaches
-		 * the trip point temperature which may be never.  In those
-		 * cases, set the initial state of the cooling device to 0.
+		 * Adjust the target states for uninitialized thermal instances
+		 * to the thermal zone temperature and the trip point threshold.
 		 */
+		turn_on = tz->temperature >= td->threshold;
 		list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 			if (!instance->initialized && instance->trip == trip)
-				bang_bang_set_instance_target(instance, 0);
+				bang_bang_set_instance_target(instance, turn_on);
 		}
 	}
 
-- 
2.43.0



