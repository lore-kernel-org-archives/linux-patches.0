Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329F92222B1;
	Thu, 13 Feb 2025 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457489; cv=none; b=jHQ4SW7XQeSyT44y19UkHe30Lmo/KRTG00FvXxanC6bE3t/4bKy/LUXlGMNb9S6/YWm8SkSuJ+P5fGykRmcrPDDy5HLRFK1NlQtr/rLXBbDewxrFnZ998qs3VjNoeizjpmuu+WXauLZqpdkF7lrE4PQkOlBM+1Yjw4V3w7u0FhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457489; c=relaxed/simple;
	bh=QGP9Cl5Zb5fFbeYhDfZTYOQF3/17FjfOqi/+y0vkvaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YT5r41A1Id8yLntCSBd5fsTSIn5AwZTF9nYX1Zn01+UMJlTxH24yrrFzOH8ae4Ar3jWu9TE2T8C8vxQ0FV7f7nxrkvU8eM6FVoIrKGFZLXSk8t1Nj0RqyD9QySMQpSpi0aXmNlIvhejUwrnfMJ1wK97PcPQpYE99NSuNXe3alBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OethBpHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OethBpHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98311C4CED1;
	Thu, 13 Feb 2025 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457489;
	bh=QGP9Cl5Zb5fFbeYhDfZTYOQF3/17FjfOqi/+y0vkvaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OethBpHRIZQSEkKlwdBZNEEZVcOlOgPFQrXC0enol/kptpJocb/E43ZjjV5/WGvkZ
	 UN3EzKd7U+k95J/n0GsHcF9pQECPaKLl32XLPa7Yl9Ti0X6fdqkz7MCJrxkSmYvH3m
	 4+Q2fkbmkJ+SJ4p03pt7T4rZ91ByT7LSJhhpmO7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/422] drm/amdgpu: Fix Circular Locking Dependency in AMDGPU GFX Isolation
Date: Thu, 13 Feb 2025 15:24:02 +0100
Message-ID: <20250213142440.141401447@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 1e8c193f8ca7ab7dff4f4747b45a55dca23c00f4 ]

This commit addresses a circular locking dependency issue within the GFX
isolation mechanism. The problem was identified by a warning indicating
a potential deadlock due to inconsistent lock acquisition order.

- The `amdgpu_gfx_enforce_isolation_ring_begin_use` and
  `amdgpu_gfx_enforce_isolation_ring_end_use` functions previously
  acquired `enforce_isolation_mutex` and called `amdgpu_gfx_kfd_sch_ctrl`,
  leading to potential deadlocks. ie., If `amdgpu_gfx_kfd_sch_ctrl` is
  called while `enforce_isolation_mutex` is held, and
  `amdgpu_gfx_enforce_isolation_handler` is called while `kfd_sch_mutex` is
  held, it can create a circular dependency.

By ensuring consistent lock usage, this fix resolves the issue:

[  606.297333] ======================================================
[  606.297343] WARNING: possible circular locking dependency detected
[  606.297353] 6.10.0-amd-mlkd-610-311224-lof #19 Tainted: G           OE
[  606.297365] ------------------------------------------------------
[  606.297375] kworker/u96:3/3825 is trying to acquire lock:
[  606.297385] ffff9aa64e431cb8 ((work_completion)(&(&adev->gfx.enforce_isolation[i].work)->work)){+.+.}-{0:0}, at: __flush_work+0x232/0x610
[  606.297413]
               but task is already holding lock:
[  606.297423] ffff9aa64e432338 (&adev->gfx.kfd_sch_mutex){+.+.}-{3:3}, at: amdgpu_gfx_kfd_sch_ctrl+0x51/0x4d0 [amdgpu]
[  606.297725]
               which lock already depends on the new lock.

[  606.297738]
               the existing dependency chain (in reverse order) is:
[  606.297749]
               -> #2 (&adev->gfx.kfd_sch_mutex){+.+.}-{3:3}:
[  606.297765]        __mutex_lock+0x85/0x930
[  606.297776]        mutex_lock_nested+0x1b/0x30
[  606.297786]        amdgpu_gfx_kfd_sch_ctrl+0x51/0x4d0 [amdgpu]
[  606.298007]        amdgpu_gfx_enforce_isolation_ring_begin_use+0x2a4/0x5d0 [amdgpu]
[  606.298225]        amdgpu_ring_alloc+0x48/0x70 [amdgpu]
[  606.298412]        amdgpu_ib_schedule+0x176/0x8a0 [amdgpu]
[  606.298603]        amdgpu_job_run+0xac/0x1e0 [amdgpu]
[  606.298866]        drm_sched_run_job_work+0x24f/0x430 [gpu_sched]
[  606.298880]        process_one_work+0x21e/0x680
[  606.298890]        worker_thread+0x190/0x350
[  606.298899]        kthread+0xe7/0x120
[  606.298908]        ret_from_fork+0x3c/0x60
[  606.298919]        ret_from_fork_asm+0x1a/0x30
[  606.298929]
               -> #1 (&adev->enforce_isolation_mutex){+.+.}-{3:3}:
