Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974BF27466A;
	Fri,  7 Aug 2026 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115907; cv=none; b=sTi5YpuS2RB+46USdxfQ/g8ulLyeESdGUFFRpHfKY1Q/9uH0RPI5xb0XmufS+ayuZ7uL3OGguHYcE48APQhkDEaCuFhqJzFrJMe1YOxDcgvz7zyOl54u9TyihLLtaFZt4LSMhYjeSZRdg7B3vLdh2pf4J8YTrSGQovPTUyB4joI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115907; c=relaxed/simple;
	bh=A8NhID1wZT/2WNnky7qKH6lf+So6x+kPtx4WcmZnqsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFgDW52G6UHnL53TxSajXMCZDio1hQWLUPM+4mWN2OFz5ISgJM2+Jbr/WY5WE4Rk9lOPMiulXgN1SUtMUVS3j1t50MBjX3EkTsf5N6NkkHt1ZJ3182BhXVm4Qwu4TLI0cQCMC2iRWFhLN8X88MLcPnzOgf8gFgEjrvkilrdP6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HhgbQ/v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HhgbQ/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF9F1F000E9;
	Fri,  7 Aug 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115906;
	bh=gZGZTvBCBG6luj4TdKbuiP6ivRqpsE541wWQFPI2250=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HhgbQ/vbHQ+KpsmtWzARBdJ6RwwV1h29LQD3WymqCh42k15tcX0yfij9hsBLYMuV
	 haEHOHjRH5U9S1aHDiseKJjleXNy2BFSCWJ3HcHFeeKd33lbu8JU6OKoRfXzTTpg3a
	 25zuvSoDE0hYpLkXpA2TazNCDGb/kcEC8kMAQaSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/261] hwmon: (lm90) Only report alarms if driver is ready
Date: Fri,  7 Aug 2026 16:36:41 +0200
Message-ID: <20260807143416.335694442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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
index e0d7454a301cf..7be9874b3dfb1 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1149,7 +1149,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		check_enable = (client->irq || !(data->config_orig & 0x80)) &&
 			(data->config & 0x80);
 
-		if (force || check_enable)
+		if (data->hwmon_dev && (force || check_enable))
 			schedule_work(&data->report_work);
 
 		/*
@@ -1157,7 +1157,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
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



