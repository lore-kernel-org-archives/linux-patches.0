Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C580335A3A9;
	Thu, 12 Mar 2026 20:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347070; cv=none; b=hKD2kahScGb9zzZ4SsU2KKlKv2u43nY5nWbE0UlBJqHfFP9Sg0PDH5p8vha96UjSWWg2WVoJteHFw90XvcmoE5A/f8DuNRTuIsyaBSjsQ2vPa4IYV9i3swwQj7Y+EIMioArMQdvQKUnAsOcNAqRNPAR53iHMl+S9lJFqN8f7vZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347070; c=relaxed/simple;
	bh=APVeU+FZjkc23cipIRSp4lxWuPDTqL7qycXOLHHShws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjycedIsDIG7FaxiAgXeL81nyJxhgJIHpArpHwWjME/O7ZNgzjfviJGMZcRFW/JEVGpqoV4qGIvIUPtweXfuZZCpzxCPkSlabGOeKP/SRqvi7u9tPmQWVoZD+B+X5isZcwmAbe6KvU5KITbb8ESecA/sXBSW9IZuSSEULj5X3GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfpGoehL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfpGoehL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AD2C4CEF7;
	Thu, 12 Mar 2026 20:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347070;
	bh=APVeU+FZjkc23cipIRSp4lxWuPDTqL7qycXOLHHShws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfpGoehL00O6IdhZwmAKxhS9kPqdDEWeqyJEvi5esnmo6VdA/WEka+MrBwKeIp6nF
	 GoPGYS22VXfptp0C75eSz7cZbZ7ApXkuaJ8wk9+ExErJZZFrxSXxRNHfGK16LeJ6Jw
	 9jUbYtbhYl6TZ8GGZJxS8x51H52Xag3hrSv9IxT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com,
	Qing Wang <wangqing7171@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 152/265] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Date: Thu, 12 Mar 2026 21:08:59 +0100
Message-ID: <20260312201023.753560609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Qing Wang <wangqing7171@gmail.com>

commit e39bb9e02b68942f8e9359d2a3efe7d37ae6be0e upstream.

When a process forks, the child process copies the parent's VMAs but the
user_mapped reference count is not incremented. As a result, when both the
parent and child processes exit, tracing_buffers_mmap_close() is called
twice. On the second call, user_mapped is already 0, causing the function to
return -ENODEV and triggering a WARN_ON.

Normally, this isn't an issue as the memory is mapped with VM_DONTCOPY set.
But this is only a hint, and the application can call
madvise(MADVISE_DOFORK) which resets the VM_DONTCOPY flag. When the
application does that, it can trigger this issue on fork.

Fix it by incrementing the user_mapped reference count without re-mapping
the pages in the VMA's open callback.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://patch.msgid.link/20260227025842.1085206-1-wangqing7171@gmail.com
Fixes: cf9f0f7c4c5bb ("tracing: Allow user-space mapping of the ring-buffer")
Reported-by: syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3b5dd2030fe08afdf65d
Tested-by: syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   21 +++++++++++++++++++++
 kernel/trace/trace.c        |   13 +++++++++++++
 3 files changed, 35 insertions(+)

--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -244,6 +244,7 @@ int trace_rb_cpu_prepare(unsigned int cp
 
 int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
+void ring_buffer_map_dup(struct trace_buffer *buffer, int cpu);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
 #endif /* _LINUX_RING_BUFFER_H */
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7154,6 +7154,27 @@ unlock:
 	return err;
 }
 
+/*
+ * This is called when a VMA is duplicated (e.g., on fork()) to increment
+ * the user_mapped counter without remapping pages.
+ */
+void ring_buffer_map_dup(struct trace_buffer *buffer, int cpu)
+{
+	struct ring_buffer_per_cpu *cpu_buffer;
+
+	if (WARN_ON(!cpumask_test_cpu(cpu, buffer->cpumask)))
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+
+	guard(mutex)(&cpu_buffer->mapping_lock);
+
+	if (cpu_buffer->user_mapped)
+		__rb_inc_dec_mapped(cpu_buffer, true);
+	else
+		WARN(1, "Unexpected buffer stat, it should be mapped");
+}
+
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8274,6 +8274,18 @@ static inline int get_snapshot_map(struc
 static inline void put_snapshot_map(struct trace_array *tr) { }
 #endif
 
+/*
+ * This is called when a VMA is duplicated (e.g., on fork()) to increment
+ * the user_mapped counter without remapping pages.
+ */
+static void tracing_buffers_mmap_open(struct vm_area_struct *vma)
+{
+	struct ftrace_buffer_info *info = vma->vm_file->private_data;
+	struct trace_iterator *iter = &info->iter;
+
+	ring_buffer_map_dup(iter->array_buffer->buffer, iter->cpu_file);
+}
+
 static void tracing_buffers_mmap_close(struct vm_area_struct *vma)
 {
 	struct ftrace_buffer_info *info = vma->vm_file->private_data;
@@ -8293,6 +8305,7 @@ static int tracing_buffers_may_split(str
 }
 
 static const struct vm_operations_struct tracing_buffers_vmops = {
+	.open		= tracing_buffers_mmap_open,
 	.close		= tracing_buffers_mmap_close,
 	.may_split      = tracing_buffers_may_split,
 };


