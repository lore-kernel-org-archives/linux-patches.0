Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF413A48C2;
	Sat, 17 Oct 2026 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254867; cv=none; b=nnS1Q5MNAHltQxyUZrT5djxpzSklFL+YJ/3Ifv4m6XqDKKgurm41Rw/17qYv4hi13VPfaHLplWpBBXH1pTdze0v9n81SzLxN/XCEtCWeGYHJrs74gwa2q/eRxSrlNRxnpZwtwXk1ka04w7ifTISneUxY8ab6IKquLLw7cs1p+PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254867; c=relaxed/simple;
	bh=rxSc6okcHyDn+6GUlPsPP56KDN5RjcTLnk0xkNwtqLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lql2ReJr3Yeyc3MOcYoqH7P/jB8kHbqE/dzOWF7KYvE3WtWcV7jdCbsQ7z2VS1JrxINvgvejy1pU/Wh8uaJIvCDMUsa6r9AnkOuPwuJt4M8tXWnTN0fiu3NzP4Ww9Zyz363VGNaEm+UeRUGl+I/BONq3U9Ws+0kYFygjhPELXsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqFA+9no; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqFA+9no"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521BE1F000C4;
	Sat, 17 Oct 2026 16:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254866;
	bh=YysYqdkjOYx456qj8LbSjei/8C+JWb7WoEepADuGgHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqFA+9nowa3plf95mF+AfV1/YOSswXuIZtHRBaf6vDslJLKJo/WVkGxScuVUG6RI6
	 AH0Vix5YQoVcSIbRC7HYSizJPQWMWfgFF/YWCUkr00jehO08Ex2EYD1X7oS4o7uBav
	 rSuPW/9PTEVETfnGUlXeLfurs1Ckb+Ys0W1CrapI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 587/869] drm/amdgpu: force complete the MES ring fences on reset
Date: Sat, 17 Oct 2026 17:57:08 +0200
Message-ID: <20261017160052.104784243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3e74e8dc2e186..ef0f6e75d718b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5498,6 +5498,19 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 		amdgpu_fence_driver_force_completion(ring, fence);
 	}
 
+	/*
+	 * MES scheduler rings have no drm scheduler, so they are missed by the
+	 * loop above. Realign their polling fence too (one per XCC), otherwise the
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



