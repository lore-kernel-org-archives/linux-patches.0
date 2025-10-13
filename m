Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC9309EFA;
	Mon, 13 Oct 2025 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367149; cv=none; b=ddKXMkzGMvXoZdl+QZSo4C3257tNWtHsw4WRqDbiMaQ6i0yxU3Q2nwHzOojm9oeqg5qDLQZNyCfJX1o485Jby6vfvMFxLNYkif3Xf0pBQRDFzlRzTQYqsfhYqFHM+EEhaGF9QPzhMoTW7WWRC4cVFHTM+onirWYZAhwNMxtjG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367149; c=relaxed/simple;
	bh=Cq8LXpXX532+otaSRd8DrzKhZ+SC2UnrBqjWcjUx2nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYUG7bzxd64QapU7gKJvuyZUfY6d9knEv/GcSqJT09pDjXRCdJ5s1SEL/bLTs1/BA5GMUY5Tx6ZuzNowN7G+X3YniQeek7uPKSM3aXOg3uLlPfSaXs3YHPbQQKteWDpdO9YFIrzS7t9db9geV9NU+vqu1UtqWZQ9i/67a5L1HLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AQZf48s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AQZf48s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F7EC4CEE7;
	Mon, 13 Oct 2025 14:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367149;
	bh=Cq8LXpXX532+otaSRd8DrzKhZ+SC2UnrBqjWcjUx2nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AQZf48sMCu/y43ZoysbWA/JJK5Pm6NgXHDxxuyONTSzbKdPo+fmTimsOKToUYqMd
	 fT4DSm6xTvGQQRomgyMSociWVi6O4uTlAXL6KNilEVDARK8WVtRfaLXtxdKdnjiMZQ
	 wZvDGi/z1SKi73MLnQSkmA+yj4SCDBSHXn/rsVkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/196] drm/amd/pm: Disable SCLK switching on Oland with high pixel clocks (v3)
Date: Mon, 13 Oct 2025 16:44:42 +0200
Message-ID: <20251013144318.642378679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 7009e3af0474aca5f64262b3c72fb6e23b232f9b ]

Port of commit 227545b9a08c ("drm/radeon/dpm: Disable sclk
switching on Oland when two 4K 60Hz monitors are connected")

This is an ad-hoc DPM fix, necessary because we don't have
proper bandwidth calculation for DCE 6.

We define "high pixelclock" for SI as higher than necessary
for 4K 30Hz. For example, 4K 60Hz and 1080p 144Hz fall into
this category.

When two high pixel clock displays are connected to Oland,
additionally disable shader clock switching, which results in
a higher voltage, thereby addressing some visible flickering.

v2:
Add more comments.
v3:
Split into two commits for easier review.

Fixes: 841686df9f7d ("drm/amdgpu: add SI DPM support (v4)")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index b3c011542daf7..7a85c042a6db9 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -3430,12 +3430,14 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 {
 	struct  si_ps *ps = si_get_ps(rps);
 	struct amdgpu_clock_and_voltage_limits *max_limits;
+	struct amdgpu_connector *conn;
 	bool disable_mclk_switching = false;
 	bool disable_sclk_switching = false;
 	u32 mclk, sclk;
 	u16 vddc, vddci, min_vce_voltage = 0;
 	u32 max_sclk_vddc, max_mclk_vddci, max_mclk_vddc;
 	u32 max_sclk = 0, max_mclk = 0;
+	u32 high_pixelclock_count = 0;
 	int i;
 
 	if (adev->asic_type == CHIP_HAINAN) {
@@ -3463,6 +3465,35 @@ static void si_apply_state_adjust_rules(struct amdgpu_device *adev,
 		}
 	}
 
+	/* We define "high pixelclock" for SI as higher than necessary for 4K 30Hz.
+	 * For example, 4K 60Hz and 1080p 144Hz fall into this category.
+	 * Find number of such displays connected.
+	 */
+	for (i = 0; i < adev->mode_info.num_crtc; i++) {
+		if (!(adev->pm.dpm.new_active_crtcs & (1 << i)) ||
+			!adev->mode_info.crtcs[i]->enabled)
+			continue;
+
+		conn = to_amdgpu_connector(adev->mode_info.crtcs[i]->connector);
+
+		if (conn->pixelclock_for_modeset > 297000)
+			high_pixelclock_count++;
+	}
+
+	/* These are some ad-hoc fixes to some issues observed with SI GPUs.
+	 * They are necessary because we don't have something like dce_calcs
+	 * for these GPUs to calculate bandwidth requirements.
+	 */
+	if (high_pixelclock_count) {
+		/* On Oland, we observe some flickering when two 4K 60Hz
+		 * displays are connected, possibly because voltage is too low.
+		 * Raise the voltage by requiring a higher SCLK.
+		 * (Voltage cannot be adjusted independently without also SCLK.)
+		 */
+		if (high_pixelclock_count > 1 && adev->asic_type == CHIP_OLAND)
+			disable_sclk_switching = true;
+	}
+
 	if (rps->vce_active) {
 		rps->evclk = adev->pm.dpm.vce_states[adev->pm.dpm.vce_level].evclk;
 		rps->ecclk = adev->pm.dpm.vce_states[adev->pm.dpm.vce_level].ecclk;
-- 
2.51.0



