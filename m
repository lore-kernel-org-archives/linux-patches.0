Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A8D446C9;
	Tue, 20 Feb 2024 21:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464862; cv=none; b=DJoNqMH9oPdiKxQ9MXJ3PAJgWuI8C88VDAuWyawuAbzGuF1VLRKVryOD6h59k/WGA7wyTXdoBYRthPyJWXTyfAd9/zyDAVZLFetuvR9RHlYCSP0iuiCoRD3/g72nVFLGT3DnyRSkHNzQJch2zmW9CeA8qCpFuyyPBH2Ux+j8Z8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464862; c=relaxed/simple;
	bh=YQtBIU3IRjET6EfOKDht0iiBrqgzIvnqabh6e2uJaFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeNlztSne8Vr85gljV2QthOUgO1ohkHGMlCGCcTMJMueKWSC2NPMpguk0uQThx5neLO0XWtMXPY/79bNsf6ISC/UGnCly0dG/axjhz8s2H5RAx9LwS6vVeJasy+9GVdmBwpD6ZGcAABI4do7IAO5YWK1mvqR29FP7esnDwPo0fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FoVIr4tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FoVIr4tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9464C433C7;
	Tue, 20 Feb 2024 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464862;
	bh=YQtBIU3IRjET6EfOKDht0iiBrqgzIvnqabh6e2uJaFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FoVIr4tj/6OcGUS8DnNa8RVECJJ1O/geZvc/8nxYA1YXgbCB2iM0zlHQcXDmaERj3
	 gcpguU1PvMVPJt8ppRYvTbCe0NCzkAJI4l82dRGqNzVx+gN7tbsQS4dJX45uIHv1Vi
	 k753RdUfyyB4raCYL2QPNnmtJxybVmdUDkDTpGAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.7 130/309] Revert "drm/amd: flush any delayed gfxoff on suspend entry"
Date: Tue, 20 Feb 2024 21:54:49 +0100
Message-ID: <20240220205637.219106336@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 916361685319098f696b798ef1560f69ed96e934 upstream.

commit ab4750332dbe ("drm/amdgpu/sdma5.2: add begin/end_use ring
callbacks") caused GFXOFF control to be used more heavily and the
codepath that was removed from commit 0dee72639533 ("drm/amd: flush any
delayed gfxoff on suspend entry") now can be exercised at suspend again.

Users report that by using GNOME to suspend the lockscreen trigger will
cause SDMA traffic and the system can deadlock.

This reverts commit 0dee726395333fea833eaaf838bc80962df886c8.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Fixes: ab4750332dbe ("drm/amdgpu/sdma5.2: add begin/end_use ring callbacks")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c    |    9 ++++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4496,7 +4496,6 @@ int amdgpu_device_suspend(struct drm_dev
 		drm_fb_helper_set_suspend_unlocked(adev_to_drm(adev)->fb_helper, true);
 
 	cancel_delayed_work_sync(&adev->delayed_init_work);
-	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
 	amdgpu_ras_suspend(adev);
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -723,8 +723,15 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_d
 
 		if (adev->gfx.gfx_off_req_count == 0 &&
 		    !adev->gfx.gfx_off_state) {
-			schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
+			/* If going to s2idle, no need to wait */
+			if (adev->in_s0ix) {
+				if (!amdgpu_dpm_set_powergating_by_smu(adev,
+						AMD_IP_BLOCK_TYPE_GFX, true))
+					adev->gfx.gfx_off_state = true;
+			} else {
+				schedule_delayed_work(&adev->gfx.gfx_off_delay_work,
 					      delay);
+			}
 		}
 	} else {
 		if (adev->gfx.gfx_off_req_count == 0) {


