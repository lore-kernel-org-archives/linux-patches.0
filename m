Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D868466B5E;
	Tue, 16 Jun 2026 18:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634597; cv=none; b=tizOHDRPIIFz8JPzDTQ5ZmDyOc8dvObIn3hVb79MJ/PmkbgfaqNa84JEoIwIOfx2Cz2dxXqRwcJk4/b1Rh3pGZoKL7XTdw7ECJbmeHv+jVRuKbEba97OJ6Ikg590RyGSfhFq2cdeHbBdj7Uw1xXERPCBUXpho9LMutpWIUK6qx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634597; c=relaxed/simple;
	bh=SQvZniLSQOTbCKEkhLBpWGUCcOMfcYNEl2Z9MDoFnhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSd0UAJkh4LK2OfrQspZp/Ex1iF7ZgXVPqqLTqMqN0xNYTfqGVBVKPEVM11JqfCbKh+EgicUYIvZT/lCEkM6YY1OpBtwgpKoh8MH3cv+hyd2mHw9mFI2qHocuCzh8bWAnKtHkLM+jJAgfCbTcKdLNR4UtclNbNR0bPIA6o4vvtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUvdMbfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUvdMbfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7ED21F000E9;
	Tue, 16 Jun 2026 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634596;
	bh=nEBwFukvsRWS6YqM8gN+PT2uguPMqZavVW+f/e5nq40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUvdMbfCJdAjkZlKgX2bAkBgoloD20QIO6J8EOncypmOuAjJNCyITFApwVQ7spYH2
	 oqv2MXD61uicfQq4YBRsjEq1ejvwS2VnmAm0Ldm3E8UducWzW0gevp4m8NrfNb54pD
	 ysLXQPy5VDOMuYG2q/p3Gmlnh3oLqzSYhsioSpd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/411] thermal: core: Fix thermal zone governor cleanup issues
Date: Tue, 16 Jun 2026 20:28:20 +0530
Message-ID: <20260616145114.964955587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -778,6 +778,7 @@ static void thermal_release(struct devic
 		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
+		thermal_set_governor(tz, NULL);
 		kfree(tz);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
 			    sizeof("cooling_device") - 1)) {
@@ -1260,8 +1261,10 @@ thermal_zone_device_register(const char
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
@@ -1385,8 +1388,6 @@ void thermal_zone_device_unregister(stru
 
 	cancel_delayed_work_sync(&tz->poll_queue);
 
-	thermal_set_governor(tz, NULL);
-
 	thermal_remove_hwmon_sysfs(tz);
 	ida_simple_remove(&thermal_tz_ida, tz->id);
 	ida_destroy(&tz->ida);


