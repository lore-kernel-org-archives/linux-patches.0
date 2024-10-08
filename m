Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C33192594;
	Tue,  8 Oct 2024 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391409; cv=none; b=ME4O5o6zSSA9U4aHw2e95xkKxfMixZwYVHMVzHMlHgOAmwinH0L/xfXY+x+z/cocKcwVtq4hwzqSbx9A2FCjWfcW6R+aNBlqqtIlGIETaGC9hoZsj1r8shDBVe+FerGBDd3JnTL2zfF3eFc2569KDjwk3TrjGaPnngfe27LZixM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391409; c=relaxed/simple;
	bh=z1Uz/vQLxiOFve8ctwb/tUUo7gq2sqh42h9u0pu0Q54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=shHkKBlTJanI4P0u1VBaUETIyWBKuu8RvaTRtihfUrr/v4p61exX81wDWLX1PcJwfxiPzF5/PkMqfgxV0MZWSiAf6CKREsQE2Lz+tnzhrRFZ42NZus/mhOuVk/4A5p+Lyy5gjMD/a+zBIIsQuqvbPmtR/U0KHN0X0Jq9mJjeJK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rsHNxVGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rsHNxVGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCDFC4CEC7;
	Tue,  8 Oct 2024 12:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391409;
	bh=z1Uz/vQLxiOFve8ctwb/tUUo7gq2sqh42h9u0pu0Q54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rsHNxVGVoyjWuztQwwP6AzYwwLBTd+nvhDomH7VO3KmDaYaX+dJIzfCO67ne/Q7x6
	 LDd3x0AUMZXGcvIXbDjVmhtR/j5FxCPNNRbcMZc9g7ywfK5J29DENw6knzTFPsS6oh
	 qEYXDpqAaZ/yGDcjmpIQnPQ8tQ1YN4rteOgKjtD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 073/558] drm/xe: Prevent null pointer access in xe_migrate_copy
Date: Tue,  8 Oct 2024 14:01:43 +0200
Message-ID: <20241008115705.091933089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhanjun Dong <zhanjun.dong@intel.com>

[ Upstream commit 7257d9c9a3c6cfe26c428e9b7ae21d61f2f55a79 ]

xe_migrate_copy designed to copy content of TTM resources. When source
resource is null, it will trigger a NULL pointer dereference in
xe_migrate_copy. To avoid this situation, update lacks source flag to
true for this case, the flag will trigger xe_migrate_clear rather than
xe_migrate_copy.

Issue trace:
<7> [317.089847] xe 0000:00:02.0: [drm:xe_migrate_copy [xe]] Pass 14,
 sizes: 4194304 & 4194304
<7> [317.089945] xe 0000:00:02.0: [drm:xe_migrate_copy [xe]] Pass 15,
 sizes: 4194304 & 4194304
<1> [317.128055] BUG: kernel NULL pointer dereference, address:
 0000000000000010
<1> [317.128064] #PF: supervisor read access in kernel mode
<1> [317.128066] #PF: error_code(0x0000) - not-present page
<6> [317.128069] PGD 0 P4D 0
<4> [317.128071] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
<4> [317.128074] CPU: 1 UID: 0 PID: 1440 Comm: kunit_try_catch Tainted:
 G     U           N 6.11.0-rc7-xe #1
<4> [317.128078] Tainted: [U]=USER, [N]=TEST
<4> [317.128080] Hardware name: Intel Corporation Lunar Lake Client
 Platform/LNL-M LP5 RVP1, BIOS LNLMFWI1.R00.3221.D80.2407291239 07/29/2024
<4> [317.128082] RIP: 0010:xe_migrate_copy+0x66/0x13e0 [xe]
<4> [317.128158] Code: 00 00 48 89 8d e0 fe ff ff 48 8b 40 10 4c 89 85 c8
 fe ff ff 44 88 8d bd fe ff ff 65 48 8b 3c 25 28 00 00 00 48 89 7d d0 31
 ff <8b> 79 10 48 89 85 a0 fe ff ff 48 8b 00 48 89 b5 d8 fe ff ff 83 ff
<4> [317.128162] RSP: 0018:ffffc9000167f9f0 EFLAGS: 00010246
<4> [317.128164] RAX: ffff8881120d8028 RBX: ffff88814d070428 RCX:
 0000000000000000
<4> [317.128166] RDX: ffff88813cb99c00 RSI: 0000000004000000 RDI:
 0000000000000000
<4> [317.128168] RBP: ffffc9000167fbb8 R08: ffff88814e7b1f08 R09:
 0000000000000001
<4> [317.128170] R10: 0000000000000001 R11: 0000000000000001 R12:
 ffff88814e7b1f08
<4> [317.128172] R13: ffff88814e7b1f08 R14: ffff88813cb99c00 R15:
 0000000000000001
