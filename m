Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A33EDE45;
	Tue, 12 May 2026 18:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609339; cv=none; b=rJkr7gsS7QE3lPwwPO98MIIde9Zmm+anaVcuwadc4y4tBCIvxQxBovRqtiXVpAQXDsY5jT4RmSgZ6DMm3HN7Rs0fKU592L3qQoiSxnUp9Crz03TLVxrpmnsGJx2FM81axvuR+OmfJwlBSNqXwCf/DzzV0QUw/eF3zYVzNcBvkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609339; c=relaxed/simple;
	bh=6fiuW5bs31bQ6h6lRgOqFzyf3M2XT6ioGnbMtMy/w0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8nwtYhf/yA9PfuiG9boMh0Jz4ql6V88MoPgVYKvGTI0fsjhuq/FCpyh+svUrq045/IGcOwdpR3XKVqskoi1Bka4Ftqi4SMoCpgJBbszDzXQJ7oSVJQ3osasYzlBGwedEyINco9Gega8Tn+Qqh6tse6UuJsXtw32Pw4GPq6nZZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fO/pnOSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fO/pnOSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB18C2BCB0;
	Tue, 12 May 2026 18:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609339;
	bh=6fiuW5bs31bQ6h6lRgOqFzyf3M2XT6ioGnbMtMy/w0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO/pnOSxdOEUaLQWJX+kmRD17063FZzM1kLwCduuNxy8Y0BvUE+bn/GevlaG/1Nu6
	 318Mv10vipwAMUM1a0Ul8f8fEb3YT82ghwT2Ys30tCDUqS20vjU8CmkR/ZmXv/Ufw1
	 M2W7KYR+Ei3R/GhY5RGghRkPQAQoPO/SKzqRpdqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 7.0 155/307] thermal: core: Free thermal zone ID later during removal
Date: Tue, 12 May 2026 19:39:10 +0200
Message-ID: <20260512173943.396905125@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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
@@ -1730,8 +1731,6 @@ void thermal_zone_device_unregister(stru
 
 	thermal_thresholds_exit(tz);
 	thermal_remove_hwmon_sysfs(tz);
-	ida_free(&thermal_tz_ida, tz->id);
-	ida_destroy(&tz->ida);
 
 	device_del(&tz->device);
 	put_device(&tz->device);
@@ -1739,6 +1738,9 @@ void thermal_zone_device_unregister(stru
 	thermal_notify_tz_delete(tz);
 
 	wait_for_completion(&tz->removal);
+
+	ida_free(&thermal_tz_ida, tz->id);
+
 	kfree(tz->tzp);
 	kfree(tz);
 }


