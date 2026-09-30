Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39C13749F6;
	Wed, 30 Sep 2026 16:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786125; cv=none; b=h5GM6jhSIKzJIYzl3D96s5oGI3gmXL+I/nebdvGZ3g6nabH0cghMvUZ5XKRjeB++J3DVi0xzpQWTBPQ7/ZMAP17fWi6esXkCJjh+EsoG6TbDl7YN86tY39T9u9Uazhi8WxtL3ZT/s+iVo8/TNxuCgTaTh3cCh2X9jJ98KNraGPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786125; c=relaxed/simple;
	bh=EzEqQbBx6ERA6r054ld5Jp6vLjqOdtGMsoI59qgN9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HP6FswV6mQRhDr/N7Nq4UgiBl0pcxoRV85sNyt/LgpCgIj08IbNJseLsC+kEiAVaqKV0WvzEYf/cYOmyULcpvGxi602Gc1czwZ2THtufnUSbYwcyv/P8xP+LAtki/hYW1TpSs9FSKKaGOMCNTeNazfpU+aYtLBhdN/eB0nwrqfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w47ZUthw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w47ZUthw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585771F00893;
	Wed, 30 Sep 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786123;
	bh=HLIRXE+3VlE7DFwie+SZ6puazkKjOm2vGrfyEku9gic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w47ZUthwlfYRzT86SmFq8GlPD9UiseUuWRfnE/fyr3BYau3VVIaWMkTrwFrHuoCWa
	 KCsnVEDxpGT53K/jUYlGHnNQyXPqM3LgPfEeCX0YgKNBTXoO5VmS9qkvKiqAO4eCFa
	 v+6DGIU4xqlsysEYUj/oVdD8PmBzj7vqv+U8rpsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 752/982] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 30 Sep 2026 17:24:48 +0200
Message-ID: <20260930152432.905932722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0ff9c7775e51ac6d47b1bb5c46f06b1434fe58a8 upstream.

When the fan/pwm 4-5 pins are not used as GPIO, w83791d_probe()
creates the w83791d_group_fanpwm45 sysfs group on the I2C client
device.

The probe error path removes this group when a later initialization
step fails, but the normal remove path only removes w83791d_group.
As a result, the optional fan/pwm 4-5 sysfs files can remain after the
driver is unbound.

The callbacks associated with these files access the driver data,
which is devm allocated and released after driver unbind. Leaving the
sysfs files behind can therefore result in accesses to stale driver
data.

Remove w83791d_group_fanpwm45 during normal teardown as well.

This issue was found by manual code inspection.

Fixes: 6e1ecd9b8f13 ("hwmon: (w83791d) fan 4/5 pins can also be used for gpio")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260914062809.1650538-1-lgs201920130244@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/w83791d.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1415,6 +1415,7 @@ static void w83791d_remove(struct i2c_cl
 	struct w83791d_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &w83791d_group_fanpwm45);
 	sysfs_remove_group(&client->dev.kobj, &w83791d_group);
 }
 


