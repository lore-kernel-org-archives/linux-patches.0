Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737F43F9F4F;
	Fri, 15 May 2026 16:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862282; cv=none; b=IMVbm6/TDRqanDJzBszyCnJaKqmVWmH9KUJkUB6OMJfVwY0GnZU8Bw5F+YdEVOV84siV26kHXkBoSuySwc6uTPvfYVSUh1hCcaqX2ccAYcYkFaVYO4DJ2E3u66kn6tfQQjF8eJ+eTpX0ZQFV7ySbcOVIYMyd35ApY317pGYvd2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862282; c=relaxed/simple;
	bh=HsFa8ghM0p6p5jbSNmWzpJOOP0+UOQ8XRGEqWy/EkAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j6gg+KYTGSiB6Ngx7RqQHgepfLAVhyBAPC77ucdg2c9Y9NGJUMjtkGcJwivh5JyIz6ovghGr/wS3lrayHlparU168+c5LyFFG4XkIVaTrCTN9JWLTxB+AXvgUgrU6Ouo+zBL+u15dFF8fyvTtP6oKsGBATGqy++jYSjjWUsqT50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=053WMDMY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="053WMDMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00757C2BCC7;
	Fri, 15 May 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862282;
	bh=HsFa8ghM0p6p5jbSNmWzpJOOP0+UOQ8XRGEqWy/EkAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=053WMDMYeWdHOtP8TB4+eJEmYsuXDsOr3+qzbpv2sWhk7lp+FqnBBRHeoV989FE5M
	 t/sCdvnju0tDwibrNe1jFViSNiFbp8H9uhW6G3NwcjZ8INE69wfJLLMVf6DwqfV+NZ
	 y9Jh54wSFZqvijQnZ0OEUXkmG/F8vQ8ib7m7RGIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <dongml2@chinatelecom.cn>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/188] tracing: fprobe: optimization for entry only case
Date: Fri, 15 May 2026 17:49:55 +0200
Message-ID: <20260515154701.201185111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Menglong Dong <menglong8.dong@gmail.com>

[ Upstream commit 2c67dc457bc67367dc8fcd8f471ce2d5bb5f7b2b ]

For now, fgraph is used for the fprobe, even if we need trace the entry
only. However, the performance of ftrace is better than fgraph, and we
can use ftrace_ops for this case.

Then performance of kprobe-multi increases from 54M to 69M. Before this
commit:

  $ ./benchs/run_bench_trigger.sh kprobe-multi
  kprobe-multi   :   54.663 ± 0.493M/s

After this commit:

  $ ./benchs/run_bench_trigger.sh kprobe-multi
  kprobe-multi   :   69.447 ± 0.143M/s

Mitigation is disable during the bench testing above.

Link: https://lore.kernel.org/all/20251015083238.2374294-2-dongml2@chinatelecom.cn/

Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Stable-dep-of: 845947aca681 ("tracing/fprobe: Remove fprobe from hash in failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |  128 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 119 insertions(+), 9 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -252,8 +252,106 @@ static inline int __fprobe_kprobe_handle
 	return ret;
 }
 
