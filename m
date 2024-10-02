Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310B1D049A;
	Wed,  2 Oct 2024 13:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875241; cv=none; b=ErWSflj7N1uHs+3IkYP2+Nf0i6aXROKb6AL3GYN58PWqKgc3E32HaLaTd8E9NiFCZFQC8xJIy14Psx2zj7GDKaBMC4Huep+uh9Dh2NXC6aHL0hQixenh+SdBGa3/2TpnP0VIDIqzav2ZuN7lKbg9xlMzaQnzcSwuYlIk0DM1BTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875241; c=relaxed/simple;
	bh=KQEmMlb7HitF5MBWJMQrhZC3vZ1XI4JuLvSTLoRNQoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3PlBTQHnTVETeFjD7tVkRlFiql6N7UNKv3Sq/v1lsMhw2W4fhLrGBcmoWJJoxZX505ayVJ8WOlWyhguZfBtp/VnQn4uJkG6gi3E1be2zX1smXgkKJrHnCGJPtBs5E/qjD274BfEQQQIVY8acYT4s5QNh9Mtm2YCoS0J3Da2SlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUG60Zu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUG60Zu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7055C4CECF;
	Wed,  2 Oct 2024 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875241;
	bh=KQEmMlb7HitF5MBWJMQrhZC3vZ1XI4JuLvSTLoRNQoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUG60Zu/OCM04pK13LK8W/nceinU1ORSVE+iESXpoQrW+SKw3g6ZUfKUnigrYxlHU
	 zFjTzBFuE5+a52By7+vbfqEb9xhZnsSiUInuPj4Esas0dGh8FdZzoeBB9KRFezSwzQ
	 D/37NVg1b3vv9ClUHRLGFpRmHKx0SLYOa6CNuoSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 038/695] thermal: core: Fold two functions into their respective callers
Date: Wed,  2 Oct 2024 14:50:36 +0200
Message-ID: <20241002125824.012874745@linuxfoundation.org>
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

[ Upstream commit a8bbe6f10f78f85243ff821432c5d798a6d99ed4 ]

Fold bind_cdev() into __thermal_cooling_device_register() and bind_tz()
into thermal_zone_device_register_with_trips() to reduce code bloat and
make it somewhat easier to follow the code flow.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/2962184.e9J7NaK4W3@rjwysocki.net
Stable-dep-of: 8144dbe68c49 ("thermal: core: Fix rounding of delay jiffies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_core.c | 55 ++++++++++++----------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index e6669aeda1fff..3ba8dd804026f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -991,20 +991,6 @@ void print_bind_err_msg(struct thermal_zone_device *tz,
 		tz->type, cdev->type, ret);
 }
 
-static void bind_cdev(struct thermal_cooling_device *cdev)
-{
-	int ret;
-	struct thermal_zone_device *pos = NULL;
-
-	list_for_each_entry(pos, &thermal_tz_list, node) {
-		if (pos->ops.bind) {
-			ret = pos->ops.bind(pos, cdev);
-			if (ret)
-				print_bind_err_msg(pos, cdev, ret);
-		}
-	}
-}
-
 /**
  * __thermal_cooling_device_register() - register a new thermal cooling device
  * @np:		a pointer to a device tree node.
@@ -1100,7 +1086,13 @@ __thermal_cooling_device_register(struct device_node *np,
 	list_add(&cdev->node, &thermal_cdev_list);
 
 	/* Update binding information for 'this' new cdev */
-	bind_cdev(cdev);
+	list_for_each_entry(pos, &thermal_tz_list, node) {
+		if (pos->ops.bind) {
+			ret = pos->ops.bind(pos, cdev);
+			if (ret)
+				print_bind_err_msg(pos, cdev, ret);
+		}
+	}
 
 	list_for_each_entry(pos, &thermal_tz_list, node)
 		if (atomic_cmpxchg(&pos->need_update, 1, 0))
@@ -1338,25 +1330,6 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);
 
-static void bind_tz(struct thermal_zone_device *tz)
-{
-	int ret;
-	struct thermal_cooling_device *pos = NULL;
-
-	if (!tz->ops.bind)
-		return;
-
-	mutex_lock(&thermal_list_lock);
-
-	list_for_each_entry(pos, &thermal_cdev_list, node) {
-		ret = tz->ops.bind(tz, pos);
-		if (ret)
-			print_bind_err_msg(tz, pos, ret);
-	}
-
-	mutex_unlock(&thermal_list_lock);
-}
-
 static void thermal_set_delay_jiffies(unsigned long *delay_jiffies, int delay_ms)
 {
 	*delay_jiffies = msecs_to_jiffies(delay_ms);
@@ -1554,13 +1527,23 @@ thermal_zone_device_register_with_trips(const char *type,
 	}
 
 	mutex_lock(&thermal_list_lock);
+
 	mutex_lock(&tz->lock);
 	list_add_tail(&tz->node, &thermal_tz_list);
 	mutex_unlock(&tz->lock);
-	mutex_unlock(&thermal_list_lock);
 
 	/* Bind cooling devices for this zone */
-	bind_tz(tz);
+	if (tz->ops.bind) {
+		struct thermal_cooling_device *cdev;
+
+		list_for_each_entry(cdev, &thermal_cdev_list, node) {
+			result = tz->ops.bind(tz, cdev);
+			if (result)
+				print_bind_err_msg(tz, cdev, result);
+		}
+	}
+
+	mutex_unlock(&thermal_list_lock);
 
 	thermal_zone_device_init(tz);
 	/* Update the new thermal zone and mark it as already updated. */
-- 
2.43.0



