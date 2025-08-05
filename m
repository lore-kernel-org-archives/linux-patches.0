Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEC02727FA;
	Tue,  5 Aug 2025 13:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399423; cv=none; b=MB6B1Lk982BO+78XRBh5JnUHHst3Nf4mkBqh/KBmtR1NmoR64yz0cDYtrY1Dtr6tD/YKAB27LFR+DJ9aWy/8TTBRAaQ0UVtdsiQ9mewJ4xcJLBbNte9V+0QrQFl6zmjIia+5BH1EfVZ2ynAxCJ5OTsYNhvyXYw9CojHmgO/iWwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399423; c=relaxed/simple;
	bh=DfoGxw5F0Uv2GDbkZtLm+s9KbcmxB3RpYbvuHS8j8SQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F12cm76OrPTIeHaSgd0SFeWVD/sYdBCL4kHwc0PJOAQv4+J5gmCWPgDXV1itxsIHQU6+Shon7SqALCDWJAB/I9cTrn+tk+ySDDQt9bmCFSVwiiwmHXgo6/PJNM84SvTe+dOGUc+qM0iHgX16nF25RpVxGEsd2rsQgOxZ/OU5Ji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn6doGr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn6doGr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E45C4CEF4;
	Tue,  5 Aug 2025 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399423;
	bh=DfoGxw5F0Uv2GDbkZtLm+s9KbcmxB3RpYbvuHS8j8SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hn6doGr0kR+OOTLe4m+k4FOAfRVsMbtSXlvSaOPc2mr9X5BrH2Okf2dXWr/SmIN6H
	 sbQhqu/Y/ospbzAyIFKr5ZX1uWke0iR27MgBRosk9SaEwejgJuxlfsOtkiYW5PPa/l
	 LFvtxYB6zFemTy8dJnyxt9mom8xMWDgKTthSXGU5aylBFr7+A6St6o6Pi46EN4PtCa
	 2C/Vdu42+Emuna/nccALnrPd90yglVYDP9NE6DMj2G6Khel26kiKBhYv7hkjDJmq09
	 b5qSaHtj4JXeT8Dz93mG25iL4peOpTQ8G99A+qXKw5JChrxgZd3cE6YoGEXZ8YAUPX
	 LEsrFYGhlKkzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florin Leotescu <florin.leotescu@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	jdelvare@suse.com,
	linux-hwmon@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state
Date: Tue,  5 Aug 2025 09:08:52 -0400
Message-Id: <20250805130945.471732-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

This commit fixes a **critical functional bug** where fan speeds remain
stuck at minimum when the system temperature is already elevated during
driver probe. The specific issue addressed:

1. **User-Impacting Bug**: When the thermal zone temperature exceeds
   trip points during driver initialization, the PWM fan controller
   incorrectly sets fans to minimum speed and they become unresponsive
   to temperature changes. This can lead to:
   - System overheating
   - Hardware damage from inadequate cooling
   - Thermal throttling affecting performance
   - Potential system crashes or shutdowns

2. **Clear Root Cause**: The bug occurs because the driver
   unconditionally initializes PWM to `pwm_min` without checking the
   current thermal state (`cur_state`). The fix properly checks if
   `cur_state > 0` and calculates appropriate PWM duty cycle using
   `EMC2305_PWM_STATE2DUTY()`.

3. **Small and Contained Fix**: The patch is minimal (8 lines added, 2
   modified) and confined to a single function
   `emc2305_set_single_tz()`. The changes are:
   - Add a check for `cur_state > 0`
   - Calculate proper PWM value if temperature is elevated
   - Update state tracking to use calculated PWM instead of hardcoded
     minimum

4. **No Architectural Changes**: This is a straightforward
   initialization fix that doesn't change any interfaces, data
   structures, or driver architecture.

5. **Low Regression Risk**: The fix only affects initialization behavior
   when thermal state indicates elevated temperatures. Normal operation
   when temperature is below trip points remains unchanged.

6. **Critical for Thermal Management**: The emc2305 driver was added in
   kernel 5.20 (commit 0d8400c5a2ce from Aug 2022), making this a
   relatively recent driver where users encountering high-temperature
   boot scenarios would experience complete fan control failure.

The commit follows stable tree rules perfectly - it's a clear bugfix for
a user-visible problem with minimal changes and low risk of introducing
new issues. Systems booting in hot environments or after warm reboots
would be particularly affected by this bug, making the fix important for
operational reliability.

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

