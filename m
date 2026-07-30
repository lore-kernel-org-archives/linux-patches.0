Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E729138B133;
	Thu, 30 Jul 2026 16:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427782; cv=none; b=E5IwIq8TvJ6ucEkkdbAdWoj0yOM8251TKHUHPnFKHa5vbKcNe3cOmpN0S3DaZd3RcPHmugGUC/AqflHJ8AWAWnvf1aucwRBaMWLzlKb3t7fsl+V6RhMqhRvoyAGtdo1VYR+xN1iVasBfJqLcjJQROvLqnuf2mQkIjl9FMtXFAl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427782; c=relaxed/simple;
	bh=zWgyo18MDHPIZUF0lh2lILOGK3W5DhGgTgq7xSLv4bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPKNhAzcT03HEx1xH2kVD+sdb+wNsm8/sSkNVtp7uaPHoOiqpNkVQnVPh/1G17Fby57nOFZhj9yKndVGFn4QsIQ/FKYl6JvzXEG1uMcGU6B2LWq/qJ9Wq+edAxLfkwcGf73gkyYvYOuWRuDPNPD8vr42ZZV38ltH7AN/n9gnlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JchzoTOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JchzoTOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F421F000E9;
	Thu, 30 Jul 2026 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427780;
	bh=Ix4S+EqYAJolGmaXmhzvH8xmekLaWTJz7SqmrVwkLHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JchzoTObY7Nx3eujr/BOBlxwDeG+lL9+LTgkRlPWqDz+MmV8Gh8Yu7U/dIN6aPiLt
	 4zq8Kmu6rxpqgO5ALTGsI53qHXMl6w8g+JtdQUeak99ws1h/Po/y0GC2hht6NONMTV
	 3LKVFEbO3JFPBvKJ9u9dLTRwTiwgTb8rs+3ZN63U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	deepakraog <gaikwad.dcg@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 292/484] tracing: Fix resource leak on mmiotrace trace_pipe close
Date: Thu, 30 Jul 2026 16:13:09 +0200
Message-ID: <20260730141429.838901139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: deepakraog <gaikwad.dcg@gmail.com>

commit c1d87e724ae55e781b7cc7ccafb34d9e668582b2 upstream.

The mmiotrace tracer was added May 12th 2008. At that time, resources
created in pipe_open() could not be freed because there was not
pipe_close function pointer of the tracer. The pipe_close function pointer
was added in December 7th, 2009, but the mmiotrace tracer was not updated.

mmio_pipe_open() allocates a header_iter and takes a pci_dev reference
when trace_pipe is opened. mmio_close() frees them, but it was only
wired to the tracer's .close callback.

tracing_release_pipe() invokes .pipe_close, not .close, when the
trace_pipe file is released. As a result, closing trace_pipe with the
mmiotrace tracer active leaked the header_iter allocation and left a
stale pci_dev reference.

Set .pipe_close to mmio_close, matching how function_graph wires both
callbacks to the same handler.

Note, if the trace_pipe is read to completion, it will clean up the
resources, but if one were to run:

  # head -n 1 /sys/kernel/tracing/trace_pipe
 VERSION 20070824

Over and over again, it would trigger a massive leak.

Cc: stable@vger.kernel.org
Fixes: c521efd1700a8 ("tracing: Add pipe_close interface)
Link: https://patch.msgid.link/20260715143604.14481-1-gaikwad.dcg@gmail.com
Signed-off-by: deepakraog <gaikwad.dcg@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_mmiotrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -109,7 +109,6 @@ static void mmio_pipe_open(struct trace_
 	iter->private = hiter;
 }
 
-/* XXX: This is not called when the pipe is closed! */
 static void mmio_close(struct trace_iterator *iter)
 {
 	struct header_iter *hiter = iter->private;
@@ -279,6 +278,7 @@ static struct tracer mmio_tracer __read_
 	.start		= mmio_trace_start,
 	.pipe_open	= mmio_pipe_open,
 	.close		= mmio_close,
+	.pipe_close	= mmio_close,
 	.read		= mmio_read,
 	.print_line	= mmio_print_line,
 	.noboot		= true,


