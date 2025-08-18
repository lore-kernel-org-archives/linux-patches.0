Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2421507C;
	Mon, 18 Aug 2025 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523416; cv=none; b=TxQ8QGhnl4H1TM6RWvQc6ipJa43RAbJ+BhwfjiiWoaa4BVDUQykexDUCia1fkPWRdJLDpy55CHehw8/Aws0PzIOGvp9mXaqtnTAHmiN4xgXlznTMF8lTt1IZvZux6ApWEzFNk51IWGGcHoTwDhCPu0cnlFnr4mvjHdkR1/7U3K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523416; c=relaxed/simple;
	bh=5jdk43B6gUBCSUKMZxLMFDxPN8sw/+DKM8cIhxCPG/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bpj5zMqCUx4G6MjCJDvmA1LW7+1FkvMLbmEHhG8QFNV13FAEdy2QfBQmgqY0D1WpVrKHy3yqLqBWZu7hpv5b91qv19wAHTyT8VnX026u18G1sKPyQjr+JkuPvkA70bQNR/Csg3M4nXjDseZMUCcROK6mx4RFyrLIlZR3hdnkEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/wQnlg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/wQnlg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87876C4CEEB;
	Mon, 18 Aug 2025 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523416;
	bh=5jdk43B6gUBCSUKMZxLMFDxPN8sw/+DKM8cIhxCPG/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z/wQnlg97yIPrLbMKVongpt1eaQQJAupRkSBFREYZVD9JidUgcCr32W48/Kg6GWqj
	 mgFSpR0rjZa1FVGn7JVXq+dEwdt37WcoedIxKKeGyCuhdFt/2V2Tj1kJq2wkJjj+Sn
	 7u/PqjlzDLIVso4got5DhSFADM2jFMSrDhjQ8B0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/515] platform/chrome: cros_ec_sensorhub: Retries when a sensor is not ready
Date: Mon, 18 Aug 2025 14:42:31 +0200
Message-ID: <20250818124504.729679009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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



