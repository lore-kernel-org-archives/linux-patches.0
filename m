Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63847581F;
	Mon, 15 Apr 2024 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191378; cv=none; b=GzXFD9IiP3iHpZs/ofXlJrpO/Aw+Ne6gjddhn90wIL+IMfYJSZZOiZMJOd16qY92+WOhZnxSe9SfYwkejV5Wj0fL3g6cgnUsWyOh8qjJBsKHLT49FHqLbCfDy+9ubTE5kxbBbAOfY8KXU453lRmGEUBMJMKxZGAYX2mo238tZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191378; c=relaxed/simple;
	bh=TxYxhmum9tt0h7g4sqLIdVuCZdORGrapgb1IIqqHNJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OghvjB8bxGu4rXiEv9RxwUFsJzUkEp3fwFxUpdbLaOvAD8ioT7UxdqUOl4HRfj+LfZDstmYtWIhYVdXGGeS7NNDAYBi25LqcV/gZEfDKRFSbEXecHjUTSxaT0JcAioR5YQnRdT0DH/g9gjKEHPR2gcf8dxGLQVQEdAdjzUjirSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WnCKeX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WnCKeX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA68C3277B;
	Mon, 15 Apr 2024 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191377;
	bh=TxYxhmum9tt0h7g4sqLIdVuCZdORGrapgb1IIqqHNJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WnCKeX9ZgzD/iy51EUK47b5Aid/Xpdii8vhjtg8qzmrfnPkgNIJb3AvkPnEM6NGq
	 vzj+Z6u73XmLFpiGGbI0wdGybgHm1yTBT40K1lr1picJAb9Px57waDFHtdP55Ay23o
	 mxhCfK8kw+mK+Okx0rDnC8/oCOhV6EQHTiRhXv0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>
Subject: [PATCH 6.8 121/172] accel/ivpu: Return max freq for DRM_IVPU_PARAM_CORE_CLOCK_RATE
Date: Mon, 15 Apr 2024 16:20:20 +0200
Message-ID: <20240415142004.062812555@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>

commit c52c35e5b404b95a5bcff39af9be1b9293be3434 upstream.

DRM_IVPU_PARAM_CORE_CLOCK_RATE returns current NPU frequency which
could be 0 if device was sleeping. This value isn't really useful to
the user space, so return max freq instead which can be used to estimate
NPU performance.

