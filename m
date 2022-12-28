Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE39B1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B22BC433EF;
	Wed, 28 Dec 2022 16:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243453;
	bh=GtGUespz73Msntrkr/dZFTKE3v0k/IKlkzEYMTCrpdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l2HF/yJdZ4ot1BcAM5AneL5B+8UNZIo6MDZJ6g7npQNW5aCMGxDaH1wsI7Li2+ZiJ
	 Mp5oQgEy9fyGeaiN4T6PWTsmT5iuaAtwLGs+pEgQUZOezKFS5x0dCBaMJLG/mllIX3
	 OJyukUjNtfdCL8dOvlclFVfL+F4WHUswcw4q+6zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjiang Qiao <nanpuyue@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0494/1146] hwmon: (emc2305) fix pwm never being able to set lower
Date: Wed, 28 Dec 2022 15:33:53 +0100
Message-Id: <20221228144343.601473483@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xingjiang Qiao <nanpuyue@gmail.com>

[ Upstream commit 364ffd2537c44cb6914ff5669153f4a86fffad29 ]

There are fields 'last_hwmon_state' and 'last_thermal_state' in the
structure 'emc2305_cdev_data', which respectively store the cooling state
set by the 'hwmon' and 'thermal' subsystem, and the driver author hopes
that if the state set by 'hwmon' is lower than the value set by 'thermal',
the driver will just save it without actually setting the pwm. Currently,
the 'last_thermal_state' also be updated by 'hwmon', which will cause the
cooling state to never be set to a lower value. This patch fixes that.

Signed-off-by: Xingjiang Qiao <nanpuyue@gmail.com>
Link: https://lore.kernel.org/r/20221206055331.170459-2-nanpuyue@gmail.com
Fixes: 0d8400c5a2ce1 ("hwmon: (emc2305) add support for EMC2301/2/3/5 RPM-based PWM Fan Speed Controller.")
[groeck: renamed emc2305_set_cur_state_shim -> __emc2305_set_cur_state]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index 9a78ca22541e..e42ae43f3de4 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -171,22 +171,12 @@ static int emc2305_get_max_state(struct thermal_cooling_device *cdev, unsigned l
 	return 0;
 }
 
-static int emc2305_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
+static int __emc2305_set_cur_state(struct emc2305_data *data, int cdev_idx, unsigned long state)
 {
-	int cdev_idx, ret;
-	struct emc2305_data *data = cdev->devdata;
+	int ret;
 	struct i2c_client *client = data->client;
 	u8 val, i;
 
-	if (state > data->max_state)
-		return -EINVAL;
-
-	cdev_idx =  emc2305_get_cdev_idx(cdev);
-	if (cdev_idx < 0)
-		return cdev_idx;
-
-	/* Save thermal state. */
-	data->cdev_data[cdev_idx].last_thermal_state = state;
 	state = max_t(unsigned long, state, data->cdev_data[cdev_idx].last_hwmon_state);
 
 	val = EMC2305_PWM_STATE2DUTY(state, data->max_state, EMC2305_FAN_MAX);
@@ -211,6 +201,27 @@ static int emc2305_set_cur_state(struct thermal_cooling_device *cdev, unsigned l
 	return 0;
 }
 
+static int emc2305_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
+{
+	int cdev_idx, ret;
+	struct emc2305_data *data = cdev->devdata;
+
+	if (state > data->max_state)
+		return -EINVAL;
+
+	cdev_idx =  emc2305_get_cdev_idx(cdev);
+	if (cdev_idx < 0)
+		return cdev_idx;
+
+	/* Save thermal state. */
+	data->cdev_data[cdev_idx].last_thermal_state = state;
+	ret = __emc2305_set_cur_state(data, cdev_idx, state);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static const struct thermal_cooling_device_ops emc2305_cooling_ops = {
 	.get_max_state = emc2305_get_max_state,
 	.get_cur_state = emc2305_get_cur_state,
@@ -401,7 +412,7 @@ emc2305_write(struct device *dev, enum hwmon_sensor_types type, u32 attr, int ch
 				 */
 				if (data->cdev_data[cdev_idx].last_hwmon_state >=
 				    data->cdev_data[cdev_idx].last_thermal_state)
-					return emc2305_set_cur_state(data->cdev_data[cdev_idx].cdev,
+					return __emc2305_set_cur_state(data, cdev_idx,
 							data->cdev_data[cdev_idx].last_hwmon_state);
 				return 0;
 			}
-- 
2.35.1



