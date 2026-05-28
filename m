Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130632ABC0;
	Thu, 28 May 2026 20:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999025; cv=none; b=jOzRqFAE53actuQzaMAeLNGXF0rjm/8ALW5TYF4G4s9WAt3SRpWPmgA9rfS3K5cdbTnVJQjsUR8fcEs5m4aHgUU/IvjEmmd75mC6TwZFc1Vt7Uph9vHML1Evxc1NEJ+yLHUGAEB7LkK+J8c3Ov9ug7fm9IDRl15oSyRlpkhtrc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999025; c=relaxed/simple;
	bh=IpZrceCTw9y57qzTJE4LgllGUvctVsUX1B2tN8qWKeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUNn8+42q51XgchNhuS/MHAcueUE0mBx/7Ky0nc/OXOqwI+KIfVRmUX+eaczn1DFEGXJSYyxEOGOi6wJyhF10e2s3EhgEa7fFvlOBAtDlji37S5r2p9IfB+N4AVNqoD8IBKXNSC6Tm6kVsLzoVX654Xp2y+1i/yEggJuHXemkKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eh9477ML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eh9477ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215711F000E9;
	Thu, 28 May 2026 20:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999023;
	bh=r0+KWc8y1R07xZDSZYC1qSY9H4qP+Y0eNi5X8WA3uVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh9477MLZFlRriPRIvh6g9abHVNMIrZWhjAgKXYVzy0uyf89Bpt8Li8cenH8UKLwm
	 ozz+7nCofefsbidW7vf3CjhQJ7THp4EJVrXlXMj1oAx571r9wn/puoQOHR0kGM9GvD
	 D4ocD7NVKloxPNGSUifLP6zoAyTkocMXPWzgkpt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 354/461] hwmon: (lm90) Add lock protection to lm90_alert
Date: Thu, 28 May 2026 21:48:03 +0200
Message-ID: <20260528194657.662999560@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 873e919e3101063a7a75989510ccfc125a4391cf ]

Sashiko reports:

lm90_alert() executes in the smbus alert context and calls
lm90_update_confreg() to disable the hardware alert line, without
acquiring hwmon_lock.

Concurrently, sysfs write operations (such as lm90_write_convrate) hold
the hwmon_lock, temporarily modify data->config, and then restore it.

If an alert interrupt occurs concurrently with a sysfs write, the sysfs
path will overwrite the alert handler's modifications to data->config
and the hardware register.

This unintentionally re-enables the hardware alert line while the alarm is
still active, causing an interrupt storm.

Add the missing lock to lm90_alert() to solve the problem.

Fixes: 7a1d220ccb0cc ("hwmon: (lm90) Introduce function to update configuration register")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index c4a9dafff81d6..1eeb608e59039 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -2946,6 +2946,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		 */
 		struct lm90_data *data = i2c_get_clientdata(client);
 
+		hwmon_lock(data->hwmon_dev);
 		if (!data->shutdown && (data->flags & LM90_HAVE_BROKEN_ALERT) &&
 		    (data->current_alarms & data->alert_alarms)) {
 			if (!(data->config & 0x80)) {
@@ -2955,6 +2956,7 @@ static void lm90_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 			schedule_delayed_work(&data->alert_work,
 				max_t(int, HZ, msecs_to_jiffies(data->update_interval)));
 		}
+		hwmon_unlock(data->hwmon_dev);
 	} else {
 		dev_dbg(&client->dev, "Everything OK\n");
 	}
-- 
2.53.0



