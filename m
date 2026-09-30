Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842153E5EC2;
	Wed, 30 Sep 2026 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796551; cv=none; b=BRpP1pSAIGeT3fd37WSVC7+sOe5Iu9Zs9yA+ZNgkLgaFHFf1SKR7kunXTGIjEg1js+n5KZU0F1uQzhg/H+pnCIdJQIgbo1BLw3aqDMpejeQsgDSqgqLxJlY56Q5cbrLNQRwfs7+24382FRBuyNVQKl+jB4H+I97lGtCfc3W5hXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796551; c=relaxed/simple;
	bh=Rxuo5YWzljUcWiYR+W0VHzIaHmy9M+gy89gPH3MAuOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qR+e8MlvNGXeLbxovLD974y4pj0QWaaK2HyAFLduYnfRLWoly73tAyT44ljJHcuAUPYAI0L0MnA33jAVOVza4aIHQAAyswYyw633CbHNHZe+UHjSSXLIybO+NKMJsO+ZZgh4jo7aNND5KwZ67I+AG99CCm2qz4KAk/Av2fHbavE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1imFoPmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1imFoPmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C4F1F000FF;
	Wed, 30 Sep 2026 19:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796550;
	bh=BhQf6Ze9o0gppv7rKdnNvQkeOxAxZBZ7Rc0eTQZO58w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1imFoPmiZHHXSkzPS/cQKMYTGvplH7/kpLqpLbI08TR57siaJxfta/lZK2/Abt08P
	 xaqN9RMLoYkriZgzaMnvIKNM7mIaszgvmLax7cy8YbvwBsp64zitYC8HvRH9pqRRrx
	 90/FdraW860T4Q82xB2WkLKdubgZINk4nNPPDA8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0908/1193] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 30 Sep 2026 17:26:32 +0200
Message-ID: <20260930152454.415829028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


