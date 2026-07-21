Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419346C4C0;
	Tue, 21 Jul 2026 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649110; cv=none; b=uhn1DoHQA+iAbuwGVEZx6xMpZM/O2WQbmAzWq34hm33xZQm14iVs8KYHMHHTuf/9H+yQBjdmdXuLDSNNQF3ihVQV3XRY1jbgYbxRj3CAA2lQkWflHMIToPGBcnLz7AdUK7H8XaKbBMasVUqSk2KVhnIgX6zHNEEgVl3eLjqdUZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649110; c=relaxed/simple;
	bh=fQWZkL8oDuq3IqdIs1Hw6G8LU7o2Yk4/g2pRv52hl3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a28CmjWEaFc85+N0K5MeycM7rDOXFyov+we3NebQXs6Jn0XzZ17C7iKeDCVMzKFx5hwFEyiPwoIbHzMpJK0j4XDyW5s6drOhAk9uEgMfmg7rm5TSwWiooy79jwehylXfJ9h5zpmTZUOTXAOeCvjPZRGGkf2JIoShlp/NUZPHplo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8hGC6pu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8hGC6pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7451F000E9;
	Tue, 21 Jul 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649107;
	bh=PnsYcBb8f3IuIYad1elqFCU3NzcdIgxaQYaRxOX9AYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8hGC6purEEosoEF+3FD4cdqVX8/oXExng/7xLUUQPNueDoI2PoSRPWmNuMEXxoQ6
	 MB3ApLDbSotfXc2CHNZGmYDx7XAmkKxE1dZpVZsUl4P0NxEOsMIWiyfpviBf1KLQhX
	 aFOu9adurFce+Ymn9SylG9uu6YCD/plwZMUR5K/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0451/2077] drm/amdgpu: fix KASAN slab-out-of-bounds in amdgpu_coredump ring dump
Date: Tue, 21 Jul 2026 17:02:04 +0200
Message-ID: <20260721152603.419512039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 08ac3a7879d300302a1927ce2038629539a37f8b ]

The ring content dump in amdgpu_coredump() uses two separate loops over
adev->rings[]: the first counts rings with unsignalled fences to size
the allocation, and the second copies ring data into the allocated
buffers.

Both loops use the same condition to skip rings:

    atomic_read(&ring->fence_drv.last_seq) == ring->fence_drv.sync_seq

Because last_seq is an atomic that is updated concurrently by the fence
signalling path, additional rings may appear unsignalled in the second
loop that were signalled during the first. When this happens, idx
exceeds the allocated ring_count and the store to coredump->rings[idx]
writes past the end of the kcalloc-ed buffer.

This was found during IGT stressful test amd_queue_reset which
triggers random GPU resets. The OVERSIZE subtest
(CMD_STREAM_EXEC_INVALID_PACKET_LENGTH_OVERSIZE on GFX ring) provokes
a ring timeout and subsequent coredump, which hits the race between
the counting and copying loops. The failure is non-deterministic and
depends on fence signalling timing during the reset.

KASAN log:

  BUG: KASAN: slab-out-of-bounds in amdgpu_coredump+0x1274/0x12f0 [amdgpu]
  Write of size 4 at addr ffff888106154258 by task kworker/u128:5/23625
  CPU: 16 UID: 0 PID: 23625 Comm: kworker/u128:5 Not tainted 6.19.0+ #35
  Workqueue: amdgpu-reset-dev drm_sched_job_timedout [gpu_sched]
  Call Trace:
   <TASK>
   dump_stack_lvl+0xa5/0x110
   print_report+0xd1/0x660
   kasan_report+0xf3/0x130
   __asan_report_store4_noabort+0x17/0x30
   amdgpu_coredump+0x1274/0x12f0 [amdgpu]
   amdgpu_job_timedout+0xef0/0x16c0 [amdgpu]
   drm_sched_job_timedout+0x194/0x5c0 [gpu_sched]
   process_one_work+0x84b/0x1990
   worker_thread+0x6b8/0x11b0
   </TASK>

  Allocated by task 23625:
   kasan_save_stack+0x39/0x70
   __kasan_kmalloc+0xc3/0xd0
   __kmalloc_noprof+0x2ec/0x910
   amdgpu_coredump+0x5c5/0x12f0 [amdgpu]
   amdgpu_job_timedout+0xef0/0x16c0 [amdgpu]

  The buggy address belongs to the object at ffff888106154200
   which belongs to the cache kmalloc-rnd-09-96 of size 96
  The buggy address is located 16 bytes to the right of
   allocated 72-byte region [ffff888106154200, ffff888106154248)

72 bytes = 3 * sizeof(struct amdgpu_coredump_ring), so ring_count was 3
but idx reached 3+, writing ring_index (at struct offset 16) 16 bytes
past the allocation.

Fix by adding an idx < ring_count guard to the copy loop so it cannot
exceed the allocated count even when the fence state changes between
the two passes.

Fixes: eea85914d15b (drm/amdgpu: save ring content before resetting the device)
Cc: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Pierre-Eric Pelloux-Prayer <pierre-eric.pelloux-prayer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
index d386bc775d03c6..3d5a2abf27c634 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dev_coredump.c
@@ -553,7 +553,7 @@ void amdgpu_coredump(struct amdgpu_device *adev, bool skip_vram_check,
 	coredump->rings_dw = kzalloc(total_ring_size, GFP_NOWAIT);
 	coredump->rings = kcalloc(ring_count, sizeof(struct amdgpu_coredump_ring), GFP_NOWAIT);
 	if (coredump->rings && coredump->rings_dw) {
-		for (i = 0, off = 0, idx = 0; i < adev->num_rings; i++) {
+		for (i = 0, off = 0, idx = 0; i < adev->num_rings && idx < ring_count; i++) {
 			ring = adev->rings[i];
 
 			if (atomic_read(&ring->fence_drv.last_seq) == ring->fence_drv.sync_seq &&
-- 
2.53.0



