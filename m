Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF3D1A1894;
	Thu,  6 Jun 2024 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683729; cv=none; b=UID+jLBrR25vn7U6J+U9aIXjhPxk9r7PKbjUE2qAZS/40QENCcekcVK9TSWYpfyqvhmi8Lpnra9sa+Vdk7caJEl9mlOmgX4jxiMCjahUGjUwUaPDOKreyegdP04GZ/iRukR7vNZwfvXCX/DzZ56jtCBr3wfEei/5i6WmoyKRuq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683729; c=relaxed/simple;
	bh=z69mAHN3SkJdNFh03YvfaHEsi87IUb4gBo6lfnhHpMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6hareecsJPE6WSGzca4ZLGENNneM/HetV/q2konQn2KbkIwO4iBsfYuMhcBLkgWl0Zko02q78LcPUggxcs6ZWJXu9cfdWCe7xjM/h7ghx4jK43mRyjLORs4lcIS4IDwZhQobyyO4Eced1Zu0FR6LG7fWGaQaM9St2FHI6rsG8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxO74+P6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxO74+P6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2B3C2BD10;
	Thu,  6 Jun 2024 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683729;
	bh=z69mAHN3SkJdNFh03YvfaHEsi87IUb4gBo6lfnhHpMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxO74+P6YUcQnt7XFEMWraGE1UOVhEmLWJuuJTXIuxYCDkU/UgAnkwwKyfRHafFOE
	 8X+PnN+QWDyVAJ38NiY1AKssC0cuhEler74vxZOFJxYXHCdyL1cq+0ah6aa23O+WI4
	 Tu5G/froZOMuJt+8Zo7Jnq3SR7VTZocY1Pc/W6NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Barry Song <baohua@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 679/744] dma-mapping: benchmark: handle NUMA_NO_NODE correctly
Date: Thu,  6 Jun 2024 16:05:51 +0200
Message-ID: <20240606131754.269060323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit e64746e74f717961250a155e14c156616fcd981f ]

cpumask_of_node() can be called for NUMA_NO_NODE inside do_map_benchmark()
resulting in the following sanitizer report:

UBSAN: array-index-out-of-bounds in ./arch/x86/include/asm/topology.h:72:28
index -1 is out of range for type 'cpumask [64][1]'
CPU: 1 PID: 990 Comm: dma_map_benchma Not tainted 6.9.0-rc6 #29
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
Call Trace:
 <TASK>
dump_stack_lvl (lib/dump_stack.c:117)
ubsan_epilogue (lib/ubsan.c:232)
__ubsan_handle_out_of_bounds (lib/ubsan.c:429)
cpumask_of_node (arch/x86/include/asm/topology.h:72) [inline]
do_map_benchmark (kernel/dma/map_benchmark.c:104)
map_benchmark_ioctl (kernel/dma/map_benchmark.c:246)
full_proxy_unlocked_ioctl (fs/debugfs/file.c:333)
__x64_sys_ioctl (fs/ioctl.c:890)
do_syscall_64 (arch/x86/entry/common.c:83)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Use cpumask_of_node() in place when binding a kernel thread to a cpuset
of a particular node.

Note that the provided node id is checked inside map_benchmark_ioctl().
It's just a NUMA_NO_NODE case which is not handled properly later.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 65789daa8087 ("dma-mapping: add benchmark support for streaming DMA APIs")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/map_benchmark.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/dma/map_benchmark.c b/kernel/dma/map_benchmark.c
index 59fb3f849b351..f7f3d14fa69a7 100644
--- a/kernel/dma/map_benchmark.c
+++ b/kernel/dma/map_benchmark.c
@@ -101,7 +101,6 @@ static int do_map_benchmark(struct map_benchmark_data *map)
 	struct task_struct **tsk;
 	int threads = map->bparam.threads;
 	int node = map->bparam.node;
-	const cpumask_t *cpu_mask = cpumask_of_node(node);
 	u64 loops;
 	int ret = 0;
 	int i;
@@ -124,7 +123,7 @@ static int do_map_benchmark(struct map_benchmark_data *map)
 		}
 
 		if (node != NUMA_NO_NODE)
-			kthread_bind_mask(tsk[i], cpu_mask);
+			kthread_bind_mask(tsk[i], cpumask_of_node(node));
 	}
 
 	/* clear the old value in the previous benchmark */
-- 
2.43.0



