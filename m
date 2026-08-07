Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B798F28E0;
	Fri,  7 Aug 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116326; cv=none; b=g5sarVQsiLNsSTu0DY+85QFmSiwn18lTC5cCdcQJmb2XWIyQYIPC1EBy2J8qvhenPnP6ZHD4zCECkQmupCK7lNAKKakRiie9+jHCWeRxsIaGJjdhebBZ/nkMHpsRbdZoIbJh1ahzL+bJakO2UKvGop5OQ78R6rCbg5+2TaO05z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116326; c=relaxed/simple;
	bh=fLQJa2EIblLBltCpLX5MhU2O2ZUTM+msGtbD9ybc6Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCaXGypO3dNAPEfjuM+7jNoo/LyD01qBgWWVX+51uYLnVb916gcc6DIJRANTFjLNdVrGF84HR0XdXtORAWScZh6aZV2mYQW2xW7EQzyhr84TUDpbwBCluMm0BvbSTxnx+jdcNncXUMaVZMVRp9Bnkj0+UsPb7ACRG8eC3KHB5Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5/jHQ0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5/jHQ0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDD11F000E9;
	Fri,  7 Aug 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116325;
	bh=8s3h9RJLAAame6RtcbJ7HSo+D9W4aSU7brJq2PKXZVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J5/jHQ0sDtVIehrnnmoKxCLIw2+8tvnBZ6sI5aIPBopONEBcB0XEzOK10jQXqSRul
	 1/VNu8O1eU81HzDkOXZ+ocopVLcw/UUImaIjoSzcYtZZASXVL7sHXo0eeqyad4EYEY
	 nzbsf27FmcgnP+/hzsrctM6E3HSQtuotElMBXNTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 191/261] drm/amdgpu: restore UMD profile pstate after runtime resume
Date: Fri,  7 Aug 2026 16:39:08 +0200
Message-ID: <20260807143419.487179269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


