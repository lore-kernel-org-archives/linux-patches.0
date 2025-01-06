Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEE2148316;
	Mon,  6 Jan 2025 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177315; cv=none; b=r6pISltTd1SPysHvkxBZbc9ZYiJlQtVX9zv3ydlGWmEyNfJjz8lLUKSakXXA3G9OoSG/f9+6hEv/x6cO7ik3VZtz6JaXWGKDniRzVmTLxaFmnpPMNSY3iU3QH4ZtGS0ngzCwLvHAGZBuJgyTWkp0UESZeN9H26sPagOCFxFnPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177315; c=relaxed/simple;
	bh=lenJExk+kbdKjgzWXIJHTeQtsPVzl/HOwXd5DuSEzws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9tIxeQ7JSiAF4Mn1wJ2uPlBZKBWe2x89i1o3gKnqFla8iMrngCmuTSc2tomD5Xrd5GHBVeU4uuFTLDqRxtve6bIyyCjciRpeD0nLZcLgXIBVkxmjpLCzq1nEzU/3VYuCYBOtTOWDBPO5HMyjXIbgJkd46x2nOQTcxyQ6JOG45E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyFufBMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyFufBMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBBEC4CED2;
	Mon,  6 Jan 2025 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177314;
	bh=lenJExk+kbdKjgzWXIJHTeQtsPVzl/HOwXd5DuSEzws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyFufBMGVEUxGs2HHcYGfpGwHKiZcFt9KqZ6gcxHghp6ayzFqX7XBa8EG62+MSYsE
	 FCoVn8/BSLmZhevntJxcqOK6B10J6C2WibD5Nk1CiZqBjfrMa56rT00FME/VdKqCqb
	 c12P7036e+EmT35fo0V3IQQ3O7zyDUm4pf1Y+uX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/222] tracing: Move readpos from seq_buf to trace_seq
Date: Mon,  6 Jan 2025 16:15:25 +0100
Message-ID: <20250106151155.189727379@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit d0ed46b60396cfa7e0056f55e1ce0b43c7db57b6 ]

To make seq_buf more lightweight as a string buf, move the readpos member
from seq_buf to its container, trace_seq.  That puts the responsibility
of maintaining the readpos entirely in the tracing code.  If some future
users want to package up the readpos with a seq_buf, we can define a
new struct then.

Link: https://lore.kernel.org/linux-trace-kernel/20231020033545.2587554-2-willy@infradead.org

Cc: Kees Cook <keescook@chromium.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h   |  5 +----
 include/linux/trace_seq.h |  2 ++
 kernel/trace/trace.c      | 10 +++++-----
 kernel/trace/trace_seq.c  |  6 +++++-
 lib/seq_buf.c             | 22 ++++++++++------------
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 515d7fcb9634..a0fb013cebdf 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -14,19 +14,16 @@
  * @buffer:	pointer to the buffer
  * @size:	size of the buffer
  * @len:	the amount of data inside the buffer
- * @readpos:	The next position to read in the buffer.
  */
 struct seq_buf {
 	char			*buffer;
 	size_t			size;
 	size_t			len;
-	loff_t			readpos;
 };
 
 static inline void seq_buf_clear(struct seq_buf *s)
 {
 	s->len = 0;
-	s->readpos = 0;
 }
 
 static inline void
@@ -143,7 +140,7 @@ extern __printf(2, 0)
 int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
 extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
 extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
-			   int cnt);
+			   size_t start, int cnt);
 extern int seq_buf_puts(struct seq_buf *s, const char *str);
 extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
 extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 6be92bf559fe..3691e0e76a1a 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -14,6 +14,7 @@
 struct trace_seq {
 	char			buffer[PAGE_SIZE];
 	struct seq_buf		seq;
+	size_t			readpos;
 	int			full;
 };
 
@@ -22,6 +23,7 @@ trace_seq_init(struct trace_seq *s)
 {
 	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
 	s->full = 0;
+	s->readpos = 0;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 220903117c51..83f6ef4d7419 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1731,15 +1731,15 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 {
 	int len;
 
-	if (trace_seq_used(s) <= s->seq.readpos)
+	if (trace_seq_used(s) <= s->readpos)
 		return -EBUSY;
 
-	len = trace_seq_used(s) - s->seq.readpos;
+	len = trace_seq_used(s) - s->readpos;
 	if (cnt > len)
 		cnt = len;
-	memcpy(buf, s->buffer + s->seq.readpos, cnt);
+	memcpy(buf, s->buffer + s->readpos, cnt);
 
-	s->seq.readpos += cnt;
+	s->readpos += cnt;
 	return cnt;
 }
 
@@ -7011,7 +7011,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	/* Now copy what we have to the user */
 	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
-	if (iter->seq.seq.readpos >= trace_seq_used(&iter->seq))
+	if (iter->seq.readpos >= trace_seq_used(&iter->seq))
 		trace_seq_init(&iter->seq);
 
 	/*
diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
index bac06ee3b98b..7be97229ddf8 100644
--- a/kernel/trace/trace_seq.c
+++ b/kernel/trace/trace_seq.c
@@ -370,8 +370,12 @@ EXPORT_SYMBOL_GPL(trace_seq_path);
  */
 int trace_seq_to_user(struct trace_seq *s, char __user *ubuf, int cnt)
 {
+	int ret;
 	__trace_seq_init(s);
-	return seq_buf_to_user(&s->seq, ubuf, cnt);
+	ret = seq_buf_to_user(&s->seq, ubuf, s->readpos, cnt);
+	if (ret > 0)
+		s->readpos += ret;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(trace_seq_to_user);
 
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 45c450f423fa..b7477aefff53 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -324,23 +324,24 @@ int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
  * seq_buf_to_user - copy the sequence buffer to user space
  * @s: seq_buf descriptor
  * @ubuf: The userspace memory location to copy to
+ * @start: The first byte in the buffer to copy
  * @cnt: The amount to copy
  *
  * Copies the sequence buffer into the userspace memory pointed to
- * by @ubuf. It starts from the last read position (@s->readpos)
- * and writes up to @cnt characters or till it reaches the end of
- * the content in the buffer (@s->len), which ever comes first.
+ * by @ubuf. It starts from @start and writes up to @cnt characters
+ * or until it reaches the end of the content in the buffer (@s->len),
+ * whichever comes first.
  *
  * On success, it returns a positive number of the number of bytes
  * it copied.
  *
  * On failure it returns -EBUSY if all of the content in the
  * sequence has been already read, which includes nothing in the
- * sequence (@s->len == @s->readpos).
+ * sequence (@s->len == @start).
  *
  * Returns -EFAULT if the copy to userspace fails.
  */
-int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
+int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, size_t start, int cnt)
 {
 	int len;
 	int ret;
@@ -350,20 +351,17 @@ int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
 
 	len = seq_buf_used(s);
 
-	if (len <= s->readpos)
+	if (len <= start)
 		return -EBUSY;
 
-	len -= s->readpos;
+	len -= start;
 	if (cnt > len)
 		cnt = len;
-	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
+	ret = copy_to_user(ubuf, s->buffer + start, cnt);
 	if (ret == cnt)
 		return -EFAULT;
 
-	cnt -= ret;
-
-	s->readpos += cnt;
-	return cnt;
+	return cnt - ret;
 }
 
 /**
-- 
2.39.5



