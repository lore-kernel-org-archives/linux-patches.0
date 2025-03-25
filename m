Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B3226F47B;
	Tue, 25 Mar 2025 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906413; cv=none; b=jjopXV3yIiUUVGlDAbLhs+fcGOkmhVTnTuFVs6cyPfemXGWG6jrXAaDCtkNQAtAX21hpdZ9qC0DgqCE2QPWzDIvdg8i0nI3Ck+is2cDf91pYQdlc1+ma6t41dX3kCeWrhDh0MOCIZIi6bdMqiQKWCzvVFPc1yfiNsoX8wa2qbFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906413; c=relaxed/simple;
	bh=5W/6a3ATg9fTIYyOG7WAUyPH6uSTcPcEgXKc5+q6Xk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeVVOLIezLRyldH1vn21wcTPJHEkcD+jVBapf6HUwSPauLyYx0fGp8dDCAWx4Bs2icQD3fqFE1hXtVUtUGDtmlyqlGACITYgP719dGXEEgMa0FW9mcNeQo1ksBIRM012hGJS4ceKNFeuOg4ew2qtGpRmeaaBvpR12k1YfR5BSSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBEjpyHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBEjpyHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07106C4CEE4;
	Tue, 25 Mar 2025 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906413;
	bh=5W/6a3ATg9fTIYyOG7WAUyPH6uSTcPcEgXKc5+q6Xk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBEjpyHSNVmamI/XU11i5kim2VqNbgGQivi27rbOrG2ZQPhpsNQwSVFNW73fgF02d
	 lEawqsHklfB/eZ8Lr3u+HFYmyOQC0xDDYe3CG2KgCWLX8hJ2B1MoF4w7Hlt52GVikg
	 5eL40/RqL5etaXbr3D/hvTb9SBu6I1YYwAjYRkaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 097/116] drm/amdgpu/pm: wire up hwmon fan speed for smu 14.0.2
Date: Tue, 25 Mar 2025 08:23:04 -0400
Message-ID: <20250325122151.688150536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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
@@ -1628,6 +1628,39 @@ out:
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
@@ -2794,6 +2827,8 @@ static const struct pptable_funcs smu_v1
 	.set_performance_level = smu_v14_0_set_performance_level,
 	.gfx_off_control = smu_v14_0_gfx_off_control,
 	.get_unique_id = smu_v14_0_2_get_unique_id,
+	.get_fan_speed_pwm = smu_v14_0_2_get_fan_speed_pwm,
+	.get_fan_speed_rpm = smu_v14_0_2_get_fan_speed_rpm,
 	.get_power_limit = smu_v14_0_2_get_power_limit,
 	.set_power_limit = smu_v14_0_2_set_power_limit,
 	.get_power_profile_mode = smu_v14_0_2_get_power_profile_mode,


