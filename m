Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019512;
	b=5NJUOpiDoMmc3K1mmJduzXrbjt9oQQtWYlaK7J6oXfR9LbU+F0GhTzZ6alnGkRDFm/W5
	 Krcp36bIgNxfqPuBhSpeieqB/nkTW3LBIOM/Saz4XAiSAkqdOns2E9DA0dIMQYAeNEnE7
	 /vtDcwCqf2RyfErMrs66mxobiywGHCAeRBE5yWN3WBG5+O73xKRNeqJiOro49/thOqaQK
	 JXRYpfaLEFpbjoCQSmg8vfJa4ecLnNz2eY8QKYa9zIaRWv6+XkdklJCKuNqBxSjwXhNuW
	 qqIDsE1cRPmwU2xBwnMNKxPXj2xaaFXHiAMIyxwTZJX7/Kgo2Fh80LMVw9YO9irjwQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jIzKm29R0SDhM2g3DOUU2CT8tBmBQeIVmMhcZrwwkes=;
	b=gUbmWFunKqcFajOpYj+4ZHC4LiRGlUjPOui4jqgzmVs/Ie7x/RG5I07tQRqUFJtZeiKe
	 EBqM7GUjp1jaZ54Xcy0upxyyglmUV8XdIHuj5h+UEb8t6fZdk1faGSULlfeWjm3S3r13f
	 o++mKfLdeAYyMFe86YjvPeCXetrJMTYGM4ih26dgOm+3Jf/pigpNrAwbyyl4hLp3d1OaB
	 5rAcmTKNPijxuzlFcQIrXsGeMq+8Rf1XQQXmlQhxMKuMIVCyYcP3oCqWqzpkGncTSxdyl
	 55albJoXFKbQ3oZT1ip5hwpfHD+DT2FP88XOiSRorRAKGK4Ms1th0O7O8WP5Z1iONCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeuvQWB6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0891606A31C;
	Wed, 18 Nov 2026 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PeuvQWB6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DBD1F000C4;
	Wed, 18 Nov 2026 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019511;
	bh=jIzKm29R0SDhM2g3DOUU2CT8tBmBQeIVmMhcZrwwkes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PeuvQWB6usP+tlFY3UOQlZPuhP5u6Jjn4do3vXfrjtI/x5NHOBjnTtTD6YRwOpm5Z
	 iDPtindtYYwQYchlmchYvWJg+TbVbK66/Q6kWB6t1IgrdXdldk0NHnQph8Z9Np9nYz
	 gQ5b6qrJP86vVn+wcwcmEgsqPZxTmFv0GQ9DzBp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1615/2651] seq_buf: Do not pop from an overflowed seq_buf
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150345.999412696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit b7e688b5635a0888613f4d620eeb7440e2f23a7e ]

When a seq_buf has overflowed, its len is size + 1, so seq_buf_pop()
decrements len to size and reads buffer[size], one byte past the end of
the buffer. It also leaves len equal to size, which no longer counts as
overflowed, so a truncated seq_buf then looks like a complete, full one.

An overflowed seq_buf logically has no last character to pop: the
length of what was written has been lost, and the last byte of the
buffer may be the NUL written by vsnprintf() or bytes that were never
committed. Return -1 for an overflowed seq_buf, as for an empty one,
and leave it overflowed, as the rest of the seq_buf API does until
seq_buf_clear() or seq_buf_init().

The current callers do not reach this, e.g. trace_syscalls only calls
trace_seq_pop() when the trace_seq it pops from has not overflowed, and
kernel/bpf/diagnostics.c sets the length from strnlen() before popping.

Add tests for the pop corner cases.

Tests passed under qemu on ARCH=x86_64 with GCC 16.2.0 and CONFIG_KASAN=y,
and on big-endian ARCH=s390 with GCC s390x-linux-gnu 16.1.0.

Fixes: 32e0f607ac6a2 ("tracing: Add trace_seq_pop() and seq_buf_pop()")
Assisted-by: LLM
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20261005155708.1471260-2-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_buf.h   |  4 ++--
 include/linux/trace_seq.h |  5 ++++-
 lib/tests/seq_buf_kunit.c | 42 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 9f2839e73f8a1..f5a350347bc5b 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -155,11 +155,11 @@ static inline void seq_buf_commit(struct seq_buf *s, int num)
  *
  * Removes the last written character to the seq_buf @s.
  *