[  606.298947]        __mutex_lock+0x85/0x930
[  606.298956]        mutex_lock_nested+0x1b/0x30
[  606.298966]        amdgpu_gfx_enforce_isolation_handler+0x87/0x370 [amdgpu]
[  606.299190]        process_one_work+0x21e/0x680
[  606.299199]        worker_thread+0x190/0x350
[  606.299208]        kthread+0xe7/0x120
[  606.299217]        ret_from_fork+0x3c/0x60
[  606.299227]        ret_from_fork_asm+0x1a/0x30
[  606.299236]
               -> #0 ((work_completion)(&(&adev->gfx.enforce_isolation[i].work)->work)){+.+.}-{0:0}:
[  606.299257]        __lock_acquire+0x16f9/0x2810
[  606.299267]        lock_acquire+0xd1/0x300
[  606.299276]        __flush_work+0x250/0x610
[  606.299286]        cancel_delayed_work_sync+0x71/0x80
[  606.299296]        amdgpu_gfx_kfd_sch_ctrl+0x287/0x4d0 [amdgpu]
[  606.299509]        amdgpu_gfx_enforce_isolation_ring_begin_use+0x2a4/0x5d0 [amdgpu]
[  606.299723]        amdgpu_ring_alloc+0x48/0x70 [amdgpu]
[  606.299909]        amdgpu_ib_schedule+0x176/0x8a0 [amdgpu]
[  606.300101]        amdgpu_job_run+0xac/0x1e0 [amdgpu]
[  606.300355]        drm_sched_run_job_work+0x24f/0x430 [gpu_sched]
[  606.300369]        process_one_work+0x21e/0x680
[  606.300378]        worker_thread+0x190/0x350
[  606.300387]        kthread+0xe7/0x120
[  606.300396]        ret_from_fork+0x3c/0x60
[  606.300406]        ret_from_fork_asm+0x1a/0x30
[  606.300416]
               other info that might help us debug this:

[  606.300428] Chain exists of:
                 (work_completion)(&(&adev->gfx.enforce_isolation[i].work)->work) --> &adev->enforce_isolation_mutex --> &adev->gfx.kfd_sch_mutex

[  606.300458]  Possible unsafe locking scenario:

[  606.300468]        CPU0                    CPU1
[  606.300476]        ----                    ----
[  606.300484]   lock(&adev->gfx.kfd_sch_mutex);
[  606.300494]                                lock(&adev->enforce_isolation_mutex);
[  606.300508]                                lock(&adev->gfx.kfd_sch_mutex);
[  606.300521]   lock((work_completion)(&(&adev->gfx.enforce_isolation[i].work)->work));
[  606.300536]
                *** DEADLOCK ***

[  606.300546] 5 locks held by kworker/u96:3/3825:
[  606.300555]  #0: ffff9aa5aa1f5d58 ((wq_completion)comp_1.1.0){+.+.}-{0:0}, at: process_one_work+0x3f5/0x680
[  606.300577]  #1: ffffaa53c3c97e40 ((work_completion)(&sched->work_run_job)){+.+.}-{0:0}, at: process_one_work+0x1d6/0x680
[  606.300600]  #2: ffff9aa64e463c98 (&adev->enforce_isolation_mutex){+.+.}-{3:3}, at: amdgpu_gfx_enforce_isolation_ring_begin_use+0x1c3/0x5d0 [amdgpu]
[  606.300837]  #3: ffff9aa64e432338 (&adev->gfx.kfd_sch_mutex){+.+.}-{3:3}, at: amdgpu_gfx_kfd_sch_ctrl+0x51/0x4d0 [amdgpu]
[  606.301062]  #4: ffffffff8c1a5660 (rcu_read_lock){....}-{1:2}, at: __flush_work+0x70/0x610
[  606.301083]
               stack backtrace:
