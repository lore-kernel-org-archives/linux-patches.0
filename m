Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216179;
	b=0xoRjTIJ+YXZQRQ2EpvyY1jDjiYwM//2KzbYT0dkyw8eOhszedCcE5US0Rn9+XbnZKry
	 4I5zcr+0zuS5qSuDa2Eh/qmwEjnyGX9kAG81ljMdzZSvC6G5Ne5SNg1xQZWGTYE+PMvve
	 AGYIVi96dyyYwh73X0ZzK2c+X+b1CDpYw49v3irAW/lCEk3sk4kQPPGucXy8NTkf5vOT9
	 V3x3rItosTnOEU7DYckMKhhiwecsRXwKC8G1F0s+io3ybV8L0IZ4xst4D69/zRn8riCeT
	 4KMcMV28IadVNIx0xg+0rwJbanaNHrk6Bi7WUoJ/nYSNEwO+bkSmYyarV56c43SuoVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PThgMjdZDmbEA7qo5iOgvErr9id7rM247onDVT4yVA4=;
	b=FvUjHuoD9L8g+HAH4drYFtQv35xk+Ch3Swny8AbqZAd/kvph4GMC+75elw71KmkhDRWb
	 YOiTOaslLz2vjnJ7gRuqYnrh4fJXqXYhjdOW2pyUMThOEV8nf6K+DPtUTtqeeByYgft36
	 gRTYbwi3FYPaSaf5Je5cSltYSi3CR8Df5A/VspvfQm8+7MX2htBEYC9odhrXYJ+eZ7/FE
	 +d8t3WJuhtIlA8PhpVsH1JQ2MUFUr0zsZzQMHYftUyBuwB7ue2VzJxYAxBQUaHBjknkAD
	 g309bhL90nbT0qPCaAJ25hRKMa4pWOc+sQDIPMqFqGrjKhjT9qpFZVH1e0gEi89WQEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMSxF3uo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B62606A31A;
	Wed, 28 Oct 2026 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMSxF3uo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868111F01825;
	Wed, 28 Oct 2026 19:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216179;
	bh=PThgMjdZDmbEA7qo5iOgvErr9id7rM247onDVT4yVA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMSxF3uorzrCb0NgagmX8okRZVT21lfZPDiIH+ChAuf7xcRlkXg7e2pSBBbaI/dwg
	 vYY8oiy2mO8AG5V/qR60AyFZwknL93H/ww/k623znf89ayVOKvOD5aK2nJSFEsqhqp
	 etiOcHMKxBIjFnJdKJijkVDDotjgWKEx0SO/90Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"ke.wang" <ke.wang@unisoc.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zhaoyang Huang <huangzhaoyang@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1469/1887] mm: use stack_depot for recording kmemleaks backtrace
Date: Wed, 28 Oct 2026 17:59:25 +0100
Message-ID: <20261028170532.885047749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 56a61617dd2276cbc56a6c868599716386d70041 ]

Using stack_depot to record kmemleak's backtrace which has been
implemented on slub for reducing redundant information.

[akpm@linux-foundation.org: fix build - remove now-unused __save_stack_trace()]
[zhaoyang.huang@unisoc.com: v3]
  Link: https://lkml.kernel.org/r/1667101354-4669-1-git-send-email-zhaoyang.huang@unisoc.com
[akpm@linux-foundation.org: fix v3 layout oddities]
[akpm@linux-foundation.org: coding-style cleanups]
Link: https://lkml.kernel.org/r/1666864224-27541-1-git-send-email-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: ke.wang <ke.wang@unisoc.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhaoyang Huang <huangzhaoyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 5d10d4e19e6d ("mm/kmemleak: avoid soft lockup when scanning task stacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.debug |  1 +
 mm/kmemleak.c     | 46 ++++++++++++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d00c695bf4921..cfff3f1e4713d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -737,6 +737,7 @@ config DEBUG_KMEMLEAK
 	select STACKTRACE if STACKTRACE_SUPPORT
 	select KALLSYMS
 	select CRC32
+	select STACKDEPOT
 	help
 	  Say Y here if you want to enable the memory leak
 	  detector. The memory allocation/freeing is traced in a way
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 3e41e669e2528..ca1a3855de07c 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -80,6 +80,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include <linux/stacktrace.h>
+#include <linux/stackdepot.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
 #include <linux/memblock.h>
