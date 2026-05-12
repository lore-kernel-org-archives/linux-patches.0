Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091E43BB100;
	Tue, 12 May 2026 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608572; cv=none; b=pzFojm0wIo/yAcywq7rNtp+t/S7i/XmngjppgOWu5JxluzqL6VFE+Ttg+65MQb7L1pPjl0lhnx0DTw3LYvRJBDecFKrtHU9KNrMOPsrouWUxkCbk20LYMMgGwRc+aPDUFhkw4Ze0QfsfbRUnvONXN9Kxfk5QdwvnehBC2eXRG3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608572; c=relaxed/simple;
	bh=OojMH6UBtMgdrKqXahQE3FfZXejDsS2J1Bmn5xU7WWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaUNeKAikj0AKX6mNWQ5rBPZ4R6PF4yr0qRR6gUMYkLFn+Xmj4A0Zxv02AZamUopMPvesNvZN51K07wCzemqBVOaCoVdEUvSjuu0550WRNIGu/cA0flOPDX53nyeJfx4ik9k1ZwJGoB9/QIHClOwCuZzNvGBa1ubvCaq4wPOpw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fSuYOGKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fSuYOGKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF6FC2BCB0;
	Tue, 12 May 2026 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608571;
	bh=OojMH6UBtMgdrKqXahQE3FfZXejDsS2J1Bmn5xU7WWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSuYOGKd3MmvM0RwEDnPRBSkvE/gj5oDDSJ8yjcvk6nE5dpnm1KOsXUgXpJcJDmuN
	 Mqcwd3OWeiDjjSrkwy9uP5adl8ePrV1LvXttuAX9SuaBXPxBfyFGAy1tGVldDQ32O3
	 lLOLRJLCvcS1qlmLaAMZ3TeVhiCWTbXBfnLznIts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 132/270] thermal: core: Free thermal zone ID later during removal
Date: Tue, 12 May 2026 19:38:53 +0200
Message-ID: <20260512173941.232299685@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit daae9c18feec74566e023fc88cfb0ce26e39d868 upstream.

The thermal zone removal ordering is different from the thermal zone
registration rollback path ordering and the former is arguably
problematic because freeing a thermal zone ID prematurely may cause
it to be used during the registration of another thermal zone which
may fail as a result.

Prevent that from occurring by changing the thermal zone removal
ordering to reflect the thermal zone registration rollback path
ordering.

Also more the ida_destroy() call from thermal_zone_device_unregister()
to thermal_release() for consistency.

Fixes: b31ef8285b19 ("thermal core: convert ID allocation to IDA")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/5063934.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -965,6 +965,7 @@ static void thermal_release(struct devic
 		tz = to_thermal_zone(dev);
 		thermal_zone_destroy_device_groups(tz);
 		thermal_set_governor(tz, NULL);
+		ida_destroy(&tz->ida);
 		mutex_destroy(&tz->lock);
 		complete(&tz->removal);
 	} else if (!strncmp(dev_name(dev), "cooling_device",
@@ -1726,8 +1727,6 @@ void thermal_zone_device_unregister(stru
 
 	thermal_thresholds_exit(tz);
 	thermal_remove_hwmon_sysfs(tz);
-	ida_free(&thermal_tz_ida, tz->id);
-	ida_destroy(&tz->ida);
 
 	device_del(&tz->device);
 	put_device(&tz->device);
@@ -1735,6 +1734,9 @@ void thermal_zone_device_unregister(stru
 	thermal_notify_tz_delete(tz);
 
 	wait_for_completion(&tz->removal);
+
+	ida_free(&thermal_tz_ida, tz->id);
+
 	kfree(tz->tzp);
 	kfree(tz);
 }


