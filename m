Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61EC52B1FF;
	Wed,  9 Sep 2026 14:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963073; cv=none; b=lBPsegIqK6zSposvksI7LYxFKVBGcdU+++2VOMkM1qfTrcyZLAw6jDuDjVjuSHZD3ujYPnnQOS+gkHnynhh62kTqwp+4ovD4m7iduGJ29mNv1n0AOsYklaJ8C21htwmXznQUXG+erT0UC3npywywEdHSGb7zLlXkLjHiDHwVTz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963073; c=relaxed/simple;
	bh=sOOlAzchRt7AJuv2ehuhowFnT8rw22weQeeGkANcxtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBlWd1D0+J9xMYlcKye5WFGjKzHzMuhV0l6jnxP+yt2R+ROz3WO5UTvoYHHbBcE4VLXm1Ijsn2bK4CW2jx76rCWUy5v0SLBbBgwo9zB+RTtvuKPiGJJgZ2KsZCrRFYB/cc5TEGQ4TsqqJNzedowFhTf22K4pZ2zB+HHZeR7KNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xCImIvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xCImIvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D81D1F00A3A;
	Wed,  9 Sep 2026 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963072;
	bh=cKx16oCCSsTtbtaBat9irdXc6eUcdZrGq3zxS3HzHCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xCImIvX0iajUb/TiMKwq4V2xs9NGwD+dW+8YQaKgyUFgmXyS+4VHN0dS/lxZJ4CR
	 oDFuD403HMZbP9lGKNyBgRyoY8dQYLHeRNVSzDTL0dfZabrcB7OW/xey/8tUG9TmXi
	 mVkCbekLmYrsONE87sKajMhqZ/953FS9Aw6Pjq28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 509/556] drm/amdgpu: force complete the MES ring fences on reset
Date: Wed,  9 Sep 2026 15:43:09 +0200
Message-ID: <20260909134248.363552018@linuxfoundation.org>
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

commit 48dc279c3010ac8f91b1845b2abb3a1e9943a0f5 upstream.

The MES scheduler ring has no drm scheduler (no_scheduler = true), so it is
skipped by the force-completion loop in amdgpu_device_pre_asic_reset(). It uses
a polling fence whose hw value lives in wb (GTT) memory and survives a MODE1
reset, while fence_drv.sync_seq keeps advancing for every packet.

When the reset is triggered because MES itself stopped responding, the
timed-out packets advance sync_seq past the last hw fence value MES wrote.
After resume the first MES submission polls forever on a seq that is never
written back, failing the resume and wedging the box on a second reset:

  amdgpu: MES ring buffer is full.
  amdgpu: *ERROR* ring gfx_0.0.0 test failed (-110)
  amdgpu: resume of IP block <gfx_v11_0> failed -110
  amdgpu: GPU reset end with ret = -110

Force complete the MES scheduler ring fences together with the scheduler rings
so their hw fence is realigned to sync_seq.

v2: cover all XCCs (one scheduler ring each), not just mes.ring[0].

Cc: stable@vger.kernel.org
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5231,6 +5231,19 @@ int amdgpu_device_pre_asic_reset(struct
 			amdgpu_fence_driver_force_completion(kiq_ring, fence);
 	}
 
+	/*
+	 * MES scheduler rings have no drm scheduler, so they are missed by the
+	 * loop above. Realign their polling fence too (one per XCC), otherwise the
+	 * first post-reset submission polls forever on a stale seq. sched.ready is
+	 * only set while the driver owns the ring.
+	 */
+	for (i = 0; i < AMDGPU_MAX_MES_INST_PIPES; i++) {
+		struct amdgpu_ring *mes_ring = &adev->mes.ring[i];
+
+		if (mes_ring->fence_drv.initialized && mes_ring->sched.ready)
+			amdgpu_fence_driver_force_completion(mes_ring, fence);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	r = amdgpu_reset_prepare_hwcontext(adev, reset_context);


