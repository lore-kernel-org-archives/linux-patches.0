Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3274E234D;
	Wed, 30 Sep 2026 15:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783603; cv=none; b=rssr6va4wXARYeeHD+gXP+wyba3sOqLSKnClBy3R6cXiQaUx3dIB3UOV9JWjmgurkGMQYt05kU9M8vXg2v7Ih4SBzFzzSPIbdLj9z69s3NIe0m+qiDu7IFJ33Zq4CLRV1Ew1reMKBEqCAgjIDEGlBSVHQabWJPPMvICRCBZL0sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783603; c=relaxed/simple;
	bh=GxJGW/p7tsQMrbR1DV1KW3EcADeet/DubtjTWl7ykRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUcVvhEqY/+NJ2Gca/8zwTY+wkU1QVJiCL7flp4rvpJG+Il8tm98oC+9gVuY4IHljIVvGh6MG4qBVtmwD66H2rRPmg9YEWHvdhVa9hbsFd/CVbleN8wS0RgTzEZQv87DvU48ksOBi7wEDHmySbb+AVqvB3wa0dQ6RjIo1aNJFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0Hz/rI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0Hz/rI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B91A1F00898;
	Wed, 30 Sep 2026 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783600;
	bh=CT9atNz/4/Z/iXBdJrLo01yon9zUWMbGMKIybXwu154=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0Hz/rI9gTkeChEb7cH5tvIySSVZ5ImK5Byamf/xMk4nMJaO/ZEbjOSdmJjqT5b+b
	 AYEzv8jiwHcu4qLr+N16t3+mdnvjAFsE4n2Enr9AV5ZFSV0+lVENFOFfMzDQX5tSyp
	 CVUPTAq9xMaNEJBbXui/t7Evc1jeW8BKUOI908dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 457/595] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 30 Sep 2026 17:25:50 +0200
Message-ID: <20260930152357.511423749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1415,6 +1415,7 @@ static int w83791d_remove(struct i2c_cli
 	struct w83791d_data *data = i2c_get_clientdata(client);
 
 	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&client->dev.kobj, &w83791d_group_fanpwm45);
 	sysfs_remove_group(&client->dev.kobj, &w83791d_group);
 
 	return 0;


