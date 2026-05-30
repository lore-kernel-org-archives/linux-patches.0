Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF543438AE;
	Sat, 30 May 2026 16:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159838; cv=none; b=HDzPvqjr/18kxfGoIVmgf6GV2qvWJJr4qE3MFCaPozMPezTPjcWUpGcnaizb1BsQSuNyN6h6j8R4JcxoFbSvYqf/wig1DXTfrKmQc8pYrCYqN7HUonDYmre8LnWnkzVrOl6xgdfd0X7RH45L3vsjlmzWW8TpgJ2A5BmdhVZ+nls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159838; c=relaxed/simple;
	bh=Kl13uFrxYqD0tUoien6snMLqKXMcDu+lPlQUcodWaBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaEbsrjsksvG0XMigXW0UFW60nmHx5GE6FYtP1TRaC45EfYH8m/X3DTmA/WmpYOzbqsgMq6/60Rpv822gGVF2ac7BxIUEpek6anSG1n9U+1dNzWZUbQ+P8rUV+pUlNO/Ijy9bkTj5F2czXjbGbyvlXAnprpBsXxoF1jDSadlrWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzNnndzJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzNnndzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E531F00893;
	Sat, 30 May 2026 16:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159836;
	bh=fVvU8E85ylU0Jztrq3ogaP8dJ/1Mpza6cR64wHPdcvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzNnndzJ7UeBB9vyteHLmq36Q7u6sJV3y1h8YIaOqQO5XZ/HQ7hgNNUfc3f5UJEY2
	 NDLZ1Wsl+gfW/RHH7X6Yn3HsSihnktjb/QZ7XO64taU83IPN6CuLavFQN83LlUxkF/
	 j6Oln0xmRMU5TefbM155qBE14YwByeHvZGNIXCY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngmin Nam <youngmin.nam@samsung.com>,
	SEO HOYOUNG <hy50.seo@samsung.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Leon Chen <leonchen.oss@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 175/969] arm64: set __exception_irq_entry with __irq_entry as a default
Date: Sat, 30 May 2026 17:54:59 +0200
Message-ID: <20260530160305.331216712@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngmin Nam <youngmin.nam@samsung.com>

[ Upstream commit f6794950f0e5ba37e3bbedda4d6ab0aad7395dd3 ]

filter_irq_stacks() is supposed to cut entries which are related irq entries
from its call stack.
And in_irqentry_text() which is called by filter_irq_stacks()
uses __irqentry_text_start/end symbol to find irq entries in callstack.

But it doesn't work correctly as without "CONFIG_FUNCTION_GRAPH_TRACER",
arm64 kernel doesn't include gic_handle_irq which is entry point of arm64 irq
between __irqentry_text_start and __irqentry_text_end as we discussed in below link.
https://lore.kernel.org/all/CACT4Y+aReMGLYua2rCLHgFpS9io5cZC04Q8GLs-uNmrn1ezxYQ@mail.gmail.com/#t

This problem can makes unintentional deep call stack entries especially
in KASAN enabled situation as below.

