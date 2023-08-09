Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9FF17756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F1C433C7;
	Wed,  9 Aug 2023 11:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580113;
	bh=eWNKNg3KY6FMiWiNRVAN944rka5vwAWmSdgbiaV70Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNpoUQRoXca2kUxQCmS1YyM50wxe+lYSEh4mmMEAzXrHAXTTs9DdYmj88XC6aTm1R
	 fQqgMTSZied+1Uomr78vbVA+did12YNPgNu1AIo/n7TadY6fGpfy+sXs6jAfXx8oFv
	 CwgOQpeT0CIDJErZE1V1Am6rvhN65h0LBTxiSVFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 231/323] ftrace: Add information on number of page groups allocated
Date: Wed,  9 Aug 2023 12:41:09 +0200
Message-ID: <20230809103708.663151839@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit da537f0aef1372c5204356a7df06be8769467b7b ]

Looking for ways to shrink the size of the dyn_ftrace structure, knowing the
information about how many pages and the number of groups of those pages, is
useful in working out the best ways to save on memory.

This adds one info print on how many groups of pages were used to allocate
the ftrace dyn_ftrace structures, and also shows the number of pages and
groups in the dyn_ftrace_total_info (which is used for debugging).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26efd79c4624 ("ftrace: Fix possible warning on checking all pages used in ftrace_process_locs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 14 ++++++++++++++
 kernel/trace/trace.c  | 21 +++++++++++++++------
 kernel/trace/trace.h  |  2 ++
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 5c0463dbe16ee..48ab4d750c650 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2915,6 +2915,8 @@ static void ftrace_shutdown_sysctl(void)
 
 static u64		ftrace_update_time;
 unsigned long		ftrace_update_tot_cnt;
+unsigned long		ftrace_number_of_pages;
+unsigned long		ftrace_number_of_groups;
 
 static inline int ops_traces_mod(struct ftrace_ops *ops)
 {
@@ -3039,6 +3041,9 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 		goto again;
 	}
 
+	ftrace_number_of_pages += 1 << order;
+	ftrace_number_of_groups++;
+
 	cnt = (PAGE_SIZE << order) / ENTRY_SIZE;
 	pg->size = cnt;
 
@@ -3094,6 +3099,8 @@ ftrace_allocate_pages(unsigned long num_to_init)
 		start_pg = pg->next;
 		kfree(pg);
 		pg = start_pg;
+		ftrace_number_of_pages -= 1 << order;
+		ftrace_number_of_groups--;
 	}
 	pr_info("ftrace: FAILED to allocate memory for functions\n");
 	return NULL;
@@ -5839,6 +5846,8 @@ void ftrace_release_mod(struct module *mod)
 		free_pages((unsigned long)pg->records, order);
 		tmp_page = pg->next;
 		kfree(pg);
+		ftrace_number_of_pages -= 1 << order;
+		ftrace_number_of_groups--;
 	}
 }
 
@@ -6184,6 +6193,8 @@ void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 			*last_pg = pg->next;
 			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 			free_pages((unsigned long)pg->records, order);
+			ftrace_number_of_pages -= 1 << order;
+			ftrace_number_of_groups--;
 			kfree(pg);
 			pg = container_of(last_pg, struct ftrace_page, next);
 			if (!(*last_pg))
@@ -6239,6 +6250,9 @@ void __init ftrace_init(void)
 				  __start_mcount_loc,
 				  __stop_mcount_loc);
 
+	pr_info("ftrace: allocated %ld pages with %ld groups\n",
+		ftrace_number_of_pages, ftrace_number_of_groups);
+
 	set_ftrace_early_filters();
 
 	return;
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 98abff0462366..9da7b10e56d23 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7107,14 +7107,23 @@ static ssize_t
 tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
-	unsigned long *p = filp->private_data;
-	char buf[64]; /* Not too big for a shallow stack */
+	ssize_t ret;
+	char *buf;
 	int r;
 
-	r = scnprintf(buf, 63, "%ld", *p);
-	buf[r++] = '\n';
+	/* 256 should be plenty to hold the amount needed */
+	buf = kmalloc(256, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	r = scnprintf(buf, 256, "%ld pages:%ld groups: %ld\n",
+		      ftrace_update_tot_cnt,
+		      ftrace_number_of_pages,
+		      ftrace_number_of_groups);
+
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	kfree(buf);
+	return ret;
 }
 
 static const struct file_operations tracing_dyn_info_fops = {
@@ -8246,7 +8255,7 @@ static __init int tracer_init_tracefs(void)
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
-			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
+			NULL, &tracing_dyn_info_fops);
 #endif
 
 	create_trace_instances(d_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0923d1b18d1fb..f4d83b552a477 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -748,6 +748,8 @@ extern void trace_event_follow_fork(struct trace_array *tr, bool enable);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern unsigned long ftrace_update_tot_cnt;
+extern unsigned long ftrace_number_of_pages;
+extern unsigned long ftrace_number_of_groups;
 void ftrace_init_trace_array(struct trace_array *tr);
 #else
 static inline void ftrace_init_trace_array(struct trace_array *tr) { }
-- 
2.39.2



