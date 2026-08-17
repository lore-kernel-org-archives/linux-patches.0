Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBA243B498;
	Mon, 17 Aug 2026 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979535; cv=none; b=Q6fUrVSRL0rG4Vk2q/MoeF9YhseF0jGecLpIrwg+b7WXWLxlR08QvqEeRtPB7UkIEvzsEiBQxSFOlDX8Fz6nITe4MYV4bPwQAr2u7lKZDaKIAAOptcHPcRzdR6F97aDzCR5k/k3jZm+9g0Io2gH5TOgaRfxipcctrHBXEy0iFaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979535; c=relaxed/simple;
	bh=mJbANmDAxzfk5XaObQUwZJtkbZM86sBUsxTe6AkUijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNRggnnnLteqZmxqlFejLwwTBFOzXug5hDCh3+3qSagTuhe8N8Y4T4zhHpn6Xo645UZc4/li/z4F9NM8zcYloxbHZVd6P/ela7DvkF8MmsNUhY8TixZ8BjRyMIFbzZLDcbfNPrtb5E+DBTpGM8yYpLwL6Gv/o4hDj1SJ9+nEGqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaCf/GrQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaCf/GrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B0A1F000E9;
	Mon, 17 Aug 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979533;
	bh=nza6jWyFm2jqVQepsvFdYyUSVI6jdiYiohhvZv39Wk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaCf/GrQJ7eYAvWYdHXfu+/RWRDu2cVMEAsotgqLXTRx8Xo+UFCqVbxTX9FKsOY02
	 YAwn80Fk1sg3do6ctwo/US/5mEN2MenDmjYQ0E9hu2XTooWj70X7i0dQrfu9RW/cNl
	 29luNBQ3P99yx8TRkFwaw+qmoHTapW4RY+O9XShU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.1 259/609] ftrace: Add global mutex to serialize trace_parser access
Date: Mon, 17 Aug 2026 15:29:15 +0200
Message-ID: <20260817132552.772932607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1037,6 +1037,12 @@ struct ftrace_ops global_ops = {
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
@@ -5077,6 +5083,8 @@ ftrace_regex_write(struct file *file, co
 	/* iter->hash is a local copy, so we don't need regex_lock */
 
 	parser = &iter->parser;
+
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
@@ -6129,12 +6137,14 @@ int ftrace_regex_release(struct inode *i
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
 
@@ -6452,10 +6462,12 @@ ftrace_graph_release(struct inode *inode
 
 		parser = &fgd->parser;
 
+		mutex_lock(&parser_lock);
 		if (trace_parser_loaded((parser))) {
 			ret = ftrace_graph_set_hash(fgd->new_hash,
 						    parser->buffer);
 		}
+		mutex_unlock(&parser_lock);
 
 		trace_parser_put(parser);
 
@@ -6575,6 +6587,7 @@ ftrace_graph_write(struct file *file, co
 
 	parser = &fgd->parser;
 
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&


