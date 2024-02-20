Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545C5133987;
	Tue, 20 Feb 2024 21:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463116; cv=none; b=c0oA2hvHvuefDMt/jYIO2FJJenRTk43ndpmqiNn5MN3FfpEGYxHVhHLrY0Ony+EAWG++WaxPcjJ5JtoFx2RLH0klwW9vv2bdFppQ6TGHzRXp1OhzuDDHycyu2P0w0VL9VC5hRHCeNTTu/LlbnHZBN/TOmioTlXa6GriPgY1doG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463116; c=relaxed/simple;
	bh=eB6By04p293gKUNLY6y8wX9C2Y3UEeCkwazkM4zGBL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfODG6/ZD53F35EXlS0t3r70i6fX9AqZG4GqUhw/U/zTPmvHyoKFmegaDfNls6x0ZoOd4lNZE+lX0G3eJErltmCtnwxai/ceLXsEs3J6ZWUQ3YXfzhFKAO2mfL4YeKdVGjC9Ho3JpkMXFLLRWiTCJoZrirWZHxPykWW6fBU9cRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6C450/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6C450/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEA56C433F1;
	Tue, 20 Feb 2024 21:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463116;
	bh=eB6By04p293gKUNLY6y8wX9C2Y3UEeCkwazkM4zGBL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6C450/XnuVmLXcObS0NStN79OGTNTdZ9TSrIlneFmxkFt/bO238A/HAD3ZZ0pot/
	 A8bDWlNnQwm+5JyMDrtFKRjWCLrch36OlEZ/hjag/7JYYaxGA6qUBMqlOnwdqgRArQ
	 lVgsooZx2mL2bPGJPm6df3zoQD9YChigp88hNs48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 100/197] tracing: Fix wasted memory in saved_cmdlines logic
Date: Tue, 20 Feb 2024 21:50:59 +0100
Message-ID: <20240220204844.077419659@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 44dc5c41b5b1267d4dd037d26afc0c4d3a568acb upstream.

While looking at improving the saved_cmdlines cache I found a huge amount
of wasted memory that should be used for the cmdlines.

The tracing data saves pids during the trace. At sched switch, if a trace
occurred, it will save the comm of the task that did the trace. This is
saved in a "cache" that maps pids to comms and exposed to user space via
the /sys/kernel/tracing/saved_cmdlines file. Currently it only caches by
default 128 comms.

The structure that uses this creates an array to store the pids using
PID_MAX_DEFAULT (which is usually set to 32768). This causes the structure
to be of the size of 131104 bytes on 64 bit machines.

In hex: 131104 = 0x20020, and since the kernel allocates generic memory in
powers of two, the kernel would allocate 0x40000 or 262144 bytes to store
this structure. That leaves 131040 bytes of wasted space.

Worse, the structure points to an allocated array to store the comm names,
which is 16 bytes times the amount of names to save (currently 128), which
is 2048 bytes. Instead of allocating a separate array, make the structure
end with a variable length string and use the extra space for that.

This is similar to a recommendation that Linus had made about eventfs_inode names:

  https://lore.kernel.org/all/20240130190355.11486-5-torvalds@linux-foundation.org/

Instead of allocating a separate string array to hold the saved comms,
have the structure end with: char saved_cmdlines[]; and round up to the
next power of two over sizeof(struct saved_cmdline_buffers) + num_cmdlines * TASK_COMM_LEN
It will use this extra space for the saved_cmdline portion.

Now, instead of saving only 128 comms by default, by using this wasted
space at the end of the structure it can save over 8000 comms and even
saves space by removing the need for allocating the other array.

Link: https://lore.kernel.org/linux-trace-kernel/20240209063622.1f7b6d5f@rorschach.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Mete Durlu <meted@linux.ibm.com>
Fixes: 939c7a4f04fcd ("tracing: Introduce saved_cmdlines_size file")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   75 +++++++++++++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2249,7 +2249,7 @@ struct saved_cmdlines_buffer {
 	unsigned *map_cmdline_to_pid;
 	unsigned cmdline_num;
 	int cmdline_idx;
-	char *saved_cmdlines;
+	char saved_cmdlines[];
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
@@ -2263,47 +2263,58 @@ static inline void set_cmdline(int idx,
 	strncpy(get_saved_cmdlines(idx), cmdline, TASK_COMM_LEN);
 }
 
-static int allocate_cmdlines_buffer(unsigned int val,
-				    struct saved_cmdlines_buffer *s)
+static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
 {
+	int order = get_order(sizeof(*s) + s->cmdline_num * TASK_COMM_LEN);
+
+	kfree(s->map_cmdline_to_pid);
+	free_pages((unsigned long)s, order);
+}
+
+static struct saved_cmdlines_buffer *allocate_cmdlines_buffer(unsigned int val)
+{
+	struct saved_cmdlines_buffer *s;
+	struct page *page;
+	int orig_size, size;
+	int order;
+
+	/* Figure out how much is needed to hold the given number of cmdlines */
+	orig_size = sizeof(*s) + val * TASK_COMM_LEN;
+	order = get_order(orig_size);
+	size = 1 << (order + PAGE_SHIFT);
+	page = alloc_pages(GFP_KERNEL, order);
+	if (!page)
+		return NULL;
+
+	s = page_address(page);
+	memset(s, 0, sizeof(*s));
+
+	/* Round up to actual allocation */
+	val = (size - sizeof(*s)) / TASK_COMM_LEN;
+	s->cmdline_num = val;
+
 	s->map_cmdline_to_pid = kmalloc_array(val,
 					      sizeof(*s->map_cmdline_to_pid),
 					      GFP_KERNEL);
-	if (!s->map_cmdline_to_pid)
-		return -ENOMEM;
-
-	s->saved_cmdlines = kmalloc_array(TASK_COMM_LEN, val, GFP_KERNEL);
-	if (!s->saved_cmdlines) {
-		kfree(s->map_cmdline_to_pid);
-		return -ENOMEM;
+	if (!s->map_cmdline_to_pid) {
+		free_saved_cmdlines_buffer(s);
+		return NULL;
 	}
 
 	s->cmdline_idx = 0;
-	s->cmdline_num = val;
 	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
 	       sizeof(s->map_pid_to_cmdline));
 	memset(s->map_cmdline_to_pid, NO_CMDLINE_MAP,
 	       val * sizeof(*s->map_cmdline_to_pid));
 
-	return 0;
+	return s;
 }
 
 static int trace_create_savedcmd(void)
 {
-	int ret;
-
-	savedcmd = kmalloc(sizeof(*savedcmd), GFP_KERNEL);
-	if (!savedcmd)
-		return -ENOMEM;
+	savedcmd = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT);
 
-	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
-	if (ret < 0) {
-		kfree(savedcmd);
-		savedcmd = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
+	return savedcmd ? 0 : -ENOMEM;
 }
 
 int is_tracing_stopped(void)
@@ -5972,26 +5983,14 @@ tracing_saved_cmdlines_size_read(struct
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
 }
 
-static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
-{
-	kfree(s->saved_cmdlines);
-	kfree(s->map_cmdline_to_pid);
-	kfree(s);
-}
-
 static int tracing_resize_saved_cmdlines(unsigned int val)
 {
 	struct saved_cmdlines_buffer *s, *savedcmd_temp;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	s = allocate_cmdlines_buffer(val);
 	if (!s)
 		return -ENOMEM;
 
-	if (allocate_cmdlines_buffer(val, s) < 0) {
-		kfree(s);
-		return -ENOMEM;
-	}
-
 	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 	savedcmd_temp = savedcmd;


