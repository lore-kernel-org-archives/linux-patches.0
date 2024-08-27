Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F801C4EEF;
	Tue, 27 Aug 2024 15:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771275; cv=none; b=nha1Q6PGYhACUDZGfEAahqCAKQHmbhNuPSaF7XgTq6GIkZz6amaD99yRsmUQ23R8DiArjr22d8baPXMiJdcinNeAWKOGbfHPsL60TC1cZMVoRVQiztMxoKgfNw5ncPY4XvnxU0jdwmgmaM90yvrE+sZk5aqmos44/5COqdh43h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771275; c=relaxed/simple;
	bh=rNcNCamtxguQZ/Pg03eIrmbWZSDFZ7kDa+bdepyB3Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TVSrWQMFWSrjY1U6g5Ne1j3C73tiP2KVwCUE28W+gO+5mh4RNidCFH54tCwkTcqW5HzfoIXCgyZ27q4JzC1MnmkiRB0/ZSCK/D7x4VXHWb4NTtyB4Ah5zuL9+VSJkk7zLAQ25ta+ThsIPLQmCq0XIVejszfhJYj3cGEltFmUrgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SYyO1IH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SYyO1IH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7876FC6107E;
	Tue, 27 Aug 2024 15:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771275;
	bh=rNcNCamtxguQZ/Pg03eIrmbWZSDFZ7kDa+bdepyB3Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SYyO1IH3/H6MXnqCl8QTC523t7s+8fLC6K6opXjVtiaFHs1IpBMwcUoW6jAY/nKvp
	 nTT5UgnpHcSu1rMZGcrHAvpaCDQaOIpBKMpMd12NyOphBlP34J62kY7mnfR6NWNHyH
	 cVweglvt0tcYlWFiA8s85oKg5VCLWJxs0N+35ekI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Peter=20K=C3=A4stle?= <peter@piie.net>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 140/273] thermal: gov_bang_bang: Add .manage() callback
Date: Tue, 27 Aug 2024 16:37:44 +0200
Message-ID: <20240827143838.733419159@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5f64b4a1ab1b0412446d42e1fc2964c2cdb60b27 ]

After recent changes, the Bang-bang governor may not adjust the
initial configuration of cooling devices to the actual situation.

Namely, if a cooling device bound to a certain trip point starts in
the "on" state and the thermal zone temperature is below the threshold
of that trip point, the trip point may never be crossed on the way up
in which case the state of the cooling device will never be adjusted
because the thermal core will never invoke the governor's
.trip_crossed() callback.  [Note that there is no issue if the zone
temperature is at the trip threshold or above it to start with because
.trip_crossed() will be invoked then to indicate the start of thermal
mitigation for the given trip.]

To address this, add a .manage() callback to the Bang-bang governor
and use it to ensure that all of the thermal instances managed by the
governor have been initialized properly and the states of all of the
cooling devices involved have been adjusted to the current zone
temperature as appropriate.

Fixes: 530c932bdf75 ("thermal: gov_bang_bang: Use .trip_crossed() instead of .throttle()")
Link: https://lore.kernel.org/linux-pm/1bfbbae5-42b0-4c7d-9544-e98855715294@piie.net/
Cc: 6.10+ <stable@vger.kernel.org> # 6.10+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Kästle <peter@piie.net>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/8419356.T7Z3S40VBb@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/gov_bang_bang.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/thermal/gov_bang_bang.c b/drivers/thermal/gov_bang_bang.c
index 87cff3ea77a9d..bc55e0698bfa8 100644
--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -26,6 +26,7 @@ static void bang_bang_set_instance_target(struct thermal_instance *instance,
 	 * when the trip is crossed on the way down.
 	 */
 	instance->target = target;
+	instance->initialized = true;
 
 	dev_dbg(&instance->cdev->device, "target=%ld\n", instance->target);
 
@@ -80,8 +81,37 @@ static void bang_bang_control(struct thermal_zone_device *tz,
 	}
 }
 
+static void bang_bang_manage(struct thermal_zone_device *tz)
+{
+	const struct thermal_trip_desc *td;
+	struct thermal_instance *instance;
+
+	for_each_trip_desc(tz, td) {
+		const struct thermal_trip *trip = &td->trip;
+
+		if (tz->temperature >= td->threshold ||
+		    trip->temperature == THERMAL_TEMP_INVALID ||
+		    trip->type == THERMAL_TRIP_CRITICAL ||
+		    trip->type == THERMAL_TRIP_HOT)
+			continue;
+
+		/*
+		 * If the initial cooling device state is "on", but the zone
+		 * temperature is not above the trip point, the core will not
+		 * call bang_bang_control() until the zone temperature reaches
+		 * the trip point temperature which may be never.  In those
+		 * cases, set the initial state of the cooling device to 0.
+		 */
+		list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
+			if (!instance->initialized && instance->trip == trip)
+				bang_bang_set_instance_target(instance, 0);
+		}
+	}
+}
+
 static struct thermal_governor thermal_gov_bang_bang = {
 	.name		= "bang_bang",
 	.trip_crossed	= bang_bang_control,
+	.manage		= bang_bang_manage,
 };
 THERMAL_GOVERNOR_DECLARE(thermal_gov_bang_bang);
-- 
2.43.0



