Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1AB46A5FB;
	Tue, 21 Jul 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649737; cv=none; b=s7ofzp7TdXPdso6MW7SnBdWADjuB+IHydMeC7FjC9FacH9FAH/y/EqdrNorxOBp9Wa64Ec/WZh8QVK/xIZ2KZixXnD/9GsvSzh6bFwF/KQGt+4jpq1IW5z34m0nN1DBdqccohk8SE5RZDzYuSghz64bDpZlnYCDeFLwvhmYk4+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649737; c=relaxed/simple;
	bh=b8wFQoHydavPw9bmeYlTz7q+m9QhI55ttXAuiwdCWUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2kknYSbchun9qlSXOQr4TElihHwP2vLOb28KCtLCVXLWHZYpRXaaRzSP57Bc/GNcwKE1TxU2pXSpd6BLiyizIwYGlzSiM2/zilFe6RRA9LagI4SfKkILgxvWYIJno/zb7W9QrL9yvGfjZQFuZZms8XOyuYTJJwlm5BffI2X/c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IooAxvAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IooAxvAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E961F000E9;
	Tue, 21 Jul 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649736;
	bh=76RsKCBLzWRuUZ2vo3hEqYivnhWxNmzfeVPGQNzggF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IooAxvApXcIQ2QV82KzTollrswP6UWl9lk/2NqPaUxfz2iyRCH4gTZ2fdMNQau0yg
	 QLqaTzt7LcwIMC9FNORjtxyOjcqy4BJ1iu/dMxhybLoSVfLEzeFn4gXtU++kYTwhgD
	 cN+s2ZcsKqlsR6LlD+p+r06XA24ETaGcQ7HKv9G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0645/2077] hwmon: (gpd-fan): fix race condition between device removal and sysfs access
Date: Tue, 21 Jul 2026 17:05:18 +0200
Message-ID: <20260721152608.019071671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 1fb4397509bd8701d323e81ac9a97c2e24ed49eb ]

Replace the manual gpd_fan_remove() callback with a devres-managed
action using devm_add_action_or_reset(). The original remove hook
resets the fan to AUTOMATIC mode, but the hwmon sysfs interface
(registered with devm_hwmon_device_register_with_info()) remains
active until after the remove callback completes. This creates a
race window where a concurrent userspace sysfs access can interleave
with the EC I/O sequence, potentially corrupting EC registers.

Using devm_add_action_or_reset() registers the reset function as a
devres action. Due to the LIFO release order of devres, the hwmon
device is unregistered (sysfs removed) before the reset action
executes, eliminating the race condition.

Fixes: 0ab88e239439 ("hwmon: add GPD devices sensor driver")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/4400828422cf3a88adad4db224d9efccdb1049d2.1781055639.git.xiaopei01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpd-fan.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/gpd-fan.c b/drivers/hwmon/gpd-fan.c
index 745b3fb9e3a49d..4615f98771ddf9 100644
--- a/drivers/hwmon/gpd-fan.c
+++ b/drivers/hwmon/gpd-fan.c
@@ -609,6 +609,16 @@ static void gpd_init_ec(struct gpd_fan_data *data)
 		gpd_win4_init_ec(data);
 }
 
+static void gpd_fan_reset_hardware(void *pdata)
+{
+	struct gpd_fan_data *data = pdata;
+
+	if (data) {
+		data->pwm_enable = AUTOMATIC;
+		gpd_set_pwm_enable(data, AUTOMATIC);
+	}
+}
+
 static int gpd_fan_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -617,6 +627,7 @@ static int gpd_fan_probe(struct platform_device *pdev)
 	struct device *hwdev;
 	struct gpd_fan_data *data;
 	const struct gpd_fan_drvdata *match;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
 	if (!res)
@@ -644,6 +655,11 @@ static int gpd_fan_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, data);
 
 	gpd_init_ec(data);
+
+	ret = devm_add_action_or_reset(dev, gpd_fan_reset_hardware, data);
+	if (ret)
+		return ret;
+
 	hwdev = devm_hwmon_device_register_with_info(dev,
 						     DRIVER_NAME,
 						     data,
@@ -655,19 +671,8 @@ static int gpd_fan_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void gpd_fan_remove(struct platform_device *pdev)
-{
-	struct gpd_fan_data *data = dev_get_drvdata(&pdev->dev);
-
-	if (data) {
-		data->pwm_enable = AUTOMATIC;
-		gpd_set_pwm_enable(data, AUTOMATIC);
-	}
-}
-
 static struct platform_driver gpd_fan_driver = {
 	.probe = gpd_fan_probe,
-	.remove = gpd_fan_remove,
 	.driver = {
 		.name = KBUILD_MODNAME,
 	},
-- 
2.53.0



