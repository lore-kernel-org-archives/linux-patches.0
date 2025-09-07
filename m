Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E33B315D54;
	Sun,  7 Sep 2025 20:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277319; cv=none; b=W9wI3mPIjUM6YAtvh8XhNe7QDbXgs6XdTcXTL2AAOO8r2wYrAp7ifjdEWZ3iU09T3a5SR+O0EryAtQFP96nvm6UuTx1MveY2up6JjdxbvqnfWOzJ3Hk0tL5+GCrGb9xlfwuv9ZbbyADeuQcRgPW4144bMXyKnY7EveDY4vpufNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277319; c=relaxed/simple;
	bh=vV+HMt466sbpMwESVGwErsr554rG/FaGBJGpk2IBeNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVEsWoMsDdNMHuRlCYqG7U3Kkpickt1fz4SYZn08ZrMCpv/wFdm/adwwYfYILz5cztngboPQm+/cTV376Z0AlBctT3uHV42NLDjz49lLecad9SuBBLvqK+Nj3ERe2Lc0eYcmtGjx6qYudUWEZ+grjJ1j5eOq/MQG5s+BNu1TsMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MsaUaiBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MsaUaiBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAF2C4CEF0;
	Sun,  7 Sep 2025 20:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277319;
	bh=vV+HMt466sbpMwESVGwErsr554rG/FaGBJGpk2IBeNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsaUaiBv9LxiiyzAXgxra6xbLXlq7ildOXTSOR1X8Dfh2wlueHAMuq57nIBAZCIdJ
	 eziF/dDLImR8GjfKcEK3f6pZ/laD+aEZaRnkPNf0P3MJyQAmnUuhh3XEJXPoSq5IB1
	 rS/J+P4Gr/YrZzmsR8c8CC3nFCCImHhLN4Jm7Wr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/175] hwmon: mlxreg-fan: Prevent fans from getting stuck at 0 RPM
Date: Sun,  7 Sep 2025 21:59:09 +0200
Message-ID: <20250907195618.500511385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 1180c79fbf36e4c02e76ae4658509523437e52a4 ]

The fans controlled by the driver can get stuck at 0 RPM if they are
configured below a 20% duty cycle. The driver tries to avoid this by
enforcing a minimum duty cycle of 20%, but this is done after the fans
are registered with the thermal subsystem. This is too late as the
thermal subsystem can set their current state before the driver is able
to enforce the minimum duty cycle.

Fix by setting the minimum duty cycle before registering the fans with
the thermal subsystem.

Fixes: d7efb2ebc7b3 ("hwmon: (mlxreg-fan) Extend driver to support multiply cooling devices")
Reported-by: Nikolay Aleksandrov <razor@blackwall.org>
Tested-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20250730201715.1111133-1-vadimp@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mlxreg-fan.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index a5f89aab3fb4d..c25a54d5b39ad 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -561,15 +561,14 @@ static int mlxreg_fan_cooling_config(struct device *dev, struct mlxreg_fan *fan)
 		if (!pwm->connected)
 			continue;
 		pwm->fan = fan;
+		/* Set minimal PWM speed. */
+		pwm->last_hwmon_state = MLXREG_FAN_PWM_DUTY2STATE(MLXREG_FAN_MIN_DUTY);
 		pwm->cdev = devm_thermal_of_cooling_device_register(dev, NULL, mlxreg_fan_name[i],
 								    pwm, &mlxreg_fan_cooling_ops);
 		if (IS_ERR(pwm->cdev)) {
 			dev_err(dev, "Failed to register cooling device\n");
 			return PTR_ERR(pwm->cdev);
 		}
-
-		/* Set minimal PWM speed. */
-		pwm->last_hwmon_state = MLXREG_FAN_PWM_DUTY2STATE(MLXREG_FAN_MIN_DUTY);
 	}
 
 	return 0;
-- 
2.51.0



