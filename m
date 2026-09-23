Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE05326AD;
	Wed, 23 Sep 2026 14:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173999; cv=none; b=sxtBZ48WbgvRAv7oGVMklrOxAQL10eqeYuP68tZmC3Se0FtCuwC8rtlwl4p2eo12cxRZGgddzMYiEB6dYL4OnxJaFazHovsjOpQRBDwp7zPudm/SqGaSajzUhDzEAVc13uFwihGXeAphPGrSZymJSVZkKMzkkZVhYlFS2fSyGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173999; c=relaxed/simple;
	bh=TPrEKy8rzXdMLA6aq/XPR+Jd/bXMxFD+cuGteAkSuAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y50l0WUUVmTfBfu1p9CNJOqc9zUxuSdV0wekIrn1cTliFUzl072w52o+/HRnwHoIerOyljSD/Dj+S+FBeU1WL6I8eS5kULUyIrrX4fzaPKUs05+0ScZLyDdtzKnDuUxFic3yi++O16PwHO0akdp3w2K+U+nkH6rx2USgzLGLhx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ueblNpEx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueblNpEx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCB11F00899;
	Wed, 23 Sep 2026 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173997;
	bh=P+7up6w65sV/rwBrpc2x6Qdc5BJhaxDKhXKKRevpGis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueblNpExsneM+VGnWkhzyHHgdj9PhsK5SJQRSFHCwQNUsGgprYegTATnkrHjPdmEE
	 EukDppFU1KQaLJYyPTfqXGTRUnQLP0AMcFdRqnLK4+55o4L6Q5w6t0tOpz8EeVtCVN
	 /2A8GeEYqbj99FZHzzWqIaLUDMsCub0YdWH/OjmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 370/438] hwmon: (w83791d) remove fan/pwm 4-5 sysfs group on remove
Date: Wed, 23 Sep 2026 16:06:31 +0200
Message-ID: <20260923140654.450029279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


