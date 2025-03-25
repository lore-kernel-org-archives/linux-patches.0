Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4270267B66;
	Tue, 25 Mar 2025 12:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905844; cv=none; b=S2FcHLnS434BAkIxZbVpqlH/TUoumvaTDHCL1c+EYTzDargpVFpbou1vRHHKiSQZg1Et99Jgz3DLiKzZtKwnsR/eyToKnhDI8AMnKChQ9xx7RYDX9NYgTkgSG4HkcPba40cJThcKRiUBP3VOc9FIGVhjljvvQum+QVozOrzuaRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905844; c=relaxed/simple;
	bh=I+lzDHVkWTI8Xk3aQMbj/Kcx0qxvX0QZ1+ykkaszdn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FOrWwDJo/X77xTAy10ng+skCRxRnbYpeVb/brShsYadMf6aQT6JhhknetjhCtUW1qKy41mfQlbuaxepJE90xAmBuD9S/zC8m2bCiwV/y8trpqcR7r/V2YaE0W2IhWlyIt4bD+SoOEMwvBSOkH5rsE9u5ihXL6+VvqVt7Dt7k0T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+2geprI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+2geprI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613CAC4CEF1;
	Tue, 25 Mar 2025 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905844;
	bh=I+lzDHVkWTI8Xk3aQMbj/Kcx0qxvX0QZ1+ykkaszdn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+2geprIG48IdZPei/rrFyxGEgVLw76IvBllmf+b4EGg+pGNeU/arUEQvJpifyNbk
	 iGQHs85yoe62Il+5U/kxeGsaWYULMGn4D+9/hzzF6roIsbKm648okfySvEVkqRKDPz
	 /S0gF7sVknW3zCDiE7a3am5ptwmI998yweTRQPEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Koenig <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Joonkyo Jung <joonkyoj@yonsei.ac.kr>,
	Dokyung Song <dokyungs@yonsei.ac.kr>,
	jisoo.jang@yonsei.ac.kr,
	yw9865@yonsei.ac.kr,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 194/198] drm/amdgpu: fix use-after-free bug
Date: Tue, 25 Mar 2025 08:22:36 -0400
Message-ID: <20250325122201.741541214@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

commit 22207fd5c80177b860279653d017474b2812af5e upstream.

The bug can be triggered by sending a single amdgpu_gem_userptr_ioctl
to the AMDGPU DRM driver on any ASICs with an invalid address and size.
The bug was reported by Joonkyo Jung <joonkyoj@yonsei.ac.kr>.
For example the following code:

static void Syzkaller1(int fd)
{
	struct drm_amdgpu_gem_userptr arg;
	int ret;

	arg.addr = 0xffffffffffff0000;
	arg.size = 0x80000000; /*2 Gb*/
	arg.flags = 0x7;
	ret = drmIoctl(fd, 0xc1186451/*amdgpu_gem_userptr_ioctl*/, &arg);
}

Due to the address and size are not valid there is a failure in
amdgpu_hmm_register->mmu_interval_notifier_insert->__mmu_interval_notifier_insert->
check_shl_overflow, but we even the amdgpu_hmm_register failure we still call
amdgpu_hmm_unregister into  amdgpu_gem_object_free which causes access to a bad address.
The following stack is below when the issue is reproduced when Kazan is enabled:

[  +0.000014] Hardware name: ASUS System Product Name/ROG STRIX B550-F GAMING (WI-FI), BIOS 1401 12/03/2020
[  +0.000009] RIP: 0010:mmu_interval_notifier_remove+0x327/0x340
[  +0.000017] Code: ff ff 49 89 44 24 08 48 b8 00 01 00 00 00 00 ad de 4c 89 f7 49 89 47 40 48 83 c0 22 49 89 47 48 e8 ce d1 2d 01 e9 32 ff ff ff <0f> 0b e9 16 ff ff ff 4c 89 ef e8 fa 14 b3 ff e9 36 ff ff ff e8 80
[  +0.000014] RSP: 0018:ffffc90002657988 EFLAGS: 00010246
[  +0.000013] RAX: 0000000000000000 RBX: 1ffff920004caf35 RCX: ffffffff8160565b
[  +0.000011] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffff8881a9f78260
[  +0.000010] RBP: ffffc90002657a70 R08: 0000000000000001 R09: fffff520004caf25
[  +0.000010] R10: 0000000000000003 R11: ffffffff8161d1d6 R12: ffff88810e988c00
[  +0.000010] R13: ffff888126fb5a00 R14: ffff88810e988c0c R15: ffff8881a9f78260
[  +0.000011] FS:  00007ff9ec848540(0000) GS:ffff8883cc880000(0000) knlGS:0000000000000000
[  +0.000012] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000010] CR2: 000055b3f7e14328 CR3: 00000001b5770000 CR4: 0000000000350ef0
[  +0.000010] Call Trace:
[  +0.000006]  <TASK>
[  +0.000007]  ? show_regs+0x6a/0x80
[  +0.000018]  ? __warn+0xa5/0x1b0
[  +0.000019]  ? mmu_interval_notifier_remove+0x327/0x340
[  +0.000018]  ? report_bug+0x24a/0x290
[  +0.000022]  ? handle_bug+0x46/0x90
[  +0.000015]  ? exc_invalid_op+0x19/0x50
[  +0.000016]  ? asm_exc_invalid_op+0x1b/0x20
[  +0.000017]  ? kasan_save_stack+0x26/0x50
[  +0.000017]  ? mmu_interval_notifier_remove+0x23b/0x340
[  +0.000019]  ? mmu_interval_notifier_remove+0x327/0x340
[  +0.000019]  ? mmu_interval_notifier_remove+0x23b/0x340
[  +0.000020]  ? __pfx_mmu_interval_notifier_remove+0x10/0x10
[  +0.000017]  ? kasan_save_alloc_info+0x1e/0x30
[  +0.000018]  ? srso_return_thunk+0x5/0x5f
[  +0.000014]  ? __kasan_kmalloc+0xb1/0xc0
[  +0.000018]  ? srso_return_thunk+0x5/0x5f
[  +0.000013]  ? __kasan_check_read+0x11/0x20
[  +0.000020]  amdgpu_hmm_unregister+0x34/0x50 [amdgpu]
[  +0.004695]  amdgpu_gem_object_free+0x66/0xa0 [amdgpu]
[  +0.004534]  ? __pfx_amdgpu_gem_object_free+0x10/0x10 [amdgpu]
[  +0.004291]  ? do_syscall_64+0x5f/0xe0
[  +0.000023]  ? srso_return_thunk+0x5/0x5f
[  +0.000017]  drm_gem_object_free+0x3b/0x50 [drm]
[  +0.000489]  amdgpu_gem_userptr_ioctl+0x306/0x500 [amdgpu]
[  +0.004295]  ? __pfx_amdgpu_gem_userptr_ioctl+0x10/0x10 [amdgpu]
[  +0.004270]  ? srso_return_thunk+0x5/0x5f
[  +0.000014]  ? __this_cpu_preempt_check+0x13/0x20
[  +0.000015]  ? srso_return_thunk+0x5/0x5f
[  +0.000013]  ? sysvec_apic_timer_interrupt+0x57/0xc0
[  +0.000020]  ? srso_return_thunk+0x5/0x5f
[  +0.000014]  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
[  +0.000022]  ? drm_ioctl_kernel+0x17b/0x1f0 [drm]
[  +0.000496]  ? __pfx_amdgpu_gem_userptr_ioctl+0x10/0x10 [amdgpu]
[  +0.004272]  ? drm_ioctl_kernel+0x190/0x1f0 [drm]
[  +0.000492]  drm_ioctl_kernel+0x140/0x1f0 [drm]
[  +0.000497]  ? __pfx_amdgpu_gem_userptr_ioctl+0x10/0x10 [amdgpu]
[  +0.004297]  ? __pfx_drm_ioctl_kernel+0x10/0x10 [drm]
[  +0.000489]  ? srso_return_thunk+0x5/0x5f
[  +0.000011]  ? __kasan_check_write+0x14/0x20
[  +0.000016]  drm_ioctl+0x3da/0x730 [drm]
[  +0.000475]  ? __pfx_amdgpu_gem_userptr_ioctl+0x10/0x10 [amdgpu]
[  +0.004293]  ? __pfx_drm_ioctl+0x10/0x10 [drm]
[  +0.000506]  ? __pfx_rpm_resume+0x10/0x10
[  +0.000016]  ? srso_return_thunk+0x5/0x5f
[  +0.000011]  ? __kasan_check_write+0x14/0x20
[  +0.000010]  ? srso_return_thunk+0x5/0x5f
[  +0.000011]  ? _raw_spin_lock_irqsave+0x99/0x100
[  +0.000015]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
[  +0.000014]  ? srso_return_thunk+0x5/0x5f
[  +0.000013]  ? srso_return_thunk+0x5/0x5f
[  +0.000011]  ? srso_return_thunk+0x5/0x5f
[  +0.000011]  ? preempt_count_sub+0x18/0xc0
[  +0.000013]  ? srso_return_thunk+0x5/0x5f
[  +0.000010]  ? _raw_spin_unlock_irqrestore+0x27/0x50
[  +0.000019]  amdgpu_drm_ioctl+0x7e/0xe0 [amdgpu]
[  +0.004272]  __x64_sys_ioctl+0xcd/0x110
[  +0.000020]  do_syscall_64+0x5f/0xe0
[  +0.000021]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
[  +0.000015] RIP: 0033:0x7ff9ed31a94f
[  +0.000012] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
[  +0.000013] RSP: 002b:00007fff25f66790 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  +0.000016] RAX: ffffffffffffffda RBX: 000055b3f7e133e0 RCX: 00007ff9ed31a94f
[  +0.000012] RDX: 000055b3f7e133e0 RSI: 00000000c1186451 RDI: 0000000000000003
[  +0.000010] RBP: 00000000c1186451 R08: 0000000000000000 R09: 0000000000000000
[  +0.000009] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff25f66ca8
[  +0.000009] R13: 0000000000000003 R14: 000055b3f7021ba8 R15: 00007ff9ed7af040
[  +0.000024]  </TASK>
[  +0.000007] ---[ end trace 0000000000000000 ]---

