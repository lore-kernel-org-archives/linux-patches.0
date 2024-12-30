Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5815E8B;
	Mon, 30 Dec 2024 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573858; cv=none; b=Z2znUKKHBo6NPeQ1fFoxUQoYrpnfuFmn+DE23TXTRBOah8BCFaDo6JjkcMG7pJ/6KHngu0ASiQNCKuCvtrPgohtugiOQKQOgxfX+no4k14nYsWqFPgu1AX6/bnvCNPrlfkQtPFqNdkFZ8mCgvoQvE+ZlffC+3BjhxPB5l5xnMjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573858; c=relaxed/simple;
	bh=0mqz514slea1G/a5ZbJjLxW1Scu9/HPC+yZEjue96H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObYQB4LXqtdiLkdwFWMmR8pvKwf8lCyvnXWsyILArdmQT1xPdymRAcPf5dXp2S0Xd9hV8VfBV3PkjssLs3sW/JPQ/BygfXGzSmiyboXR8ylfWaZJk3tOBla4WT5SfSmFMb+BomgV+7UUGk1Ntd5EjkHkNCIbhRmFdC6EoCYESLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXZ0q/C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXZ0q/C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E6CC4CED0;
	Mon, 30 Dec 2024 15:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573858;
	bh=0mqz514slea1G/a5ZbJjLxW1Scu9/HPC+yZEjue96H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXZ0q/C5TiwF3wsZfAtXNEoaFpMvUwQBKev+0eKOFHgBul3+Q1RSGUxc99/a5mUsd
	 bX0XH0RNbAYG3g1F4QmU+Pz6V9Mavb6dGTMsK/aLz6mplPCMk/TL2jkV5dXZQUKwqg
	 /gJ+We/h3HwNLonJnAyI/S1p6PUB0YMlyNHrwWxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	Andrew Yang <andrew.yang@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Casper Li <casper.li@mediatek.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chinwen Chang <chinwen.chang@mediatek.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 54/86] sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers
Date: Mon, 30 Dec 2024 16:43:02 +0100
Message-ID: <20241230154213.773955654@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qun-Wei Lin <qun-wei.lin@mediatek.com>

[ Upstream commit fd7b4f9f46d46acbc7af3a439bb0d869efdc5c58 ]

When CONFIG_KASAN_SW_TAGS and CONFIG_KASAN_STACK are enabled, the
object_is_on_stack() function may produce incorrect results due to the
presence of tags in the obj pointer, while the stack pointer does not have
tags.  This discrepancy can lead to incorrect stack object detection and
subsequently trigger warnings if CONFIG_DEBUG_OBJECTS is also enabled.

Example of the warning:

ODEBUG: object 3eff800082ea7bb0 is NOT on stack ffff800082ea0000, but annotated.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at lib/debugobjects.c:557 __debug_object_init+0x330/0x364
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.0-rc5 #4
Hardware name: linux,dummy-virt (DT)
pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __debug_object_init+0x330/0x364
lr : __debug_object_init+0x330/0x364
sp : ffff800082ea7b40
x29: ffff800082ea7b40 x28: 98ff0000c0164518 x27: 98ff0000c0164534
x26: ffff800082d93ec8 x25: 0000000000000001 x24: 1cff0000c00172a0
x23: 0000000000000000 x22: ffff800082d93ed0 x21: ffff800081a24418
x20: 3eff800082ea7bb0 x19: efff800000000000 x18: 0000000000000000
x17: 00000000000000ff x16: 0000000000000047 x15: 206b63617473206e
x14: 0000000000000018 x13: ffff800082ea7780 x12: 0ffff800082ea78e
x11: 0ffff800082ea790 x10: 0ffff800082ea79d x9 : 34d77febe173e800
x8 : 34d77febe173e800 x7 : 0000000000000001 x6 : 0000000000000001
x5 : feff800082ea74b8 x4 : ffff800082870a90 x3 : ffff80008018d3c4
x2 : 0000000000000001 x1 : ffff800082858810 x0 : 0000000000000050
Call trace:
 __debug_object_init+0x330/0x364
 debug_object_init_on_stack+0x30/0x3c
 schedule_hrtimeout_range_clock+0xac/0x26c
 schedule_hrtimeout+0x1c/0x30
 wait_task_inactive+0x1d4/0x25c
 kthread_bind_mask+0x28/0x98
 init_rescuer+0x1e8/0x280
 workqueue_init+0x1a0/0x3cc
 kernel_init_freeable+0x118/0x200
 kernel_init+0x28/0x1f0
 ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---
ODEBUG: object 3eff800082ea7bb0 is NOT on stack ffff800082ea0000, but annotated.
------------[ cut here ]------------

Link: https://lkml.kernel.org/r/20241113042544.19095-1-qun-wei.lin@mediatek.com
Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
Cc: Andrew Yang <andrew.yang@mediatek.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Casper Li <casper.li@mediatek.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Resolve line conflicts ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/task_stack.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index f158b025c175..d2117e1c8fa5 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -8,6 +8,7 @@
 
 #include <linux/sched.h>
 #include <linux/magic.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
@@ -88,6 +89,7 @@ static inline int object_is_on_stack(const void *obj)
 {
 	void *stack = task_stack_page(current);
 
+	obj = kasan_reset_tag(obj);
 	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
 }
 
-- 
2.39.5



