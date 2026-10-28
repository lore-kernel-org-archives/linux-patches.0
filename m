Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208434;
	b=qhRC7JmgFrYkFFl+GG2om/RMH+u191H7EMxZPQOq9t3PKasJX1+47+JVhQSJdO6inhNk
	 mEgd8AvNAYAZn5vX3tp1qhuYSUakZn/5jjzPcytQGHYduhH+bm7tCpo1E5AatEN7AfL/X
	 UOjbWtFVs08tQViJcVGRhmu3g4XJC14hIqgJ/OrwGFQ2nVrUDxKR4Hg5+FsiMxw3v0i3R
	 fLhDmocmHl90sfxA0kvbjierIkZlAHYx5X9VDH/bAY4E8FCoQ/GNpHbYLFBu0By1HA3hO
	 APa4Y4hXo5H1FYK1sTWCgAoapxnyvBzJN8iaytahaC2yqc5VGK91lbD5cdCBR7KREsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oiaKtEGkhG5rvVZjADRyp43lwQHipnXR63zLxq0Tyjw=;
	b=irz60EQIjNaviunYdU3ZzfNeBA/xUzpiRY+g+9TrAKCOImo/git9BRiZ0fZtEAAFNKdX
	 cFJJa62HCuVAZvfa8FR/zqmmb97RkVx2XEzNzMJewGGaf1DT/wgoYqBXhYqdDT3JP2vMJ
	 UVK+3RZG0RvCkkSCuwVCSfFpttTF8ta/cr7SqAPLMXatPr6W1e5+QnvK5exS3i6mnHZAf
	 WlZQwC+To/8Mihb1aXvTGVUyLYwWz6DQaHALWy7f2A5sK25DUSBUNayYO2NCMurKBECSm
	 Mp6YVe1dPz0x9+NTj5fU+P5qLND++62RC03jQLgxbWd2M+xBEqkLoW9NhhIdFb1k6yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTNsdHuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D62F606A31C;
	Wed, 28 Oct 2026 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTNsdHuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6391F01825;
	Wed, 28 Oct 2026 17:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208434;
	bh=oiaKtEGkhG5rvVZjADRyp43lwQHipnXR63zLxq0Tyjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTNsdHuoOPciinf0MQ8RFLKw27Bgy/k5ilb7tW5Q7X+UJ5AZm1dxCIU9TAklnxjda
	 I4AksrVP5e3yfrhvJs6A0M4p+hja572WzZbIr2UKJB0TuNYIVrYWfml51mk4kcDWbH
	 Vkc/yxgTy/MrIFFdS7bb4dY7rTVn/PuqOtO0S8CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang He <peiyang_he@smail.nju.edu.cn>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/516] drm/nouveau: dont bump pin count on failed re-pin in nouveau_bo_pin_locked()
Date: Wed, 28 Oct 2026 17:54:30 +0100
Message-ID: <20261028170006.313596780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang He <peiyang_he@smail.nju.edu.cn>

[ Upstream commit 6a6870d3077faa501ca97760057ddca22b68418d ]

nouveau_bo_pin_locked() checks whether an already pinned BO is in a
memory domain compatible with a new pin request. When the domains are
incompatible, it sets -EBUSY but still calls ttm_bo_pin() before
returning.

Callers treat a failed nouveau_bo_pin() as not having acquired a new pin,
so the extra pin count is never decreased by a matching unpin.
This triggers the warning in ttm_bo_release():

	WARN_ON_ONCE(bo->pin_count);

