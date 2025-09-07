Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18B31A0BFD;
	Sun,  7 Sep 2025 20:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277166; cv=none; b=Sziq8s1PyrV94O4x+vQu/H/TlB2tznIvrmkmcqK3RHVX/zC/afSCwjxtB/jAP4jH72JPdm5OGkKzgHIHc9Zbtc3A2gliq3wuhlI1Z3oPRIv5IfSJ4UAgR5AbfGZT54hRgqvpAZ2uAR3dP6IdBXcnm91NPV44J200LKGel8clyjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277166; c=relaxed/simple;
	bh=lWFPRyTOlHZN+KlCSVT0HtHrasf5SruGXY/z7AgxmzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nsf0Fc4xblJncMShPQb9RignwF7sNb9wTP5CC0nhCks/TgF2fnaXcQCieqNhYHILyVP5mWbzlHMs3RSXwTj4VCb3gykEKEz1/7913leMWoP9J6V9oo+xBslDBPPXcg2w4875yqz74h+2oyoT23HFZ4+eWrnE3lNprO0u/Kjk9WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnCdbN+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnCdbN+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0813C4CEF0;
	Sun,  7 Sep 2025 20:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277166;
	bh=lWFPRyTOlHZN+KlCSVT0HtHrasf5SruGXY/z7AgxmzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnCdbN+mR+av278DmS52+ILui9gJKXXlEKkPsB9RzoKuPW727oqCs6QhwN0JeiVP7
	 XxdinBHeLE8nCoecIdgD0EJhQb7gRmdFXvXmSZOQAil9jvXFfm5XjB9UeEgVw/Xb7n
	 1B8L7iPY85m0NktW9gf2zIzEO/ihSTwfTgmouuXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yin Tirui <yintirui@huawei.com>,
	David Hildenbrand <david@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Chen Jun <chenjun102@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 106/175] of_numa: fix uninitialized memory nodes causing kernel panic
Date: Sun,  7 Sep 2025 21:58:21 +0200
Message-ID: <20250907195617.361191159@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yin Tirui <yintirui@huawei.com>

commit ee4d098cbc9160f573b5c1b5a51d6158efdb2896 upstream.

When there are memory-only nodes (nodes without CPUs), these nodes are not
properly initialized, causing kernel panic during boot.

of_numa_init
	of_numa_parse_cpu_nodes
		node_set(nid, numa_nodes_parsed);
	of_numa_parse_memory_nodes

In of_numa_parse_cpu_nodes, numa_nodes_parsed gets updated only for nodes
containing CPUs.  Memory-only nodes should have been updated in
of_numa_parse_memory_nodes, but they weren't.

Subsequently, when free_area_init() attempts to access NODE_DATA() for
these uninitialized memory nodes, the kernel panics due to NULL pointer
dereference.

This can be reproduced on ARM64 QEMU with 1 CPU and 2 memory nodes:

qemu-system-aarch64 \
-cpu host -nographic \
-m 4G -smp 1 \
-machine virt,accel=kvm,gic-version=3,iommu=smmuv3 \
-object memory-backend-ram,size=2G,id=mem0 \
-object memory-backend-ram,size=2G,id=mem1 \
-numa node,nodeid=0,memdev=mem0 \
-numa node,nodeid=1,memdev=mem1 \
-kernel $IMAGE \
-hda $DISK \
-append "console=ttyAMA0 root=/dev/vda rw earlycon"

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x481fd010]
[    0.000000] Linux version 6.17.0-rc1-00001-gabb4b3daf18c-dirty (yintirui@local) (gcc (GCC) 12.3.1, GNU ld (GNU Binutils) 2.41) #52 SMP PREEMPT Mon Aug 18 09:49:40 CST 2025
[    0.000000] KASLR enabled
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: pl11 at MMIO 0x0000000009000000 (options '')
[    0.000000] printk: legacy bootconsole [pl11] enabled
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory node in the DT
[    0.000000] NODE_DATA(0) allocated [mem 0xbfffd9c0-0xbfffffff]
[    0.000000] node 1 must be removed before remove section 23
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000]   node   1: [mem 0x00000000c0000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a0
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x0000000096000004
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x04: level 0 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    0.000000]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.000000]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.000000] [00000000000000a0] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1]  SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 6.17.0-rc1-00001-g760c6dabf762-dirty #54 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : free_area_init+0x50c/0xf9c
[    0.000000] lr : free_area_init+0x5c0/0xf9c
[    0.000000] sp : ffffa02ca0f33c00
[    0.000000] x29: ffffa02ca0f33cb0 x28: 0000000000000000 x27: 0000000000000000
[    0.000000] x26: 4ec4ec4ec4ec4ec5 x25: 00000000000c0000 x24: 00000000000c0000
[    0.000000] x23: 0000000000040000 x22: 0000000000000000 x21: ffffa02ca0f3b368
[    0.000000] x20: ffffa02ca14c7b98 x19: 0000000000000000 x18: 0000000000000002
[    0.000000] x17: 000000000000cacc x16: 0000000000000001 x15: 0000000000000001
[    0.000000] x14: 0000000080000000 x13: 0000000000000018 x12: 0000000000000002
[    0.000000] x11: ffffa02ca0fd4f00 x10: ffffa02ca14bab20 x9 : ffffa02ca14bab38
[    0.000000] x8 : 00000000000c0000 x7 : 0000000000000001 x6 : 0000000000000002
[    0.000000] x5 : 0000000140000000 x4 : ffffa02ca0f33c90 x3 : ffffa02ca0f33ca0
[    0.000000] x2 : ffffa02ca0f33c98 x1 : 0000000080000000 x0 : 0000000000000001
[    0.000000] Call trace:
[    0.000000]  free_area_init+0x50c/0xf9c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] Code: d503201f b98093e0 52800016 f8607a93 (f9405260)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task! ]---

Link: https://lkml.kernel.org/r/20250819075510.2079961-1-yintirui@huawei.com
Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/of_numa.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -62,8 +62,11 @@ static int __init of_numa_parse_memory_n
 			r = -EINVAL;
 		}
 
-		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
+		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
 			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
+			if (!r)
+				node_set(nid, numa_nodes_parsed);
+		}
 
 		if (!i || r) {
 			of_node_put(np);


