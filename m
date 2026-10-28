Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208149;
	b=jc/FKKwW1RNWsu9tTXSzD0MrHy3ncq2t7iKqnmnYhYiSvIHaeDda4y5YkynR3ApHE2LD
	 22dzDVd5ri7Kf6lLskE/4HsBKqAv0xk6XEpoqD/doB85SBPZe5ouWtmf8pw+LgmBQZNr0
	 udLgY3pIwJ+SjAZSS7An0R9Ey34+o+XhISfS9YWTj1VUMwCOdmiJhW5pYo4yYdoED0iYg
	 YZhWlyDegoLYCeHEkCJuWqqums8tsi8+SRjtq/ONvyp5BixFUNDn799doS/I+H3z7eX1w
	 qb6iMGM9vVHhVEQvSBEu/B1YzLpurBBod1NRGe/0G/c2Guclt4qFv2Bci97V8eEDucA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RwT8iLv4Undy+aoKKO98Obh/mSPDm/ZnPYIIObFPJFE=;
	b=3hTGSoEBxfsK7EoX1KUETB+7XCpOwqbVH2IUSSBKezPwNXCmyRcIN4aGGX+vaywoO3vA
	 LxGq236vBtzlqKGJ52VApYUWQVdaDS/Rsn1zy2js/XjAg5Bhm88gU2iUE+4dy2GxLdnUx
	 kAv/kblrfOXb4ggEmbOTq8yuaB8vkue+5ovGAtdDJi+/CIPKmma/2I/zbONJwVquUQ4oX
	 uxm5/RQ3Y1fuzdgU8YBiXrFvHxEheVje5XsBjS7d39iveq83awiyPG7wb31lozhyoKcrI
	 2ooLsZeuvnixtnfnslO2LPliPCRUwVoxCRpI7Uptx1OEJOa3CSJVTAk0yCyI9M9pJqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="P+IaV/55";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4D8606A31E;
	Wed, 28 Oct 2026 17:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P+IaV/55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4251F01825;
	Wed, 28 Oct 2026 17:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208149;
	bh=RwT8iLv4Undy+aoKKO98Obh/mSPDm/ZnPYIIObFPJFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+IaV/55Z21AsoGjqYWtF3mEubtXjln/6OJ99DgVn9rZX42nGv1t7EOEPEQ7tuK58
	 5MRcIHFC5FBGAkzqnP8Ke3nUB6hdFCgU5FYfGgM0aA89TJjDebo+NFsDjPrDcZTAj4
	 27E6vYLQd3hi0vpj2riSPzlJlU1fa9ezwISF1yXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/516] ftrace: Take trace_array reference before accessing its ftrace_ops
Date: Wed, 28 Oct 2026 17:52:51 +0100
Message-ID: <20261028170003.982296786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 9100191e5acb2e5ea2313f436667bb5fce129f47 ]

The trace instance files set_ftrace_filter and set_ftrace_notrace was
updated to work with specific trace instances (trace_arrays). The issue is
that when these files are opened, there is a small race window where it
will use the ftrace_ops from the inode->private pointer to get a reference
to the trace_array and then take its reference. The problem is that the
ftrace_ops itself could be freed. If the rmdir on the instance happens at
the same time the set_ftrace_filter file is opened, the rmdir could have
also freed the ftrace_ops and referencing it will cause a use-after-free
bug and crash the kernel.

Instead, pass in the trace_array as the file private data (NULL for the
top level instance), and then pass both the trace_array and the ftrace_ops
to the ftrace_regex_open() function. If the trace_array is NULL, then it
just uses the ftrace_ops without the need to take its reference (like
normal). If the ftrace_ops is NULL, that is only the case for the top
level instance and the global_ops can be used.

