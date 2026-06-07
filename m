Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E59212564;
	Sun,  7 Jun 2026 11:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830084; cv=none; b=F9mR5PTVVMTiTAm/wwYsfyAOgy/qvmUPk0QWGiwRreoOFR7pR+6a5E3/UimUvT3R6HIij4pTDL2OzGaKC4B9xhnaHQxb9QjMmTQf3ULzholUS1qumxz/CynmrIq8Xizkn5jQw+NhuxB0VoyCnPyMa35VHjSzCzu/UI0BE+9UPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830084; c=relaxed/simple;
	bh=rT48XzCqtcQDmmNdzzXuebGWaZ/eGI+lZEShq/yiCl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuEC+0IG48Y04A7Iyx6R1SafYstkR+D5+tF8wJ8fWsQHvmGE94CV5sQAnYT8CXtf2F2zH/6BOa/XX2SAyeocXwqqWCT+GzqjVZMxgTqTIG7ow++0J5Afwct7m+Zr+2sc/56lZ76oXz6vwllCtS/qHjQRaS68cWfdIASDLl42pDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wq65jF9D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wq65jF9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FFB1F00893;
	Sun,  7 Jun 2026 11:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830083;
	bh=KNQEHShU8OCmdhs7545npZci5bEezrG3GEJx6wNl/00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wq65jF9D+909oqcNA3HLYfCIIoUAZYjUKc78seRnhrS4hV2WIdY2QLvX+fgm0NPqG
	 gFmFkGm/k4yKf6iQi2YUk4vRqHC2Ib9MoHvBBYfSbLZUqh3+nwbl+kUjoiOI1EfUnF
	 drtogQc/HcEw55q0OZGkLbLB8kAG4qJqSb0tv2XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/315] hwmon: (pmbus) Add support for guarded PMBus lock
Date: Sun,  7 Jun 2026 12:01:34 +0200
Message-ID: <20260607095738.884512804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1814f4d3ff358277a5b6957e7f133c2812dc80ec ]

Add support for guard(pmbus_lock)() and scoped_guard(pmbus_lock)()
to be able to simplify the PMBus code.

Also introduce pmbus_lock() as pre-requisite for supporting
guard().

Reviewed-by: Sanman Pradhan <psanman@juniper.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 4e4af55aaca7 ("hwmon: (pmbus/adm1266) serialize sequencer_state debugfs read with pmbus_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus.h      |    5 +++++
 drivers/hwmon/pmbus/pmbus_core.c |    8 ++++++++
 2 files changed, 13 insertions(+)

--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -10,6 +10,7 @@
 #define PMBUS_H
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 #include <linux/regulator/driver.h>
 
 /*
@@ -563,7 +564,11 @@ int pmbus_get_fan_rate_device(struct i2c
 int pmbus_get_fan_rate_cached(struct i2c_client *client, int page, int id,
 			      enum pmbus_fan_mode mode);
 int pmbus_lock_interruptible(struct i2c_client *client);
+void pmbus_lock(struct i2c_client *client);
 void pmbus_unlock(struct i2c_client *client);
+
+DEFINE_GUARD(pmbus_lock, struct i2c_client *, pmbus_lock(_T), pmbus_unlock(_T))
+
 int pmbus_update_fan(struct i2c_client *client, int page, int id,
 		     u8 config, u8 mask, u16 command);
 struct dentry *pmbus_get_debugfs_dir(struct i2c_client *client);
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -3871,6 +3871,14 @@ struct dentry *pmbus_get_debugfs_dir(str
 }
 EXPORT_SYMBOL_NS_GPL(pmbus_get_debugfs_dir, "PMBUS");
 
+void pmbus_lock(struct i2c_client *client)
+{
+	struct pmbus_data *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->update_lock);
+}
+EXPORT_SYMBOL_NS_GPL(pmbus_lock, "PMBUS");
+
 int pmbus_lock_interruptible(struct i2c_client *client)
 {
 	struct pmbus_data *data = i2c_get_clientdata(client);


