Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD40541F362;
	Thu, 30 Jul 2026 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424257; cv=none; b=gNx1o5cAqsLjW7rGsYnZyWh/SiGhQgedSxbnX9uv8PLO2E4hdFXC6GCPjy2k72hTMF8blHKKgv20dwNOHD1ckD5mBXpW0gQQ5/sbck5uggtePZCRtyg4AQYRe9IuYvJE12MiYJmjcD+EdP8NQXnCX9rw9zYQPkUtUruyaLQ4dgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424257; c=relaxed/simple;
	bh=AwiTiLlyRstvyUq9E0iboYDCb5A6kg3Ef8IeKUsfJMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MERE/VIfxKIHFgKoWMKtK1+qtF8TYzAkCBXC2qWHxsJFpkXFOV2JabtBR4LTlfZfQJT63uFbCCsZOTibMEYuNwOHS+QE9MnaP4uNo70DZiPNDyUB7ITPY2WEhEDjVJuhP7YPWAfK1wNe71bFYfGUPXjJFhFZfFvAaCVx99YtRzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuHxVrJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuHxVrJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2411F00A3D;
	Thu, 30 Jul 2026 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424250;
	bh=z5vzIu2b5c0p0zjYlgToJnkyCV7viHHDPI7CGVyyRls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuHxVrJaZIj2zfBZyuPVA1RHppJtZRYwrf3HDeTwg9ypKGXyBecJ/935ZbTm5HXuk
	 o+R03Sb8+uSmx4Tf9pSI+kvGEzh963sw5qe2IhMky8CRVjHCNi/U0RRCIyHahj5rUJ
	 IyMPcmyipypcOkxXU9l4DHJBHu//HbkxN90pOvTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 329/675] drm/amdgpu/gfx: fix cleaner shader IB buffer overflow
Date: Thu, 30 Jul 2026 16:10:59 +0200
Message-ID: <20260730141452.122011946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

commit 3e864bf2a32a1cbdf1e0f9c5a5a4176e8575f4a3 upstream.

The cleaner shader sysfs path allocates a 16-dword (64 byte) IB but
incorrectly fills (align_mask + 1) dwords. On GFX rings align_mask is
0xff, so the loop wrote 256 dwords into a 64-byte buffer, causing a
kernel page fault.

The IB only needs to be a minimal NOP shell to schedule the job; the
cleaner shader itself is emitted on the ring via emit_cleaner_shader().
Fill 16 dwords to match the allocation.

v2: Use ib_size_dw variable (Lijo)

Fixes: d361ad5d2fc0 ("drm/amdgpu: Add sysfs interface for running cleaner shader")
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit bf21af331ebf72d0935fd70c73192414a422c03a)
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1456,12 +1456,13 @@ static int amdgpu_gfx_run_cleaner_shader
 	struct amdgpu_device *adev = ring->adev;
 	struct drm_gpu_scheduler *sched = &ring->sched;
 	struct drm_sched_entity entity;
+	unsigned int ib_size_dw = 16;
 	static atomic_t counter;
 	struct dma_fence *f;
 	struct amdgpu_job *job;
 	struct amdgpu_ib *ib;
 	void *owner;
-	int i, r;
+	int r;
 
 	/* Initialize the scheduler entity */
 	r = drm_sched_entity_init(&entity, DRM_SCHED_PRIORITY_NORMAL,
@@ -1479,7 +1480,7 @@ static int amdgpu_gfx_run_cleaner_shader
 	owner = (void *)(unsigned long)atomic_inc_return(&counter);
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, &entity, owner,
-				     64, 0, &job,
+				     ib_size_dw * sizeof(uint32_t), 0, &job,
 				     AMDGPU_KERNEL_JOB_ID_CLEANER_SHADER);
 	if (r)
 		goto err;
@@ -1489,9 +1490,8 @@ static int amdgpu_gfx_run_cleaner_shader
 	job->run_cleaner_shader = true;
 
 	ib = &job->ibs[0];
-	for (i = 0; i <= ring->funcs->align_mask; ++i)
-		ib->ptr[i] = ring->funcs->nop;
-	ib->length_dw = ring->funcs->align_mask + 1;
+	memset32(ib->ptr, ring->funcs->nop, ib_size_dw);
+	ib->length_dw = ib_size_dw;
 
 	f = amdgpu_job_submit(job);
 


