Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE44442391;
	Mon, 17 Aug 2026 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979796; cv=none; b=XKJMXwmAiynhiksgrx6Ko6XSimj09OVx1MfbgXPDHN2+g2EmViiS2Y8EdeCz8zJ7hRnEikPfgAJl+lZuYw1bDPXyJSiSv08cNAyMvonX4RMvUtXqteyChd3T+O99bWCQmkvLLlOSjfhAA71kCW4IEYSXy4N20SYNbUb1T83fL1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979796; c=relaxed/simple;
	bh=Al1EuNIkc7l9WdmLYH1ICH6nh5IiKPm4aIt12kUd4es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+tXzUDqMFb6WpQ1xpRDwHVsi9aQJZEOyqp7MLZ9eRW6QmXa56+IB/xWq71BDVq84UG+iTZr4Y0y4y3P0Mad7aZSQtBm3+j2lUsq5P+3Uoi3TKXQREd7y7ofo/Pka9OZ5zPZ3VI+nG04FYGRmHjmk+y2JlqVz7tGecVJLpErn5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRj4mCIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRj4mCIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE591F000E9;
	Mon, 17 Aug 2026 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979791;
	bh=SqzBwNQJnZKOfKaZ/e557zxFrIy9hzu/QdiQ5N6nkck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRj4mCILiXyKfsXYsTXBXEnvk8XH5+UYdBZPebbm8ujGvOs8Qy9gCWlr9R899VIjM
	 SiD+8xS0ECGTXALPPwgsCT6cre7VGTk/omD9K2F4Nx57xPnvLNinaIaj5A0heFjmz0
	 Mzi2rDCD2bTUW3Z7uRqgkj66qFlVIelZBc6IK6AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 348/609] hwmon: (lm90) Only report alarms if driver is ready
Date: Mon, 17 Aug 2026 15:30:44 +0200
Message-ID: <20260817132555.916501984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index db595f7d01f8a..7ce75e64cc3ca 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1148,7 +1148,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		check_enable = (client->irq || !(data->config_orig & 0x80)) &&
 			(data->config & 0x80);
 
-		if (force || check_enable)
+		if (data->hwmon_dev && (force || check_enable))
 			schedule_work(&data->report_work);
 
 		/*
@@ -1156,7 +1156,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
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



