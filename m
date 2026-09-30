Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9400450B8A3;
	Wed, 30 Sep 2026 15:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782633; cv=none; b=OrWuvvZqAdB6UBr6Q+ffDmUw6CgXsL/wg77I7Tn6B/zp6w0uFWlfccbNOO0wsQezuyk109A97g8uNrftHRTiTNxvWYTyLJlden2KR3/AWAxNbG8wgq49lZ2F1dom4c3+ghPnKNYthQnYF9Zd5J8N8eWh+dLNTIxlrPGDj5+yTRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782633; c=relaxed/simple;
	bh=AZIikPSyegE8XIJjbgcn2kyQRD1zALfukoQGt7nfNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SWSu56ZA8mquBh2TwFkHq8wT8Tc2ZwvLwEGdU3PeKCx0FzGjJzVhUy+cSczoyWXdBWuiVBP0bbdhvSmXHOiypqwa8oaTIo9J0AQ7/7uwyKaKPROKJGyIc8kkO/V0LR0CykMoyU8MSSg6A9BOIszD5pNV0VdqaaCdXO6iMkONAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0V0OXef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0V0OXef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6201F00893;
	Wed, 30 Sep 2026 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782626;
	bh=YApWM+jnIY8kbQvsF4AdaV+LuvGeRoQQcbIEgKMrxQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0V0OXefEA3+QOcwHlDuMV94kPnTIbJbx/ohOnKNxYkX2BDR97fZYFoJif6S0q6VG
	 WIlGYWt3St0dhCHQ6B9VZo0FMz7k6u4u+RBkkRy6ONP9kxjB8us4wcA2gCFJfGt55t
	 HnuB1v8kVTGVNawWbHF0+lnSA6FFIlhvr1TDI5Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/595] drm/amd/pm/si: Fix updating clock limits from power states
Date: Wed, 30 Sep 2026 17:19:21 +0200
Message-ID: <20260930152349.202066765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>

[ Upstream commit e6c5d36756e7d4d260e2365fc4d01226f1973152 ]

VBIOS can contain conflicting values between:
- the maximum allowed clocks and voltages on AC or DC
- the clocks and voltages in power states on AC or DC

Update maximum clock (and voltage) limits for both AC/DC
and take the highest value from the VBIOS limits and
the performance/battery power states. Previously this
was only done for AC, but is also needed for DC.

This commit fixes the behaviour on some laptop GPUs,
where the VBIOS limit was set to the lowest possible
clock frequency, so the GPU was stuck on the lowest
possible power level on battery.

Some affected GPUs are:
FirePro W4170M (Dell Precision M2800)
Radeon HD 8790M (Dell Latitude E6540)
and possibly other laptop GPUs.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Co-developed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/si_dpm.c | 29 +++++++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
index 47d18f129cac8..6062bfec0e04f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/si_dpm.c
@@ -7143,6 +7143,7 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
+	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7202,12 +7203,30 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 		si_pi->mvdd_bootup_value = mvdd;
 	}
 
+	/*
+	 * Update maximum allowed clock limits.
+	 * VBIOS can contain conflicting values between:
+	 * - the maximum allowed clocks and voltages on AC or DC
+	 * - the clocks and voltages in power states on AC or DC
+	 */
 	if ((rps->class & ATOM_PPLIB_CLASSIFICATION_UI_MASK) ==
-	    ATOM_PPLIB_CLASSIFICATION_UI_PERFORMANCE) {
-		adev->pm.dpm.dyn_state.max_clock_voltage_on_ac.sclk = pl->sclk;
-		adev->pm.dpm.dyn_state.max_clock_voltage_on_ac.mclk = pl->mclk;
-		adev->pm.dpm.dyn_state.max_clock_voltage_on_ac.vddc = pl->vddc;
-		adev->pm.dpm.dyn_state.max_clock_voltage_on_ac.vddci = pl->vddci;
+	    ATOM_PPLIB_CLASSIFICATION_UI_PERFORMANCE)
+		limits = &adev->pm.dpm.dyn_state.max_clock_voltage_on_ac;
+	else if ((rps->class & ATOM_PPLIB_CLASSIFICATION_UI_MASK) ==
+		 ATOM_PPLIB_CLASSIFICATION_UI_BATTERY)
+		limits = &adev->pm.dpm.dyn_state.max_clock_voltage_on_dc;
+	else
+		limits = NULL;
+
+	if (limits) {
+		if (pl->sclk > limits->sclk)
+			limits->sclk = pl->sclk;
+		if (pl->mclk > limits->mclk)
+			limits->mclk = pl->mclk;
+		if (pl->vddc > limits->vddc)
+			limits->vddc = pl->vddc;
+		if (pl->vddci > limits->vddci)
+			limits->vddci = pl->vddci;
 	}
 }
 
-- 
2.53.0



