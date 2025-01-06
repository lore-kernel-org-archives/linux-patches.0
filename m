Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28120146D40;
	Mon,  6 Jan 2025 15:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177341; cv=none; b=JlOuzdyHxwo7J438KbUSbBnLL0QCxZPIQD3SIGhU9i+zx9EfHkdLMJYVbGymZETJBVzneTD8ENYeKwiaJj8VesDRIStkg+cOp5SKXprJwWgm+VG9ssqcvidLmWt6scEie3FlHaBlaCAb5aHi4NRFwm9EcCQ3K3OH13e3qJKJJn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177341; c=relaxed/simple;
	bh=ad+zbkeJ8/AZpl6QHmBz4avBSXdszzStPk/nRy1816Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW/iH901So+YmeES5TCHArtI4GlW8IYElCbPDQK3FpWm3oAOrCqQNQhHeIuV27beushGYNsHyzK7E+m0/i8A+GV+/JhAefIpZ8D/7WW6XA/9mM+lt9jHX2v16U29fOVd2eOhO97MeGwtmiHOGUKPxHXNO5yy7aQgItdSzG75DRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1o8ahf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1o8ahf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C2BC4CED2;
	Mon,  6 Jan 2025 15:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177341;
	bh=ad+zbkeJ8/AZpl6QHmBz4avBSXdszzStPk/nRy1816Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1o8ahf3XavmmM4j4LhKrd+Q//rNn2EAEYH66UxCzdbWV35I/GJt6lKzZyanfjPAW
	 6xCv7mIbOOlneI7NqbxXsQJ6phdAbmU3impI1wzP4u8Zobx6q5XQxvQKKyaaerhjT2
	 5G5mUOd22pV47djxftNOdnsM9cBQ1pyD6sj2xEZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Youssef Esmat <youssefesmat@google.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Ross Zwisler <zwisler@google.com>,
	Kees Cook <keescook@chromium.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/222] tracing: Handle old buffer mappings for event strings and functions
Date: Mon,  6 Jan 2025 16:15:28 +0100
Message-ID: <20250106151155.303357040@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 07714b4bb3f9800261c8b4b2f47e9010ed60979d ]

Use the saved text_delta and data_delta of a persistent memory mapped ring
buffer that was saved from a previous boot, and use the delta in the trace
event print output so that strings and functions show up normally.

That is, for an event like trace_kmalloc() that prints the callsite via
"%pS", if it used the address saved in the ring buffer it will not match
the function that was saved in the previous boot if the kernel remaps
itself between boots.

For RCU events that point to saved static strings where only the address
of the string is saved in the ring buffer, it too will be adjusted to
point to where the string is on the current boot.

Link: https://lkml.kernel.org/r/20240612232026.821020753@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vineeth Pillai <vineeth@bitbyteword.org>
Cc: Youssef Esmat <youssefesmat@google.com>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: afd2627f727b ("tracing: Check "%s" dereference via the field and not the TP_printk format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d9406a1f8795..2a45efc4e417 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3858,8 +3858,11 @@ static void test_can_verify(void)
 void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 			 va_list ap)
 {
+	long text_delta = iter->tr->text_delta;
+	long data_delta = iter->tr->data_delta;
 	const char *p = fmt;
 	const char *str;
+	bool good;
 	int i, j;
 
 	if (WARN_ON_ONCE(!fmt))
@@ -3878,7 +3881,10 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 
 		j = 0;
 
-		/* We only care about %s and variants */
+		/*
+		 * We only care about %s and variants
+		 * as well as %p[sS] if delta is non-zero
+		 */
 		for (i = 0; p[i]; i++) {
 			if (i + 1 >= iter->fmt_size) {
 				/*
@@ -3907,6 +3913,11 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 				}
 				if (p[i+j] == 's')
 					break;
+
+				if (text_delta && p[i+1] == 'p' &&
+				    ((p[i+2] == 's' || p[i+2] == 'S')))
+					break;
+
 				star = false;
 			}
 			j = 0;
@@ -3920,6 +3931,24 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		iter->fmt[i] = '\0';
 		trace_seq_vprintf(&iter->seq, iter->fmt, ap);
 
+		/* Add delta to %pS pointers */
+		if (p[i+1] == 'p') {
+			unsigned long addr;
+			char fmt[4];
+
+			fmt[0] = '%';
+			fmt[1] = 'p';
+			fmt[2] = p[i+2]; /* Either %ps or %pS */
+			fmt[3] = '\0';
+
+			addr = va_arg(ap, unsigned long);
+			addr += text_delta;
+			trace_seq_printf(&iter->seq, fmt, (void *)addr);
+
+			p += i + 3;
+			continue;
+		}
+
 		/*
 		 * If iter->seq is full, the above call no longer guarantees
 		 * that ap is in sync with fmt processing, and further calls
@@ -3938,6 +3967,14 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		/* The ap now points to the string data of the %s */
 		str = va_arg(ap, const char *);
 
+		good = trace_safe_str(iter, str, star, len);
+
+		/* Could be from the last boot */
+		if (data_delta && !good) {
+			str += data_delta;
+			good = trace_safe_str(iter, str, star, len);
+		}
+
 		/*
 		 * If you hit this warning, it is likely that the
 		 * trace event in question used %s on a string that
@@ -3947,8 +3984,7 @@ void trace_check_vprintf(struct trace_iterator *iter, const char *fmt,
 		 * instead. See samples/trace_events/trace-events-sample.h
 		 * for reference.
 		 */
-		if (WARN_ONCE(!trace_safe_str(iter, str, star, len),
-			      "fmt: '%s' current_buffer: '%s'",
+		if (WARN_ONCE(!good, "fmt: '%s' current_buffer: '%s'",
 			      fmt, seq_buf_str(&iter->seq.seq))) {
 			int ret;
 
-- 
2.39.5