[  606.301092] CPU: 14 PID: 3825 Comm: kworker/u96:3 Tainted: G           OE      6.10.0-amd-mlkd-610-311224-lof #19
[  606.301109] Hardware name: Gigabyte Technology Co., Ltd. X570S GAMING X/X570S GAMING X, BIOS F7 03/22/2024
[  606.301124] Workqueue: comp_1.1.0 drm_sched_run_job_work [gpu_sched]
[  606.301140] Call Trace:
[  606.301146]  <TASK>
[  606.301154]  dump_stack_lvl+0x9b/0xf0
[  606.301166]  dump_stack+0x10/0x20
[  606.301175]  print_circular_bug+0x26c/0x340
[  606.301187]  check_noncircular+0x157/0x170
[  606.301197]  ? register_lock_class+0x48/0x490
[  606.301213]  __lock_acquire+0x16f9/0x2810
[  606.301230]  lock_acquire+0xd1/0x300
[  606.301239]  ? __flush_work+0x232/0x610
[  606.301250]  ? srso_alias_return_thunk+0x5/0xfbef5
[  606.301261]  ? mark_held_locks+0x54/0x90
[  606.301274]  ? __flush_work+0x232/0x610
[  606.301284]  __flush_work+0x250/0x610
[  606.301293]  ? __flush_work+0x232/0x610
[  606.301305]  ? __pfx_wq_barrier_func+0x10/0x10
[  606.301318]  ? mark_held_locks+0x54/0x90
[  606.301331]  ? srso_alias_return_thunk+0x5/0xfbef5
[  606.301345]  cancel_delayed_work_sync+0x71/0x80
[  606.301356]  amdgpu_gfx_kfd_sch_ctrl+0x287/0x4d0 [amdgpu]
[  606.301661]  amdgpu_gfx_enforce_isolation_ring_begin_use+0x2a4/0x5d0 [amdgpu]
[  606.302050]  ? srso_alias_return_thunk+0x5/0xfbef5
[  606.302069]  amdgpu_ring_alloc+0x48/0x70 [amdgpu]
[  606.302452]  amdgpu_ib_schedule+0x176/0x8a0 [amdgpu]
[  606.302862]  ? drm_sched_entity_error+0x82/0x190 [gpu_sched]
[  606.302890]  amdgpu_job_run+0xac/0x1e0 [amdgpu]
[  606.303366]  drm_sched_run_job_work+0x24f/0x430 [gpu_sched]
[  606.303388]  process_one_work+0x21e/0x680
[  606.303409]  worker_thread+0x190/0x350
[  606.303424]  ? __pfx_worker_thread+0x10/0x10
[  606.303437]  kthread+0xe7/0x120
[  606.303449]  ? __pfx_kthread+0x10/0x10
[  606.303463]  ret_from_fork+0x3c/0x60
[  606.303476]  ? __pfx_kthread+0x10/0x10
[  606.303489]  ret_from_fork_asm+0x1a/0x30
[  606.303512]  </TASK>

v2: Refactor lock handling to resolve circular dependency (Alex)

- Introduced a `sched_work` flag to defer the call to
  `amdgpu_gfx_kfd_sch_ctrl` until after releasing
  `enforce_isolation_mutex`.
- This change ensures that `amdgpu_gfx_kfd_sch_ctrl` is called outside
  the critical section, preventing the circular dependency and deadlock.
- The `sched_work` flag is set within the mutex-protected section if
  conditions are met, and the actual function call is made afterward.
- This approach ensures consistent lock acquisition order.

Fixes: afefd6f24502 ("drm/amdgpu: Implement Enforce Isolation Handler for KGD/KFD serialization")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 156abd2ba5a6c..05ebb8216a55a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1837,6 +1837,7 @@ void amdgpu_gfx_enforce_isolation_ring_begin_use(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
 	u32 idx;
+	bool sched_work = false;
 
 	if (!adev->gfx.enable_cleaner_shader)
 		return;
@@ -1852,15 +1853,19 @@ void amdgpu_gfx_enforce_isolation_ring_begin_use(struct amdgpu_ring *ring)
 	mutex_lock(&adev->enforce_isolation_mutex);
 	if (adev->enforce_isolation[idx]) {
 		if (adev->kfd.init_complete)
-			amdgpu_gfx_kfd_sch_ctrl(adev, idx, false);
+			sched_work = true;
 	}
 	mutex_unlock(&adev->enforce_isolation_mutex);
+
+	if (sched_work)
+		amdgpu_gfx_kfd_sch_ctrl(adev, idx, false);
 }
 
 void amdgpu_gfx_enforce_isolation_ring_end_use(struct amdgpu_ring *ring)
 {
 	struct amdgpu_device *adev = ring->adev;
 	u32 idx;
+	bool sched_work = false;
 
 	if (!adev->gfx.enable_cleaner_shader)
 		return;
@@ -1876,7 +1881,10 @@ void amdgpu_gfx_enforce_isolation_ring_end_use(struct amdgpu_ring *ring)
 	mutex_lock(&adev->enforce_isolation_mutex);
 	if (adev->enforce_isolation[idx]) {
 		if (adev->kfd.init_complete)
-			amdgpu_gfx_kfd_sch_ctrl(adev, idx, true);
+			sched_work = true;
 	}
 	mutex_unlock(&adev->enforce_isolation_mutex);
+
+	if (sched_work)
+		amdgpu_gfx_kfd_sch_ctrl(adev, idx, true);
 }
-- 
2.39.5



