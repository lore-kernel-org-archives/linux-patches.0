Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C044B26B082;
	Thu, 13 Feb 2025 15:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459290; cv=none; b=di5QmFehfzhhFPyTQOu3ca2KnTgGIUUeyKDs8PkfLrp+NAMmpSbURgWGca0vGfVohGJioGWGcRadDoIVStT7DAmZ9O+bV4gRt9kNermSHBVAXzqq60o+1rclHj+iGGKjl2+ruVWIboUeBcj4xzWtS0+Q1eGZL10+rd35OYKM+uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459290; c=relaxed/simple;
	bh=dJltKLW/QOJ0gvwDR0Ic4FHYYOdyvTEyvI1fnWabKeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARfzkXpxBjnI55XUwt0JwOtVJgQkO/5RITIHrNdaR307apHhhmePDA6brgbnpCngqI1eQiWY+ckZHp7Fx26vFeco8FaQgomgpFALkrUrpKaMxUZquX436ZqM22nJJecPnlGEZLNVG2mHOb7iVlUkaEYTDgRqwns4aqIlY6E8mB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvaEVb5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvaEVb5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882BFC4CED1;
	Thu, 13 Feb 2025 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459290;
	bh=dJltKLW/QOJ0gvwDR0Ic4FHYYOdyvTEyvI1fnWabKeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvaEVb5vj5kh4QrZSzGCcg5CoCd3jHr1xURcEbVQ9iYnKr2ytlVrLIk6MAZVPIxQ+
	 vCVYmldZjDRhz317LHdSBOZ0ANFv6jLLeNy+6FCIoR+EGPWowBUkJ1WVHXRvTs+M4J
	 jTLsZhF/z69LdafVdu+iDZHgq041NP+rdOjK7U8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Ludwig Rydberg <ludwig.rydberg@gaisler.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 222/443] ring-buffer: Do not allow events in NMI with generic atomic64 cmpxchg()
Date: Thu, 13 Feb 2025 15:26:27 +0100
Message-ID: <20250213142449.178681656@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit cd2375a3567fd3d93aa6c68e0027a5756213bda0 upstream.

Some architectures can not safely do atomic64 operations in NMI context.
Since the ring buffer relies on atomic64 operations to do its time
keeping, if an event is requested in NMI context, reject it for these
architectures.

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/20250120235721.407068250@goodmis.org
Fixes: c84897c0ff592 ("ring-buffer: Remove 32bit timestamp logic")
Closes: https://lore.kernel.org/all/86fb4f86-a0e4-45a2-a2df-3154acc4f086@gaisler.com/
Reported-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4398,8 +4398,13 @@ rb_reserve_next_event(struct trace_buffe
 	int nr_loops = 0;
 	int add_ts_default;
 
-	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
-	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	/*
+	 * ring buffer does cmpxchg as well as atomic64 operations
+	 * (which some archs use locking for atomic64), make sure this
+	 * is safe in NMI context
+	 */
+	if ((!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) ||
+	     IS_ENABLED(CONFIG_GENERIC_ATOMIC64)) &&
 	    (unlikely(in_nmi()))) {
 		return NULL;
 	}


