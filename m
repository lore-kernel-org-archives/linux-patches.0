Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E393F23B3;
	Tue, 17 Mar 2026 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766749; cv=none; b=hYlcHLRJVxL/UHD6/Y9T7WtKhfE4VQDKm2ANXTqN4j2BnuCXRYIad49oKTktnPMGi+qEsQ9P2arC72Ufw/k2E31QCUhcYIyfEkeBkjKzzbY17+RBgOGEV4vyp8OkO+UNcgQOvAJZwvzSMjnhXO8RBmJawY+KWlbwC7zJGHGmsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766749; c=relaxed/simple;
	bh=Oj/yTVBhja2FxBKd/xhg/QCzzdL3jwAnnHz7YTTPWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQ2b7zVuLWaq1FnPTLpeINRDXIhY10+SMd7dq2B/HjCibbqVbGOD6TZEQ6w0+MsQvyMfQdxYQHyMef/MDZdwgaSQN+1/vcqWhTLqpKKe9ZwHQmpqwcxs7C7T8icUY3QTyrIem2qsmZmRAJe5gCszYOGu/7I0Wmu6Jvg7QJBMF3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW54xACa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW54xACa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3458FC4CEF7;
	Tue, 17 Mar 2026 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766748;
	bh=Oj/yTVBhja2FxBKd/xhg/QCzzdL3jwAnnHz7YTTPWqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW54xACaxI+okSfrcVveJOWWfTsLqsyRwZEDXmZgpcLl/FyQ/JmK5G41mmnLF/f9K
	 iVCrFAo+mrE51YBsbMNJrBohkReXljsu9Fshh9WbO0mpBdzK7wCUHZGVZQl1mm1B+1
	 ZH0ehLaOr/SH97mFTFUPlBHt7TVA7rtlrW9rYIwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Calvin Owens <calvin@wbinvd.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.19 313/378] tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G
Date: Tue, 17 Mar 2026 17:34:30 +0100
Message-ID: <20260317163018.510046981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Calvin Owens <calvin@wbinvd.org>

commit d008ba8be8984760e36d7dcd4adbd5a41a645708 upstream.

Some of the sizing logic through tracer_alloc_buffers() uses int
internally, causing unexpected behavior if the user passes a value that
does not fit in an int (on my x86 machine, the result is uselessly tiny
buffers).

Fix by plumbing the parameter's real type (unsigned long) through to the
ring buffer allocation functions, which already use unsigned long.

It has always been possible to create larger ring buffers via the sysfs
interface: this only affects the cmdline parameter.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/bff42a4288aada08bdf74da3f5b67a2c28b761f8.1772852067.git.calvin@wbinvd.org
Fixes: 73c5162aa362 ("tracing: keep ring buffer to minimum size till used")
Signed-off-by: Calvin Owens <calvin@wbinvd.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10136,7 +10136,7 @@ static void setup_trace_scratch(struct t
 }
 
 static int
-allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, int size)
+allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, unsigned long size)
 {
 	enum ring_buffer_flags rb_flags;
 	struct trace_scratch *tscratch;
@@ -10191,7 +10191,7 @@ static void free_trace_buffer(struct arr
 	}
 }
 
-static int allocate_trace_buffers(struct trace_array *tr, int size)
+static int allocate_trace_buffers(struct trace_array *tr, unsigned long size)
 {
 	int ret;
 
@@ -11557,7 +11557,7 @@ __init static void enable_instances(void
 
 __init static int tracer_alloc_buffers(void)
 {
-	int ring_buf_size;
+	unsigned long ring_buf_size;
 	int ret = -ENOMEM;
 
 


