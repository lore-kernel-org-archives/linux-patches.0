Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEADB2E7BD6;
	Mon, 17 Aug 2026 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980136; cv=none; b=NJQ1VwQfAeo/HmZRYSG3Jai08k4K/AcKB2omt+Kv0fbrD1X8b/Iz/jNg1nxEVOme7lbpGojZ5k68anrJVIDkWTKiYrp11/sSW2qnLRmbrAwed95VDQ4heQVZDN7+HCkaElRAVRbCIFMkK5E+K1bZDb3/eYEJWtXt5VnCeIAFnAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980136; c=relaxed/simple;
	bh=JHVhAxMRIqnq4EVV2sxM1TvNrf5qW77V8D9SZ47Mg7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8gTvnY9Asd8wSoBTnCf7eFow0WEiII0b5z62wvgcQ6hR3tym0mX78Mf20iQ2yX1BnthPGl/E9h3I30797tZw7Ljs0T7RqXc+J1NUI43Vygcni+kqE9n5ibYyqbyB35pqMVYTgl75MpVrON04g3xcDBnF/fEL0wKaPA7RreDCGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pqbxhono; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pqbxhono"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236681F000E9;
	Mon, 17 Aug 2026 15:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980135;
	bh=okKiDHwK+GKuxjEbx6pDtKMFMVEUyrlLkzBuwzpCR08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pqbxhono4VvKupBGhFiF7rYEs/rzan0ToicviEqG7GLoxIhpaNzCXGX5b9ti5RxE6
	 HNxXse1cabI7YgIaFVOfKLnhQrHulErHg0pJGOz1SDd3vEsESMyXPLlPUkTn913mDv
	 u08jHS8HACe9WnUyvaJiRFDDWhr8+YkVrlESNIYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 468/609] drm/amdgpu: restore UMD profile pstate after runtime resume
Date: Mon, 17 Aug 2026 15:32:44 +0200
Message-ID: <20260817132559.648153224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Candice Li <candice.li@amd.com>

commit f931c54b241ce2f36bfc34955aec43a188276b8d upstream.

Runtime suspend runs GFX hw_fini and clears perfmon clock gating while
the UMD profile DPM level remains set in software.  Re-apply stable
pstate after a successful runtime resume when a profile mode is active.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 138531c8850cc247aa12b104bb29ea387bcdcbb1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2637,6 +2637,19 @@ static int amdgpu_pmops_runtime_suspend(
 	return 0;
 }
 
+static void amdgpu_restore_umd_profile_pstate_after_runpm(struct amdgpu_device *adev)
+{
+	enum amd_dpm_forced_level level;
+	uint32_t profile_mode_mask = AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD |
+		AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK |
+		AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK |
+		AMD_DPM_FORCED_LEVEL_PROFILE_PEAK;
+
+	level = amdgpu_dpm_get_performance_level(adev);
+	if (level & profile_mode_mask)
+		amdgpu_asic_update_umd_stable_pstate(adev, true);
+}
+
 static int amdgpu_pmops_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -2680,6 +2693,8 @@ static int amdgpu_pmops_runtime_resume(s
 
 	if (amdgpu_device_supports_px(drm_dev))
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
+
+	amdgpu_restore_umd_profile_pstate_after_runpm(adev);
 	adev->in_runpm = false;
 	return 0;
 }


