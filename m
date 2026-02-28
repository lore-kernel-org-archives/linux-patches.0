Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAB7383C66
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302111; cv=none; b=Yv83hG3HQTVpkSFo+pKciDe6DKo9FvW/HEa91+hRWG+kQR0EjfM6ansuE9Uy2A3Pusd7FxCrrz5zhQqrSO4PHrRNiiQ41JVSwS/GCJQxOrYp+N7TccR/cG4iNB0zxyYn40zej0biGk5/fzVGs/7pGFcMn57RIr7d2lrGLbBqGpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302111; c=relaxed/simple;
	bh=5s0v9TgRKN3OUY+s/+/NIvaREAjrmowNgeaj65dVPEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8nc85wi9wj/vDGGl87v/kFpn2LFeaHfkOok36DqhE+lvE0eBC34hIgfZ/ONB6J28kD0XwSfbIoDv73H0udVkxox5fKv8Pj4Oc1ED+1AQ+Pxyh+rB0Qs7dRs6SRuQmGm2sBjjF4OlYuEK++Zc0cVL0gWwq1oKGlXJj/qMLdoZ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqRXUw50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqRXUw50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25533C116D0;
	Sat, 28 Feb 2026 18:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302111;
	bh=5s0v9TgRKN3OUY+s/+/NIvaREAjrmowNgeaj65dVPEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqRXUw50x5MzsebHE4YJcDrD7GX5ke2ZagW20TlaUEimsGsItufqvC6Rfis8IIoBr
	 xaaHuAF5OLCRK88/ljjp5xtwQ3T0SNt0ZeeqKRl4V1BsBwlFQQCYyiHPMhmbm7gjcU
	 KZOm2LqKmEOC6ccMmbezJb4j0sKrREUhSPijPENfMm6FZ0YBEhOVP/AN8xog6m08aK
	 j37pqkmWb3NQ8yFhAimYZsklU88OoX/diAnA791XxJGbLjIcQEUa4s59eJc3dPadrI
	 i4l2JyeC7obtx+QSXrYUW3Pj3Hz8/oNgpONMnV7sdJpaTyky834Wmgha/1RJGrPRzZ
	 y13ViNw/zBCOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Guenter Roeck <linux@roeck-us.net>,
	Jean Delvare <jdelvare@suse.de>,
	Junrui Luo <moonafterrain@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/283] Revert "hwmon: (ibmpex) fix use-after-free in high/low store"
Date: Sat, 28 Feb 2026 13:04:02 -0500
Message-ID: <20260228180709.1583486-100-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 40fff7e95ea1c..db066b3689187 100644
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

