Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB12F7F02;
	Mon, 17 Aug 2026 14:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977632; cv=none; b=tpuPnbPwnuQE5XJwbnqkPiXnwuNp7yrNpjV1VyoGUDrhdlDOTV5N2noCMHpLTbEUngeAFNrlx0GW49uPIRabT5V8Y+KC7DUPIiUgNDTjelZBCoSeY1mNRFJ7Sv3aYs8x8EfHKrWAdho+gZ9BnOEDU7AHV+v7nKkqXDM492f2RNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977632; c=relaxed/simple;
	bh=yQVCNBYv7vP9lpZaXeEB2A724mAVad+DRdb+acMER8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKuTpxJ4mN3HRKHSceTtk1mckGNstUiZAdkK5v/aMz2DTEQvlE4JFPqq/HSvp524Zh8wkUSS2XJc5UHQOtTPRpkXewvTGK6sMNQgSoCoTZi6jcvLTwxejJyBnDWvClnAobuCCa71JWhatiF9173ifNpZzQh34gdmYjuEmSpkQ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4TEz3HO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4TEz3HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3BA1F000E9;
	Mon, 17 Aug 2026 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977631;
	bh=HnXfxI9h14kwF60HS2HQPCUxOSbaBC0jIOYC0DU4rXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4TEz3HO5hWfJjph0QKkVRjzOAyLPE3nt8iZ63yOojSd6stBtUnrZXnra5udqsiRE
	 JkpIQM9+0ureXFp9DPgIFbhk8DhkHWNgeb55CU95tgyFM6Sc2wx7rc5Oe84kg2UPxm
	 /JWtDtn+YLy4u5eryLwgL69ww4lpIwi5jc+JeNFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 357/456] drm/amdgpu: restore UMD profile pstate after runtime resume
Date: Mon, 17 Aug 2026 15:32:27 +0200
Message-ID: <20260817132553.494659064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2393,6 +2393,19 @@ static int amdgpu_pmops_runtime_suspend(
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
@@ -2436,6 +2449,8 @@ static int amdgpu_pmops_runtime_resume(s
 
 	if (amdgpu_device_supports_px(drm_dev))
 		drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
+
+	amdgpu_restore_umd_profile_pstate_after_runpm(adev);
 	adev->in_runpm = false;
 	return 0;
 }


