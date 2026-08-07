Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2936A36E;
	Fri,  7 Aug 2026 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114878; cv=none; b=mLjJ4QcysW+Si52zfB5ZkdxyJp3mLOlc4OL7w5CCxONHS8JGxRaoDhQk3PEjCNhODO+7lCdknkq0xMPnTF9/QtDm5W2ZJDgE/HCZ9rjKuymkV/BTy5FuL2OkURqzY6du1qP8+3i4tus414c0Z7QB4ALzg3kkmMUclqcZD4XcCv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114878; c=relaxed/simple;
	bh=KeQVtmiXiklDUZZvrtEJT56HEAxqsiipXTlo4GjVKj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZV1VvRa/7V9Jrj7qptb43ghkIDNhMOrl8wqPERR+9VWNuIK7egJYij7NK97Z5QJMMesaNq45vnTL15Ww4l2hN3a4S0zTEayoyHQmOeIqnJKkz17Ms4OkU0I1O+6WTUWbs3FQupf8KUzA9atI0zcq/CUroU8qQLig9Db/4HtpN8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YVxPa8tu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YVxPa8tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0881F000E9;
	Fri,  7 Aug 2026 15:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114876;
	bh=q2zPtDdtNzYVxg9ms5uRljf/3Ycige2mv1YtVHU7qg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVxPa8tu+qmuR7yjeRG1gL27fwmlzdLFqnQ83Q5jnBm+3/si1elyLa4QF0VivHWFB
	 3Fbs1m34ECEvXBW1rMEbgzuwAVSPT+X5sKuvQ1GBPUDJmbfY9lXDEP6GejzjPcUigJ
	 PtfxbfyEOx5Rl/1rBvTeyJVvXx6idKiIIckQGYqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/396] hwmon: (lm90) Only report alarms if driver is ready
Date: Fri,  7 Aug 2026 16:33:58 +0200
Message-ID: <20260807143425.950620876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

[ Upstream commit aa9429edf9fc0e90d6f4da19ea4b5495a54ab117 ]

Userspace can read sysfs attributes before driver registration is complete,
immediately after devm_hwmon_device_register_with_info() has been called.
At that time, data->hwmon_dev is not yet initialized. This can trigger
a NULL pointer access since lm90_update_device() and with it
lm90_update_alarms_locked() will be called. This call schedules
report_work and lm90_report_alarms(), which passes the still-NULL
data->hwmon_dev to hwmon_notify_event() and triggers a NULL pointer
dereference.

Fix the problem by only scheduling the report and alert workers
data->hwmon_dev is set.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: f6d0775119fb9 ("hwmon: (lm90) Rework alarm/status handling")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index a465a8a7ef5af..e1795ccde876c 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1196,7 +1196,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		check_enable = (client->irq || !(data->config_orig & 0x80)) &&
 			(data->config & 0x80);
 
-		if (force || check_enable)
+		if (data->hwmon_dev && (force || check_enable))
 			schedule_work(&data->report_work);
 
 		/*
@@ -1204,7 +1204,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		 * alarms are all clear, and alerts are currently disabled.
 		 * Otherwise (re)schedule worker if needed.
 		 */
-		if (check_enable) {
+		if (check_enable && data->hwmon_dev) {
 			if (!(data->current_alarms & data->alert_alarms)) {
 				dev_dbg(&client->dev, "Re-enabling ALERT#\n");
 				lm90_update_confreg(data, data->config & ~0x80);
-- 
2.53.0