v2: Consolidate any error handling into amdgpu_hmm_register
    which applied to kfd_bo also. (Christian)
v3: Improve syntax and comment (Christian)

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Joonkyo Jung <joonkyoj@yonsei.ac.kr>
Cc: Dokyung Song <dokyungs@yonsei.ac.kr>
Cc: <jisoo.jang@yonsei.ac.kr>
Cc: <yw9865@yonsei.ac.kr>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c is renamed from
  drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c since
  d9483ecd327b ("drm/amdgpu: rename the files for HMM handling").
  The path is changed accordingly to apply the patch on 6.1.y. ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
@@ -132,13 +132,25 @@ static const struct mmu_interval_notifie
  */
 int amdgpu_mn_register(struct amdgpu_bo *bo, unsigned long addr)
 {
+	int r;
+
 	if (bo->kfd_bo)
-		return mmu_interval_notifier_insert(&bo->notifier, current->mm,
+		r = mmu_interval_notifier_insert(&bo->notifier, current->mm,
 						    addr, amdgpu_bo_size(bo),
 						    &amdgpu_mn_hsa_ops);
-	return mmu_interval_notifier_insert(&bo->notifier, current->mm, addr,
-					    amdgpu_bo_size(bo),
-					    &amdgpu_mn_gfx_ops);
+	else
+		r = mmu_interval_notifier_insert(&bo->notifier, current->mm, addr,
+							amdgpu_bo_size(bo),
+							&amdgpu_mn_gfx_ops);
+	if (r)
+		/*
+		 * Make sure amdgpu_hmm_unregister() doesn't call
+		 * mmu_interval_notifier_remove() when the notifier isn't properly
+		 * initialized.
+		 */
+		bo->notifier.mm = NULL;
+
+	return r;
 }
 
 /**