Found when fuzzing the nouveau driver with a modified Syzkaller:

	WARNING: drivers/gpu/drm/ttm/ttm_bo.c:256 at ttm_bo_release+0x827/0x9e0 drivers/gpu/drm/ttm/ttm_bo.c:256, CPU#1: syz.3.24/2212
	Modules linked in:
	CPU: 1 UID: 0 PID: 2212 Comm: syz.3.24 Not tainted 7.2.0 #24 PREEMPT(lazy)
	nouveau 0000:01:00.0: gsp:msg fn:103 len:0x40/0x20 res:0x19 resp:0x19
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
	RIP: 0010:ttm_bo_release+0x827/0x9e0 drivers/gpu/drm/ttm/ttm_bo.c:256
	Code: 02 00 0f 85 51 01 00 00 48 8b 7b 08 e8 d2 20 01 00 e9 80 fd ff ff e8 d8 15 c0 fe 90 0f 0b 90 e9 e1 f8 ff ff e8 ca 15 c0 fe 90 <0f> 0b 90 e9 a4 f8 ff ff e8 bc 15 c0 fe be 03 00 00 00 4c 89 e7 e8
	msg: 00000000: 05 00 d0 c1 04 00 f0 f1 01 30 00 00 2d 90 00 00  .........0..-...
	RSP: 0018:ffffc9000f5cf710 EFLAGS: 00010293
	RAX: 0000000000000000 RBX: ffff888018e5d2a8 RCX: ffffffff82bb1b36
	RDX: ffff888017b68000 RSI: 0000000000000004 RDI: ffff888018e5d2a8
	msg: 00000010: 19 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
	RBP: ffff88801261c720 R08: 0000000000000001 R09: ffffed10031cba55
	R10: ffff888018e5d2ab R11: 00000000000000f3 R12: ffff888018e5d290
	R13: ffff888018e5d2d4 R14: ffff88801b219c18 R15: dffffc0000000000
	FS:  0000000000000000(0000) GS:ffff8880e0f6f000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000001b31223ffc CR3: 0000000028e00005 CR4: 0000000000770ef0
	PKRU: 80000000
	Call Trace:
	<TASK>
	kref_put include/linux/kref.h:65 [inline]
	ttm_bo_put drivers/gpu/drm/ttm/ttm_bo.c:325 [inline]
	ttm_bo_fini+0x55/0x80 drivers/gpu/drm/ttm/ttm_bo.c:330
	nouveau_gem_object_del+0xb2/0x1b0 drivers/gpu/drm/nouveau/nouveau_gem.c:90
	drm_gem_object_free+0x5f/0x90 drivers/gpu/drm/drm_gem.c:1165
	kref_put include/linux/kref.h:65 [inline]
	__drm_gem_object_put include/drm/drm_gem.h:562 [inline]
	drm_gem_object_put include/drm/drm_gem.h:575 [inline]
	nouveau_abi16_chan_fini.constprop.0+0x44f/0x5a0 drivers/gpu/drm/nouveau/nouveau_abi16.c:195
	nouveau 0000:01:00.0: syz.2.23[2209]: Unknown handle 0x00000000
	nouveau_abi16_fini+0x1d0/0x340 drivers/gpu/drm/nouveau/nouveau_abi16.c:225
	nouveau_drm_postclose+0x18b/0x3e0 drivers/gpu/drm/nouveau/nouveau_drm.c:1284
	nouveau 0000:01:00.0: syz.2.23[2209]: validate_init
	drm_file_free.part.0+0x6d6/0xb60 drivers/gpu/drm/drm_file.c:267
	drm_file_free drivers/gpu/drm/drm_file.c:237 [inline]
	drm_close_helper.isra.0+0x11a/0x160 drivers/gpu/drm/drm_file.c:290
	drm_release+0x1ab/0x330 drivers/gpu/drm/drm_file.c:438
	__fput+0x39c/0xa60 fs/file_table.c:512
	nouveau 0000:01:00.0: syz.2.23[2209]: validate: -2
	task_work_run+0x15a/0x230 kernel/task_work.c:233
	exit_task_work include/linux/task_work.h:40 [inline]
	do_exit+0x82b/0x25a0 kernel/exit.c:1009
	do_group_exit+0xc2/0x280 kernel/exit.c:1152
	get_signal+0x1d6e/0x1f30 kernel/signal.c:3046
	arch_do_signal_or_restart+0x7d/0x6e0 arch/x86/kernel/signal.c:337
	__exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
	exit_to_user_mode_loop+0xdf/0x440 kernel/entry/common.c:101
	__exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
	syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
	syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
	do_syscall_64+0x4f8/0x690 arch/x86/entry/syscall_64.c:100
	entry_SYSCALL_64_after_hwframe+0x77/0x7f
	RIP: 0033:0x7f12bac8594d
	Code: Unable to access opcode bytes at 0x7f12bac85923.
	RSP: 002b:00007f12b96e70d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
	RAX: 0000000000000001 RBX: 00007f12baf15fa8 RCX: 00007f12bac8594d
	RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f12baf15fac
	RBP: 00007f12baf15fa0 R08: 00007f12baee8000 R09: 0000000000000000
	R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
	R13: 00007f12baf16038 R14: 0000000000000006 R15: 00007ffe2ed394b0
	</TASK>
	irq event stamp: 47867
	hardirqs last  enabled at (47883): [<ffffffff815cafc6>] __up_console_sem+0x66/0x70 kernel/printk/printk.c:347
	hardirqs last disabled at (47892): [<ffffffff815cafab>] __up_console_sem+0x4b/0x70 kernel/printk/printk.c:345
	softirqs last  enabled at (47880): [<ffffffff81434277>] __do_softirq kernel/softirq.c:656 [inline]
	softirqs last  enabled at (47880): [<ffffffff81434277>] invoke_softirq kernel/softirq.c:496 [inline]
	softirqs last  enabled at (47880): [<ffffffff81434277>] __irq_exit_rcu+0x137/0x1c0 kernel/softirq.c:735
	softirqs last disabled at (47875): [<ffffffff81434277>] __do_softirq kernel/softirq.c:656 [inline]
	softirqs last disabled at (47875): [<ffffffff81434277>] invoke_softirq kernel/softirq.c:496 [inline]
	softirqs last disabled at (47875): [<ffffffff81434277>] __irq_exit_rcu+0x137/0x1c0 kernel/softirq.c:735

Fix by calling ttm_bo_pin() only when the existing placement is compatible
with the new pin request. This matches the correct behavior in other DRM
drivers such as amdgpu_bo_pin() in amdgpu.

Cc: stable@vger.kernel.org
Fixes: ad76b3f7c7a0 ("drm/nouveau: teach nouveau_bo_pin() how to force a contig vram allocation")
Signed-off-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
Assisted-by: LLM
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/EACEF2F4E098413F+20260918025312.2814889-1-peiyang_he@smail.nju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index bc3ffd2c942fd..023da613402c2 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -474,8 +474,9 @@ nouveau_bo_pin(struct nouveau_bo *nvbo, uint32_t domain, bool contig)
 				      "0x%08x vs 0x%08x\n", bo,
 				 bo->mem.mem_type, domain);
 			ret = -EBUSY;
+		} else {
+			ttm_bo_pin(&nvbo->bo);
 		}
-		ttm_bo_pin(&nvbo->bo);
 		goto out;
 	}
 
-- 
2.53.0



