Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36C3442B0F;
	Thu, 30 Jul 2026 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422245; cv=none; b=hlIFKkUD5VUrvzImdqOfkMdL8wcSHNWPnJSZ/+25AiNrAy5xkmsR6Q1VJX59L+RJqbzfhRo0hLvGMLeWiIfvMQmI6henNHNnkrQd3TuapfX4UFhHn2Y05IrcrCSSAQ9ZN5no/K1dWzZs7upUeV0y/wmAz4xwR/USB1RSYKZEgyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422245; c=relaxed/simple;
	bh=5udCZmnlKFVNy/O9Kmh31LZFDfSJOlwDDb0eLcIfwmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BStc99KuBJYJj3Qgh8yjaPYjeqG2Rncvt+Pqce7Mn+X5e27r/IfWQKcVBtw04oYCWhNSLXh1Eok52pnJjHc7QwXSb5Y7EDhcyzLh481H0vigudR6MDB0jHxcmslLx+6pQnJAW5lIR41fCGng0QuywfFwRUQqzexe25/CMNEMXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJ2Ozpmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJ2Ozpmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165221F000E9;
	Thu, 30 Jul 2026 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422244;
	bh=aUN0O88WNAxpeUC3aMeP6rflz8nr9gDOPSNgAx+4R6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJ2OzpmqqUjljRSB+XmyVBDtL3AFddTc3E3RXfHONxhW4Qj1Km240gfdfBa3j2vMQ
	 dRA42KtjxpXYra9/AFshjJCbi7Z/sO8uuIZv85PNmuDpJZIqP/EJ2wo9Iz76x0B4ml
	 jEm1XJBEokDqkTK/CoiyxraQB7LmB8X4I9iip5/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 374/744] drm/amdgpu/gfx: fix cleaner shader IB buffer overflow
Date: Thu, 30 Jul 2026 16:10:47 +0200
Message-ID: <20260730141452.235434638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1646,12 +1646,13 @@ static int amdgpu_gfx_run_cleaner_shader
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
@@ -1669,7 +1670,7 @@ static int amdgpu_gfx_run_cleaner_shader
 	owner = (void *)(unsigned long)atomic_inc_return(&counter);
 
 	r = amdgpu_job_alloc_with_ib(ring->adev, &entity, owner,
-				     64, 0, &job,
+				     ib_size_dw * sizeof(uint32_t), 0, &job,
 				     AMDGPU_KERNEL_JOB_ID_CLEANER_SHADER);
 	if (r)
 		goto err;
@@ -1679,9 +1680,8 @@ static int amdgpu_gfx_run_cleaner_shader
 	job->run_cleaner_shader = true;
 
 	ib = &job->ibs[0];
-	for (i = 0; i <= ring->funcs->align_mask; ++i)
-		ib->ptr[i] = ring->funcs->nop;
-	ib->length_dw = ring->funcs->align_mask + 1;
+	memset32(ib->ptr, ring->funcs->nop, ib_size_dw);
+	ib->length_dw = ib_size_dw;
 
 	f = amdgpu_job_submit(job);
 


