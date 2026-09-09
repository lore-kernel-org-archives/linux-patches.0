Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58EC582BBE;
	Wed,  9 Sep 2026 14:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963071; cv=none; b=WWFjyxRdw190ufUTuAclDpblr822O9Wt9/Qul73KtZ3jch966ufZ5vCu2Sz1AzBqAhkwrp9aXsil9MHrRJfkfPhL6E58T4Hg8g9Pww0iidurgi4VeW7X/t48K4M7YL21avcXxp/Tqst7BNFlNXMIcSzFc5fzZsi1t0XufC9zAZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963071; c=relaxed/simple;
	bh=P4GRNfRJD5m+RrQKw68m0cyiQJN+3vtw7gz5OPk+4YM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQrQHPrcbURYcCFKtHuWAw5X0Jt9UgcuF911wze/K0HxWGv63gRGaHWciNjB4EA6ya/XMteInvrIt3rFntA+bCE7NxkmRwkAmzwhFcPkHWLdiLJAsP3aDi1JfayUbp6EQ6QME4sgUKPvaTloLmcgLWAQ6UguJNLbQ/dr7QuIo+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ67DNsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ67DNsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B151F00A3E;
	Wed,  9 Sep 2026 14:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963069;
	bh=Qk7tkAMLwoPOJn9TmI6XEikCpxwEp2NrtBrYfZWuuWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJ67DNsWEY3Dz0VIsmEGaW5aHcZVU0PJDGCfRDvBV1qVgir9HoXMyJ88rRU/AwyR/
	 OqW2I2Dh/cN/YtmG2zqxpCpiTM11FCvZPP2uDHV99tMG12DS11iH6VJGY8TbCJ/w80
	 b4qI9OQnDQ1iDUQIztyrwwwZlza7w8V9x4Fr10gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>
Subject: [PATCH 7.2 508/556] drm/amdgpu: force complete the KIQ ring fences on reset
Date: Wed,  9 Sep 2026 15:43:08 +0200
Message-ID: <20260909134248.331509115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

commit fd65d1742992361fc2201ecb4e43411e6e417fcb upstream.

Like the MES scheduler ring, the KIQ ring sets no_scheduler = true and uses a
polling fence, so it is skipped by the force-completion loop in
amdgpu_device_pre_asic_reset(). Its hw fence value lives in wb (GTT) memory and
survives a MODE1 reset while fence_drv.sync_seq keeps advancing, so after a
reset the first KIQ submission can poll forever on a seq that is never written
back.

Force complete the KIQ ring fences too so their hw fence is realigned to
sync_seq.

Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5219,6 +5219,18 @@ int amdgpu_device_pre_asic_reset(struct
 		amdgpu_fence_driver_force_completion(ring, fence);
 	}
 
+	/*
+	 * KIQ rings are polling-fence/no_scheduler like MES, so realign their
+	 * fence too (one ring per XCC), otherwise the first post-reset KIQ
+	 * submission polls forever on a stale seq.
+	 */
+	for (i = 0; i < AMDGPU_MAX_GC_INSTANCES; i++) {
+		struct amdgpu_ring *kiq_ring = &adev->gfx.kiq[i].ring;
+
+		if (kiq_ring->fence_drv.initialized && kiq_ring->sched.ready)
+			amdgpu_fence_driver_force_completion(kiq_ring, fence);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	r = amdgpu_reset_prepare_hwcontext(adev, reset_context);


