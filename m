Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710234E19B;
	Mon, 18 Aug 2025 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525814; cv=none; b=W8U02GrDvuryPMFaVD3LVLEZjTx6KJ1CPL4rubr/XvORhl+SVLksO9RhPzllhoAk2WfuaDWDSIiHDfmJP3fXbpYI8WPlehSEIqEIxlpdAUMRSyJB3G4RJwXX2n0n3/DTUM0FK16D/IZVPfLuKLQ0dqXQTpgU6BLcVgo4z0MrWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525814; c=relaxed/simple;
	bh=9sueY2WCDO9s/Dhxlc2w5TiR8RXGEApG9irsF+al83Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsNvW52zaMj5j8eHOs0v5kdKBXEpaT5XCFC3kfnUx3n9zKjvwAX7TRby/V0vgl/qiHAfRflapuEwDsJp1F6dgn9R16gVW7mhaPJvp1uUpUjDBqGG1B66r9WTN+RyUKhj/HaSHPiPnTSxwpvPOlcU4AAVSEssLG8fVPevCOrdUow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJdh32QK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJdh32QK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE34C4CEEB;
	Mon, 18 Aug 2025 14:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525814;
	bh=9sueY2WCDO9s/Dhxlc2w5TiR8RXGEApG9irsF+al83Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJdh32QKNjLng7DQeZZ6YFfie28CmCevcfJw+Jo/t22tGTwrVW8vSoEL9CJOo1Hot
	 LO/YG1gtJW3kM2TfBu/brnxh3+np52tx7yc2WxGzUTmqXd9qVa53KtjSUJiQfUX4QV
	 B9fdcGue4Zqll5/ZZe/IymLlEb+NOB66ZSshcBA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florin Leotescu <florin.leotescu@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 373/570] hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state
Date: Mon, 18 Aug 2025 14:46:00 +0200
Message-ID: <20250818124520.219702972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 234c54956a4b..1dbe3f26467d 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -299,6 +299,12 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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
@@ -312,10 +318,10 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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



