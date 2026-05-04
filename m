Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F9229BD9A;
	Mon,  4 May 2026 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902938; cv=none; b=mAe+9cHzKEME4QySHsXKkt3VQ64o+EXR2Qpi9dGKiHY9y6eHBC+fkU/SNdhiQGqoNgXYyGEIp/qvi4NHTQkajpSpxbfIsE/Nwu1vMHrNQ89cszGeEy59PwWnT36iey8UlOqPHiJeGB9VTRZlXAG0hkuW8N3ZV5vXvCc7kXGyOrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902938; c=relaxed/simple;
	bh=DZ7rXMCFvyEGWda2tvFQLDlFV/iPSzGmbTMmNLXD7wE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyXTlDWj8WrU8ZGMZ/UmHU0ALqzmhJjomYeVN6RWDZef1Ch4NQffjmwgQTgH/ySMjr/+1Ilu0ZwdH8fmydHn6V+NsLHfZYF9LE+39M1kMb5tY15f0IedJDqZ4NpKko9SfssimrICPkAfNweBZ9B+9cu2GGdCTv3DoAgoflPU7PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VklSn83c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VklSn83c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ECD3C2BCB8;
	Mon,  4 May 2026 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902937;
	bh=DZ7rXMCFvyEGWda2tvFQLDlFV/iPSzGmbTMmNLXD7wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VklSn83cWrLY4UUY1g/Ml8B8zlSCQNfeF/hxTqNN0XlwJtSLhV4iPJPSI301KJ/rH
	 pPs0Zmf8j9CGywm2/e/YxhDXJF3161eshfV2qiQwhcuu+HVCwLDOZajRj/SlL/V9It
	 u0XTK73eFGC79dnig3rhOkG4JXBecAi9m0Qz7phs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.0 041/307] thermal: core: Fix thermal zone governor cleanup issues
Date: Mon,  4 May 2026 15:48:46 +0200
Message-ID: <20260504135144.372575714@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 41ff66baf81c6541f4f985dd7eac4494d03d9440 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -964,6 +964,7 @@ static void thermal_release(struct devic
 		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
+		thermal_set_governor(tz, NULL);
 		mutex_destroy(&tz->lock);
 		complete(&tz->removal);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
@@ -1611,8 +1612,10 @@ thermal_zone_device_register_with_trips(
 	/* sys I/F */
 	/* Add nodes that are always present via .groups */
 	result = thermal_zone_create_device_groups(tz);
-	if (result)
+	if (result) {
+		thermal_set_governor(tz, NULL);
 		goto remove_id;
+	}
 
 	result = device_register(&tz->device);
 	if (result)
@@ -1725,8 +1728,6 @@ void thermal_zone_device_unregister(stru
 
 	cancel_delayed_work_sync(&tz->poll_queue);
 
-	thermal_set_governor(tz, NULL);
-
 	thermal_thresholds_exit(tz);
 	thermal_remove_hwmon_sysfs(tz);
 	ida_free(&thermal_tz_ida, tz->id);


