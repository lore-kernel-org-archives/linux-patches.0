Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D541B25C6EE;
	Thu, 20 Aug 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244494; cv=none; b=EH7nNyNXwROg41/Njgj5jeshPEl/JvomkdRJrTVwc5r+oFaxO8Y0CKQasdm3Sfuf1aVNh3L8uRcWDAwpTNoIqfShncrkPeHoXoR52MlzM4nPCN09eVAviLY+k0S2KIXU2JluxhkS4heJIJYbXW1ijTmzG+q82rB2aRRGnVwimKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244494; c=relaxed/simple;
	bh=IVqZP1XABYKxUEgAteSfRj1hMsmyYfJOTePGJwBdrNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDSp5sOwE6kc3b0+d2UEzEwphOguxDRoDJN9qFLfeIRcbmyT07R8NyB6EAv44ecVDPkwtd+nCNlPX5sGozqCeAdPg6MQxVjbTU0gExiAZ6/1JuDiG8+2QtE8KKvZpNUXD4yobhz3eLLGSTOydiDYSLkFuO9X+Ps+cBrucPIW8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfDOnV0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfDOnV0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA81F000E9;
	Thu, 20 Aug 2026 16:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244492;
	bh=RUdWTcxC5DugpoHNodWWVdHzdXYCElpMpuPy1uDXWL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfDOnV0rboH6yKCys1cZCc7aPq4fDuPkrsg/r+uHqb0Q85bF+BDtILsg+inisY1lT
	 dvpyJLn1S7YlQ5A0BCPCDm89DyCkNWkj7yfi7XmAKYjxAh2t584dZgTjWZo0bWun92
	 KgQxYuBV3fjpY5IrtQTjg5p6bcd/Tgvo3IZZyd0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/235] ftrace: Add global mutex to serialize trace_parser access
Date: Thu, 20 Aug 2026 16:57:05 +0200
Message-ID: <20260820145222.272054503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit 7720b63bcef3f54c7fe288774b720a227d54a306 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1043,6 +1043,12 @@ struct ftrace_ops global_ops = {
 };
 
 /*
+ * parser_lock - Protects trace_parser state against concurrent operations.
+ * Held across trace_get_user() and subsequent buffer parsing to prevent races.
+ */
+static DEFINE_MUTEX(parser_lock);
+
+/*
  * Used by the stack undwinder to know about dynamic ftrace trampolines.
  */
 struct ftrace_ops *ftrace_ops_trampoline(unsigned long addr)
@@ -4934,6 +4940,8 @@ ftrace_regex_write(struct file *file, co
 	/* iter->hash is a local copy, so we don't need regex_lock */
 
 	parser = &iter->parser;
+
+	mutex_lock(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
@@ -4947,6 +4955,7 @@ ftrace_regex_write(struct file *file, co
 
 	ret = read;
  out:
+	mutex_unlock(&parser_lock);
 	return ret;
 }
 
@@ -5682,12 +5691,14 @@ int ftrace_regex_release(struct inode *i
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
 
@@ -6005,10 +6016,12 @@ ftrace_graph_release(struct inode *inode
 
 		parser = &fgd->parser;
 
+		mutex_lock(&parser_lock);
 		if (trace_parser_loaded((parser))) {
 			ret = ftrace_graph_set_hash(fgd->new_hash,
 						    parser->buffer);
 		}
+		mutex_unlock(&parser_lock);
 
 		trace_parser_put(parser);
 
@@ -6127,6 +6140,7 @@ ftrace_graph_write(struct file *file, co
 
 	parser = &fgd->parser;
 
+	mutex_lock(&parser_lock);
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
 	if (read >= 0 && trace_parser_loaded(parser) &&
@@ -6139,6 +6153,7 @@ ftrace_graph_write(struct file *file, co
 
 	if (!ret)
 		ret = read;
+	mutex_unlock(&parser_lock);
 
 	return ret;
 }


