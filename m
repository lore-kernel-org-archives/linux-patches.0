Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE6625F988;
	Fri,  7 Aug 2026 15:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116801; cv=none; b=P+8Vlv4SYoJYIAi1SoOlfAQPtgYSY/9sWbrHxx71ShdfCJtgykHrpSAlHyEyD73HKCF0Tfeu0EWHQ4Yi/hD+sqYpm5mT/WuW8cgdwNpZDS092YJWVQ3CY8DqY7zmkOu4cb8YlQAShJ+pXL/3lpdGDkXlU0+0V3vSUrUMBAv7tA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116801; c=relaxed/simple;
	bh=gqc1HzWPf/sI38GmiITU7FXo9HKjqvkRS7hshaqL+Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knO6X1HsHpuoEYJlgI9v+YGrg73SXGq70lS1h9n/dwlPAZmeNxhZIEVeMbRa8IxoRvrWOHV82jDdnzj8sXfcc46euq1isrSPTEkcTAxaU/UBQL85Ob/75+QygCMVhvcEba+3X2vR+sUkDiJfMtmKFCbzUY+F+xJ9rxy2hGFDif8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvABflTb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvABflTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F961F000E9;
	Fri,  7 Aug 2026 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116800;
	bh=yXYZ7ZD9rJ3RpmHZT/5bYicFG4U7jxqytdAoOXg2FKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvABflTbLx6SywsFthBYf/C5M5/hL/vcSri3z1Kf4/NbjefuCgpD1avirW1y+k/C7
	 Q+mlFATwG2BS0BTl7qzdvn/Geu1WYWr4eQGNuzDl9E7NBceNboKUHW0KmfhRYU/6f5
	 oGtqI+D1lz12Zw2MVseA1DdCKPi+mfSUQwc5ugd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 095/438] hwmon: (lm90) Only report alarms if driver is ready
Date: Fri,  7 Aug 2026 16:34:51 +0200
Message-ID: <20260807143430.015599010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c78c96e1bd83f..c56dd958429be 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1194,7 +1194,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		check_enable = (client->irq || !(data->config_orig & 0x80)) &&
 			(data->config & 0x80);
 
-		if (force || check_enable)
+		if (data->hwmon_dev && (force || check_enable))
 			schedule_work(&data->report_work);
 
 		/*
@@ -1202,7 +1202,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
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



