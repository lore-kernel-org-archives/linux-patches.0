Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B9F314A86;
	Wed, 30 Sep 2026 17:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788800; cv=none; b=YqF1Elrgcw5G3JYzz2+RGGK6puQD730YHsohdc/gofH3+FMhr+W1yLXRLcuhQGLHfa7uzIrNNg1Tiq0+haKZsfGIFPZ1wgAnbibMiX3OC51OZg7ZPZ1XaxXu12JAj+R8i7SgjiqmWmE5PnapZ35UYseK0RXqvpl0c7FGMnoBy7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788800; c=relaxed/simple;
	bh=693s2Jg4t0/XGNN6j5fEFoaAz1c95eelfrt8S1wzR6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQwM8E4fFSVKrudKjY3UqfeBpwhSRCg4y3Pix2HdBnx3Tg6YzQOIr6aa/j2kYNBqAUtgKf/2XIjC0isicq4Vo9b1bnGfq7jN3frVnupG145okNg4G2H+F/vR5n9TM2/Z3QJ5yV09P3gzQDTJeLw/ax0AdU5X8L6jODewPJ62Mxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5GuEjDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5GuEjDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315FA1F000FF;
	Wed, 30 Sep 2026 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788798;
	bh=qd7LZivCUew2Gf4sDBW9HTwAfMlVzIVr5pLH9kv2XJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5GuEjDOyI49tkfSeOkFLS5izm1DS1/InLjr4tvHWjtfb7P5rOW+bCn1V5hZCWpn7
	 1BDjBd+Fd4NeU19gmaznuzKGugY+tLvZbFSC3PE0Mc6/1bjWnz6/ZkIChtgheTqhsN
	 TG2FZ4QzLBLtMkhpRf5oMbwz+EHGUskTmUPK6IQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 250/877] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 30 Sep 2026 17:19:21 +0200
Message-ID: <20260930152420.117727725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


