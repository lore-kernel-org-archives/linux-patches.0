Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3B1EEDE;
	Tue, 20 May 2025 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749685; cv=none; b=FCIOKBO1jfeBBXV69nUXUcaL9LrQEdM/53EgSFneWBcA5mAZAl6G/4IqGwAOK5vQhjRLnoFyUy7Vvkg97/VzqZfI1pUJnOV1COoPUzN61iu8SadmdWrO5RsYYSOgJa31P91HMUA0Y9jYj5p1AAUIXEYYXPlmoPGKe74Uoy5cMlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749685; c=relaxed/simple;
	bh=XCcw8TEQhVkaBbcgVik7MjLjV42QTKimDzKGD3lMu6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKSaeMGWEsgi2tGXhR5WKyVOClNb0MgPjkvpHUdnLi1oZuodK94AhWQfXJ7Od/TENw12WWf7w0wBZvKDu4vGloejpV9F7Lf9ycH2C4B28sV0LJLOBCtAVNv/oRtQqmGWZOWxx1qKmr8UUdRLFHRBCnmhHIx7Y+fgqDka252pRGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrQKIqmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrQKIqmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21281C4CEE9;
	Tue, 20 May 2025 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749685;
	bh=XCcw8TEQhVkaBbcgVik7MjLjV42QTKimDzKGD3lMu6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrQKIqmNvxtVVvGmVM2GjF8dd5Cy+yjvIZgk+cQcUVQXDyfCMszwskcH0T/rb9b4g
	 P1kMJ2heXBeEgdhI40JNahEjfmwbH5rwr0KygATH/pNE1Pk4/TS5PZF66AJJQ7Pb3b
	 Y/r8oJQQeUhT0YqdL2OIdyxR4HyNcbCTKnggTMdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/117] Revert "drm/amd: Stop evicting resources on APUs in suspend"
Date: Tue, 20 May 2025 15:49:52 +0200
Message-ID: <20250520125805.058172741@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit d0ce1aaa8531a4a4707711cab5721374751c51b0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h        |  2 --
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c   | 18 ------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 11 ++---------
 3 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 9cda2ecaf69b5..c5d706a4c7b4a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -1459,11 +1459,9 @@ static inline int amdgpu_acpi_smart_shift_update(struct drm_device *dev,
 #if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
 bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev);
 bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev);
-void amdgpu_choose_low_power_state(struct amdgpu_device *adev);
 #else
 static inline bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev) { return false; }
 static inline bool amdgpu_acpi_is_s3_active(struct amdgpu_device *adev) { return false; }
-static inline void amdgpu_choose_low_power_state(struct amdgpu_device *adev) { }
 #endif
 
 #if defined(CONFIG_DRM_AMD_DC)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index a6fd52aed91ab..8b2f2b921d9de 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1525,22 +1525,4 @@ bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 9fd9424ec8f71..814142844197a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4167,15 +4167,13 @@ int amdgpu_device_prepare(struct drm_device *dev)
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
 
@@ -4186,15 +4184,10 @@ int amdgpu_device_prepare(struct drm_device *dev)
 			continue;
 		r = adev->ip_blocks[i].version->funcs->prepare_suspend((void *)adev);
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
-- 
2.39.5



