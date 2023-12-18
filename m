Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143E37884;
	Mon, 18 Dec 2023 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TFIa7Uvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FDCC433C7;
	Mon, 18 Dec 2023 14:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908888;
	bh=prgDe56YUWHzhH9nuLFTU1wqgV/rZh9wMG0AmkwgOrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TFIa7UvvD+uqH3BPlw/kr+cWYN+ahQL9mUySh3UQryR6mIQZUDi3gA2A62Al3Zp/2
	 V2GbMnQ9HDAM4GaUgHyw/Jd8iR+0cIK1RwJVSPKsXptLxsDbuOAcucrhmFd64rjfqL
	 3aYcIA2gS8FYLVeVVFaqWash5PKA3yXigEV2dcEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 71/83] ring-buffer: Do not update before stamp when switching sub-buffers
Date: Mon, 18 Dec 2023 14:52:32 +0100
Message-ID: <20231218135052.853165048@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 9e45e39dc249c970d99d2681f6bcb55736fd725c upstream.

The ring buffer timestamps are synchronized by two timestamp placeholders.
One is the "before_stamp" and the other is the "write_stamp" (sometimes
referred to as the "after stamp" but only in the comments. These two
stamps are key to knowing how to handle nested events coming in with a
lockless system.

When moving across sub-buffers, the before stamp is updated but the write
stamp is not. There's an effort to put back the before stamp to something
that seems logical in case there's nested events. But as the current event
is about to cross sub-buffers, and so will any new nested event that happens,
updating the before stamp is useless, and could even introduce new race
conditions.

The first event on a sub-buffer simply uses the sub-buffer's timestamp
and keeps a "delta" of zero. The "before_stamp" and "write_stamp" are not
used in the algorithm in this case. There's no reason to try to fix the
before_stamp when this happens.

As a bonus, it removes a cmpxchg() when crossing sub-buffers!

Link: https://lore.kernel.org/linux-trace-kernel/20231211114420.36dde01b@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: a389d86f7fd09 ("ring-buffer: Have nested events still record running time stamp")
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3558,14 +3558,7 @@ __rb_reserve_next(struct ring_buffer_per
 
 	/* See if we shot pass the end of this buffer page */
 	if (unlikely(write > BUF_PAGE_SIZE)) {
-		/* before and after may now different, fix it up*/
-		b_ok = rb_time_read(&cpu_buffer->before_stamp, &info->before);
-		a_ok = rb_time_read(&cpu_buffer->write_stamp, &info->after);
-		if (a_ok && b_ok && info->before != info->after)
-			(void)rb_time_cmpxchg(&cpu_buffer->before_stamp,
-					      info->before, info->after);
-		if (a_ok && b_ok)
-			check_buffer(cpu_buffer, info, CHECK_FULL_PAGE);
+		check_buffer(cpu_buffer, info, CHECK_FULL_PAGE);
 		return rb_move_tail(cpu_buffer, tail, info);
 	}
 