[ 2479.383395]I[0:launcher-loader: 1719] Stack depot reached limit capacity
[ 2479.383538]I[0:launcher-loader: 1719] WARNING: CPU: 0 PID: 1719 at lib/stackdepot.c:129 __stack_depot_save+0x464/0x46c
[ 2479.385693]I[0:launcher-loader: 1719] pstate: 624000c5 (nZCv daIF +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
[ 2479.385724]I[0:launcher-loader: 1719] pc : __stack_depot_save+0x464/0x46c
[ 2479.385751]I[0:launcher-loader: 1719] lr : __stack_depot_save+0x460/0x46c
[ 2479.385774]I[0:launcher-loader: 1719] sp : ffffffc0080073c0
[ 2479.385793]I[0:launcher-loader: 1719] x29: ffffffc0080073e0 x28: ffffffd00b78a000 x27: 0000000000000000
[ 2479.385839]I[0:launcher-loader: 1719] x26: 000000000004d1dd x25: ffffff891474f000 x24: 00000000ca64d1dd
[ 2479.385882]I[0:launcher-loader: 1719] x23: 0000000000000200 x22: 0000000000000220 x21: 0000000000000040
[ 2479.385925]I[0:launcher-loader: 1719] x20: ffffffc008007440 x19: 0000000000000000 x18: 0000000000000000
[ 2479.385969]I[0:launcher-loader: 1719] x17: 2065726568207475 x16: 000000000000005e x15: 2d2d2d2d2d2d2d20
[ 2479.386013]I[0:launcher-loader: 1719] x14: 5d39313731203a72 x13: 00000000002f6b30 x12: 00000000002f6af8
[ 2479.386057]I[0:launcher-loader: 1719] x11: 00000000ffffffff x10: ffffffb90aacf000 x9 : e8a74a6c16008800
[ 2479.386101]I[0:launcher-loader: 1719] x8 : e8a74a6c16008800 x7 : 00000000002f6b30 x6 : 00000000002f6af8
[ 2479.386145]I[0:launcher-loader: 1719] x5 : ffffffc0080070c8 x4 : ffffffd00b192380 x3 : ffffffd0092b313c
[ 2479.386189]I[0:launcher-loader: 1719] x2 : 0000000000000001 x1 : 0000000000000004 x0 : 0000000000000022
[ 2479.386231]I[0:launcher-loader: 1719] Call trace:
[ 2479.386248]I[0:launcher-loader: 1719]  __stack_depot_save+0x464/0x46c
[ 2479.386273]I[0:launcher-loader: 1719]  kasan_save_stack+0x58/0x70
[ 2479.386303]I[0:launcher-loader: 1719]  save_stack_info+0x34/0x138
[ 2479.386331]I[0:launcher-loader: 1719]  kasan_save_free_info+0x18/0x24
[ 2479.386358]I[0:launcher-loader: 1719]  ____kasan_slab_free+0x16c/0x170
[ 2479.386385]I[0:launcher-loader: 1719]  __kasan_slab_free+0x10/0x20
[ 2479.386410]I[0:launcher-loader: 1719]  kmem_cache_free+0x238/0x53c
[ 2479.386435]I[0:launcher-loader: 1719]  mempool_free_slab+0x1c/0x28
[ 2479.386460]I[0:launcher-loader: 1719]  mempool_free+0x7c/0x1a0
[ 2479.386484]I[0:launcher-loader: 1719]  bvec_free+0x34/0x80
[ 2479.386514]I[0:launcher-loader: 1719]  bio_free+0x60/0x98
[ 2479.386540]I[0:launcher-loader: 1719]  bio_put+0x50/0x21c
[ 2479.386567]I[0:launcher-loader: 1719]  f2fs_write_end_io+0x4ac/0x4d0
[ 2479.386594]I[0:launcher-loader: 1719]  bio_endio+0x2dc/0x300
[ 2479.386622]I[0:launcher-loader: 1719]  __dm_io_complete+0x324/0x37c
[ 2479.386650]I[0:launcher-loader: 1719]  dm_io_dec_pending+0x60/0xa4
[ 2479.386676]I[0:launcher-loader: 1719]  clone_endio+0xf8/0x2f0
[ 2479.386700]I[0:launcher-loader: 1719]  bio_endio+0x2dc/0x300
[ 2479.386727]I[0:launcher-loader: 1719]  blk_update_request+0x258/0x63c
[ 2479.386754]I[0:launcher-loader: 1719]  scsi_end_request+0x50/0x304
[ 2479.386782]I[0:launcher-loader: 1719]  scsi_io_completion+0x88/0x160
[ 2479.386808]I[0:launcher-loader: 1719]  scsi_finish_command+0x17c/0x194
[ 2479.386833]I[0:launcher-loader: 1719]  scsi_complete+0xcc/0x158
[ 2479.386859]I[0:launcher-loader: 1719]  blk_mq_complete_request+0x4c/0x5c
[ 2479.386885]I[0:launcher-loader: 1719]  scsi_done_internal+0xf4/0x1e0
[ 2479.386910]I[0:launcher-loader: 1719]  scsi_done+0x14/0x20
[ 2479.386935]I[0:launcher-loader: 1719]  ufshcd_compl_one_cqe+0x578/0x71c
[ 2479.386963]I[0:launcher-loader: 1719]  ufshcd_mcq_poll_cqe_nolock+0xc8/0x150
[ 2479.386991]I[0:launcher-loader: 1719]  ufshcd_intr+0x868/0xc0c
[ 2479.387017]I[0:launcher-loader: 1719]  __handle_irq_event_percpu+0xd0/0x348
[ 2479.387044]I[0:launcher-loader: 1719]  handle_irq_event_percpu+0x24/0x74
[ 2479.387068]I[0:launcher-loader: 1719]  handle_irq_event+0x74/0xe0
[ 2479.387091]I[0:launcher-loader: 1719]  handle_fasteoi_irq+0x174/0x240
[ 2479.387118]I[0:launcher-loader: 1719]  handle_irq_desc+0x7c/0x2c0
[ 2479.387147]I[0:launcher-loader: 1719]  generic_handle_domain_irq+0x1c/0x28
[ 2479.387174]I[0:launcher-loader: 1719]  gic_handle_irq+0x64/0x158
[ 2479.387204]I[0:launcher-loader: 1719]  call_on_irq_stack+0x2c/0x54
[ 2479.387231]I[0:launcher-loader: 1719]  do_interrupt_handler+0x70/0xa0
[ 2479.387258]I[0:launcher-loader: 1719]  el1_interrupt+0x34/0x68
[ 2479.387283]I[0:launcher-loader: 1719]  el1h_64_irq_handler+0x18/0x24
[ 2479.387308]I[0:launcher-loader: 1719]  el1h_64_irq+0x68/0x6c
[ 2479.387332]I[0:launcher-loader: 1719]  blk_attempt_bio_merge+0x8/0x170
[ 2479.387356]I[0:launcher-loader: 1719]  blk_mq_attempt_bio_merge+0x78/0x98
[ 2479.387383]I[0:launcher-loader: 1719]  blk_mq_submit_bio+0x324/0xa40
[ 2479.387409]I[0:launcher-loader: 1719]  __submit_bio+0x104/0x138
[ 2479.387436]I[0:launcher-loader: 1719]  submit_bio_noacct_nocheck+0x1d0/0x4a0
[ 2479.387462]I[0:launcher-loader: 1719]  submit_bio_noacct+0x618/0x804
[ 2479.387487]I[0:launcher-loader: 1719]  submit_bio+0x164/0x180
[ 2479.387511]I[0:launcher-loader: 1719]  f2fs_submit_read_bio+0xe4/0x1c4
[ 2479.387537]I[0:launcher-loader: 1719]  f2fs_mpage_readpages+0x888/0xa4c
[ 2479.387563]I[0:launcher-loader: 1719]  f2fs_readahead+0xd4/0x19c
[ 2479.387587]I[0:launcher-loader: 1719]  read_pages+0xb0/0x4ac
[ 2479.387614]I[0:launcher-loader: 1719]  page_cache_ra_unbounded+0x238/0x288
[ 2479.387642]I[0:launcher-loader: 1719]  do_page_cache_ra+0x60/0x6c
[ 2479.387669]I[0:launcher-loader: 1719]  page_cache_ra_order+0x318/0x364
[ 2479.387695]I[0:launcher-loader: 1719]  ondemand_readahead+0x30c/0x3d8
[ 2479.387722]I[0:launcher-loader: 1719]  page_cache_sync_ra+0xb4/0xc8
[ 2479.387749]I[0:launcher-loader: 1719]  filemap_read+0x268/0xd24
[ 2479.387777]I[0:launcher-loader: 1719]  f2fs_file_read_iter+0x1a0/0x62c
[ 2479.387806]I[0:launcher-loader: 1719]  vfs_read+0x258/0x34c
[ 2479.387831]I[0:launcher-loader: 1719]  ksys_pread64+0x8c/0xd0
[ 2479.387857]I[0:launcher-loader: 1719]  __arm64_sys_pread64+0x48/0x54
[ 2479.387881]I[0:launcher-loader: 1719]  invoke_syscall+0x58/0x158
[ 2479.387909]I[0:launcher-loader: 1719]  el0_svc_common+0xf0/0x134
[ 2479.387935]I[0:launcher-loader: 1719]  do_el0_svc+0x44/0x114
[ 2479.387961]I[0:launcher-loader: 1719]  el0_svc+0x2c/0x80
[ 2479.387985]I[0:launcher-loader: 1719]  el0t_64_sync_handler+0x48/0x114
[ 2479.388010]I[0:launcher-loader: 1719]  el0t_64_sync+0x190/0x194
[ 2479.388038]I[0:launcher-loader: 1719] Kernel panic - not syncing: kernel: panic_on_warn set ...

So let's set __exception_irq_entry with __irq_entry as a default.
Applying this patch, we can see gic_hande_irq is included in Systemp.map as below.

* Before
ffffffc008010000 T __do_softirq
ffffffc008010000 T __irqentry_text_end
ffffffc008010000 T __irqentry_text_start
ffffffc008010000 T __softirqentry_text_start
ffffffc008010000 T _stext
ffffffc00801066c T __softirqentry_text_end
ffffffc008010670 T __entry_text_start

* After
ffffffc008010000 T __irqentry_text_start
ffffffc008010000 T _stext
ffffffc008010000 t gic_handle_irq
ffffffc00801013c t gic_handle_irq
ffffffc008010294 T __irqentry_text_end
ffffffc008010298 T __do_softirq
ffffffc008010298 T __softirqentry_text_start
ffffffc008010904 T __softirqentry_text_end
ffffffc008010908 T __entry_text_start

Signed-off-by: Youngmin Nam <youngmin.nam@samsung.com>
Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20230424010436.779733-1-youngmin.nam@samsung.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/exception.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/exception.h b/arch/arm64/include/asm/exception.h
index 19713d0f013b7..18dbb35a337f7 100644
--- a/arch/arm64/include/asm/exception.h
+++ b/arch/arm64/include/asm/exception.h
@@ -8,16 +8,11 @@
 #define __ASM_EXCEPTION_H
 
 #include <asm/esr.h>
-#include <asm/kprobes.h>
 #include <asm/ptrace.h>
 
 #include <linux/interrupt.h>
 
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
 #define __exception_irq_entry	__irq_entry
-#else
-#define __exception_irq_entry	__kprobes
-#endif
 
 static inline unsigned long disr_to_esr(u64 disr)
 {
-- 
2.53.0



