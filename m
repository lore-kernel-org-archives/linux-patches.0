Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235557C08D;
	Wed, 21 Feb 2024 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522290; cv=none; b=UZ5C0BMkGDsV7SfyYAv+A+e1irbHw4QCTn+qmIonL8G8g5VU1px+yH3JB15MwLGOLILbuQSrgSPeA72koPiK8tv/5Qjq8+4QeNNTLNZWG7EFwgFxxGSHscMTyRh6WSgYfZN6YkG6kL8IimGlba+qp0ER1HmL/EcBNC17NAvd+gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522290; c=relaxed/simple;
	bh=GNvY2fxjb2NTkMJuQY8mZWWdlAbkA+iRKw8SAB3o6xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqlMaf8yjTvAFQOW9vOhgrzSxwuxQ4UqTqu14o4tJA3RXdYyXzNa8N0HKJfYhxYjXBE8hJrrcKlal6/eGHv/QI78lxbMd3iFdzFOttvzEEixiFcc6uvNNOC9snyYtZX/WPd6mLblZT+DGI2bu3coneVdMyUjhrxo/2vGAoIV2DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=if6o4ynM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="if6o4ynM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3EBC433F1;
	Wed, 21 Feb 2024 13:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522288;
	bh=GNvY2fxjb2NTkMJuQY8mZWWdlAbkA+iRKw8SAB3o6xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=if6o4ynMHiu5LuBbjyN77Nsffy+NDZ+MUyp2YRtccC7PhR4B5PQOJOo/xEQzL1TP8
	 w0S6AcFuTbpc9IOOSXNQlqrG+U7IskWFDRrUp9Y9y2Wsae/EvZ/xaXucClws10YfyW
	 40fBBW30jqNpjhbuDfC2f8eYzb3ABheegSlsIajo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/476] arm64: irq: set the correct node for VMAP stack
Date: Wed, 21 Feb 2024 14:02:57 +0100
Message-ID: <20240221130012.634704073@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
index bda49430c9ea..dab45f19df49 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -19,6 +19,7 @@
 #include <linux/kprobes.h>
 #include <linux/scs.h>
 #include <linux/seq_file.h>
+#include <asm/numa.h>
 #include <linux/vmalloc.h>
 #include <asm/daifflags.h>
 #include <asm/vmap_stack.h>
@@ -48,13 +49,13 @@ static void init_irq_scs(void)
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
index 00fb4120a5b3..bce0902dccb4 100644
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



