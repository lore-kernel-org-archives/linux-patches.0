Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F5C35AC3C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302702; cv=none; b=SHLFllosFUxmZ25TnxIwWtvq2MTmGMUq1+OCDf6ibfS4RiK2YO8xH3ZzbQ2X8/ieY5FLSFQ8BqRWu8u/tM7PgVYuMQj2lhZKGmggQdc0IWNePm+5yzObfs6nGXv1gDdxYVfSe+FNZJBYyMBQzEZyzcAnDOcOXancVGCRe3lymWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302702; c=relaxed/simple;
	bh=TcJHA4PVCesQPozGcknQRrtYq5zW4Dg90tXplISYUGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kc6keNbNMVKLzG9AbaGwvE0FttcVekw2WJqF0iQF+yqctuNHSWmV24v4TZO16rGuYIORvj6IO3GV6WEORA9mYzgBKvRJmzkJDQJFMSB+1OD0tbI1tbGYDtxnBQhlmkZpb/QOWmrnKZQKHOIdJg9rrWoHhJgOgHBUJuQfQSekaeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNOVhHNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNOVhHNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10643C19423;
	Sat, 28 Feb 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302702;
	bh=TcJHA4PVCesQPozGcknQRrtYq5zW4Dg90tXplISYUGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNOVhHNw2sZVQRd0CvO1dE6+UxaPwWMaWQFSYJRp/8FG6niE5tCCH/7FAybU7+1Fx
	 cBWqT7aOY2VrzGAzeq9qIPYB+GRdmEDYW4SyknBMZZeqOsFPoWG9/WLNK9f9HikZWP
	 KVWa0krVql+zUF4uBKt6DNNvSVmYDjrwqy4UvFetu+3j5Kf5J7gpf9vduyRC4TWaDP
	 +jipsxTYdHssDGVvVcMgd82mPbmoGDaERD21JUF3N3MGfbvxix20CdwZtUg/BG0PJG
	 3L+ue+rOt3+T2kpJjag6I253Dj3TRnkPfIANgiYvYwJ2zSnqr7lan/HixqhFpr5Zaq
	 Yv3msP2dPrF6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guenter Roeck <linux@roeck-us.net>,
	Jean Delvare <jdelvare@suse.de>,
	Junrui Luo <moonafterrain@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/147] Revert "hwmon: (ibmpex) fix use-after-free in high/low store"
Date: Sat, 28 Feb 2026 13:16:07 -0500
Message-ID: <20260228181736.1605592-59-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8bde3e395a85017f12af2b0ba5c3684f5af9c006 ]

This reverts commit 6946c726c3f4c36f0f049e6f97e88c510b15f65d.

Jean Delvare points out that the patch does not completely
fix the reported problem, that it in fact introduces a
(new) race condition, and that it may actually not be needed in
the first place.

Various AI reviews agree. Specific and relevant AI feedback:

"
This reordering sets the driver data to NULL before removing the sensor
attributes in the loop below.

ibmpex_show_sensor() retrieves this driver data via dev_get_drvdata() but
does not check if it is NULL before dereferencing it to access
data->sensors[].

If a userspace process reads a sensor file (like temp1_input) while this
delete function is running, could it race with the dev_set_drvdata(...,
NULL) call here and crash in ibmpex_show_sensor()?

Would it be safer to keep the original order where device_remove_file() is
called before clearing the driver data? device_remove_file() should wait
for any active sysfs callbacks to complete, which might already prevent the
use-after-free this patch intends to fix.
"

Revert the offending patch. If it can be shown that the originally reported
alleged race condition does indeed exist, it can always be re-introduced
with a complete fix.

Reported-by: Jean Delvare <jdelvare@suse.de>
Closes: https://lore.kernel.org/linux-hwmon/20260121095342.73e723cb@endymion/
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Junrui Luo <moonafterrain@outlook.com>
Fixes: 6946c726c3f4 ("hwmon: (ibmpex) fix use-after-free in high/low store")
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ibmpex.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 235d56e96879c..fe90f0536d76c 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -282,9 +282,6 @@ static ssize_t ibmpex_high_low_store(struct device *dev,
 {
 	struct ibmpex_bmc_data *data = dev_get_drvdata(dev);
 
-	if (!data)
-		return -ENODEV;
-
 	ibmpex_reset_high_low_data(data);
 
 	return count;
@@ -517,9 +514,6 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 {
 	int i, j;
 
-	hwmon_device_unregister(data->hwmon_dev);
-	dev_set_drvdata(data->bmc_device, NULL);
-
 	device_remove_file(data->bmc_device,
 			   &sensor_dev_attr_reset_high_low.dev_attr);
 	device_remove_file(data->bmc_device, &sensor_dev_attr_name.dev_attr);
@@ -533,7 +527,8 @@ static void ibmpex_bmc_delete(struct ibmpex_bmc_data *data)
 		}
 
 	list_del(&data->list);
-
+	dev_set_drvdata(data->bmc_device, NULL);
+	hwmon_device_unregister(data->hwmon_dev);
 	ipmi_destroy_user(data->user);
 	kfree(data->sensors);
 	kfree(data);
-- 
2.51.0