@@ -161,8 +162,7 @@ struct kmemleak_object {
 	u32 checksum;
 	/* memory ranges to be scanned inside an object (empty for all) */
 	struct hlist_head area_list;
-	unsigned long trace[MAX_TRACE];
-	unsigned int trace_len;
+	depot_stack_handle_t trace_handle;
 	unsigned long jiffies;		/* creation timestamp */
 	pid_t pid;			/* pid of the current task */
 	char comm[TASK_COMM_LEN];	/* executable name */
@@ -353,18 +353,21 @@ static void print_unreferenced(struct seq_file *seq,
 			       struct kmemleak_object *object)
 {
 	int i;
+	unsigned long *entries;
+	unsigned int nr_entries;
 	unsigned int msecs_age = jiffies_to_msecs(jiffies - object->jiffies);
 
+	nr_entries = stack_depot_fetch(object->trace_handle, &entries);
 	warn_or_seq_printf(seq, "unreferenced object 0x%08lx (size %zu):\n",
-		   object->pointer, object->size);
+			  object->pointer, object->size);
 	warn_or_seq_printf(seq, "  comm \"%s\", pid %d, jiffies %lu (age %d.%03ds)\n",
-		   object->comm, object->pid, object->jiffies,
-		   msecs_age / 1000, msecs_age % 1000);
+			   object->comm, object->pid, object->jiffies,
+			   msecs_age / 1000, msecs_age % 1000);
 	hex_dump_object(seq, object);
 	warn_or_seq_printf(seq, "  backtrace:\n");
 
-	for (i = 0; i < object->trace_len; i++) {
-		void *ptr = (void *)object->trace[i];
+	for (i = 0; i < nr_entries; i++) {
+		void *ptr = (void *)entries[i];
 		warn_or_seq_printf(seq, "    [<%p>] %pS\n", ptr, ptr);
 	}
 }
@@ -377,15 +380,16 @@ static void print_unreferenced(struct seq_file *seq,
 static void dump_object_info(struct kmemleak_object *object)
 {
 	pr_notice("Object 0x%08lx (size %zu):\n",
-		  object->pointer, object->size);
+			object->pointer, object->size);
 	pr_notice("  comm \"%s\", pid %d, jiffies %lu\n",
-		  object->comm, object->pid, object->jiffies);
+			object->comm, object->pid, object->jiffies);
 	pr_notice("  min_count = %d\n", object->min_count);
 	pr_notice("  count = %d\n", object->count);
 	pr_notice("  flags = 0x%x\n", object->flags);
 	pr_notice("  checksum = %u\n", object->checksum);
 	pr_notice("  backtrace:\n");
-	stack_trace_print(object->trace, object->trace_len, 4);
+	if (object->trace_handle)
+		stack_depot_print(object->trace_handle);
 }
 
 /*
@@ -603,12 +607,18 @@ static struct kmemleak_object *find_and_remove_object(unsigned long ptr, int ali
 	return object;
 }
 
-/*
- * Save stack trace to the given array of MAX_TRACE size.
- */
-static int __save_stack_trace(unsigned long *trace)
+static noinline depot_stack_handle_t set_track_prepare(void)
 {
-	return stack_trace_save(trace, MAX_TRACE, 2);
+	depot_stack_handle_t trace_handle;
+	unsigned long entries[MAX_TRACE];
+	unsigned int nr_entries;
+
+	if (!kmemleak_initialized)
+		return 0;
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 3);
+	trace_handle = stack_depot_save(entries, nr_entries, GFP_NOWAIT);
+
+	return trace_handle;
 }
 
 /*
@@ -666,7 +676,7 @@ static void __create_object(unsigned long ptr, size_t size,
 	}
 
 	/* kernel backtrace */
-	object->trace_len = __save_stack_trace(object->trace);
+	object->trace_handle = set_track_prepare();
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 
@@ -705,7 +715,6 @@ static void __create_object(unsigned long ptr, size_t size,
 	rb_link_node(&object->rb_node, rb_parent, link);
 	rb_insert_color(&object->rb_node, is_phys ? &object_phys_tree_root :
 					  &object_tree_root);
-
 	list_add_tail_rcu(&object->object_list, &object_list);
 out:
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
@@ -1104,7 +1113,7 @@ void __ref kmemleak_update_trace(const void *ptr)
 	}
 
 	raw_spin_lock_irqsave(&object->lock, flags);
-	object->trace_len = __save_stack_trace(object->trace);
+	object->trace_handle = set_track_prepare();
 	raw_spin_unlock_irqrestore(&object->lock, flags);
 
 	put_object(object);
@@ -2091,6 +2100,7 @@ void __init kmemleak_init(void)
 	if (kmemleak_error)
 		return;
 
+	stack_depot_init();
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
-- 
2.53.0