<4> [317.128174] FS:  0000000000000000(0000) GS:ffff88846f280000(0000)
 knlGS:0000000000000000
<4> [317.128176] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4> [317.128178] CR2: 0000000000000010 CR3: 000000011f676004 CR4:
 0000000000770ef0
<4> [317.128180] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
 0000000000000000
<4> [317.128182] DR3: 0000000000000000 DR6: 00000000ffff07f0 DR7:
 0000000000000400
<4> [317.128184] PKRU: 55555554
<4> [317.128185] Call Trace:
<4> [317.128187]  <TASK>
<4> [317.128189]  ? show_regs+0x67/0x70
<4> [317.128194]  ? __die_body+0x20/0x70
<4> [317.128196]  ? __die+0x2b/0x40
<4> [317.128198]  ? page_fault_oops+0x15f/0x4e0
<4> [317.128203]  ? do_user_addr_fault+0x3fb/0x970
<4> [317.128205]  ? lock_acquire+0xc7/0x2e0
<4> [317.128209]  ? exc_page_fault+0x87/0x2b0
<4> [317.128212]  ? asm_exc_page_fault+0x27/0x30
<4> [317.128216]  ? xe_migrate_copy+0x66/0x13e0 [xe]
<4> [317.128263]  ? __lock_acquire+0xb9d/0x26f0
<4> [317.128265]  ? __lock_acquire+0xb9d/0x26f0
<4> [317.128267]  ? sg_free_append_table+0x20/0x80
<4> [317.128271]  ? lock_acquire+0xc7/0x2e0
<4> [317.128273]  ? mark_held_locks+0x4d/0x80
<4> [317.128275]  ? trace_hardirqs_on+0x1e/0xd0
<4> [317.128278]  ? _raw_spin_unlock_irqrestore+0x31/0x60
<4> [317.128281]  ? __pm_runtime_resume+0x60/0xa0
<4> [317.128284]  xe_bo_move+0x682/0xc50 [xe]
<4> [317.128315]  ? lock_is_held_type+0xaa/0x120
<4> [317.128318]  ttm_bo_handle_move_mem+0xe5/0x1a0 [ttm]
<4> [317.128324]  ttm_bo_validate+0xd1/0x1a0 [ttm]
<4> [317.128328]  shrink_test_run_device+0x721/0xc10 [xe]
<4> [317.128360]  ? find_held_lock+0x31/0x90
<4> [317.128363]  ? lock_release+0xd1/0x2a0
<4> [317.128365]  ? __pfx_kunit_generic_run_threadfn_adapter+0x10/0x10
 [kunit]
<4> [317.128370]  xe_bo_shrink_kunit+0x11/0x20 [xe]
<4> [317.128397]  kunit_try_run_case+0x6e/0x150 [kunit]
<4> [317.128400]  ? trace_hardirqs_on+0x1e/0xd0
<4> [317.128402]  ? _raw_spin_unlock_irqrestore+0x31/0x60
<4> [317.128404]  kunit_generic_run_threadfn_adapter+0x1e/0x40 [kunit]
<4> [317.128407]  kthread+0xf5/0x130
<4> [317.128410]  ? __pfx_kthread+0x10/0x10
<4> [317.128412]  ret_from_fork+0x39/0x60
<4> [317.128415]  ? __pfx_kthread+0x10/0x10
<4> [317.128416]  ret_from_fork_asm+0x1a/0x30
<4> [317.128420]  </TASK>

Fixes: 266c85885263 ("drm/xe/xe2: Handle flat ccs move for igfx.")
Signed-off-by: Zhanjun Dong <zhanjun.dong@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240927161308.862323-2-zhanjun.dong@intel.com
(cherry picked from commit 59a1c9c7e1d02b43b415ea92627ce095b7c79e47)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 261d3d6c8a931..e147ef1d0578f 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -680,8 +680,8 @@ static int xe_bo_move(struct ttm_buffer_object *ttm_bo, bool evict,
 	tt_has_data = ttm && (ttm_tt_is_populated(ttm) ||
 			      (ttm->page_flags & TTM_TT_FLAG_SWAPPED));
 
-	move_lacks_source = handle_system_ccs ? (!bo->ccs_cleared)  :
-						(!mem_type_is_vram(old_mem_type) && !tt_has_data);
+	move_lacks_source = !old_mem || (handle_system_ccs ? (!bo->ccs_cleared) :
+					 (!mem_type_is_vram(old_mem_type) && !tt_has_data));
 
 	needs_clear = (ttm && ttm->page_flags & TTM_TT_FLAG_ZERO_ALLOC) ||
 		(!ttm && ttm_bo->type == ttm_bo_type_device);
-- 
2.43.0



