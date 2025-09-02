Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC80337682;
	Tue,  2 Sep 2025 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820536; cv=none; b=mMevqr2XnrjeQIcaULTJg0cf5NELll4I/1JGphhdaXaTAsoUyJQ7VO/9+WemUM+goFAP1IUyqRntmAL7bAS8X8eMCbUFO7BVZQMRjT7rxVTzFHUOjM9djMRrjpMGdPK0A/8GlPwLU4kJOWz1ab7r+V3PpyBEYrJ5AiTN766IrEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820536; c=relaxed/simple;
	bh=O6KEgh3sinwqx6nwF9sSM9Yop4OebAULbLvjIPUM8xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDrby11eINIOBuXzsE2oVrQWiYawK3CRMHDMenwBBF7+icigdmi6owFr6TG9J0cmkqWRx+uMRAB97x8jiUf94aaqyokVF+t83C+9sg1DzqIN8+95m0WzYsThV6Rz83alGP9f6RtBOJGPyEsJLaX04YFdGgWSyy96lBThcmdhJOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKrRnSV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKrRnSV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2449CC4CEED;
	Tue,  2 Sep 2025 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820536;
	bh=O6KEgh3sinwqx6nwF9sSM9Yop4OebAULbLvjIPUM8xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKrRnSV2SkIsQgb4VmTya0QCAxo0Z397cb+pWodv+tbIZvx149hH+0KV5uW8ZkBV/
	 NvtBx1kpXO2UVwksplxBPIP5ETt3j8JXkBjTQ0LpB4B3f8ecdAU713e4aP2ncprp6k
	 sjkBWQN4dbAFJlCzazU4SS3iWhuVMzo8Rzi3hbkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@elte.hu>,
	Tengda Wu <wutengda@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/33] ftrace: Fix potential warning in trace_printk_seq during ftrace_dump
Date: Tue,  2 Sep 2025 15:21:20 +0200
Message-ID: <20250902131927.143199725@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit 4013aef2ced9b756a410f50d12df9ebe6a883e4a ]

When calling ftrace_dump_one() concurrently with reading trace_pipe,
a WARN_ON_ONCE() in trace_printk_seq() can be triggered due to a race
condition.

The issue occurs because:

CPU0 (ftrace_dump)                              CPU1 (reader)
echo z > /proc/sysrq-trigger

!trace_empty(&iter)
trace_iterator_reset(&iter) <- len = size = 0
                                                cat /sys/kernel/tracing/trace_pipe
trace_find_next_entry_inc(&iter)
  __find_next_entry
    ring_buffer_empty_cpu <- all empty
  return NULL

trace_printk_seq(&iter.seq)
  WARN_ON_ONCE(s->seq.len >= s->seq.size)

In the context between trace_empty() and trace_find_next_entry_inc()
during ftrace_dump, the ring buffer data was consumed by other readers.
This caused trace_find_next_entry_inc to return NULL, failing to populate
`iter.seq`. At this point, due to the prior trace_iterator_reset, both
`iter.seq.len` and `iter.seq.size` were set to 0. Since they are equal,
the WARN_ON_ONCE condition is triggered.

Move the trace_printk_seq() into the if block that checks to make sure the
return value of trace_find_next_entry_inc() is non-NULL in
ftrace_dump_one(), ensuring the 'iter.seq' is properly populated before
subsequent operations.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ingo Molnar <mingo@elte.hu>
Link: https://lore.kernel.org/20250822033343.3000289-1-wutengda@huaweicloud.com
Fixes: d769041f8653 ("ring_buffer: implement new locking")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 23f6a9941be1d..7af8bbc57531c 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10122,10 +10122,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 			ret = print_trace_line(&iter);
 			if (ret != TRACE_TYPE_NO_CONSUME)
 				trace_consume(&iter);
+
+			trace_printk_seq(&iter.seq);
 		}
 		touch_nmi_watchdog();
-
-		trace_printk_seq(&iter.seq);
 	}
 
 	if (!cnt)
-- 
2.50.1



