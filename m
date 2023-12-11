Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A1321B8;
	Mon, 11 Dec 2023 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C08AgdSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAE3C433C8;
	Mon, 11 Dec 2023 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321157;
	bh=v4VWqROuaHsJJwsH/mg24Oy6rthEBcZqkk5XlNOJfnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C08AgdSEAxDhwPtk8/6kcbfPrAMUPlc9ilkGeEe9669H1Sj8R6a56DKycJGOg9W7r
	 2zI0Dt0wVCx1Py5Y7doBR5yqA3ahi5sErp5buX3EettNtlBJYkq9ct0Eg193WrHlly
	 RDtXhbtTPYjrJKVc/Bih4UfkCJJbPO+4VdLAIZWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/141] ring-buffer: Force absolute timestamp on discard of event
Date: Mon, 11 Dec 2023 19:22:41 +0100
Message-ID: <20231211182030.985659979@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

[ Upstream commit b2dd797543cfa6580eac8408dd67fa02164d9e56 ]

There's a race where if an event is discarded from the ring buffer and an
interrupt were to happen at that time and insert an event, the time stamp
is still used from the discarded event as an offset. This can screw up the
timings.

If the event is going to be discarded, set the "before_stamp" to zero.
When a new event comes in, it compares the "before_stamp" with the
"write_stamp" and if they are not equal, it will insert an absolute
timestamp. This will prevent the timings from getting out of sync due to
the discarded event.

Link: https://lore.kernel.org/linux-trace-kernel/20231206100244.5130f9b3@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 6f6be606e763f ("ring-buffer: Force before_stamp and write_stamp to be different on discard")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a930a9d7d834d..16fce72a7601c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2982,22 +2982,19 @@ rb_try_to_discard(struct ring_buffer_per_cpu *cpu_buffer,
 			local_read(&bpage->write) & ~RB_WRITE_MASK;
 		unsigned long event_length = rb_event_length(event);
 
+		/*
+		 * For the before_stamp to be different than the write_stamp
+		 * to make sure that the next event adds an absolute
+		 * value and does not rely on the saved write stamp, which
+		 * is now going to be bogus.
+		 */
+		rb_time_set(&cpu_buffer->before_stamp, 0);
+
 		/* Something came in, can't discard */
 		if (!rb_time_cmpxchg(&cpu_buffer->write_stamp,
 				       write_stamp, write_stamp - delta))
 			return 0;
 
-		/*
-		 * It's possible that the event time delta is zero
-		 * (has the same time stamp as the previous event)
-		 * in which case write_stamp and before_stamp could
-		 * be the same. In such a case, force before_stamp
-		 * to be different than write_stamp. It doesn't
-		 * matter what it is, as long as its different.
-		 */
-		if (!delta)
-			rb_time_set(&cpu_buffer->before_stamp, 0);
-
 		/*
 		 * If an event were to come in now, it would see that the
 		 * write_stamp and the before_stamp are different, and assume
-- 
2.42.0



