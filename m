Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EF91E7C27;
	Wed, 15 Jan 2025 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937583; cv=none; b=niep4FLQ2rX8FaRKEq1/dyDN19eRWvFQrNijPXOWjBBzVUOx3BhIkLCpKO42n1U2Gn9rdg+dd4OctgdC5+f4+pT/8IKnp9ePm9U/aihp1vJDt+sUBWFBQUpM1+ou4PlebUmQbTQbxJiW30bAtJ/d18miYV5AwHOr3fNSreJwmrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937583; c=relaxed/simple;
	bh=i+c0HcKjQW3ArlxJt4Yvfjit7Qk0fPkKzomkkUtxaiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fl0iL6txJzNxPYVJA2GmVe4OzciRkcvYnTT2EoZwtyWVr9OHSTc/TZddrauckabiSl5RtSNroHfqt7NFwvBuf8O3HqcNWJPT8AxskVXIFsslBm3kj/eP4yknP3Ld7RRAcPKwVLHD/RrS2M5K4ZOdlJ2vgM1611jvl9BShyleg90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z32LoFtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z32LoFtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5ECC4CEE2;
	Wed, 15 Jan 2025 10:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937582;
	bh=i+c0HcKjQW3ArlxJt4Yvfjit7Qk0fPkKzomkkUtxaiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z32LoFtCI96MS+PaU5EyixVSZ/Vb78RIHnNLnmw7/+wJuEhP07uTmHme/xaB/9WNH
	 v7Rf98HOIc4cMh8oEgiDsP61XXXu2hcBDHz40fM5wdhN3IOPesvrEKjJMGx8sj6LQU
	 kshTZQEGSq8qFWQjYRYmGQmPzGEmODIBcmx4WMws=
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
	Alva Lan <alvalan9@foxmail.com>
Subject: [PATCH 6.1 03/92] sched/task_stack: fix object_is_on_stack() for KASAN tagged pointers
Date: Wed, 15 Jan 2025 11:36:21 +0100
Message-ID: <20250115103547.664923193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qun-Wei Lin <qun-wei.lin@mediatek.com>

commit fd7b4f9f46d46acbc7af3a439bb0d869efdc5c58 upstream.

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
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/task_stack.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -8,6 +8,7 @@
 
 #include <linux/sched.h>
 #include <linux/magic.h>
+#include <linux/kasan.h>
 
 #ifdef CONFIG_THREAD_INFO_IN_TASK
 
@@ -88,6 +89,7 @@ static inline int object_is_on_stack(con
 {
 	void *stack = task_stack_page(current);
 
+	obj = kasan_reset_tag(obj);
 	return (obj >= stack) && (obj < (stack + THREAD_SIZE));
 }
 


