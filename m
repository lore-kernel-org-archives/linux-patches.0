Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C6E1EE033;
	Wed,  6 Nov 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897338; cv=none; b=QvgTBvYP1Ryd8q1+uXZi5/x2lEIgZfSYYNK4Kvf3VMEANKk8I4+vdWmd+0ZNj8InF35aXcm8Nu6754KfUbLLz13ysIsFsFP6p6SO/+dnAjd+YMEYl7Kub2sehGIa7p0H3z6nvTYYMf0zPpeB/X63RTBcNbkTV650OijZMHxx644=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897338; c=relaxed/simple;
	bh=z+pUf72+jPLVIoS+rNuw3qBW2YPCoIKBAj0omXcmIPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9JQJVYAGOdChGQYvt985pumoWfSziPHuO50IBnW24XE93G5S/bacIeqGuSkXzp5NDBAezu0OgG3BAnjWWwyNvKd/5DunTnrH0ATdt3itWkTTyjLdVPk+WJWcZXN+T34TZzAhgKEUJB8/fUCigG+a4Ul1wGbfQa1DRD6/ZpfgU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9fdBOvR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9fdBOvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69792C4CECD;
	Wed,  6 Nov 2024 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897337;
	bh=z+pUf72+jPLVIoS+rNuw3qBW2YPCoIKBAj0omXcmIPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9fdBOvRzDlpy0zjAU0IBO/7hVIhHB/ROyz8FZnD75N07secTQmMGWD+cxJv/tmLV
	 bcv/OmbN6VGeDKuWl6gaW0i02lK+HzppZ7taoZd80Dc7MAyAXVXfBp8U8CEsna77Mr
	 BiBXUs4JT1r3HDy//3kb6ZgJa0va4peeNg4ZIhN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.6 002/151] thermal: core: Rework thermal zone availability check
Date: Wed,  6 Nov 2024 13:03:10 +0100
Message-ID: <20241106120308.908857217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit b38aa87f67931e23ebc32c0ca00a86dfa4688719 ]

In order to avoid running __thermal_zone_device_update() for thermal
zones going away, the thermal zone lock is held around device_del()
in thermal_zone_device_unregister() and thermal_zone_device_update()
passes the given thermal zone device to device_is_registered().
This allows thermal_zone_device_update() to skip the
__thermal_zone_device_update() if device_del() has already run for
the thermal zone at hand.

However, instead of looking at driver core internals, the thermal
subsystem may as well rely on its own data structures for this
purpose.  Namely, if the thermal zone is not present in
thermal_tz_list, it can be regarded as unavailable, which in fact is
already the case in thermal_zone_device_unregister().  Accordingly,
the device_is_registered() check in thermal_zone_device_update() can
be replaced with checking whether or not the node list_head in struct
thermal_zone_device is empty, in which case it is not there in
thermal_tz_list.

To make this work, though, it is necessary to initialize tz->node
in thermal_zone_device_register_with_trips() before registering the
thermal zone device and it needs to be added to thermal_tz_list and
deleted from it under its zone lock.

After the above modifications, the zone lock does not need to be
held around device_del() in thermal_zone_device_unregister() any more.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-and-tested-by: Lukasz Luba <lukasz.luba@arm.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Stable-dep-of: 827a07525c09 ("thermal: core: Free tzp copy along with the thermal zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 5a9068e8f050d..69b89a71f44eb 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -487,11 +487,16 @@ int thermal_zone_device_is_enabled(struct thermal_zone_device *tz)
 	return tz->mode == THERMAL_DEVICE_ENABLED;
 }
 
+static bool thermal_zone_is_present(struct thermal_zone_device *tz)
+{
+	return !list_empty(&tz->node);
+}
+
 void thermal_zone_device_update(struct thermal_zone_device *tz,
 				enum thermal_notify_event event)
 {
 	mutex_lock(&tz->lock);
-	if (device_is_registered(&tz->device))
+	if (thermal_zone_is_present(tz))
 		__thermal_zone_device_update(tz, event);
 	mutex_unlock(&tz->lock);
 }
@@ -1292,6 +1297,7 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	}
 
 	INIT_LIST_HEAD(&tz->thermal_instances);
+	INIT_LIST_HEAD(&tz->node);
 	ida_init(&tz->ida);
 	mutex_init(&tz->lock);
 	init_completion(&tz->removal);
@@ -1365,7 +1371,9 @@ thermal_zone_device_register_with_trips(const char *type, struct thermal_trip *t
 	}
 
 	mutex_lock(&thermal_list_lock);
+	mutex_lock(&tz->lock);
 	list_add_tail(&tz->node, &thermal_tz_list);
+	mutex_unlock(&tz->lock);
 	mutex_unlock(&thermal_list_lock);
 
 	/* Bind cooling devices for this zone */
@@ -1455,7 +1463,10 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 		mutex_unlock(&thermal_list_lock);
 		return;
 	}
+
+	mutex_lock(&tz->lock);
 	list_del(&tz->node);
+	mutex_unlock(&tz->lock);
 
 	/* Unbind all cdevs associated with 'this' thermal zone */
 	list_for_each_entry(cdev, &thermal_cdev_list, node)
@@ -1472,9 +1483,7 @@ void thermal_zone_device_unregister(struct thermal_zone_device *tz)
 	ida_free(&thermal_tz_ida, tz->id);
 	ida_destroy(&tz->ida);
 
-	mutex_lock(&tz->lock);
 	device_del(&tz->device);
-	mutex_unlock(&tz->lock);
 
 	kfree(tz->tzp);
 
-- 
2.43.0



