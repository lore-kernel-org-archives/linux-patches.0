Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DE3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCBAC433D2;
	Mon, 30 Jan 2023 14:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088707;
	bh=4OrA0ZDpwKQpPRV0xuqGGanvcqCqBG/tGPjB2AVrfp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gacEXbydc54Lr7bJFxqOxX85CSMCM14Q8+7wlrIAjpA5RHRKkss0KLyzOqK0+6jZj
	 7lx8JLTu1kSmhSyDwubY2ndyCfU2gnbH+3731J+VgDuV7+ISJTjefaH62fn0dKdspv
	 zsnihbd/PaIqvlPurqxiJG9L1cDvOtsp5gKSGcbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 108/143] thermal: intel: int340x: Protect trip temperature from concurrent updates
Date: Mon, 30 Jan 2023 14:52:45 +0100
Message-Id: <20230130134311.312121455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 6757a7abe47bcb12cb2d45661067e182424b0ee3 upstream.

Trip temperatures are read using ACPI methods and stored in the memory
during zone initializtion and when the firmware sends a notification for
change. This trip temperature is returned when the thermal core calls via
callback get_trip_temp().

But it is possible that while updating the memory copy of the trips when
the firmware sends a notification for change, thermal core is reading the
trip temperature via the callback get_trip_temp(). This may return invalid
trip temperature.

To address this add a mutex to protect the invalid temperature reads in
the callback get_trip_temp() and int340x_thermal_read_trips().

Fixes: 5fbf7f27fa3d ("Thermal/int340x: Add common thermal zone handler")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.0+ <stable@vger.kernel.org> # 5.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c |   18 +++++++++--
 drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h |    1 
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -44,11 +44,13 @@ static int int340x_thermal_get_trip_temp
 					 int trip, int *temp)
 {
 	struct int34x_thermal_zone *d = zone->devdata;
-	int i;
+	int i, ret = 0;
 
 	if (d->override_ops && d->override_ops->get_trip_temp)
 		return d->override_ops->get_trip_temp(zone, trip, temp);
 
+	mutex_lock(&d->trip_mutex);
+
 	if (trip < d->aux_trip_nr)
 		*temp = d->aux_trips[trip];
 	else if (trip == d->crt_trip_id)
@@ -66,10 +68,12 @@ static int int340x_thermal_get_trip_temp
 			}
 		}
 		if (i == INT340X_THERMAL_MAX_ACT_TRIP_COUNT)
-			return -EINVAL;
+			ret = -EINVAL;
 	}
 
-	return 0;
+	mutex_unlock(&d->trip_mutex);
+
+	return ret;
 }
 
 static int int340x_thermal_get_trip_type(struct thermal_zone_device *zone,
@@ -174,6 +178,8 @@ int int340x_thermal_read_trips(struct in
 	int trip_cnt = int34x_zone->aux_trip_nr;
 	int i;
 
+	mutex_lock(&int34x_zone->trip_mutex);
+
 	int34x_zone->crt_trip_id = -1;
 	if (!int340x_thermal_get_trip_config(int34x_zone->adev->handle, "_CRT",
 					     &int34x_zone->crt_temp))
@@ -201,6 +207,8 @@ int int340x_thermal_read_trips(struct in
 		int34x_zone->act_trips[i].valid = true;
 	}
 
+	mutex_unlock(&int34x_zone->trip_mutex);
+
 	return trip_cnt;
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_read_trips);
@@ -224,6 +232,8 @@ struct int34x_thermal_zone *int340x_ther
 	if (!int34x_thermal_zone)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&int34x_thermal_zone->trip_mutex);
+
 	int34x_thermal_zone->adev = adev;
 	int34x_thermal_zone->override_ops = override_ops;
 
@@ -275,6 +285,7 @@ err_thermal_zone:
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
 err_trip_alloc:
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 	return ERR_PTR(ret);
 }
@@ -286,6 +297,7 @@ void int340x_thermal_zone_remove(struct
 	thermal_zone_device_unregister(int34x_thermal_zone->zone);
 	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
 	kfree(int34x_thermal_zone->aux_trips);
+	mutex_destroy(&int34x_thermal_zone->trip_mutex);
 	kfree(int34x_thermal_zone);
 }
 EXPORT_SYMBOL_GPL(int340x_thermal_zone_remove);
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.h
@@ -32,6 +32,7 @@ struct int34x_thermal_zone {
 	struct thermal_zone_device_ops *override_ops;
 	void *priv_data;
 	struct acpi_lpat_conversion_table *lpat_table;
+	struct mutex trip_mutex;
 };
 
 struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *,


