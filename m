Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA5C1DF72E;
	Mon, 12 May 2025 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072075; cv=none; b=s3r+wSuxFAoESE5SLQiCkIxXvgPsUq3DcYBplvH2A9qaamtIzH0X7uwa3y1oIKxmrRAHrZ/xazigDC1CPfLdJNvkgSpmcUIjb5waKokGit3B6tXDOu0OUQ3GXVjlnMetQpSthxdpA1leCTNhB3icxEAZZTXlTj21IgowizTv7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072075; c=relaxed/simple;
	bh=EJuoxXgqCCMmVmwAAYab0FbIywRu4dHPYsJhwov4Y9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4+UgKuNi8GDI4h3bgGJhukPelhrJcLkXRO6OPDFXdNwNcRj4Jtl3JpTtqHbG41qZ/C62vSglF6FVcmGnhUhFI3zCR3VYlksSs/p6ZvwrPCy9HnK5F4bVrOfPPEPtuoCa6xG0ekGdR7LthRR64/ZxSUt9aWUgz3tj+CokPzUVsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYa7g6n4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYa7g6n4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A45C4CEE7;
	Mon, 12 May 2025 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072074;
	bh=EJuoxXgqCCMmVmwAAYab0FbIywRu4dHPYsJhwov4Y9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYa7g6n4blRRQYq6LVGZt4CIYCF9m7iz1sSBFtO0z1pQHX/qk5B0UZwP7vDmUfdFd
	 0X4sr4sNjieZ33j2ON2DSeNrKBmKJWZdzcj7Nks5x8tPb/zKaSaUwn4TnLv+BqstMv
	 a3R3y71y+tA8+V8oMV2VMUwYGkqgH1WBEsCB20KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 101/197] Revert "drm/amd: Stop evicting resources on APUs in suspend"
Date: Mon, 12 May 2025 19:39:11 +0200
Message-ID: <20250512172048.494024591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d0ce1aaa8531a4a4707711cab5721374751c51b0 upstream.

This reverts commit 3a9626c816db901def438dc2513622e281186d39.

This breaks S4 because we end up setting the s3/s0ix flags
even when we are entering s4 since prepare is used by both
flows.  The causes both the S3/s0ix and s4 flags to be set
which breaks several checks in the driver which assume they
are mutually exclusive.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3634
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ce8f7d95899c2869b47ea6ce0b3e5bf304b2fff4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |    2 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c   |   18 ------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   11 ++---------
 3 files changed, 2 insertions(+), 29 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1593,11 +1593,9 @@ static inline void amdgpu_acpi_get_backl
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
-void amdgpu_choose_low_power_state(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
-static inline void amdgpu_choose_low_power_state(struct amdgpu_device *adev) { }
 #endif
 
 void amdgpu_register_gpu_instance(struct amdgpu_device *adev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1533,22 +1533,4 @@ bool amdgpu_acpi_is_s0ix_active(struct a
 #endif /* CONFIG_AMD_PMC */
 }
 
-/**
- * amdgpu_choose_low_power_state
- *
- * @adev: amdgpu_device_pointer
- *
- * Choose the target low power state for the GPU
- */
-void amdgpu_choose_low_power_state(struct amdgpu_device *adev)
-{
-	if (adev->in_runpm)
-		return;
-
-	if (amdgpu_acpi_is_s0ix_active(adev))
-		adev->in_s0ix = true;
-	else if (amdgpu_acpi_is_s3_active(adev))
-		adev->in_s3 = true;
-}
-
 #endif /* CONFIG_SUSPEND */
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4861,15 +4861,13 @@ int amdgpu_device_prepare(struct drm_dev
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	int i, r;
 
-	amdgpu_choose_low_power_state(adev);
-
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
 
 	/* Evict the majority of BOs before starting suspend sequence */
 	r = amdgpu_device_evict_resources(adev);
 	if (r)
-		goto unprepare;
+		return r;
 
 	flush_delayed_work(&adev->gfx.gfx_off_delay_work);
 
@@ -4880,15 +4878,10 @@ int amdgpu_device_prepare(struct drm_dev
 			continue;
 		r = adev->ip_blocks[i].version->funcs->prepare_suspend(&adev->ip_blocks[i]);
 		if (r)
-			goto unprepare;
+			return r;
 	}
 
 	return 0;
-
-unprepare:
-	adev->in_s0ix = adev->in_s3 = adev->in_s4 = false;
-
-	return r;
 }
 
 /**


