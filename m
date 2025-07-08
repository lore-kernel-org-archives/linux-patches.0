Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB972E2F0D;
	Tue,  8 Jul 2025 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993746; cv=none; b=WQJ7rFYrjr43bmmP5LON6l8EO+BSqCnvBDiZiA1Ethx9IsSvSpCUuFPkvd+q90vEhm7uy+Q/edZQAVrIH0pzUd252MBttwZxQJD4CM7q69M6dVgkGW2cfFUNO3GhkieZuAxaLH/c/moY/5nnmrCDqBVsPBPA14Gz26SdrUAf/KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993746; c=relaxed/simple;
	bh=IlIohNjIY9eD8ep4Zh4wME0mh6oKJ24XSgC3N+uoTGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV9KgdjLaeXESBHTCTbZX7SAz9jVn97/xYAxoAnrFvV0slTkPkXvE4L6UgRRTbxZDxqeXRjxZULuO7j9mhI/5Yuj9caO81W1F3pMiL50T3hgdS6JkMpo2HhcUgGcrJYthH32H1FFE52gu4DGW8kdPaUhoYPzqhlUYT7zNapGzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H413k3Cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H413k3Cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C0AC4CEED;
	Tue,  8 Jul 2025 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993745;
	bh=IlIohNjIY9eD8ep4Zh4wME0mh6oKJ24XSgC3N+uoTGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H413k3Cvl7eUPOgMmVYCJAl8OiEaaZiT6/a1whjXQ6u5Bw+KQHh76XcwbI3/MifaP
	 97Jlg5ZgGSUf9mnGVGDlx72VL3zHCjtDGY/y+lUtM5VFQBZrUg5I8uRQhLLSGppiZz
	 yXMT7UqnnvHD3sEIRUXnRVeJy10Ue8YAWcWNLhvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: [PATCH 6.15 172/178] mm/vmalloc: fix data race in show_numa_info()
Date: Tue,  8 Jul 2025 18:23:29 +0200
Message-ID: <20250708162240.946538446@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 5c5f0468d172ddec2e333d738d2a1f85402cf0bc upstream.

The following data-race was found in show_numa_info():

==================================================================
BUG: KCSAN: data-race in vmalloc_info_show / vmalloc_info_show

read to 0xffff88800971fe30 of 4 bytes by task 8289 on cpu 0:
 show_numa_info mm/vmalloc.c:4936 [inline]
 vmalloc_info_show+0x5a8/0x7e0 mm/vmalloc.c:5016
 seq_read_iter+0x373/0xb40 fs/seq_file.c:230
 proc_reg_read_iter+0x11e/0x170 fs/proc/inode.c:299
....

write to 0xffff88800971fe30 of 4 bytes by task 8287 on cpu 1:
 show_numa_info mm/vmalloc.c:4934 [inline]
 vmalloc_info_show+0x38f/0x7e0 mm/vmalloc.c:5016
 seq_read_iter+0x373/0xb40 fs/seq_file.c:230
 proc_reg_read_iter+0x11e/0x170 fs/proc/inode.c:299
....

value changed: 0x0000008f -> 0x00000000
==================================================================

According to this report,there is a read/write data-race because
m->private is accessible to multiple CPUs.  To fix this, instead of
allocating the heap in proc_vmalloc_init() and passing the heap address to
m->private, vmalloc_info_show() should allocate the heap.

