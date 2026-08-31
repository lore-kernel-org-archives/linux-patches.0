Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A03448B9B;
	Mon, 31 Aug 2026 13:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183626; cv=none; b=a0Uba32ydzvsM817LPQ5IOFXaTovGYZKx7k1g4LzJAXqTt9Ths96X4jf5yBUf7PPKqvThPu4dVNY2xrRX1kua+2ojFzZGGW3ENI6XjJ/XSttLL6U4WNTP/dtrDg4pCHqRMvgLhETI3Ib/e0rPX14fTx682KVv8f5wUlCaAEqwCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183626; c=relaxed/simple;
	bh=LzKUEN5iloDyuAC5qBgV8IjlQFTiekzLkNn72l1wtZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbJO2MFcUFt0cHe8QpIlkqkR9xmkeVRLExmT9YlTrIlYyMhq3NSpgUDdynO9VzUgt3VIq2yLTOHAC95S1rZatkhtfb9hSlbQx0sJre5EoyOEZ2feRIjmn/+H6Q61dpH7Rc4aelTw9TFBs/H+Z6xpomtPsAGlgj89VUmrRoHxtfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKBlvMnu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKBlvMnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C664E1F00A3F;
	Mon, 31 Aug 2026 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183624;
	bh=ud6f7rM9i9/CrEz3zfui4Cdx9Ga+5N1V8oNPpgXSeFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKBlvMnuc/cN9j8haHASSqEIYjZ3v2tW3pAmCn2RNP/2CG5nt7kB1HUhCAUmx8W3s
	 6bJyHkwu/h/r4MM2JyliK6MJm1sTnuWLYZb05/4jbGPFsKNoU5fhuVEt2mlYD5yaqp
	 MAvmvIAPTkaeTjZY2cwFrNYuXYfQhg8gR0DwWmeGAO2NY5Q6jo+LMiUP+kahld1Ih+
	 lcPqu04wFJZARJwzWW4NajaY2IppkOSt2bk/pQI/QFI0B7YExFUCqfyW3VRMZ2QD7g
	 C58Y1r5JO0hK5XcUPugHKNfXaUOIHFCDY1TQaZJORGtBbXugaSgAZPqWhAaQ84juOh
	 OKKX05q2I6yiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jeremy Klarenbeek <jeremy.klarenbeek99@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm/si: Fix updating clock limits from power states
Date: Mon, 31 Aug 2026 09:23:53 -0400
Message-ID: <20260831133314.4125787-205-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background git searches finished and match the earlier analysis:

- **History search:** The AC-only `max_clock_voltage_on_ac` assignment
  traces back through the SI DPM code (pickaxe hit `837d542a09cd5`, the
  pm header relocation). No prior fix for DC clock limits was found.
- **Author search:** Jeremy Klarenbeek has no commits in this 6.18.44
  tree.
- **Fix commit search:** `git log --grep="updating clock limits"`
  returned nothing — the patch is not in this tree yet. The only "power
  states" hit in `si_dpm.c` was an unrelated debug-level change.
- **Hardware search:** No existing commits mention the FirePro W4170M or
  Radeon HD 8790M by name.

That supports the **YES** backport recommendation: the bug is present
and unfixed in 6.18.44, and this would be a new, standalone fix.The
hardware-related git search completed: there are no commits in this
6.18.44 tree that mention the FirePro W4170M, Radeon HD 8790M, or author
Jeremy Klarenbeek in connection with this clock-limits issue. That
confirms this would be a new fix rather than something already present
under a different commit.

 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c | 29 ++++++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
index 0385b24e7e4a2..ea97276358c0a 100644
--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -7238,6 +7238,7 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
 	struct evergreen_power_info *eg_pi = evergreen_get_pi(adev);
 	struct si_power_info *si_pi = si_get_pi(adev);
 	struct  si_ps *ps = si_get_ps(rps);
+	struct amdgpu_clock_and_voltage_limits *limits;
 	u16 leakage_voltage;
 	struct rv7xx_pl *pl = &ps->performance_levels[index];
 	int ret;
@@ -7297,12 +7298,30 @@ static void si_parse_pplib_clock_info(struct amdgpu_device *adev,
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

