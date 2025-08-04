Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B438E1C84B8;
	Mon,  4 Aug 2025 00:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267592; cv=none; b=geNgox4TJlXAh8kNMkfBwGiWLdFOQwoM+wQwWBvIQrE470jygnk8ar1Hz5W9+WGhRIE+UOlEsbYILKTBbD/ZFn2z/yJP+jw3nsBg7cA+iE6prAIUNsue79Q+jyzJqfP3HG2j4vwS/BizX9zpVTStaJ7ExUIK89vkd/URUMLwDBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267592; c=relaxed/simple;
	bh=zcedYNa5zL016K3XMpbB9rAfhfDmoOYDSvzyv/PdQYU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=enEDl92XSVP46aub5t1W6duCNalgKnotZoSTXsI921p6J4iw4vaO0G1g63t7AQx+moRXIlqmrseRk5/as+fjRJHmNtidd04DJAHNXv44tHFQbALOnfyZO5DBoYE3PCtpuQDg3+BA27Bw0DeTshlwaOjA3CueNMnbphOIbLTatAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uc4rfgh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uc4rfgh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38424C4CEEB;
	Mon,  4 Aug 2025 00:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267592;
	bh=zcedYNa5zL016K3XMpbB9rAfhfDmoOYDSvzyv/PdQYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uc4rfgh2Ukbt5AfQRPlp25ptXrzCb0hRumzliUsnvWEA3nnxgOwF3gMBBTBj/6qLh
	 s30Hs//iJ6H+EsxMnqxJDLjJfSEdGmsagjeF27rmhGsxxA0pLIdJFHet4pjN5AQ7Gc
	 jiFj4mrkCwRnluN63vokEHdwdXTu+MAH0lGP8TuZ0cGa8rinSjVtiYI/3pCk2sjefr
	 joC99ktmuu3hEcyRDV0hGlegReYmYeXx3QJh1xdWHkY+Lq/uVE8IvAxQjxC9tY5Xq7
	 413VtIUp4VyYlEMjnotXANXF7lunMcbbAOdAPya3N1tYZircr+wi3HpnjVDvsVRzuX
	 TRxORB0fz/8qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>,
	Gwendal Grignou <gwendal@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bleung@chromium.org,
	chrome-platform@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 47/69] platform/chrome: cros_ec_sensorhub: Retries when a sensor is not ready
Date: Sun,  3 Aug 2025 20:30:57 -0400
Message-Id: <20250804003119.3620476-47-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003119.3620476-1-sashal@kernel.org>
References: <20250804003119.3620476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 981d7f91aeda17424b29f033249f4fa7cd2a7556 ]

When the EC/ISH starts, it can take a while for all the sensors to be up
and running or declared broken.

If the sensor stack return -EBUSY when checking for sensor information,
retry up to 50 times.
It has been observed 100ms wait time is enough to have valid sensors
ready. It can take more time in case a sensor is really broken and is
not coming up.

Signed-off-by: Gwendal Grignou <gwendal@google.com>
Link: https://lore.kernel.org/r/20250623210518.306740-1-gwendal@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real user-impacting bug**: The commit addresses a race
   condition where the ChromeOS EC sensor hub fails to initialize
   sensors properly during EC/ISH startup. Without this fix, sensors may
   appear as broken or unavailable to userspace when they are actually
   just slow to initialize.

2. **Small and contained fix**: The change is minimal - it only adds:
   - A retry loop around `cros_ec_cmd_xfer_status()` for -EBUSY errors
   - A 5-6ms delay between retries
   - A maximum of 50 retries (approximately 250-300ms total timeout)
   - A warning message when retries were needed

3. **Clear bug fix pattern**: The EC returning -EBUSY (EC_RES_BUSY) is
   documented behavior indicating "Up but too busy. Should retry". The
   original code didn't handle this case, leading to sensors being
   skipped during initialization.

4. **Low regression risk**:
   - The retry logic only triggers on -EBUSY errors, not affecting the
     normal path
   - The change is isolated to sensor initialization during probe
   - Similar retry patterns exist in other parts of the cros_ec
     subsystem (e.g., commit 11799564fc7e)
   - The dev_warn to dev_err change is appropriate as sensor
     initialization failure is an error condition

5. **Hardware-specific timing issue**: This fixes a timing-dependent
   hardware initialization issue that can manifest differently across
   different EC/ISH firmware versions and boot conditions, making it
   important for stable operation across various Chromebook models.

6. **No architectural changes**: The commit doesn't introduce new
   features or change any interfaces - it simply makes the existing
   sensor initialization more robust by handling a known EC busy state.

The commit follows established patterns in the cros_ec subsystem for
handling EC_RES_BUSY responses and is a straightforward reliability
improvement that should be included in stable kernels to ensure
consistent sensor availability on ChromeOS devices.

 drivers/platform/chrome/cros_ec_sensorhub.c | 23 +++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_sensorhub.c b/drivers/platform/chrome/cros_ec_sensorhub.c
index 50cdae67fa32..9bad8f72680e 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub.c
@@ -8,6 +8,7 @@
 
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/delay.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/platform_data/cros_ec_commands.h>
@@ -18,6 +19,7 @@
 #include <linux/types.h>
 
 #define DRV_NAME		"cros-ec-sensorhub"
+#define CROS_EC_CMD_INFO_RETRIES 50
 
 static void cros_ec_sensorhub_free_sensor(void *arg)
 {
@@ -53,7 +55,7 @@ static int cros_ec_sensorhub_register(struct device *dev,
 	int sensor_type[MOTIONSENSE_TYPE_MAX] = { 0 };
 	struct cros_ec_command *msg = sensorhub->msg;
 	struct cros_ec_dev *ec = sensorhub->ec;
-	int ret, i;
+	int ret, i, retries;
 	char *name;
 
 
@@ -65,12 +67,25 @@ static int cros_ec_sensorhub_register(struct device *dev,
 		sensorhub->params->cmd = MOTIONSENSE_CMD_INFO;
 		sensorhub->params->info.sensor_num = i;
 
-		ret = cros_ec_cmd_xfer_status(ec->ec_dev, msg);
+		retries = CROS_EC_CMD_INFO_RETRIES;
+		do {
+			ret = cros_ec_cmd_xfer_status(ec->ec_dev, msg);
+			if (ret == -EBUSY) {
+				/* The EC is still busy initializing sensors. */
+				usleep_range(5000, 6000);
+				retries--;
+			}
+		} while (ret == -EBUSY && retries);
+
 		if (ret < 0) {
-			dev_warn(dev, "no info for EC sensor %d : %d/%d\n",
-				 i, ret, msg->result);
+			dev_err(dev, "no info for EC sensor %d : %d/%d\n",
+				i, ret, msg->result);
 			continue;
 		}
+		if (retries < CROS_EC_CMD_INFO_RETRIES) {
+			dev_warn(dev, "%d retries needed to bring up sensor %d\n",
+				 CROS_EC_CMD_INFO_RETRIES - retries, i);
+		}
 
 		switch (sensorhub->resp->info.type) {
 		case MOTIONSENSE_TYPE_ACCEL:
-- 
2.39.5

