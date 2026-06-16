Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489BB32A3C9;
	Tue, 16 Jun 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632246; cv=none; b=Rgf71kRTuFCoEW/jyADo1ggUM0Jc15Kjwmw3ACFXfdIxnDdT50am7mcS82Rf0DyuhpnyzHpQNPekzLToGg0NaBrPJXGvwQwWUHIvo5gNGyAal6UPkH6NVQYY4f5ijf5Ur6IAIuwckkhLZ46Bs9iK1qYMIhBytqD0bBUPu1BdOIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632246; c=relaxed/simple;
	bh=sbixWEFU+uDd4RnkyasSRcuQZyZ4rGhuKwund0SjNRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGrZP4dSU9OHGBL0lbxNaVoz5Kp1aniiIzSzJoLnGYx3UaOyHoHxSQUwjsbz8TETzoykDT/ulf8qw7YHfm0JVE6SUZH9YZ/fPxDXz/1AXbty8AP2IDqxxOL56LoOTKBR2ZnrvPVfyve/5SDzGwjHLWuFboBGPW2KQnMSnGwZh3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4A42JHh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4A42JHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2E81F000E9;
	Tue, 16 Jun 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632245;
	bh=2Wb7ozkK8BlphkTLVmgOSHum9FmJHrq26RcXxiLj6mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D4A42JHhxOZOwEynVaL1uTY4kW/HiiOA/UuudjJwbkxpR1OZOi3hhk2p3OuqctMw2
	 46aRy2AXlQerEEFj7sBnycRGR6mjygObfXzbmkbCU+VChgawoiBVCDa9Q7daiemhbo
	 JYudetC0U08Raj9ktq+7yevT3lPCMUvIErdBQqyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/522] thermal: core: Fix thermal zone governor cleanup issues
Date: Tue, 16 Jun 2026 20:28:09 +0530
Message-ID: <20260616145141.812464695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 41ff66baf81c6541f4f985dd7eac4494d03d9440 ]

If thermal_zone_device_register_with_trips() fails after adding
a thermal governor to the thermal zone being registered, the
governor is not removed from it as appropriate which may lead to
a memory leak.

In turn, thermal_zone_device_unregister() calls thermal_set_governor()
without acquiring the thermal zone lock beforehand which may race with
a governor update via sysfs and may lead to a use-after-free in that
case.

Address these issues by adding two thermal_set_governor() calls, one to
thermal_release() to remove the governor from the given thermal zone,
and one to the thermal zone registration error path to cover failures
preceding the thermal zone device registration.

Fixes: e33df1d2f3a0 ("thermal: let governors have private data for each thermal zone")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5092923.31r3eYUQgx@rafael.j.wysocki
[ adapted context for missing mutex_destroy/complete ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -756,6 +756,7 @@ static void thermal_release(struct devic
 		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
+		thermal_set_governor(tz, NULL);
 		kfree(tz);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
 			    sizeof("cooling_device") - 1)) {
@@ -1260,8 +1261,10 @@ thermal_zone_device_register_with_trips(
 	/* sys I/F */
 	/* Add nodes that are always present via .groups */
 	result = thermal_zone_create_device_groups(tz, mask);
-	if (result)
+	if (result) {
+		thermal_set_governor(tz, NULL);
 		goto remove_id;
+	}
 
 	/* A new thermal zone needs to be updated anyway. */
 	atomic_set(&tz->need_update, 1);
@@ -1396,8 +1399,6 @@ void thermal_zone_device_unregister(stru
 
 	cancel_delayed_work_sync(&tz->poll_queue);
 
-	thermal_set_governor(tz, NULL);
-
 	thermal_remove_hwmon_sysfs(tz);
 	ida_free(&thermal_tz_ida, tz->id);
 	ida_destroy(&tz->ida);