Link: https://lkml.kernel.org/r/20250508165620.15321-1-aha310510@gmail.com
Fixes: 8e1d743f2c26 ("mm: vmalloc: support multiple nodes in vmallocinfo")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c |   63 ++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3100,7 +3100,7 @@ static void clear_vm_uninitialized_flag(
 	/*
 	 * Before removing VM_UNINITIALIZED,
 	 * we should make sure that vm has proper values.
-	 * Pair with smp_rmb() in show_numa_info().
+	 * Pair with smp_rmb() in vread_iter() and vmalloc_info_show().
 	 */
 	smp_wmb();
 	vm->flags &= ~VM_UNINITIALIZED;
@@ -4934,28 +4934,29 @@ bool vmalloc_dump_obj(void *object)
 #endif
 
 #ifdef CONFIG_PROC_FS
-static void show_numa_info(struct seq_file *m, struct vm_struct *v)
-{
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		unsigned int nr, *counters = m->private;
-		unsigned int step = 1U << vm_area_page_order(v);
 
-		if (!counters)
-			return;
+/*
+ * Print number of pages allocated on each memory node.
+ *
+ * This function can only be called if CONFIG_NUMA is enabled
+ * and VM_UNINITIALIZED bit in v->flags is disabled.
+ */
+static void show_numa_info(struct seq_file *m, struct vm_struct *v,
+				 unsigned int *counters)
+{
+	unsigned int nr;
+	unsigned int step = 1U << vm_area_page_order(v);
 
-		if (v->flags & VM_UNINITIALIZED)
-			return;
-		/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
-		smp_rmb();
+	if (!counters)
+		return;
 
-		memset(counters, 0, nr_node_ids * sizeof(unsigned int));
+	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-		for (nr = 0; nr < v->nr_pages; nr += step)
-			counters[page_to_nid(v->pages[nr])] += step;
-		for_each_node_state(nr, N_HIGH_MEMORY)
-			if (counters[nr])
-				seq_printf(m, " N%u=%u", nr, counters[nr]);
-	}
+	for (nr = 0; nr < v->nr_pages; nr += step)
+		counters[page_to_nid(v->pages[nr])] += step;
+	for_each_node_state(nr, N_HIGH_MEMORY)
+		if (counters[nr])
+			seq_printf(m, " N%u=%u", nr, counters[nr]);
 }
 
 static void show_purge_info(struct seq_file *m)
@@ -4983,6 +4984,10 @@ static int vmalloc_info_show(struct seq_
 	struct vmap_area *va;
 	struct vm_struct *v;
 	int i;
+	unsigned int *counters;
+
+	if (IS_ENABLED(CONFIG_NUMA))
+		counters = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
 
 	for (i = 0; i < nr_vmap_nodes; i++) {
 		vn = &vmap_nodes[i];
@@ -4999,6 +5004,11 @@ static int vmalloc_info_show(struct seq_
 			}
 
 			v = va->vm;
+			if (v->flags & VM_UNINITIALIZED)
+				continue;
+
+			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
+			smp_rmb();
 
 			seq_printf(m, "0x%pK-0x%pK %7ld",
 				v->addr, v->addr + v->size, v->size);
@@ -5033,7 +5043,9 @@ static int vmalloc_info_show(struct seq_
 			if (is_vmalloc_addr(v->pages))
 				seq_puts(m, " vpages");
 
-			show_numa_info(m, v);
+			if (IS_ENABLED(CONFIG_NUMA))
+				show_numa_info(m, v, counters);
+
 			seq_putc(m, '\n');
 		}
 		spin_unlock(&vn->busy.lock);
@@ -5043,19 +5055,14 @@ static int vmalloc_info_show(struct seq_
 	 * As a final step, dump "unpurged" areas.
 	 */
 	show_purge_info(m);
+	if (IS_ENABLED(CONFIG_NUMA))
+		kfree(counters);
 	return 0;
 }
 
 static int __init proc_vmalloc_init(void)
 {
-	void *priv_data = NULL;
-
-	if (IS_ENABLED(CONFIG_NUMA))
-		priv_data = kmalloc(nr_node_ids * sizeof(unsigned int), GFP_KERNEL);
-
-	proc_create_single_data("vmallocinfo",
-		0400, NULL, vmalloc_info_show, priv_data);
-
+	proc_create_single("vmallocinfo", 0400, NULL, vmalloc_info_show);
 	return 0;
 }
 module_init(proc_vmalloc_init);