- * Returns the last character or -1 if it is empty.
+ * Returns the last character, or -1 if @s is empty or has overflowed.
  */
 static inline int seq_buf_pop(struct seq_buf *s)
 {
-	if (!s->len)
+	if (!s->len || seq_buf_has_overflowed(s))
 		return -1;
 
 	s->len--;
diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 697d619aafdca..7174ebf3f015f 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -86,7 +86,10 @@ static inline bool trace_seq_has_overflowed(struct trace_seq *s)
  *
  * Removes the last written character to the trace_seq @s.
  *
- * Returns the last character or -1 if it is empty.
+ * Returns the last character, or -1 if the underlying seq_buf is empty or
+ * has overflowed. Note that only that buffer is consulted: a @s marked
+ * full by a write that did not fit, which trace_seq_has_overflowed()
+ * reports as overflowed, still pops the last character written.
  */
 static inline int trace_seq_pop(struct trace_seq *s)
 {
diff --git a/lib/tests/seq_buf_kunit.c b/lib/tests/seq_buf_kunit.c
index 0934dfb602ff6..de491f96c1acb 100644
--- a/lib/tests/seq_buf_kunit.c
+++ b/lib/tests/seq_buf_kunit.c
@@ -115,6 +115,47 @@ static void seq_buf_putc_test(struct kunit *test)
 	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "");
 }
 
+static void seq_buf_pop_test(struct kunit *test)
+{
+	DECLARE_SEQ_BUF(s, 8);
+	struct seq_buf t;
+	char *buf;
+
+	/* Nothing to pop. */
+	KUNIT_EXPECT_EQ(test, seq_buf_pop(&s), -1);
+	KUNIT_EXPECT_EQ(test, s.len, 0);
+
+	seq_buf_puts(&s, "hello");
+	KUNIT_EXPECT_EQ(test, seq_buf_pop(&s), 'o');
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 4);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hell");
+
+	/* A 0xff byte must not be mistaken for an empty buffer. */
+	seq_buf_putc(&s, 0xff);
+	KUNIT_EXPECT_EQ(test, seq_buf_pop(&s), 0xff);
+
+	/* A full buffer pops its last byte. */
+	seq_buf_puts(&s, "abc");
+	seq_buf_putc(&s, 'd');
+	KUNIT_EXPECT_FALSE(test, seq_buf_has_overflowed(&s));
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 8);
+	KUNIT_EXPECT_EQ(test, seq_buf_pop(&s), 'd');
+	KUNIT_EXPECT_EQ(test, seq_buf_used(&s), 7);
+	KUNIT_EXPECT_STREQ(test, seq_buf_str(&s), "hellabc");
+
+	/*
+	 * An overflowed buffer has nothing to pop, and stays overflowed. Use
+	 * a buffer allocated at its exact size, so that KASAN reports any
+	 * read past its end.
+	 */
+	buf = kunit_kmalloc(test, 16, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	seq_buf_init(&t, buf, 16);
+	KUNIT_EXPECT_EQ(test, seq_buf_printf(&t, "%s", "longer than sixteen"), -1);
+	KUNIT_EXPECT_EQ(test, seq_buf_pop(&t), -1);
+	KUNIT_EXPECT_TRUE(test, seq_buf_has_overflowed(&t));
+}
+
 static void seq_buf_printf_test(struct kunit *test)
 {
 	DECLARE_SEQ_BUF(s, 32);
@@ -354,6 +395,7 @@ static struct kunit_case seq_buf_test_cases[] = {
 	KUNIT_CASE(seq_buf_puts_test),
 	KUNIT_CASE(seq_buf_puts_overflow_test),
 	KUNIT_CASE(seq_buf_putc_test),
+	KUNIT_CASE(seq_buf_pop_test),
 	KUNIT_CASE(seq_buf_printf_test),
 	KUNIT_CASE(seq_buf_printf_overflow_test),
 	KUNIT_CASE(seq_buf_get_buf_commit_test),
-- 
2.53.0



