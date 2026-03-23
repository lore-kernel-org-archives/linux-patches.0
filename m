Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FBD3B19B8;
	Mon, 23 Mar 2026 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278531; cv=none; b=cv5HKGBKmHsywin0/BkivL2qUTnYvOqP0YfsT2QqACs/VCP9EuYM5VukYdRVyQgj5fCUOaZpAtTwkzNkHCDgelHq//+XqcXfdGlZ0GvdM2+ID6S51kxZ3A6zZPBZyVx4earTyea+WGtzQJXPe+343EWoyYYlz2qMlU1NR84hL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278531; c=relaxed/simple;
	bh=Rpf4ssqDtXQM/3SJRT1W7y2evNQPr/kGfMKPsixhiWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJgA+SaBL6sDQ6pMvT0vBdGGsSwZ5Oth5Oxk6hxGX0D5HLpSp/TLLigvsEXLV75g8xXJIMa+pOPN8QE/LlthL2wmhBQkhGrJL6KY6n6HM7HLB32N7nP39koZAFweXhqq5HZQ/ofTEFRZqvcF4p7FzEOQBexthMlB2si4E9gU/nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pl2u9lOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pl2u9lOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102CFC4CEF7;
	Mon, 23 Mar 2026 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278531;
	bh=Rpf4ssqDtXQM/3SJRT1W7y2evNQPr/kGfMKPsixhiWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pl2u9lOvrm4qR5YdLVENexYJPz/gYVwMw2yKWfHZRRi10k2YLE4UMFNHFWuOUBvDX
	 gKoDZkhfiZLrRz4ahfTZS93XNbywkuBUCKKZhPd+qdfj9WMbcb7Kz8yF/t582GyjtV
	 nnQMTK6qQS66o56t+hNPtlfPTKNYVr9J/40A+BgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Calvin Owens <calvin@wbinvd.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 338/567] tracing: Fix trace_buf_size= cmdline parameter with sizes >= 2G
Date: Mon, 23 Mar 2026 14:44:18 +0100
Message-ID: <20260323134542.198159871@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -9271,7 +9271,7 @@ static void
 init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer);
 
 static int
-allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, int size)
+allocate_trace_buffer(struct trace_array *tr, struct array_buffer *buf, unsigned long size)
 {
 	enum ring_buffer_flags rb_flags;
 
@@ -9307,7 +9307,7 @@ static void free_trace_buffer(struct arr
 	}
 }
 
-static int allocate_trace_buffers(struct trace_array *tr, int size)
+static int allocate_trace_buffers(struct trace_array *tr, unsigned long size)
 {
 	int ret;
 
@@ -10330,7 +10330,7 @@ __init static void enable_instances(void
 
 __init static int tracer_alloc_buffers(void)
 {
-	int ring_buf_size;
+	unsigned long ring_buf_size;
 	int ret = -ENOMEM;
 
 


