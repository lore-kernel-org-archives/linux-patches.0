Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55B187554;
	Tue, 26 Aug 2025 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214601; cv=none; b=g676haZKOtNitTHcCvKI43NJdvrVOz9t9R78C/oNxKHTBPr/t/SojgZhhjeBHEvQHN+PKWlRzYIid6ezZvz+vefHumwIb6K1nFHA2xLkcm39hyMbeNDIqCHxMeg2ZMWY2Lwe2AEsYVxcL+cypGAsA9WWI1TZU/HO/8kzPK4VguE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214601; c=relaxed/simple;
	bh=xwPxjvyvoVwpoXIU7uJKkWPsCY+CrF0f/0NAkhjeiME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiIMFOT2Da6ei0l/sJ8ArRPZ2y5jR7glVS3+zLKCzmA72UFkg2zklR7C98rb7msBIoNnoryFj1612qOVLasw2TpzeqLPgvX/2WaTghqntXx5xDymqEhiG8PwMSixdADhddiphG/L3DtrPKqAZlMh/ABCIml80vgusjlkP3u52E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR4GJjNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR4GJjNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6A9C4CEF1;
	Tue, 26 Aug 2025 13:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214601;
	bh=xwPxjvyvoVwpoXIU7uJKkWPsCY+CrF0f/0NAkhjeiME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BR4GJjNREN/7Ij7qdkfeim3GeagTHCHJQZDB8CQFYcdNC8jkNceWZxarV0vr9ErZA
	 lwt4DgHFsQJTUDf5jww8qhLo9xLbHQNCHkKK7uCg0HEerODWtwOrfc2tP4nj97M0Bg
	 REwyBxHqzacS4Ud6cNT20giVUDJuQ8EdUMWqVLVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florin Leotescu <florin.leotescu@nxp.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/482] hwmon: (emc2305) Set initial PWM minimum value during probe based on thermal state
Date: Tue, 26 Aug 2025 13:07:15 +0200
Message-ID: <20250826110935.302267036@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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
index e42ae43f3de4..286582e99c28 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -301,6 +301,12 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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
@@ -314,10 +320,10 @@ static int emc2305_set_single_tz(struct device *dev, int idx)
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



