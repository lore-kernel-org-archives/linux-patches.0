Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412B9227E82;
	Tue, 26 Aug 2025 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213209; cv=none; b=cT82FF/M/vYBVZgQ9qConZczG7JoCZtRx3Q9jYRvKVqZckvo8GroF/pgkavcH+gVK4Gokh6Hwv/KswXyeHWsAyGz9vMs51m4T0n+1/WmESmj77S8kxOMCzopbi7H5BjuoE+hp+Xw2HarucZmJkaEDtVOjAmezLaGNmbIAHR3JP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213209; c=relaxed/simple;
	bh=AcKnGCdWoiFqOV/A3pQ9vIds7glWlEVFlJVq6uk7ZUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP5yf1RTJRfovHf2WXL765dbi8WJaV66EyVJrhrUcCLhkhLKCRuWO3fdp7msFP0mezyZEpxSKr99fSupRuuM02A4I0KRHVqrbfTWWbP/xIplY+L7PWhNr3huD/6WBPcvPIwXPtUg+vVzbeNXZ6OPtTZqf3asyiyXJ0qbY1i+mnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtUKXAeF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtUKXAeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40FAC4CEF1;
	Tue, 26 Aug 2025 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213209;
	bh=AcKnGCdWoiFqOV/A3pQ9vIds7glWlEVFlJVq6uk7ZUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtUKXAeFtMItbeMJ5htgARxL4eNwWayLv91WTn97KwxWainSiUWDD1I+ISh+DMb5L
	 DgqAjBUaHkXQzh6xjoN6tAb21z2RzLErLHaOeJyQ9++OeSe/oU6yWI9v0XfTMnQPU6
	 ZmHz7ALbiIBHVrZtREV9Qy7YZpStiOzEmALSZrD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florin Leotescu <florin.leotescu@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/587] hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state
Date: Tue, 26 Aug 2025 13:06:19 +0200
Message-ID: <20250826110958.785465109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florin Leotescu <florin.leotescu@nxp.com>

[ Upstream commit 0429415a084a15466e87d504e8c2a502488184a5 ]

Prevent the PWM value from being set to minimum when thermal zone
temperature exceeds any trip point during driver probe. Otherwise, the
PWM fan speed will remains at minimum speed and not respond to
temperature changes.

Signed-off-by: Florin Leotescu <florin.leotescu@nxp.com>
Link: https://lore.kernel.org/r/20250603113125.3175103-5-florin.leotescu@oss.nxp.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index 29f0e4945f19..840acd5260f4 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -303,6 +303,12 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
 		dev_err(dev, "Failed to register cooling device %s\n", emc2305_fan_name[idx]);
 		return PTR_ERR(data->cdev_data[cdev_idx].cdev);
 	}
+
+	if (data->cdev_data[cdev_idx].cur_state > 0)
+		/* Update pwm when temperature is above trips */
+		pwm = EMC2305_PWM_STATE2DUTY(data->cdev_data[cdev_idx].cur_state,
+					     data->max_state, EMC2305_FAN_MAX);
+
 	/* Set minimal PWM speed. */
 	if (data->pwm_separate) {
 		ret = emc2305_set_pwm(dev, pwm, cdev_idx);
@@ -316,10 +322,10 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
 		}
 	}
 	data->cdev_data[cdev_idx].cur_state =
-		EMC2305_PWM_DUTY2STATE(data->pwm_min[cdev_idx], data->max_state,
+		EMC2305_PWM_DUTY2STATE(pwm, data->max_state,
 				       EMC2305_FAN_MAX);
 	data->cdev_data[cdev_idx].last_hwmon_state =
-		EMC2305_PWM_DUTY2STATE(data->pwm_min[cdev_idx], data->max_state,
+		EMC2305_PWM_DUTY2STATE(pwm, data->max_state,
 				       EMC2305_FAN_MAX);
 	return 0;
 }
-- 
2.39.5



