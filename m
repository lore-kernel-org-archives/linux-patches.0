Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1971847A6B;
	Mon,  1 Apr 2024 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990097; cv=none; b=JvILp3nVDh4IkIK09M0yRcg7KPl1UkW8Uwb49CKeNdHUy0RcVV+2nDvh/CYDkuH0CBbCumg3/jO5RMuSTQ/KDa2ytmon5oJFTXhZDimCwtYNpcN3IiUUOz9S5b1Km8pJ9/AgE9cZwB9giTJJIoxUTIhWaxa+sfK7Y2L4VI1AlcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990097; c=relaxed/simple;
	bh=r6+LyfjMaBb1bElwj5ovznd2qLUxCBFSYtO0kIrQSFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7BVhIGMUpswXI87wQjEEAEXre1shIsv13k8kMXLIrhO8mEVQWiolgPzblaYBOcAEMQpGzhW3AS7C8V/x2zT3BzzVCMgexxpkT4Vq4IyJFFRHcXGZWPNXu7QfpKfl6mQ3WVOf+bz86FZtEg5feFrNbmwA70vbRKa2xfkDNyFMcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9iQEGoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9iQEGoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D70C433C7;
	Mon,  1 Apr 2024 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990097;
	bh=r6+LyfjMaBb1bElwj5ovznd2qLUxCBFSYtO0kIrQSFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9iQEGoGsBRNzLdO+NpGYhNUofJcOdL4vKuLT0cqgWq806k+CgstCLiyxodqlJg6F
	 63kOZx8BNO/dgDAJPTrssv1QxqSGoxGLq7THkEATnGpWv2g2aXOoRUkL5jK/Rdmm4s
	 qgDzzYZgrCniFuk0PigIcmD0Ro01hUmr8cFRbJK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linke li <lilinke99@qq.com>,
	Rabin Vincent <rabin@rab.in>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 216/396] tracing: Use .flush() call to wake up readers
Date: Mon,  1 Apr 2024 17:44:25 +0200
Message-ID: <20240401152554.362845175@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit e5d7c1916562f0e856eb3d6f569629fcd535fed2 upstream.

The .release() function does not get called until all readers of a file
descriptor are finished.

If a thread is blocked on reading a file descriptor in ring_buffer_wait(),
and another thread closes the file descriptor, it will not wake up the
other thread as ring_buffer_wake_waiters() is called by .release(), and
that will not get called until the .read() is finished.

The issue originally showed up in trace-cmd, but the readers are actually
other processes with their own file descriptors. So calling close() would wake
up the other tasks because they are blocked on another descriptor then the
one that was closed(). But there's other wake ups that solve that issue.

When a thread is blocked on a read, it can still hang even when another
thread closed its descriptor.

This is what the .flush() callback is for. Have the .flush() wake up the
readers.

Link: https://lore.kernel.org/linux-trace-kernel/20240308202432.107909457@goodmis.org

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linke li <lilinke99@qq.com>
Cc: Rabin Vincent <rabin@rab.in>
Fixes: f3ddb74ad0790 ("tracing: Wake up ring buffer waiters on closing of the file")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8359,6 +8359,20 @@ tracing_buffers_read(struct file *filp,
 	return size;
 }
 
+static int tracing_buffers_flush(struct file *file, fl_owner_t id)
+{
+	struct ftrace_buffer_info *info = file->private_data;
+	struct trace_iterator *iter = &info->iter;
+
+	iter->wait_index++;
+	/* Make sure the waiters see the new wait_index */
+	smp_wmb();
+
+	ring_buffer_wake_waiters(iter->array_buffer->buffer, iter->cpu_file);
+
+	return 0;
+}
+
 static int tracing_buffers_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_buffer_info *info = file->private_data;
@@ -8370,12 +8384,6 @@ static int tracing_buffers_release(struc
 
 	__trace_array_put(iter->tr);
 
-	iter->wait_index++;
-	/* Make sure the waiters see the new wait_index */
-	smp_wmb();
-
-	ring_buffer_wake_waiters(iter->array_buffer->buffer, iter->cpu_file);
-
 	if (info->spare)
 		ring_buffer_free_read_page(iter->array_buffer->buffer,
 					   info->spare_cpu, info->spare);
@@ -8589,6 +8597,7 @@ static const struct file_operations trac
 	.read		= tracing_buffers_read,
 	.poll		= tracing_buffers_poll,
 	.release	= tracing_buffers_release,
+	.flush		= tracing_buffers_flush,
 	.splice_read	= tracing_buffers_splice_read,
 	.unlocked_ioctl = tracing_buffers_ioctl,
 	.llseek		= no_llseek,


