Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2605352C4F;
	Tue, 10 Mar 2026 11:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141144; cv=none; b=lhBrYmg8GudB2DBEv8NlJ/VOC3TWmUBoX657P0qbfW7zJmJMQJiO6v36jiCng6V9s5NiNIuRaP5ZZUBDlYdrvDonomn/cbYyqRYWxumNfG4bzrJ/z6M63FgBY326vGfNe4U7YM5orBupYxR2daqmP6w1aCGrYWSvf0rn5RbiRoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141144; c=relaxed/simple;
	bh=XdxD0cocWjcEfwdJ2fyfwngsxrmeKaqfgizzc7DyVIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQQouHMXuu0d2FEErUyR3F32bmASq47DDM8gfsuacfN+8dx4G0YPL121s4aqoWN0wk/Y9i4nKpUw5SJoptsnAWvF0zEimRLOpJIjHvt2a8RauarlW8I+/Z+tOpgbRoJ6rJ0gl//yLn9KFgGFGFPE8XzK9pwt7COnE551kk/XEy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kzWQLdWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kzWQLdWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C421C2BC86;
	Tue, 10 Mar 2026 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141144;
	bh=XdxD0cocWjcEfwdJ2fyfwngsxrmeKaqfgizzc7DyVIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzWQLdWyoWdfNtkXnp4s7MV6aKwZ5/s7Q36VFhyNNmqYiafCMLpTzjMfpI/Mv+ULG
	 tCq4c7QwjbmjuQS4k+lxhV2OTsszswTZ+4XbFSEBhIgi8xb0QiY9JeAvz5AXlg+pdA
	 63X8wPfl/0eKySA36uvf7+Fl8vWw2BKcstG14M05C5hh3+lLtjfa+mTRgb5CMa0tVi
	 Ty8AfQMWzYvPkwHyh2w2VMy0Tt7DZ+vdsMrSs9WQML/pnVDzbnZ1jjgnVB+D0onoI6
	 WrULZ16/Fc669rgKwwO6UsyMw1+CYv3xC+9ahcFZko1oq9beEwaETU6I5xU5/yzlRv
	 ERP435QlyFmzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qing Wang <wangqing7171@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 148/311] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Date: Tue, 10 Mar 2026 07:03:15 -0400
Message-ID: <57a348cbb43b075f3f61994dffca4b92d9bcc018.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 include/linux/ring_buffer.h |  1 +
 kernel/trace/ring_buffer.c  | 21 +++++++++++++++++++++
 kernel/trace/trace.c        | 13 +++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 876358cfe1b12..d862fa610270b 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -248,6 +248,7 @@ int trace_rb_cpu_prepare(unsigned int cpu, struct hlist_node *node);
 
 int ring_buffer_map(struct trace_buffer *buffer, int cpu,
 		    struct vm_area_struct *vma);
+void ring_buffer_map_dup(struct trace_buffer *buffer, int cpu);
 int ring_buffer_unmap(struct trace_buffer *buffer, int cpu);
 int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu);
 #endif /* _LINUX_RING_BUFFER_H */
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2f44063c666f2..93f521b89aee1 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7292,6 +7292,27 @@ int ring_buffer_map(struct trace_buffer *buffer, int cpu,
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
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cc93d0e1f1876..bce112e1bbbae 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8999,6 +8999,18 @@ static inline int get_snapshot_map(struct trace_array *tr) { return 0; }
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
@@ -9018,6 +9030,7 @@ static int tracing_buffers_may_split(struct vm_area_struct *vma, unsigned long a
 }
 
 static const struct vm_operations_struct tracing_buffers_vmops = {
+	.open		= tracing_buffers_mmap_open,
 	.close		= tracing_buffers_mmap_close,
 	.may_split      = tracing_buffers_may_split,
 };
-- 
2.51.0

