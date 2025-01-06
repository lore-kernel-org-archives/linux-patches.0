Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0608E1DCB0E;
	Mon,  6 Jan 2025 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177436; cv=none; b=FTxZba4ICUjZplLjqnUsXDhVG9pbSItAsq3quZKZIyO9e4c3FxdMAJHLu5OEZrz4wf344yv+YoN6fputamRDvd2fGZI5dl+UILd+mZcyiU1vyiOVOsrlox1L1yBjcmy5/zskA4ILJaCDmTrLdj6OsCzU9WYOHGayfEeIKEmB434=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177436; c=relaxed/simple;
	bh=hKj4Z6Q6fY3mfVOjAVNmK7IwUGoqWD3SmZt/Lx9fRr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYvdXji6Mgfb1zsyVO5bOx2i9e1QsLE9t6tLpvDjnJIJpCee/uA0Y/O6IHqfW2wII4J8QqTyKDaNxo4mdpPnSkdg9FwFIXl/NwQ0zUWE0lZzyeikjldblPatVOshrOojA7YomVjGDkcJYGVac7S1S6RNm0bIdsnWAZEniln9x3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRR80enM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRR80enM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8BBC4CED6;
	Mon,  6 Jan 2025 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177435;
	bh=hKj4Z6Q6fY3mfVOjAVNmK7IwUGoqWD3SmZt/Lx9fRr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRR80enMdRKLI97FloZqrsuZKg3i0PhWtVMWksgWRJ+rP1dyQBaOvT+dKLSp10aGy
	 ETiyQCYKUeNeBxmpn6rGeTkM2QIwZw4YiCPjUZkacNzCvSRWiKT2XEZYOXQbwF2B0A
	 Gi5G26NN04wlJqBi45+mqrf4i9BZrKwWJ8uA5Uv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosryahmed@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Justin Stitt <justinstitt@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Yun Zhou <yun.zhou@windriver.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Kees Cook <keescook@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/222] seq_buf: Introduce DECLARE_SEQ_BUF and seq_buf_str()
Date: Mon,  6 Jan 2025 16:15:27 +0100
Message-ID: <20250106151155.265226041@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit dcc4e5728eeaeda84878ca0018758cff1abfca21 ]

Solve two ergonomic issues with struct seq_buf;

1) Too much boilerplate is required to initialize:

	struct seq_buf s;
	char buf[32];

	seq_buf_init(s, buf, sizeof(buf));

Instead, we can build this directly on the stack. Provide
DECLARE_SEQ_BUF() macro to do this:

	DECLARE_SEQ_BUF(s, 32);

2) %NUL termination is fragile and requires 2 steps to get a valid
   C String (and is a layering violation exposing the "internals" of
   seq_buf):

	seq_buf_terminate(s);
	do_something(s->buffer);

Instead, we can just return s->buffer directly after terminating it in
the refactored seq_buf_terminate(), now known as seq_buf_str():

	do_something(seq_buf_str(s));

Link: https://lore.kernel.org/linux-trace-kernel/20231027155634.make.260-kees@kernel.org
Link: https://lore.kernel.org/linux-trace-kernel/20231026194033.it.702-kees@kernel.org/

Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yun Zhou <yun.zhou@windriver.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h | 21 +++++++++++++++++----
 kernel/trace/trace.c    | 11 +----------
 lib/seq_buf.c           |  4 +---
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index a0fb013cebdf..d9db59f420a4 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -21,9 +21,18 @@ struct seq_buf {
 	size_t			len;
 };
 
+#define DECLARE_SEQ_BUF(NAME, SIZE)			\
+	char __ ## NAME ## _buffer[SIZE] = "";		\
+	struct seq_buf NAME = {				\
+		.buffer = &__ ## NAME ## _buffer,	\
+		.size = SIZE,				\
+	}
+
 static inline void seq_buf_clear(struct seq_buf *s)
 {
 	s->len = 0;
+	if (s->size)
+		s->buffer[0] = '\0';
 }
 
 static inline void
@@ -69,8 +78,8 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
 }
 
 /**
- * seq_buf_terminate - Make sure buffer is nul terminated
- * @s: the seq_buf descriptor to terminate.
+ * seq_buf_str - get %NUL-terminated C string from seq_buf
+ * @s: the seq_buf handle
  *
  * This makes sure that the buffer in @s is nul terminated and
  * safe to read as a string.
@@ -81,16 +90,20 @@ static inline unsigned int seq_buf_used(struct seq_buf *s)
  *
  * After this function is called, s->buffer is safe to use
  * in string operations.
+ *
+ * Returns @s->buf after making sure it is terminated.
  */
-static inline void seq_buf_terminate(struct seq_buf *s)
+static inline const char *seq_buf_str(struct seq_buf *s)
 {
 	if (WARN_ON(s->size == 0))
-		return;
+		return "";
 
 	if (seq_buf_buffer_left(s))
 		s->buffer[s->len] = 0;
 	else
 		s->buffer[s->size - 1] = 0;
+
+	return s->buffer;
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 83f6ef4d7419..d9406a1f8795 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3810,15 +3810,6 @@ static bool trace_safe_str(struct trace_iterator *iter, const char *str,
 	return false;
 }
 
-static const char *show_buffer(struct trace_seq *s)
-{
-	struct seq_buf *seq = &s->seq;
-
-	seq_buf_terminate(seq);
-
-	return seq->buffer;
-}
-
 static DEFINE_STATIC_KEY_FALSE(trace_no_verify);
 
 static int test_can_verify_check(const char *fmt, ...)
@@ -3958,7 +3949,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		 */
 		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
 			      "fmt: '%s' current_buffer: '%s'",
-			      fmt, show_buffer(&iter->seq))) {
+			      fmt, seq_buf_str(&iter->seq.seq))) {
 			int ret;
 
 			/* Try to safely read the string */
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index b7477aefff53..23518f77ea9c 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -109,9 +109,7 @@ void seq_buf_do_printk(struct seq_buf *s, const char *lvl)
 	if (s->size == 0 || s->len == 0)
 		return;
 
-	seq_buf_terminate(s);
-
-	start = s->buffer;
+	start = seq_buf_str(s);
 	while ((lf = strchr(start, '\n'))) {
 		int len = lf - start + 1;
 
-- 
2.39.5



