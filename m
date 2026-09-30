Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3210330566A;
	Wed, 30 Sep 2026 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794772; cv=none; b=cZU3Iw9/OetPISTvEpdV/AMCz4j8nj3u1sOOqh1ejB7YDf4vTgt2PtNbpWCW/hgNrJjVIAw9oK6VYXlu1ZW38fFGGd//3HGeSmxGbc97WVB/HSE99H8nMju1tCZL1MQsd6ae10euyQei6J59DKo0PW1enIwaVjGq+BF/drCuPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794772; c=relaxed/simple;
	bh=EAGAGdMKjQ7ymTRndlOdB8e2GAv/wKJI4ZgwMWGOIK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=douxuskxfVNPwBVeYWRe6n4WnnNCODuCFeS/f7dM+ZPtp+Xt3ifXv9j+ZXW6gXS0/kEAXT60xU+tB9dDyVKLuxlAiyXIO0M60XrlPeikHZ00hTKVCCt0iRWAbw9t+4x6E4a7yrQZT8R7FiZhq9xz2/W+vTO120ll1OUDqO5+7bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmGvTPfG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmGvTPfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF631F000FF;
	Wed, 30 Sep 2026 18:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794770;
	bh=RcSr2NNLB/zRAI3H708Q44NMedkWRJN/x3yNb4GANYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QmGvTPfG87RhXrU67T4/o27S3E9bHuFHkqMJwAyDFYkn3dk3bh5u76emYq4MskqUp
	 vfnChDqEqwiGIZ/dBPLTEVLxNWr5opvwtbwcGtYxFeCkVVoAMppE2voDhT4UuZ1NBa
	 jm9BgK8GIqE0AVUZBnPh3konYJz7ZwWiwsoQ8c+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0283/1193] drm/amdgpu: flush pending RCU callbacks on module unload
Date: Wed, 30 Sep 2026 17:16:07 +0200
Message-ID: <20260930152440.452167616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 67a654b41cfa73c3b83402c4a01b2689cad5b9bc ]

Call rcu_barrier() in module exit to wait for outstanding call_rcu() callbacks
before freeing module text, preventing late callback execution in freed memory.

BUG: unable to handle page fault for address: ffffffffc1d59c40
PGD 6a12067 P4D 6a12067 PUD 6a14067 PMD 13698b067 PTE 0
Oops: 0010 [#1] SMP NOPTI
RIP: 0010:0xffffffffc1d59c40
Code: Unable to access opcode bytes at RIP 0xffffffffc1d59c16.
RSP: 0018:ffffc900198c0f28 EFLAGS: 00010286
RAX: ffffffffc1d59c40 RBX: ffff897c7d6b61c0 RCX: ffff88826aff4590
RDX: ffff8884d8b35490 RSI: ffffc900198c0f30 RDI: ffff88812af67290
RBP: 000000000000000a (DONE segment entries) R08: 0000000000000000 R09: 0000000000000100
R10: 0000000000000000 R11: ffffffff82a06100 R12: ffff88811a4e3700
R13: 0000000000000000 R14: ffff897c7d6b6270 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff897c7d680000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffc1d59c16 CR3: 00000104a980a001 CR4: 0000000002770ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <IRQ>
 ? rcu_do_batch+0x163/0x450
 ? rcu_core+0x177/0x1c0
 ? __do_softirq+0xc1/0x280
 ? asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 ? do_softirq_own_stack+0x37/0x50
 ? irq_exit_rcu+0xc4/0x100
 ? sysvec_apic_timer_interrupt+0x36/0x80
 ? asm_sysvec_apic_timer_interrupt+0x12/0x20
 ? cpuidle_enter_state+0xd4/0x360
 ? cpuidle_enter+0x29/0x40
 ? cpuidle_idle_call+0x108/0x1a0
 ? do_idle+0x77/0xf0
 ? cpu_startup_entry+0x19/0x20
 ? secondary_startup_64_no_verify+0xbf/0xcb

Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit feaa5039f6c12acc9aa934c2d45dcd251a12c69f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 90fe4833240f4..bb137063bae11 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2938,6 +2938,14 @@ static void __exit amdgpu_exit(void)
 	amdgpu_fence_slab_fini();
 	mmu_notifier_synchronize();
 	amdgpu_xcp_drv_release();
+
+	/*
+	 * Flush outstanding call_rcu() callbacks before the
+	 * module text is freed.  Otherwise a grace period elapsing after
+	 * unload invokes a callback in already-freed module memory and
+	 * faults in rcu_do_batch().
+	 */
+	rcu_barrier();
 }
 
 module_init(amdgpu_init);
-- 
2.53.0



