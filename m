Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BBF1F1921;
	Sun,  7 Sep 2025 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276360; cv=none; b=uy6FBXmmrASxb8ppXS3NZqZDA2lm5Gu4v0umSgG21girAV5TdsiGaHfC6iD70EFC4r4CQbZ2hKu52wvBVgmFuCFBj5Yvx236dVhLA/wt6cDMopKufi7CYmvvvBwhqRxGbBKKzStTXymMqRGHt+UDgyyT4uQN117p8JLgFq1PQaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276360; c=relaxed/simple;
	bh=Dw48bgi4hFck+pbTwJ6UOguS8dQFDcB5ScbuvvtS7+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MO/iqKNpxWm1cHfpZE7GBdtYNkgbpGK/syR//DyNV4oG6P7epF04GQE3RgzSshiRkGSOUCW69NFJKHzLyMN8vFF5wDRFr8qbIxyvAoema7yboIMaG9l1L1osMMIUUuseW1ui2XEn4AWQH+5aGH7Jcw81IXLLoNp7aLnHovHouVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMU13Q2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMU13Q2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62932C4CEF0;
	Sun,  7 Sep 2025 20:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276359;
	bh=Dw48bgi4hFck+pbTwJ6UOguS8dQFDcB5ScbuvvtS7+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMU13Q2sCzNUox4+STRsdz1LsqpkzhM/ovUEA6lAQgVLDxpYOFDz4RusBf+NRVDtI
	 MADFkqKolxgKpXq/vQ+T0DxOiMk00jOFufLAOoOHxpbqIvwZplt2BqSs0MTpk9rHgI
	 rr9cENNMDx87ZPrCm8toWgHmQb0TH7q9sp9mt/Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/104] hwmon: mlxreg-fan: Prevent fans from getting stuck at 0 RPM
Date: Sun,  7 Sep 2025 21:58:38 +0200
Message-ID: <20250907195609.774216872@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 96017cc8da7ec..7514d57661048 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -551,15 +551,14 @@ static int mlxreg_fan_cooling_config(struct device *dev, struct mlxreg_fan *fan)
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



