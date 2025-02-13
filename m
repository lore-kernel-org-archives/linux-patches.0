Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ADD24290D;
	Thu, 13 Feb 2025 14:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457856; cv=none; b=U14R6cY4Ji9kX9xBWmEAYI11M6WWcKEw2D5UCs1zMv/ND2xbeYj4LQ7fhPqaI3myAQe6dFa11GHv8XoQaBOZjN/3o7KPqbVE0bFjIimA1YoUkZlvATUtEzvpmKgjsfhp1c2+etIxKEmC+D4xw343tZRLnlvDQzVEwnHavNATm9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457856; c=relaxed/simple;
	bh=6mzQsGFPkkaTeTDlKmrSEqIsDB1VMDeHa6w76e+xM/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vD8Znci+aHBpIhW2hxOn5m9KbX0nvnRew3/LdoDN7Bn3ArHHm94+jMA83xHNSIC9IGRNvZ+CFPMkKf21G95JmepqklX/ttjsovCaEivn+ORpLggo1sxFm2XtdGuGS5rMoV9rj44FHVzcnr3XUW3wgeRQ0KLsdj1nti7QX77Pi4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6NusI5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6NusI5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E4CC4CED1;
	Thu, 13 Feb 2025 14:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457856;
	bh=6mzQsGFPkkaTeTDlKmrSEqIsDB1VMDeHa6w76e+xM/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6NusI5Q3bIYAUka0qHo9FqDsfixVGXyvkM4tQys0zrXC+XO95UoYWYeX0PQVdYYV
	 bnuQ/jr9Uwh7gbvxGuLsjWrDCzSfqYDafte5HdFmN150OIMHIDmOpOPPjJWP3eQQy2
	 96McM/UnXxL6NY0ufUBPOHrSIbUmWxoz0rw/LRz8=
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
Subject: [PATCH 6.12 200/422] ring-buffer: Do not allow events in NMI with generic atomic64 cmpxchg()
Date: Thu, 13 Feb 2025 15:25:49 +0100
Message-ID: <20250213142444.261046652@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


