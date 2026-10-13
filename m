Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B0F4EE85E;
	Tue, 13 Oct 2026 12:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893948; cv=none; b=YutRARft2gGcomDlxf/D5d6KTsbESoHu/e3BYaldH258LY66HBSXvMmT6wuciovYOjcmHzXAg882/A8b8nkx97KqPLOWYEuZiWBPX39LCaRMUSRiRANkpLTShgzBcmCPyvWc2bfDNCEgbvfK+BJrS2Q0m3DA3+dwLCj8FnUlJPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893948; c=relaxed/simple;
	bh=Ox3s7fDHq/BhKmi8XtquNb9L9OxCHQJ8i+FgKJHOFao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcsg+4QlsS3zJTxzzlW6MLW4j3P3aIWpGMhG8OuTnDjpW6kAh4Ql3i4yQY0Nm8QiKZR98GVrrXMTLZ9HH0+gcN2jqXoAZWIr/YdGBzZiATLtD3gQOuqa9+fJVWObbv2EBoArodqgi8O/CbKmFarjd5O4hqCXww1TZZEav0u4srs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7kQM2Uj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7kQM2Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1507C1F00893;
	Tue, 13 Oct 2026 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893947;
	bh=mQl1D1lePxTS5gt5gexFQuNV0/mU7+NZEyoNFSyLNQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7kQM2UjZ6CYxaTDB/tPp2Iop9ZIKNiqOB2qNBMJiDTXRNXPXDun9siVCCRpIgmSo
	 EmFINRjhGVC7AfqmUx0oxzEHmJ2NReOtZICmR2UWv/D9iGOMMq3tSWONNnKm0cmW4v
	 5N1moO9Z785BVgZJXKz4LNEl5ZJL5947S//yrKh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/621] drm/amdgpu: force complete the MES ring fences on reset
Date: Tue, 13 Oct 2026 13:36:24 +0200
Message-ID: <20261013112930.075071010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 48dc279c3010ac8f91b1845b2abb3a1e9943a0f5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b47989692bba7..ccb14ca65c497 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5920,6 +5920,19 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_fence_driver_force_completion(ring, fence);
 	}
 
+	/*
+	 * MES scheduler rings have no drm scheduler, so they are missed by the
+	 * loop above. Realign their polling fence too, otherwise the
+	 * first post-reset submission polls forever on a stale seq. sched.ready is
+	 * only set while the driver owns the ring.
+	 */
+	for (i = 0; i < AMDGPU_MAX_MES_PIPES; i++) {
+		struct amdgpu_ring *mes_ring = &adev->mes.ring[i];
+
+		if (mes_ring->fence_drv.initialized && mes_ring->sched.ready)
+			amdgpu_fence_driver_force_completion(mes_ring, fence);
+	}
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



