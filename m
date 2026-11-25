Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623189;
	b=hh0rn1nevY92eU9ndAKcRzclFUd/1hHxvI5omAuiBjMhdxdcRNzG0z95DneiQ1x93+Vs
	 l5THYtXHHbsTg2zQmCUFqmJcGvd/idYOxThT8nHjp3bQXhja6guKfI1v/nVzrL8wxEbu2
	 Hprzw4IbX9M3Zk61zkPzEZ264dC/uOU9vjSQlBS1E84z1208nUTgaKYQddB9sFKsBAUUV
	 k9HHG/up7iW0gQLj2/JmP7gxTT46dt+v0HPpSL4cQZ0QlMZ5WnPCp23Adv0g+q6fOfonn
	 3m94rOvRhZx1s7GDKnnKOESk/M93xdKN3NksG7WJdyYZmMG9EzPe3lGLwBzE+cc9kvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AcIQPVd5DskUiww1AFprKL8mLYwfrZWLHsYIqosN7tg=;
	b=ZNkuH0N8bhNbWVfgc2jltFAd+NGT/YNqyg8I29LAM6X3zMxZjTiprq4dtWGsVxLsG9yj
	 j2BQOPiQawGCxPTgctr8zZM9KPNWbXeWQgRBAXHqv1zQeSE/IhzZdWsiDflWFxG6cOLCs
	 E15mhTAQ4yLsRBoq5DibPsqhfBPE/ywe4anRAVk7/89uPzlgyP4hiIaP05pNsGhRDqteb
	 HPMjKOKWjUOWpAoiCWYR9R4DHTB567Kr4gshFbY9BG6MPmzDOgXQLomuuaTcN7IHaTwo8
	 3WLpBAKw5dp0Ciytt88JM45c2IGe20W+SDCIvNFDp0yluCbEy6Bdx4ToW7GI/tGhr+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwccvZxv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7120D606A32A;
	Wed, 25 Nov 2026 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwccvZxv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1C71F000C0;
	Wed, 25 Nov 2026 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623188;
	bh=AcIQPVd5DskUiww1AFprKL8mLYwfrZWLHsYIqosN7tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwccvZxv8T0MT3tvyTXHcmelZOYCWHoxFvsm8NqQ3rR8MHVFhi4G8/w5Li6xwLE7y
	 EjC/o/5cGp5OQQOFFSOnpEG/paXhYNu76TdiDv4ryt/tZeHI4ckewyYILAgRUAtdQd
	 cnU6ggHoqwoTyScYcLsfr6ivWoeoNVeA6D7jVago=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@sashiko.dev>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 777/990] hwmon: (gpio-fan) Fix runtime PM imbalance in probe and teardown
Date: Wed, 25 Nov 2026 15:35:44 +0100
Message-ID: <20261125143840.250827896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 221b565a3316b1ba3a9bcd1f61238440207b3e00 upstream.

In gpio_fan_probe(), gpio_fan_stop() is registered conditionally as a
devres action before runtime PM is initialized, while gpio_fan_stop()
unconditionally calls pm_runtime_disable(). This breaks runtime PM
disable_depth and usage_count invariants across several paths:

- On alarm-only devices without control GPIOs, gpio_fan_stop() is never
  registered, leaving pm_runtime_enable() unbalanced on unbind and
  triggering "Unbalanced pm_runtime_enable!" on subsequent binds.
- When control GPIOs are present and devm_add_action_or_reset(), hwmon
  registration, or fan_alarm_init() fails, gpio_fan_stop() runs before
  pm_runtime_enable(), incrementing disable_depth to 2 (leaving runtime
  PM permanently disabled on re-probe) and, if speed_index > 0,
  underflowing usage_count via pm_runtime_put_sync().
- If pm_runtime_resume_and_get() fails when speed_index > 0, it drops
  its reference while speed_index remains non-zero, causing
  gpio_fan_stop() to call pm_runtime_put_sync() and underflow
  usage_count.
- Registering the hwmon device before enabling runtime PM exposes sysfs
  attributes that can invoke set_fan_speed() before runtime PM state is
  initialized.

Initialize runtime PM upfront with pm_runtime_set_suspended() and
devm_pm_runtime_enable(), remove pm_runtime_disable() from
gpio_fan_stop(), and acquire the initial active runtime PM reference
before registering gpio_fan_stop() and the hwmon device.

Fixes: 0d01110e6356 ("hwmon: (gpio-fan) Add regulator support")
Reported-by: Sashiko <sashiko@sashiko.dev>
Link: https://sashiko.dev/#/bug/linux-349aa3ba-30c3-4c3c-b47e-f52839af2b8d
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gpio-fan.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -531,8 +531,6 @@ static void gpio_fan_stop(void *data)
 	mutex_lock(&fan_data->lock);
 	set_fan_speed(data, 0);
 	mutex_unlock(&fan_data->lock);
-
-	pm_runtime_disable(fan_data->dev);
 }
 
 static int gpio_fan_probe(struct platform_device *pdev)
@@ -560,6 +558,11 @@ static int gpio_fan_probe(struct platfor
 		return dev_err_probe(dev, PTR_ERR(fan_data->supply),
 				     "Failed to get fan-supply");
 
+	pm_runtime_set_suspended(dev);
+	err = devm_pm_runtime_enable(dev);
+	if (err)
+		return err;
+
 	/* Configure control GPIOs if available. */
 	if (fan_data->gpios && fan_data->num_gpios > 0) {
 		if (!fan_data->speed || fan_data->num_speed <= 1)
@@ -567,6 +570,12 @@ static int gpio_fan_probe(struct platfor
 		err = fan_ctrl_init(fan_data);
 		if (err)
 			return err;
+		/* If current GPIO state is active, mark RPM as active as well */
+		if (fan_data->speed_index > 0) {
+			err = pm_runtime_resume_and_get(dev);
+			if (err)
+				return err;
+		}
 		err = devm_add_action_or_reset(dev, gpio_fan_stop, fan_data);
 		if (err)
 			return err;
@@ -587,17 +596,6 @@ static int gpio_fan_probe(struct platfor
 			return err;
 	}
 
-	pm_runtime_set_suspended(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-	/* If current GPIO state is active, mark RPM as active as well */
-	if (fan_data->speed_index > 0) {
-		int ret;
-
-		ret = pm_runtime_resume_and_get(&pdev->dev);
-		if (ret)
-			return ret;
-	}
-
 	/* Optional cooling device register for Device tree platforms */
 	fan_data->cdev = devm_thermal_of_cooling_device_register(dev, np,
 				"gpio-fan", fan_data, &gpio_fan_cool_ops);


