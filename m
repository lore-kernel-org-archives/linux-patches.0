Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43B440A16;
	Wed, 23 Sep 2026 14:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175070; cv=none; b=sW8f0+tb9jZYi1y/IDy1IgNC7Ry9OnnzxcBs2p8EGmwM0o7srmTt+6GztO9i1QEpj8YMwQ3PET8VMakOsZ6qvBm/riaBxXiHiqkCkY1NixxwwaTJlR9GPpjwn2fEvh8mVrqv7v8xmgbLD4eO3013UjfjzCC9rkEoUVgGVI1oV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175070; c=relaxed/simple;
	bh=ZqPIVYRjEXcPolTbtUyModJ++sxNEQRa4QEeOG+lTcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twkp2NmO3b2ijSGaWDu7D9X6LZDfBCNbbQ0F5TnmlwPg0MygXp5gPNGClsuo4XcEs1JBkUV8Q4w7yBX2xEB5CP0jeNemNK2a+KhI0WE1HkjA6/xOFVTm+0CJo/iWwcA1Qy7bnOha8ETlAZ2RBeq3uUMfyYJxHFPvfA0134cEado=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXVOKxyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXVOKxyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E0D1F000FF;
	Wed, 23 Sep 2026 14:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175068;
	bh=nV9BMfG/RD3Tcb9NsXRBmqg3TjJ0ylifxBvpFcl1xkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXVOKxyb6Xmuxt7CFcdQgkC+to4oL12glUO7s86T+W33R8LuBqtG0tI2uZMsQtgv6
	 SSs0SZ3J53+TIpS2Tq45U6af+W5xkdlVgW6SYEMk3/FP5SvburZgI2tTsdA1oju0aD
	 p0YvIgEnzMMS3oY/+JbmEXv2iRu4u9sLZYhQw0VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 311/398] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 23 Sep 2026 16:06:25 +0200
Message-ID: <20260923140651.487367845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
 


