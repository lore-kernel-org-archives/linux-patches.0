Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F633914ED;
	Thu, 30 Jul 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426423; cv=none; b=gus1N3SO/yQ5M5fT++SJNAse9eD5cWUztnn/OdOsJ3KnP4icTzye7Ba78XHtC9+OFMyqB53iTJui3Lmb6bKCSpfDmfSweiBWhqkt6ufh37IjZTr3BOWc1HrrtH/dHIq/yVXmSrXtV7Oyo9EC/rhLJGyPziQ6Ctn4WJOMM3a6S9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426423; c=relaxed/simple;
	bh=xcSS3dGAG9yBCuwVZS/EDMQf4ytsxBcF6TrK37jFp00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpKaqQ9xlNzSgVn2yFJN/v62IqLcLALn0LIBukZDZuuQ+SF8Um6lkQTCAstHdaZnv3TXQZfYivhOJWzU2VPFJ+PDKGfdzWPTa6PahIaE3DysYWfkGWW23YQJWkhHsAnRvBQXL/A2dhdjTP48erNDumesARftYIZ5e56RNPDtIrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gXVjZmGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gXVjZmGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFDE1F000E9;
	Thu, 30 Jul 2026 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426422;
	bh=feC/dJr3afpe0rvzoasbb3zWCStHqhnA0UgbRzEAJHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXVjZmGiB9a/Fr/ELwuow3b1dg2Amn5Msj3QQ3FDKqkm3tnT4z+MO0h0fn9fT8BlH
	 JvqxHdMVDP3FoChUSFTzMQASF8oadNSJQIy+rKhzwYlQ25e310vieVxfzYu1XKZgAW
	 f8pEPyQGtXto8ySOUiqzANUghB6vRhdj7PUy/OvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	deepakraog <gaikwad.dcg@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 377/602] tracing: Fix resource leak on mmiotrace trace_pipe close
Date: Thu, 30 Jul 2026 16:12:49 +0200
Message-ID: <20260730141443.883239127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


