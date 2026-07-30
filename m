Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B374D42047A;
	Thu, 30 Jul 2026 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423200; cv=none; b=dAZ7IGC5BKpXdxVQws5JJ9qjNadhPHuIQ+YRbVzzHlrKsiEUQ6F4s5X7xo5JdwUcdYyZA53OCzs2lUa/NOi5b6uqHOZQw9RJh7j8ZKMWW553wOWK/ZmYOrFgp47qVgRjcx8oHN787c7l6M/Tv2/+/8abvOmUbgx7G1bwmuuaGZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423200; c=relaxed/simple;
	bh=ExY6vUAbwlFO0NMZYFc2GuEC7YJnIzMyy9FdZry3on0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot6MI8/tqaiCU3kc9INNocwJgdOlJhA83kDY7IK3GvZ/tT2qW5FYI8mDJWQLWYxlU/QYrIs3IyuDg/RkPECEjpfVk0vTTSUyfn7zQbj3xEXDFFZYNFnY1KYxZX6ve9sgLOUieysgCtZsRfNGxBn1Sk7UkfkFudOozBfvojJaBcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAOozcM+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAOozcM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF051F000E9;
	Thu, 30 Jul 2026 14:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423199;
	bh=/A1peeF2PLFqMmVknVNqq+/zysOipagsVxJkI4vglSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAOozcM+KE9Mq4d1+KdcZSjydceOAzZAeoQG2F3VFCyrQgUwZJmg3zKucaW1+5gz8
	 M7EXWMEGq+B+Dz/nN4+97+Oon1aqyb0ENgfanMnJdyanSULUFruMHpCQg5LcY4CbJH
	 xuG9O1M/2QhNcIQyJHmNc1IBtToeHfebpLR4/EKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 646/744] ftrace: Add global mutex to serialize trace_parser access
Date: Thu, 30 Jul 2026 16:15:19 +0200
Message-ID: <20260730141458.001700840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

commit 7720b63bcef3f54c7fe288774b720a227d54a306 upstream.

In ftrace, the trace_parser structure is allocated and initialized when
a trace file is opened, and is subsequently used across write and release
handlers to parse user input.

The affected handler paths and their specific functions are:
  - Open paths: ftrace_regex_open(), ftrace_graph_open()
  - Write paths: ftrace_regex_write(), ftrace_graph_write()
  - Release paths: ftrace_regex_release(), ftrace_graph_release()

If userspace opens a trace file descriptor and shares it across multiple
threads, concurrent write calls will race on the parser's internal state,
specifically the 'idx', 'cont', and 'buffer' fields, leading to corrupted
input or undefined behavior.

Fix this by adding a global mutex, parser_lock, to serialize all access
to trace_parser across write and release paths, preventing concurrent
corruption of parser state.

Fixes: e704eff3ff51 ("ftrace: Have set_graph_function handle multiple functions in one write")
Fixes: 689fd8b65d66 ("tracing: trace parser support for function and graph")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260725024721.1983675-1-wutengda@huaweicloud.com
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1098,6 +1098,12 @@ struct ftrace_ops global_ops = {
 };
 
 /*
+ * parser_lock - Protects trace_parser state against concurrent operations.
+ * Held across trace_get_user() and subsequent buffer parsing to prevent races.
+ */
+static DEFINE_MUTEX(parser_lock);
+
+/*
  * Used by the stack unwinder to know about dynamic ftrace trampolines.
  */
 struct ftrace_ops *ftrace_ops_trampoline(unsigned long addr)
@@ -5824,6 +5830,8 @@ ftrace_regex_write(struct file *file, co
 	/* iter->hash is a local copy, so we don't need regex_lock */
 
 	parser = &iter->parser;
+
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
@@ -6961,12 +6969,14 @@ int ftrace_regex_release(struct inode *i
 		iter = file->private_data;
 
 	parser = &iter->parser;
+	mutex_lock(&parser_lock);
 	if (trace_parser_loaded(parser)) {
 		int enable = !(iter->flags & FTRACE_ITER_NOTRACE);
 
 		ftrace_process_regex(iter, parser->buffer,
 				     parser->idx, enable);
 	}
+	mutex_unlock(&parser_lock);
 
 	trace_parser_put(parser);
 
@@ -7298,10 +7308,12 @@ ftrace_graph_release(struct inode *inode
 
 		parser = &fgd->parser;
 
+		mutex_lock(&parser_lock);
 		if (trace_parser_loaded((parser))) {
 			ret = ftrace_graph_set_hash(fgd->new_hash,
 						    parser->buffer);
 		}
+		mutex_unlock(&parser_lock);
 
 		trace_parser_put(parser);
 
@@ -7414,6 +7426,7 @@ ftrace_graph_write(struct file *file, co
 
 	parser = &fgd->parser;
 
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&


