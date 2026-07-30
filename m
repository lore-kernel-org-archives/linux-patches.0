Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B021B44102D;
	Thu, 30 Jul 2026 14:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422899; cv=none; b=JOzKS92cxybpG+2032C33qCgoWPm7b0lcdePHqzVvkUxfR93GRHgko1V1qQzq59l5an4eXrb3QT0c/YKT5bHBFNRZSIi1mLA0L09bPtkTxI7PgdR+Zk4psxfd9od1lTayeECqu2uNxLRlUJc7c8msEOiDmpNaxHciBV6n5W2PRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422899; c=relaxed/simple;
	bh=u69Im/r14eLSFkOliFzHgClCTdkcULNuw5UyyyyA/Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd+RdKcIFS6XPSfE8fQl4gkuZnt8VA7M30xYA0axi6+avcaVXWN85qHjIa4fFy0U2fLIigVLdPPWbA+HZUSMe9SxH5nCSFRmImsAdWu055TS3DLAain0e7LzqinRkCGwMpdLc7KC2AluWhnKoIHLdbm6Eo9MA+f0zazfq+UfN18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UofLZH2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UofLZH2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162021F000E9;
	Thu, 30 Jul 2026 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422898;
	bh=dKo4sxQg+8zyEGLPP0UqwFK7pFsuM76SP6dgDoq2qCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UofLZH2poLm4TcNKBSLA1v9yPt1raeHy6Dc4WMUGhe6U+fl0Wuzs6ufCYZR4BuyAc
	 yhRruObxQHrwfgdt7DfRyp+D0Xy4mf5iSZ7wyGW9yO9++50BfTjf7Vx3EqHPcw8lCb
	 e8BNEpGiLfGemF0l3xkAMSvRzRbG12tSWRpAF19s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	deepakraog <gaikwad.dcg@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 593/744] tracing: Fix resource leak on mmiotrace trace_pipe close
Date: Thu, 30 Jul 2026 16:14:26 +0200
Message-ID: <20260730141456.884059967@linuxfoundation.org>
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


