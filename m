Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E1E46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C88C433D2;
	Mon, 16 Jan 2023 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885454;
	bh=8buAUihA0KsplwC4rHJmW4jrw8mQC5n+V9B900/ouNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMen+FYOaHohXGAu1zYO8kB3wNIUQ5Z6K+d419utfH/S5bgxytKDEmLtxnwbiEOcl
	 qsserbezvkaYd1lb+kesURAY5KzDDVeN11f1nyQV/YF9eKnjIzcuLBjpFjf0ol1f23
	 pocYpkpcfYjT1NmR3ar5NZPjfUrttslfaOimnyPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@windriver.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/658] debugobjects: Free per CPU pool after CPU unplug
Date: Mon, 16 Jan 2023 16:42:24 +0100
Message-Id: <20230116154912.229874030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 88451f2cd3cec2abc30debdf129422d2699d1eba ]

If a CPU is offlined the debug objects per CPU pool is not cleaned up. If
the CPU is never onlined again then the objects in the pool are wasted.

Add a CPU hotplug callback which is invoked after the CPU is dead to free
the pool.

[ tglx: Massaged changelog and added comment about remote access safety ]

Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20200908062709.11441-1-qiang.zhang@windriver.com
Stable-dep-of: eabb7f1ace53 ("lib/debugobjects: fix stat count and optimize debug_objects_mem_init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpuhotplug.h |  1 +
 lib/debugobjects.c         | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 15835f37bd5f..970b47fcd6ff 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -36,6 +36,7 @@ enum cpuhp_state {
 	CPUHP_X86_MCE_DEAD,
 	CPUHP_VIRT_NET_DEAD,
 	CPUHP_SLUB_DEAD,
+	CPUHP_DEBUG_OBJ_DEAD,
 	CPUHP_MM_WRITEBACK_DEAD,
 	CPUHP_MM_VMSTAT_DEAD,
 	CPUHP_SOFTIRQ_DEAD,
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 48054dbf1b51..746b632792b5 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <linux/hash.h>
 #include <linux/kmemleak.h>
+#include <linux/cpu.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
@@ -433,6 +434,25 @@ static void free_object(struct debug_obj *obj)
 	}
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static int object_cpu_offline(unsigned int cpu)
+{
+	struct debug_percpu_free *percpu_pool;
+	struct hlist_node *tmp;
+	struct debug_obj *obj;
+
+	/* Remote access is safe as the CPU is dead already */
+	percpu_pool = per_cpu_ptr(&percpu_obj_pool, cpu);
+	hlist_for_each_entry_safe(obj, tmp, &percpu_pool->free_objs, node) {
+		hlist_del(&obj->node);
+		kmem_cache_free(obj_cache, obj);
+	}
+	percpu_pool->obj_free = 0;
+
+	return 0;
+}
+#endif
+
 /*
  * We run out of memory. That means we probably have tons of objects
  * allocated.
@@ -1378,6 +1398,11 @@ void __init debug_objects_mem_init(void)
 	} else
 		debug_objects_selftest();
 
+#ifdef CONFIG_HOTPLUG_CPU
+	cpuhp_setup_state_nocalls(CPUHP_DEBUG_OBJ_DEAD, "object:offline", NULL,
+					object_cpu_offline);
+#endif
+
 	/*
 	 * Increase the thresholds for allocating and freeing objects
 	 * according to the number of possible CPUs available in the system.
-- 
2.35.1



