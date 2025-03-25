Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0F62571AB;
	Tue, 25 Mar 2025 12:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906039; cv=none; b=t52A9hWOjdKp3ldTYlbmAe7JYhAZ2Z9zlSUqV0+7HqUpB4GNu1KKVXuf2aUCTfganf7S9mdidKny0kPg2UZXOtRiQ9iNeqt2Y1pTB9A2SI6nk1/G2HAGrs+t4hkp2pw12CFSwfGC63ELM6boEf6wUWwTy8gPKJtGQGUlnH+t9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906039; c=relaxed/simple;
	bh=dkGBsBvPDJSXwf6L1Fc4xfkNklbPVwRX89bTt2SLUUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VR/9S1e3svUe2PDxD54BbXsS8qWsY67C6N3HU/MSQcYTSjfw4d/8eKJ2cT/wfa3L6KlXqPUM0Nj/Qv55Ij2PEiuk9cHqPFplPRuyY9ULKgx6FGGraxFrZP70WmDC1pMHeJDDVfOr8KsapoOZ9UVvRRRcKY5dj9XWUFzi3nJGUyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRfhokVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRfhokVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C4FC4CEE4;
	Tue, 25 Mar 2025 12:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906039;
	bh=dkGBsBvPDJSXwf6L1Fc4xfkNklbPVwRX89bTt2SLUUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRfhokVJ3KvgA84kCroCFsQFDWKGdhZ8Rd34r4nXerw7/cO6p9a9nZRZmAHlRdh+H
	 rHbYo+6bInua4SdhT/TpRUaRFSLCKQWSpWyfxqSe83sh2Zk49w99ODvGi9qmONHZRN
	 O7V67biNo0dzQhE917uwTVLuzTIT+0cXb57aGwqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 102/119] drm/amdgpu/pm: wire up hwmon fan speed for smu 14.0.2
Date: Tue, 25 Mar 2025 08:22:40 -0400
Message-ID: <20250325122151.664068757@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5ca0040ecfe8ba0dee9df1f559e8d7587f12bf89 upstream.

Add callbacks for fan speed fetching.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4034
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 90df6db62fa78a8ab0b705ec38db99c7973b95d6)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c |   35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu14/smu_v14_0_2_ppt.c
@@ -1616,6 +1616,39 @@ out:
 	adev->unique_id = ((uint64_t)upper32 << 32) | lower32;
 }
 
+static int smu_v14_0_2_get_fan_speed_pwm(struct smu_context *smu,
+					 uint32_t *speed)
+{
+	int ret;
+
+	if (!speed)
+		return -EINVAL;
+
+	ret = smu_v14_0_2_get_smu_metrics_data(smu,
+					       METRICS_CURR_FANPWM,
+					       speed);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to get fan speed(PWM)!");
+		return ret;
+	}
+
+	/* Convert the PMFW output which is in percent to pwm(255) based */
+	*speed = min(*speed * 255 / 100, (uint32_t)255);
+
+	return 0;
+}
+
+static int smu_v14_0_2_get_fan_speed_rpm(struct smu_context *smu,
+					 uint32_t *speed)
+{
+	if (!speed)
+		return -EINVAL;
+
+	return smu_v14_0_2_get_smu_metrics_data(smu,
+						METRICS_CURR_FANSPEED,
+						speed);
+}
+
 static int smu_v14_0_2_get_power_limit(struct smu_context *smu,
 				       uint32_t *current_power_limit,
 				       uint32_t *default_power_limit,
@@ -2781,6 +2814,8 @@ static const struct pptable_funcs smu_v1
 	.set_performance_level = smu_v14_0_set_performance_level,
 	.gfx_off_control = smu_v14_0_gfx_off_control,
 	.get_unique_id = smu_v14_0_2_get_unique_id,
+	.get_fan_speed_pwm = smu_v14_0_2_get_fan_speed_pwm,
+	.get_fan_speed_rpm = smu_v14_0_2_get_fan_speed_rpm,
 	.get_power_limit = smu_v14_0_2_get_power_limit,
 	.set_power_limit = smu_v14_0_2_set_power_limit,
 	.get_power_profile_mode = smu_v14_0_2_get_power_profile_mode,


