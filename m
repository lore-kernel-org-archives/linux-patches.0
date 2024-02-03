Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDFF9E4;
	Sat,  3 Feb 2024 04:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933319; cv=none; b=KuOqsPzttN3uZGRLGunWxAs3mVtvvAUwBinpKcisApBAeBSve5Y94e5mgQXxgHNIoZD53TbLc9etoZLN/z6Sm6WjHfoYbD+IVR/GrNLCclwldDCCtSl3u/xAQwrtwAjYh05muVXtm+g91NF/lE6Pt+fYsweu/55gBUlFO6zQC14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933319; c=relaxed/simple;
	bh=G5Tw+2cV4KzDlmZeqgZbRU8Q4JTCjkq4VCelX+LnT+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OROxEid9KFx6GMjesy6o/DdqCHBsWimru1Hd5uVzs6Jo6uw4tGHtzY3LgSAm4XrEei829UImfJkOnji/WOCOHG8kF6d1HEr7ItC3hmSWGsZVvTvIfGH0BRuwCsD5sE0Mc6dOdmWqQqtqLfCpIJjpoZ2+xeBL4/D74IADt5F6beA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGc1kdDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGc1kdDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C47C43399;
	Sat,  3 Feb 2024 04:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933319;
	bh=G5Tw+2cV4KzDlmZeqgZbRU8Q4JTCjkq4VCelX+LnT+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGc1kdDFHKKYb2EINJT5ueFolp3DYi3PqZ9Px27H5DQn+zss8rPr07G7wIjcMr5hp
	 TVuJUxSyfpo8gctltPhxy6q5BQJy3KB5toJMnhv6aX0Rk7GsegKZ+YR0MeYGFc3+R4
	 OgpgtRF6swZRE1QzIlMkYe3jZMtp20hLSJBsgpNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/219] arm64: irq: set the correct node for VMAP stack
Date: Fri,  2 Feb 2024 20:02:56 -0800
Message-ID: <20240203035317.675035096@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Shijie <shijie@os.amperecomputing.com>

[ Upstream commit 75b5e0bf90bffaca4b1f19114065dc59f5cc161f ]

In current code, init_irq_stacks() will call cpu_to_node().
The cpu_to_node() depends on percpu "numa_node" which is initialized in:
     arch_call_rest_init() --> rest_init() -- kernel_init()
	--> kernel_init_freeable() --> smp_prepare_cpus()

But init_irq_stacks() is called in init_IRQ() which is before
arch_call_rest_init().

So in init_irq_stacks(), the cpu_to_node() does not work, it
always return 0. In NUMA, it makes the node 1 cpu accesses the IRQ stack which
is in the node 0.

This patch fixes it by:
  1.) export the early_cpu_to_node(), and use it in the init_irq_stacks().
  2.) change init_irq_stacks() to __init function.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Huang Shijie <shijie@os.amperecomputing.com>
Link: https://lore.kernel.org/r/20231124031513.81548-1-shijie@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/irq.c    | 5 +++--
 drivers/base/arch_numa.c   | 2 +-
 include/asm-generic/numa.h | 2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 38dbd3828f13..d9db544285c4 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <asm/daifflags.h>
 #include <asm/exception.h>
+#include <asm/numa.h>
 #include <asm/vmap_stack.h>
 #include <asm/softirq_stack.h>
 
@@ -50,13 +51,13 @@ static void init_irq_scs(void)
 }
 
 #ifdef CONFIG_VMAP_STACK
-static void init_irq_stacks(void)
+static void __init init_irq_stacks(void)
 {
 	int cpu;
 	unsigned long *p;
 
 	for_each_possible_cpu(cpu) {
-		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, cpu_to_node(cpu));
+		p = arch_alloc_vmap_stack(IRQ_STACK_SIZE, early_cpu_to_node(cpu));
 		per_cpu(irq_stack_ptr, cpu) = p;
 	}
 }
diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index eaa31e567d1e..5b59d133b6af 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -144,7 +144,7 @@ void __init early_map_cpu_to_node(unsigned int cpu, int nid)
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);
 
-static int __init early_cpu_to_node(int cpu)
+int __init early_cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
diff --git a/include/asm-generic/numa.h b/include/asm-generic/numa.h
index 1a3ad6d29833..c32e0cf23c90 100644
--- a/include/asm-generic/numa.h
+++ b/include/asm-generic/numa.h
@@ -35,6 +35,7 @@ int __init numa_add_memblk(int nodeid, u64 start, u64 end);
 void __init numa_set_distance(int from, int to, int distance);
 void __init numa_free_distance(void);
 void __init early_map_cpu_to_node(unsigned int cpu, int nid);
+int __init early_cpu_to_node(int cpu);
 void numa_store_cpu_info(unsigned int cpu);
 void numa_add_cpu(unsigned int cpu);
 void numa_remove_cpu(unsigned int cpu);
@@ -46,6 +47,7 @@ static inline void numa_add_cpu(unsigned int cpu) { }
 static inline void numa_remove_cpu(unsigned int cpu) { }
 static inline void arch_numa_init(void) { }
 static inline void early_map_cpu_to_node(unsigned int cpu, int nid) { }
+static inline int early_cpu_to_node(int cpu) { return 0; }
 
 #endif	/* CONFIG_NUMA */
 
-- 
2.43.0