This allows the trace_array to have its reference incremented before
touching the ftrace_ops that could also be freed when the instance is.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260828223901.29e26edb@robin
Fixes: 591dffdade9f0 ("ftrace: Allow for function tracing instance to filter functions")
Reported-by: Breno Leitao <leitao@debian.org>
Tested-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/all/apGORjltZgAiAYHT@gmail.com/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ Replaced kzalloc_obj(*iter) with kzalloc(sizeof(*iter), GFP_KERNEL) for Linux 5.10. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ftrace.h         |  5 +--
 kernel/trace/ftrace.c          | 59 ++++++++++++++++++++++------------
 kernel/trace/trace.h           |  4 +--
 kernel/trace/trace_functions.c |  2 +-
 kernel/trace/trace_stack.c     |  2 +-
 5 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index b9dd113599eb4..0813521820746 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -535,8 +535,9 @@ unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec);
 unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec);
 
 extern ftrace_func_t ftrace_trace_function;
+struct trace_array;
 
-int ftrace_regex_open(struct ftrace_ops *ops, int flag,
+int ftrace_regex_open(struct trace_array *tr, struct ftrace_ops *ops, int flag,
 		  struct inode *inode, struct file *file);
 ssize_t ftrace_filter_write(struct file *file, const char __user *ubuf,
 			    size_t cnt, loff_t *ppos);
@@ -735,7 +736,7 @@ static inline unsigned long ftrace_location(unsigned long ip)
  * have them defined when ftrace is not enabled, but these
  * functions may still be called. Use a macro instead of inline.
  */
-#define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
+#define ftrace_regex_open(tr, ops, flag, inode, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
 #define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f45022df3f816..765f5f6778946 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3771,7 +3771,8 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
 
 /**
  * ftrace_regex_open - initialize function tracer filter files
- * @ops: The ftrace_ops that hold the hash filters
+ * @tr: The trace_array that holds the ftrace_ops [optional]
+ * @ops: The ftrace_ops that hold the hash filters [optional]
  * @flag: The type of filter to process
  * @inode: The inode, usually passed in to your open routine
  * @file: The file, usually passed in to your open routine
@@ -3784,25 +3785,46 @@ ftrace_enabled_open(struct inode *inode, struct file *file)
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
  * tracing_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
+ *
+ * Note, If @tr is not NULL, its reference has to be taken before
+ *       @ops may be referenced.
+ *       If @ops is NULL and @tr is not, then @tr->ops is used.
+ *       If @tr is NULL and @ops is not then @ops->private is uesd for @tr.
+ *       If both @tr and @ops are NULL, then the &global_ops is
+ *         to be used, and @tr will be the global_ops.private pointer.
+ *
+ * Returns: 0 on success or a negative errno value on failure
  */
 int
-ftrace_regex_open(struct ftrace_ops *ops, int flag,
+ftrace_regex_open(struct trace_array *tr, struct ftrace_ops *ops, int flag,
 		  struct inode *inode, struct file *file)
 {
-	struct ftrace_iterator *iter;
+	struct ftrace_iterator *iter = NULL;
 	struct ftrace_hash *hash;
 	struct list_head *mod_head;
-	struct trace_array *tr = ops->private;
-	int ret = -ENOMEM;
-
-	ftrace_ops_init(ops);
+	int ret = -ENODEV;
 
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	if (!tr) {
+		if (!ops)
+			ops = &global_ops;
+		tr = ops->private;
+	}
+
 	if (tracing_check_open_get_tr(tr))
 		return -ENODEV;
 
+	if (!ops)
+		ops = tr->ops;
+
+	if (WARN_ON_ONCE(!ops))
+		goto out;
+
+	ftrace_ops_init(ops);
+
+	ret = -ENOMEM;
 	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		goto out;
@@ -3880,21 +3902,19 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 static int
 ftrace_filter_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_ops *ops = inode->i_private;
+	struct trace_array *tr = inode->i_private;
 
-	/* Checks for tracefs lockdown */
-	return ftrace_regex_open(ops,
-			FTRACE_ITER_FILTER | FTRACE_ITER_DO_PROBES,
-			inode, file);
+	return ftrace_regex_open(tr, NULL,
+				 FTRACE_ITER_FILTER | FTRACE_ITER_DO_PROBES,
+				 inode, file);
 }
 
 static int
 ftrace_notrace_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_ops *ops = inode->i_private;
+	struct trace_array *tr = inode->i_private;
 
-	/* Checks for tracefs lockdown */
-	return ftrace_regex_open(ops, FTRACE_ITER_NOTRACE,
+	return ftrace_regex_open(tr, NULL, FTRACE_ITER_NOTRACE,
 				 inode, file);
 }
 
@@ -6175,15 +6195,15 @@ static const struct file_operations ftrace_graph_notrace_fops = {
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
-void ftrace_create_filter_files(struct ftrace_ops *ops,
+void ftrace_create_filter_files(struct trace_array *tr,
 				struct dentry *parent)
 {
 
 	trace_create_file("set_ftrace_filter", 0644, parent,
-			  ops, &ftrace_filter_fops);
+			  tr, &ftrace_filter_fops);
 
 	trace_create_file("set_ftrace_notrace", 0644, parent,
-			  ops, &ftrace_notrace_fops);
+			  tr, &ftrace_notrace_fops);
 }
 
 /*
@@ -6208,14 +6228,13 @@ void ftrace_destroy_filter_files(struct ftrace_ops *ops)
 
 static __init int ftrace_init_dyn_tracefs(struct dentry *d_tracer)
 {
-
 	trace_create_file("available_filter_functions", 0444,
 			d_tracer, NULL, &ftrace_avail_fops);
 
 	trace_create_file("enabled_functions", 0444,
 			d_tracer, NULL, &ftrace_enabled_fops);
 
-	ftrace_create_filter_files(&global_ops, d_tracer);
+	ftrace_create_filter_files(NULL, d_tracer);
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	trace_create_file("set_graph_function", 0644, d_tracer,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8dce0e205c8ed..0f5a71d35dcb0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1230,7 +1230,7 @@ extern void clear_ftrace_function_probes(struct trace_array *tr);
 int register_ftrace_command(struct ftrace_func_command *cmd);
 int unregister_ftrace_command(struct ftrace_func_command *cmd);
 
-void ftrace_create_filter_files(struct ftrace_ops *ops,
+void ftrace_create_filter_files(struct trace_array *tr,
 				struct dentry *parent);
 void ftrace_destroy_filter_files(struct ftrace_ops *ops);
 
@@ -1253,11 +1253,11 @@ static inline void clear_ftrace_function_probes(struct trace_array *tr)
 {
 }
 
+#define ftrace_create_filter_files(tr, parent) do { } while (0)
 /*
  * The ops parameter passed in is usually undefined.
  * This must be a macro.
  */
-#define ftrace_create_filter_files(ops, parent) do { } while (0)
 #define ftrace_destroy_filter_files(ops) do { } while (0)
 #endif /* CONFIG_FUNCTION_TRACER && CONFIG_DYNAMIC_FTRACE */
 
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 93e20ed642e53..14358ecdeb366 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -75,7 +75,7 @@ int ftrace_create_function_files(struct trace_array *tr,
 	if (!tr->ops)
 		return -EINVAL;
 
-	ftrace_create_filter_files(tr->ops, parent);
+	ftrace_create_filter_files(tr, parent);
 
 	return 0;
 }
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index c408423e5d65e..c33129747a400 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -500,7 +500,7 @@ stack_trace_filter_open(struct inode *inode, struct file *file)
 	struct ftrace_ops *ops = inode->i_private;
 
 	/* Checks for tracefs lockdown */
-	return ftrace_regex_open(ops, FTRACE_ITER_FILTER,
+	return ftrace_regex_open(NULL, ops, FTRACE_ITER_FILTER,
 				 inode, file);
 }
 
-- 
2.53.0



