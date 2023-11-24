Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D090B35F1A;
	Fri, 24 Nov 2023 19:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9a1Ciqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE9BC433CD;
	Fri, 24 Nov 2023 19:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853010;
	bh=iGTZ/n/AX9c68souWwHmlXbZSsvm0B+oSN6+yl4n+kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9a1CiqegsXYfCJ5N2cxKctZfK99WMSBWjBxYgb2H8RrzbscXRFUOWV2CdBAmXDk7
	 vOxHrsoiSpf2YPK9PbJnsnoG/NQlDG240Ian32tefLgryFlab2Y5CAc8jjGgvnaVd1
	 szqklimkcbaJYAsTwowYZCaf8EArLQfjdkuVuLas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Mario Casquero <mcasquer@redhat.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rik van Riel <riel@surriel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/297] x86/mm: Drop the 4 MB restriction on minimal NUMA node memory size
Date: Fri, 24 Nov 2023 17:50:48 +0000
Message-ID: <20231124172000.315555368@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (IBM) <rppt@kernel.org>

[ Upstream commit a1e2b8b36820d8c91275f207e77e91645b7c6836 ]

Qi Zheng reported crashes in a production environment and provided a
simplified example as a reproducer:

 |  For example, if we use Qemu to start a two NUMA node kernel,
 |  one of the nodes has 2M memory (less than NODE_MIN_SIZE),
 |  and the other node has 2G, then we will encounter the
 |  following panic:
 |
 |    BUG: kernel NULL pointer dereference, address: 0000000000000000
 |    <...>
 |    RIP: 0010:_raw_spin_lock_irqsave+0x22/0x40
 |    <...>
 |    Call Trace:
 |      <TASK>
 |      deactivate_slab()
 |      bootstrap()
 |      kmem_cache_init()
 |      start_kernel()
 |      secondary_startup_64_no_verify()

The crashes happen because of inconsistency between the nodemask that
has nodes with less than 4MB as memoryless, and the actual memory fed
into the core mm.

The commit:

  9391a3f9c7f1 ("[PATCH] x86_64: Clear more state when ignoring empty node in SRAT parsing")

... that introduced minimal size of a NUMA node does not explain why
a node size cannot be less than 4MB and what boot failures this
restriction might fix.

Fixes have been submitted to the core MM code to tighten up the
memory topologies it accepts and to not crash on weird input:

  mm: page_alloc: skip memoryless nodes entirely
  mm: memory_hotplug: drop memoryless node from fallback lists

Andrew has accepted them into the -mm tree, but there are no
stable SHA1's yet.

This patch drops the limitation for minimal node size on x86:

  - which works around the crash without the fixes to the core MM.
  - makes x86 topologies less weird,
  - removes an arbitrary and undocumented limitation on NUMA topologies.

[ mingo: Improved changelog clarity. ]

Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Tested-by: Mario Casquero <mcasquer@redhat.com>
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Link: https://lore.kernel.org/r/ZS+2qqjEO5/867br@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/numa.h | 7 -------
 arch/x86/mm/numa.c          | 7 -------
 2 files changed, 14 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index e3bae2b60a0db..ef2844d691735 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -12,13 +12,6 @@
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
 
-/*
- * Too small node sizes may confuse the VM badly. Usually they
- * result from BIOS bugs. So dont recognize nodes as standalone
- * NUMA entities that have less than this amount of RAM listed:
- */
-#define NODE_MIN_SIZE (4*1024*1024)
-
 extern int numa_off;
 
 /*
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index e360c6892a584..1a1c0c242f272 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -601,13 +601,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 		if (start >= end)
 			continue;
 
-		/*
-		 * Don't confuse VM with a node that doesn't have the
-		 * minimum amount of memory:
-		 */
-		if (end && (end - start) < NODE_MIN_SIZE)
-			continue;
-
 		alloc_node_data(nid);
 	}
 
-- 
2.42.0



