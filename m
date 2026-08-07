Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995B6381AE4;
	Fri,  7 Aug 2026 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115569; cv=none; b=cOy5MBHtJ0FoF/fjXHFChLqpUYTgCW1p5sIMYDkZa7hoio8KY/fRueAFZDxVhv59ehNHnXD1vuNMGmkNuHqEHCFrA0Csdt+Oae8THW7mK65JMUpwo9TfOZbpYjKjgDfdN48FJ5Lh+WX3TsP066RWZSoXc+WPz+yIku0GSIvx4sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115569; c=relaxed/simple;
	bh=hiAv6dAEe/2NgzIM5KBm0cOIjRBlABa2Xg8vUrGWy/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvoTqiB4Fa2qcwWtZHddjFsLFE++xfn1Fe4Fv06gFBgsxFGBSRua79Hh/mfadOJTmfMcBit43FYzlT7xqqTOT3lmRmVCFcBfF4PugX7Zp6cOHPtATOhJIeJtzVoo65T2c2RhaBLRDk/u6821a0N9lYAi8t3Vl9RE4LeAFvatWeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhChJvaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhChJvaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FAF1F000E9;
	Fri,  7 Aug 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115565;
	bh=sXU7cxBFVsAGRct7ZpvfjLlPyJxpGxFS46dWqY65jww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhChJvaXKkOJByv+bnXVIiB+sroCBrjoSqQRiominR1X0nyul8LJqX95LrLLWJls/
	 tgDzp2F82cSWoPrAURYy1NiOPtU5qdncTCsEYmFQE5eOSY25mFgO7jO2P+bLeiHxKa
	 jGKyGQ9tATAcBlUpXM9s0TYOUgFNeCfnmUAD6QhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 320/396] drm/amdgpu: restore UMD profile pstate after runtime resume
Date: Fri,  7 Aug 2026 16:38:00 +0200
Message-ID: <20260807143431.167903217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2891,6 +2891,19 @@ static int amdgpu_pmops_runtime_suspend(
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
@@ -2935,6 +2948,8 @@ static int amdgpu_pmops_runtime_resume(s
 
 	if (adev->pm.rpm_mode == AMDGPU_RUNPM_PX)
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
+
+	amdgpu_restore_umd_profile_pstate_after_runpm(adev);
 	adev->in_runpm = false;
 	return 0;
 }