Fixes: c39dc15191c4 ("accel/ivpu: Read clock rate only if device is up")
Cc: <stable@vger.kernel.org> # v6.7
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402104929.941186-7-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c     |   18 +-----------------
 drivers/accel/ivpu/ivpu_hw.h      |    6 ++++++
 drivers/accel/ivpu/ivpu_hw_37xx.c |    7 ++++---
 drivers/accel/ivpu/ivpu_hw_40xx.c |    6 ++++++
 4 files changed, 17 insertions(+), 20 deletions(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -131,22 +131,6 @@ static int ivpu_get_capabilities(struct
 	return 0;
 }
 
-static int ivpu_get_core_clock_rate(struct ivpu_device *vdev, u64 *clk_rate)
-{
-	int ret;
-
-	ret = ivpu_rpm_get_if_active(vdev);
-	if (ret < 0)
-		return ret;
-
-	*clk_rate = ret ? ivpu_hw_reg_pll_freq_get(vdev) : 0;
-
-	if (ret)
-		ivpu_rpm_put(vdev);
-
-	return 0;
-}
-
 static int ivpu_get_param_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 {
 	struct ivpu_file_priv *file_priv = file->driver_priv;
@@ -170,7 +154,7 @@ static int ivpu_get_param_ioctl(struct d
 		args->value = vdev->platform;
 		break;
 	case DRM_IVPU_PARAM_CORE_CLOCK_RATE:
-		ret = ivpu_get_core_clock_rate(vdev, &args->value);
+		args->value = ivpu_hw_ratio_to_freq(vdev, vdev->hw->pll.max_ratio);
 		break;
 	case DRM_IVPU_PARAM_NUM_CONTEXTS:
 		args->value = ivpu_get_context_count(vdev);
--- a/drivers/accel/ivpu/ivpu_hw.h
+++ b/drivers/accel/ivpu/ivpu_hw.h
@@ -21,6 +21,7 @@ struct ivpu_hw_ops {
 	u32 (*profiling_freq_get)(struct ivpu_device *vdev);
 	void (*profiling_freq_drive)(struct ivpu_device *vdev, bool enable);
 	u32 (*reg_pll_freq_get)(struct ivpu_device *vdev);
+	u32 (*ratio_to_freq)(struct ivpu_device *vdev, u32 ratio);
 	u32 (*reg_telemetry_offset_get)(struct ivpu_device *vdev);
 	u32 (*reg_telemetry_size_get)(struct ivpu_device *vdev);
 	u32 (*reg_telemetry_enable_get)(struct ivpu_device *vdev);
@@ -130,6 +131,11 @@ static inline u32 ivpu_hw_reg_pll_freq_g
 	return vdev->hw->ops->reg_pll_freq_get(vdev);
 };
 
+static inline u32 ivpu_hw_ratio_to_freq(struct ivpu_device *vdev, u32 ratio)
+{
+	return vdev->hw->ops->ratio_to_freq(vdev, ratio);
+}
+
 static inline u32 ivpu_hw_reg_telemetry_offset_get(struct ivpu_device *vdev)
 {
 	return vdev->hw->ops->reg_telemetry_offset_get(vdev);
--- a/drivers/accel/ivpu/ivpu_hw_37xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_37xx.c
@@ -805,12 +805,12 @@ static void ivpu_hw_37xx_profiling_freq_
 	/* Profiling freq - is a debug feature. Unavailable on VPU 37XX. */
 }
 
-static u32 ivpu_hw_37xx_pll_to_freq(u32 ratio, u32 config)
+static u32 ivpu_hw_37xx_ratio_to_freq(struct ivpu_device *vdev, u32 ratio)
 {
 	u32 pll_clock = PLL_REF_CLK_FREQ * ratio;
 	u32 cpu_clock;
 
-	if ((config & 0xff) == PLL_RATIO_4_3)
+	if ((vdev->hw->config & 0xff) == PLL_RATIO_4_3)
 		cpu_clock = pll_clock * 2 / 4;
 	else
 		cpu_clock = pll_clock * 2 / 5;
@@ -829,7 +829,7 @@ static u32 ivpu_hw_37xx_reg_pll_freq_get
 	if (!ivpu_is_silicon(vdev))
 		return PLL_SIMULATION_FREQ;
 
-	return ivpu_hw_37xx_pll_to_freq(pll_curr_ratio, vdev->hw->config);
+	return ivpu_hw_37xx_ratio_to_freq(vdev, pll_curr_ratio);
 }
 
 static u32 ivpu_hw_37xx_reg_telemetry_offset_get(struct ivpu_device *vdev)
@@ -1052,6 +1052,7 @@ const struct ivpu_hw_ops ivpu_hw_37xx_op
 	.profiling_freq_get = ivpu_hw_37xx_profiling_freq_get,
 	.profiling_freq_drive = ivpu_hw_37xx_profiling_freq_drive,
 	.reg_pll_freq_get = ivpu_hw_37xx_reg_pll_freq_get,
+	.ratio_to_freq = ivpu_hw_37xx_ratio_to_freq,
 	.reg_telemetry_offset_get = ivpu_hw_37xx_reg_telemetry_offset_get,
 	.reg_telemetry_size_get = ivpu_hw_37xx_reg_telemetry_size_get,
 	.reg_telemetry_enable_get = ivpu_hw_37xx_reg_telemetry_enable_get,
--- a/drivers/accel/ivpu/ivpu_hw_40xx.c
+++ b/drivers/accel/ivpu/ivpu_hw_40xx.c
@@ -980,6 +980,11 @@ static u32 ivpu_hw_40xx_reg_pll_freq_get
 	return PLL_RATIO_TO_FREQ(pll_curr_ratio);
 }
 
+static u32 ivpu_hw_40xx_ratio_to_freq(struct ivpu_device *vdev, u32 ratio)
+{
+	return PLL_RATIO_TO_FREQ(ratio);
+}
+
 static u32 ivpu_hw_40xx_reg_telemetry_offset_get(struct ivpu_device *vdev)
 {
 	return REGB_RD32(VPU_40XX_BUTTRESS_VPU_TELEMETRY_OFFSET);
@@ -1230,6 +1235,7 @@ const struct ivpu_hw_ops ivpu_hw_40xx_op
 	.profiling_freq_get = ivpu_hw_40xx_profiling_freq_get,
 	.profiling_freq_drive = ivpu_hw_40xx_profiling_freq_drive,
 	.reg_pll_freq_get = ivpu_hw_40xx_reg_pll_freq_get,
+	.ratio_to_freq = ivpu_hw_40xx_ratio_to_freq,
 	.reg_telemetry_offset_get = ivpu_hw_40xx_reg_telemetry_offset_get,
 	.reg_telemetry_size_get = ivpu_hw_40xx_reg_telemetry_size_get,
 	.reg_telemetry_enable_get = ivpu_hw_40xx_reg_telemetry_enable_get,


