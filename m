Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51447217723;
	Thu, 30 Jul 2026 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424821; cv=none; b=YuIOZCRA64IlmzEVhS+fVX3VyQqNicd9M1CbDCoOtG71J1qkmwZTMm87t6iLxoc/oPC+aJNvo0aWesBeq1v+093Xhy/EgqnUqpv8zPJO06C/YQfUS3lfpAL/pfdrkH+CrQ1Xeb405Ta4UPEnLImKzMUIE89qEyEASGxSUKIdywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424821; c=relaxed/simple;
	bh=xmSRmujvoR56XK29x/kDFmtYnc714DcVHiFWoOppw+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcBYxZDMFerHPh52KyGvjx1B+ckF7FAukpjPZI429egBU1/KlFG9NmPPq7fk0xNx7akPWKv2YXOzQI8jnkjjY1N0xx8cIzc09swOPwlgJGlmyHM7ornnbKZujiD2l/IWWJ59tCU4mxlqPWgS/cfgqbM8oLDh04ysigoXPtxkfsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsQNUDS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsQNUDS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF2D1F000E9;
	Thu, 30 Jul 2026 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424820;
	bh=7OH9AbRSeW43DsWb/wlsPcf9FZThkSTOhlxv8y1Po1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsQNUDS8g7ZzX1Kmwuo42dXqrjk9cHHvwvb7mVDBImBo928tctRb8lBWzGfA2aruO
	 thIRqOrSC72PXM6N7pKRY7UII7VuxC/n+lB38XczAVnA86nUZ3cg0vRacAR8MkanAD
	 YYilEYhfuky5sLUyXywvU2BkxkbsgTy2ToeEhQdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 528/675] ftrace: Add global mutex to serialize trace_parser access
Date: Thu, 30 Jul 2026 16:14:18 +0200
Message-ID: <20260730141456.366566430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1073,6 +1073,12 @@ struct ftrace_ops global_ops = {
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
@@ -5783,6 +5789,8 @@ ftrace_regex_write(struct file *file, co
 	/* iter->hash is a local copy, so we don't need regex_lock */
 
 	parser = &iter->parser;
+
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
@@ -6551,12 +6559,14 @@ int ftrace_regex_release(struct inode *i
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
 
@@ -6888,10 +6898,12 @@ ftrace_graph_release(struct inode *inode
 
 		parser = &fgd->parser;
 
+		mutex_lock(&parser_lock);
 		if (trace_parser_loaded((parser))) {
 			ret = ftrace_graph_set_hash(fgd->new_hash,
 						    parser->buffer);
 		}
+		mutex_unlock(&parser_lock);
 
 		trace_parser_put(parser);
 
@@ -7004,6 +7016,7 @@ ftrace_graph_write(struct file *file, co
 
 	parser = &fgd->parser;
 
+	guard(mutex)(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&