-static int fprobe_entry(struct ftrace_graph_ent *trace, struct fgraph_ops *gops,
-			struct ftrace_regs *fregs)
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+/* ftrace_ops callback, this processes fprobes which have only entry_handler. */
+static void fprobe_ftrace_entry(unsigned long ip, unsigned long parent_ip,
+	struct ftrace_ops *ops, struct ftrace_regs *fregs)
+{
+	struct fprobe_hlist_node *node;
+	struct rhlist_head *head, *pos;
+	struct fprobe *fp;
+	int bit;
+
+	bit = ftrace_test_recursion_trylock(ip, parent_ip);
+	if (bit < 0)
+		return;
+
+	/*
+	 * ftrace_test_recursion_trylock() disables preemption, but
+	 * rhltable_lookup() checks whether rcu_read_lcok is held.
+	 * So we take rcu_read_lock() here.
+	 */
+	rcu_read_lock();
+	head = rhltable_lookup(&fprobe_ip_table, &ip, fprobe_rht_params);
+
+	rhl_for_each_entry_rcu(node, pos, head, hlist) {
+		if (node->addr != ip)
+			break;
+		fp = READ_ONCE(node->fp);
+		if (unlikely(!fp || fprobe_disabled(fp) || fp->exit_handler))
+			continue;
+
+		if (fprobe_shared_with_kprobes(fp))
+			__fprobe_kprobe_handler(ip, parent_ip, fp, fregs, NULL);
+		else
+			__fprobe_handler(ip, parent_ip, fp, fregs, NULL);
+	}
+	rcu_read_unlock();
+	ftrace_test_recursion_unlock(bit);
+}
+NOKPROBE_SYMBOL(fprobe_ftrace_entry);
+
+static struct ftrace_ops fprobe_ftrace_ops = {
+	.func	= fprobe_ftrace_entry,
+	.flags	= FTRACE_OPS_FL_SAVE_REGS,
+};
+static int fprobe_ftrace_active;
+
+static int fprobe_ftrace_add_ips(unsigned long *addrs, int num)
+{
+	int ret;
+
+	lockdep_assert_held(&fprobe_mutex);
+
+	ret = ftrace_set_filter_ips(&fprobe_ftrace_ops, addrs, num, 0, 0);
+	if (ret)
+		return ret;
+
+	if (!fprobe_ftrace_active) {
+		ret = register_ftrace_function(&fprobe_ftrace_ops);
+		if (ret) {
+			ftrace_free_filter(&fprobe_ftrace_ops);
+			return ret;
+		}
+	}
+	fprobe_ftrace_active++;
+	return 0;
+}
+
+static void fprobe_ftrace_remove_ips(unsigned long *addrs, int num)
+{
+	lockdep_assert_held(&fprobe_mutex);
+
+	fprobe_ftrace_active--;
+	if (!fprobe_ftrace_active)
+		unregister_ftrace_function(&fprobe_ftrace_ops);
+	if (num)
+		ftrace_set_filter_ips(&fprobe_ftrace_ops, addrs, num, 1, 0);
+}
+
+static bool fprobe_is_ftrace(struct fprobe *fp)
+{
+	return !fp->exit_handler;
+}
+#else
+static int fprobe_ftrace_add_ips(unsigned long *addrs, int num)
+{
+	return -ENOENT;
+}
+
+static void fprobe_ftrace_remove_ips(unsigned long *addrs, int num)
+{
+}
+
+static bool fprobe_is_ftrace(struct fprobe *fp)
+{
+	return false;
+}
+#endif
+
+/* fgraph_ops callback, this processes fprobes which have exit_handler. */
+static int fprobe_fgraph_entry(struct ftrace_graph_ent *trace, struct fgraph_ops *gops,
+			       struct ftrace_regs *fregs)
 {
 	unsigned long *fgraph_data = NULL;
 	unsigned long func = trace->func;
@@ -289,7 +387,7 @@ static int fprobe_entry(struct ftrace_gr
 				if (node->addr != func)
 					continue;
 				fp = READ_ONCE(node->fp);
-				if (fp && !fprobe_disabled(fp))
+				if (fp && !fprobe_disabled(fp) && !fprobe_is_ftrace(fp))
 					fp->nmissed++;
 			}
 			return 0;
@@ -309,7 +407,7 @@ static int fprobe_entry(struct ftrace_gr
 		if (node->addr != func)
 			continue;
 		fp = READ_ONCE(node->fp);
-		if (!fp || fprobe_disabled(fp))
+		if (unlikely(!fp || fprobe_disabled(fp) || fprobe_is_ftrace(fp)))
 			continue;
 
 		data_size = fp->entry_data_size;
@@ -337,7 +435,7 @@ static int fprobe_entry(struct ftrace_gr
 	/* If any exit_handler is set, data must be used. */
 	return used != 0;
 }
-NOKPROBE_SYMBOL(fprobe_entry);
+NOKPROBE_SYMBOL(fprobe_fgraph_entry);
 
 static void fprobe_return(struct ftrace_graph_ret *trace,
 			  struct fgraph_ops *gops,
@@ -376,7 +474,7 @@ static void fprobe_return(struct ftrace_
 NOKPROBE_SYMBOL(fprobe_return);
 
 static struct fgraph_ops fprobe_graph_ops = {
-	.entryfunc	= fprobe_entry,
+	.entryfunc	= fprobe_fgraph_entry,
 	.retfunc	= fprobe_return,
 };
 static int fprobe_graph_active;
@@ -498,9 +596,14 @@ static int fprobe_module_callback(struct
 	} while (node == ERR_PTR(-EAGAIN));
 	rhashtable_walk_exit(&iter);
 
-	if (alist.index > 0)
+	if (alist.index > 0) {
 		ftrace_set_filter_ips(&fprobe_graph_ops.ops,
 				      alist.addrs, alist.index, 1, 0);
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+		ftrace_set_filter_ips(&fprobe_ftrace_ops,
+				      alist.addrs, alist.index, 1, 0);
+#endif
+	}
 	mutex_unlock(&fprobe_mutex);
 
 	kfree(alist.addrs);
@@ -735,7 +838,11 @@ int register_fprobe_ips(struct fprobe *f
 		return ret;
 
 	hlist_array = fp->hlist_array;
-	ret = fprobe_graph_add_ips(addrs, num);
+	if (fprobe_is_ftrace(fp))
+		ret = fprobe_ftrace_add_ips(addrs, num);
+	else
+		ret = fprobe_graph_add_ips(addrs, num);
+
 	if (!ret) {
 		add_fprobe_hash(fp);
 		for (i = 0; i < hlist_array->size; i++) {
@@ -830,7 +937,10 @@ int unregister_fprobe(struct fprobe *fp)
 	}
 	del_fprobe_hash(fp);
 
-	fprobe_graph_remove_ips(addrs, count);
+	if (fprobe_is_ftrace(fp))
+		fprobe_ftrace_remove_ips(addrs, count);
+	else
+		fprobe_graph_remove_ips(addrs, count);
 
 	kfree_rcu(hlist_array, rcu);
 	fp->hlist_array = NULL;


