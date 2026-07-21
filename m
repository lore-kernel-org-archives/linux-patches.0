Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5794344AB68;
	Tue, 21 Jul 2026 21:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668980; cv=none; b=nrQ7MEoM1y2xtBq145eelfi+LMRbb+ikS7tnEcdJ4O1bcuS9Ep2z07zmSe6Gisf72GkpviUhy7E1d2ep561vu0P3Y4EOzx8loYrp/ElaLB3NoBzhVU0Q9m5XrpXUIE3UTl1t8ElyhWkXEIfBpt5x633/ptQ1dyc/QpbfRN49E0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668980; c=relaxed/simple;
	bh=jIAIQquStT/ya0dmrTtumZQ6sFd8oIqiVdDg5/XEOA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoNfaDDpg8043M2xk0H/EtB/Zp78Zdxb5kHVLQ4Ii/pn1PrAlksctCrQ1qWZHZCDn44jE2KOmcvU55etij2OI0ozqHJ5gZjzQ/drc1hD0aSwZBagxQVA5Gn1nxfO2lmoIjFFQmUDI9WJRYvQYNIrGI2NJk/Ii2xNJGLOXLvyeNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkYJYAHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkYJYAHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C155A1F000E9;
	Tue, 21 Jul 2026 21:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668979;
	bh=xdkZTo6HCWbJigpOOtuJMrgft/WRUDTS4RbmFMqxt0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkYJYAHjV6KmsBcLF5t+Xjs00iMjDAywjKCPnqlW7affBbG4i+rKvL5Kt6wXFxcum
	 iPqrMhhhSnhP1nx39J/NLnGNbEJWLe4GlEvViJeg6sg7YiO3pCRholUGY9amYHTyGC
	 2jSS7LVyrW1NQJdZGjmnqU3sevp6PP8ho4YEhJKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	Hannes Reinecke <hare@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0338/1067] nvme-multipath: fix flex array size in struct nvme_ns_head
Date: Tue, 21 Jul 2026 17:15:39 +0200
Message-ID: <20260721152432.158054772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 001e57554de81aa79c25c18fd53911d8a415c304 ]

struct nvme_ns_head contains a flexible array member, current_path[],
which is indexed using the NUMA node ID:
head->current_path[numa_node_id()]

The structure is currently allocated as:
size = sizeof(struct nvme_ns_head) +
       (num_possible_nodes() * sizeof(struct nvme_ns *));
head = kzalloc(size, GFP_KERNEL);

This allocation assumes that NUMA node IDs are sequential and densely
packed from 0 .. num_possible_nodes() - 1. While this assumption holds
on many systems, it is not always true on some architectures such as
powerpc.

On some powerpc systems, NUMA node IDs can be sparse. For example:
NUMA:
  NUMA node(s):              6
  NUMA node0 CPU(s):         80-159
  NUMA node8 CPU(s):         0-79
  NUMA node252 CPU(s):
  NUMA node253 CPU(s):
  NUMA node254 CPU(s):
  NUMA node255 CPU(s):

That is, the possible/online NUMA node IDs are: 0, 8, 252, 253, 254, 255
In this case: num_possible_nodes() = 6

So memory is allocated for only 6 entries in current_path[]. However,
the array is later indexed using the actual NUMA node ID. As a result,
accesses such as:
head->current_path[8] or
head->current_path[252]
goes out of bounds, leading to the following KASAN splat:

==================================================================
BUG: KASAN: slab-out-of-bounds in nvme_mpath_revalidate_paths+0x22c/0x290 [nvme_core]
Write of size 8 at addr c00020003bda35b8 by task kworker/u641:2/1997

CPU: 1 UID: 0 PID: 1997 Comm: kworker/u641:2 Not tainted 7.1.0-rc5-dirty #14 PREEMPT(lazy)
Hardware name: 8335-GTH POWER9 0x4e1202 opal:skiboot-v6.5.3-35-g1851b2a06 PowerNV
Workqueue: async async_run_entry_fn
Call Trace:
[c000200037fa7510] [c0000000021c23d4] dump_stack_lvl+0x88/0xdc (unreliable)
[c000200037fa7540] [c0000000009fda90] print_report+0x22c/0x67c
[c000200037fa7630] [c0000000009fd508] kasan_report+0x108/0x220
[c000200037fa7740] [c0000000009fff48] __asan_store8+0xe8/0x120
[c000200037fa7760] [c008000018e76474] nvme_mpath_revalidate_paths+0x22c/0x290 [nvme_core]
[c000200037fa7800] [c008000018e6556c] nvme_update_ns_info+0x4a4/0x5e0 [nvme_core]
[c000200037fa7a50] [c008000018e66270] nvme_alloc_ns+0x6d8/0x1a70 [nvme_core]
[c000200037fa7c20] [c008000018e679fc] nvme_scan_ns+0x3f4/0x630 [nvme_core]
[c000200037fa7d10] [c00000000031f22c] async_run_entry_fn+0x9c/0x3a0
[c000200037fa7db0] [c0000000002fa544] process_one_work+0x414/0xa10
[c000200037fa7ec0] [c0000000002fbf00] worker_thread+0x320/0x640
[c000200037fa7f80] [c00000000030d0f8] kthread+0x278/0x290
[c000200037fa7fe0] [c00000000000ded8] start_kernel_thread+0x14/0x18

Allocated by task 1997 on cpu 1 at 35.928317s:

The buggy address belongs to the object at c00020003bda3000
 which belongs to the cache kmalloc-rnd-15-2k of size 2048
The buggy address is located 16 bytes to the right of
 allocated 1448-byte region [c00020003bda3000, c00020003bda35a8)

The buggy address belongs to the physical page:

Memory state around the buggy address:
 c00020003bda3480: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c00020003bda3500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>c00020003bda3580: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 c00020003bda3600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 c00020003bda3680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================

Fix this by allocating the flexible array using nr_node_ids instead
of num_possible_nodes(). Since nr_node_ids represents the maximum
possible NUMA node IDs, indexing current_path[] using numa_node_id()
becomes safe even on systems with sparse node IDs.

Fixes: f333444708f8 ("nvme: take node locality into account when selecting a path")
Tested-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 28f54f414e9c02..8cc2c2ab95c6eb 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4146,7 +4146,7 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	int ret = -ENOMEM;
 
 #ifdef CONFIG_NVME_MULTIPATH
-	size += num_possible_nodes() * sizeof(struct nvme_ns *);
+	size += nr_node_ids * sizeof(struct nvme_ns *);
 #endif
 
 	head = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



