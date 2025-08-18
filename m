Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EEA3218CA;
	Mon, 18 Aug 2025 13:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522345; cv=none; b=iQ1wARsuPg2QlRmFn5KPZqu45STIMpMuP4bUnMsw68SxLpp8CnT1hJZjyTePqQSiNnBV9GT23jNW9kN/Kgt5c/qaQefmAjyFVAoE051q6mvaa+aGJTpGXImZZ6SaXMkEQtXHqxK86xs0EcXCu/sWFlMQjclK53+XgS1bbDuwaw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522345; c=relaxed/simple;
	bh=2RlCWpnLbwMjHtgJOhCRA23GtLXykNKlOqoJ6yt4Mkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7a+gsxCbr1Yae6jiALzzw+h0fFS/IH9wgMdxQ4O/6EoVLD7vjW/z1FkHusocFvFJYqUx9zbb9e/Ub3R0lw52au9s40iV5X0sIJXRDpbKkwWq/kk1+QkxOraCsXJTZ89WR3GoP6JHxtnur/OAjoDyHeSrFArO7x9JcPby4/Y6W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWW2B3u2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWW2B3u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53AEC4CEEB;
	Mon, 18 Aug 2025 13:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522345;
	bh=2RlCWpnLbwMjHtgJOhCRA23GtLXykNKlOqoJ6yt4Mkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWW2B3u2CZsSdQDKDOUjTB8+w5OPcn63/adnKehn1KGLpPfqc20+lvyQdJtspB/uM
	 TjmGPpWqVLwLanFf2iI618cV2dNkJ+mNN4fs7ZRQfs17rtcO/S/VPjyRRKcGKnrLN3
	 DkFIZMVLbinZJCIwNQsQc4zfepHn3Zue2LwfSnuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florin Leotescu <florin.leotescu@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/444] hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state
Date: Mon, 18 Aug 2025 14:45:13 +0200
Message-ID: <20250818124459.723940858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 4d39fbd83769..5b5fccac9635 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -300,6 +300,12 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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
@@ -313,10 +319,10 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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



