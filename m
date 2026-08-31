Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC4146D0AB;
	Mon, 31 Aug 2026 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183299; cv=none; b=Q3+nqE9q5uJoTkCvf8L83Rbo6HeSFSIJVDZIH8C5y+CWR75QYitRyToxp8iUKW2mJ2whL93Peb9bk8Vlo8FKwlTJh45WjxvQMgMQX9/rLMXZYwrY5FtbDQ7WgBixei4trtIbxPe7LK2iJSZTsOjKXPNnXRtHabR2PW1zXPFuYQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183299; c=relaxed/simple;
	bh=bymwIIFAHeg+65d0SVA/VsKjQHqn5xRbo4MPgwAkBkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AAdZj2//sA0pO7pIkLg+BLhuCS806yHVxW8qvFJzwoNSr6L7i5uAEpCHUrcQJb/53rv8XWEciBcPshOKfQ/yoN39r1gNcLYan24Bz7Y1C0vCI8q9IMSP0f91Pz7f97c9wHnE0sg0M+HvjCp8uQCkSpymm7+bRlJOxtZMqNpzMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0FtzWbc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0FtzWbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EAF1F000E9;
	Mon, 31 Aug 2026 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183298;
	bh=GSoH0uowbh2rhbgIfmVYDmAuDzNohrLyvgtanOutFl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0FtzWbcV77MlcspZC5c1FkpSiPUeqsZ8YyKqjK4WppAwItwC25R8/TyXMu2trloX
	 UY3pcZp5L673Ly95s1wsxqMc+fqWDWSVCCDzwF5muFI1gZ/NriYmjbKTHlGIGiY7t0
	 JxegY2QEBtdF5bKpIy8l3adUaQ03LlPz8RoQZLxi4uRwWm0o3qyzs+ifWmppzIjcqk
	 cQBjHVipNbk92kvQFHS2IagygDEXmCvtDnLEuVGEpV6X64ke2wqrfrdSq0lMCD9GnJ
	 pQIxkeMbErWP/Y9/9v/g2cdYhuZC8CI4z5jeDTSPYJ+wYADURwng04oLk5gWMks5rS
	 M2GcQZhcbYS/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shubham Chakraborty <chakrabortyshubham66@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	florian.fainelli@broadcom.com,
	linux-hwmon@vger.kernel.org,
	linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] hwmon: (raspberrypi) Fix delayed-work teardown race
Date: Mon, 31 Aug 2026 09:21:33 -0400
Message-ID: <20260831133314.4125787-65-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shubham Chakraborty <chakrabortyshubham66@gmail.com>

[ Upstream commit eb0d491e2787aa359f0d930151ff6e5e5df70fb9 ]

The delayed polling work rearms itself from the work function, so use
explicit delayed-work setup and cleanup instead of
devm_delayed_work_autocancel().

Initialize the delayed work with INIT_DELAYED_WORK() and register a
devres cleanup action that calls disable_delayed_work_sync() during
teardown.

This addresses the concern raised during review about the polling work
being able to requeue itself while the driver is being removed.

Signed-off-by: Shubham Chakraborty <chakrabortyshubham66@gmail.com>
Link: https://lore.kernel.org/r/20260517080445.103962-4-chakrabortyshubham66@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Those background searches finished and match the earlier analysis:

- On **6.18.44 (HEAD)**, `git log --grep` does not find this fix — only
  unrelated teardown commits show up.
- On **master**, the fix is **`eb0d491e2787a`** (`hwmon: (raspberrypi)
  Fix delayed-work teardown race`), merged via the `hwmon-for-v7.2` tag.
- It is present on **next** branches (`all-next`, `arch-next`, etc.) but
  **not** on the checked-out **6.18.y** stable tree.

That confirms the patch still needs to be backported to 6.18.44, and the
**YES** recommendation stands.

 drivers/hwmon/raspberrypi-hwmon.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/raspberrypi-hwmon.c b/drivers/hwmon/raspberrypi-hwmon.c
index a2938881ccd2f..b0f0f50986b9a 100644
--- a/drivers/hwmon/raspberrypi-hwmon.c
+++ b/drivers/hwmon/raspberrypi-hwmon.c
@@ -7,7 +7,6 @@
  * Copyright (C) 2018 Stefan Wahren <stefan.wahren@i2se.com>
  */
 #include <linux/device.h>
-#include <linux/devm-helpers.h>
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/module.h>
@@ -72,6 +71,13 @@ static void get_values_poll(struct work_struct *work)
 	schedule_delayed_work(&data->get_values_poll_work, 2 * HZ);
 }
 
+static void rpi_hwmon_cancel_poll_work(void *res)
+{
+	struct rpi_hwmon_data *data = res;
+
+	disable_delayed_work_sync(&data->get_values_poll_work);
+}
+
 static int rpi_read(struct device *dev, enum hwmon_sensor_types type,
 		    u32 attr, int channel, long *val)
 {
@@ -117,8 +123,8 @@ static int rpi_hwmon_probe(struct platform_device *pdev)
 	if (IS_ERR(data->hwmon_dev))
 		return PTR_ERR(data->hwmon_dev);
 
-	ret = devm_delayed_work_autocancel(dev, &data->get_values_poll_work,
-					   get_values_poll);
+	INIT_DELAYED_WORK(&data->get_values_poll_work, get_values_poll);
+	ret = devm_add_action_or_reset(dev, rpi_hwmon_cancel_poll_work, data);
 	if (ret)
 		return ret;
 	platform_set_drvdata(pdev, data);
-- 
2.53.0

