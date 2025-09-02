Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FA130505C;
	Tue,  2 Sep 2025 13:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820448; cv=none; b=Os6QJgAh6T05w+wS4aCSVIWqjuwSHeJfoCUVlnZw0xavQslV8Z6DztRSwwti55LdpTlmoxxOZURxvGoq+IQSurB4Erkw29BJAik3+NvZhualIipE8JolAFxMw3Ey3z/YHrGQWIQOTJURuozuLvuULxJ6413pnNKkuFf0zUq3Tws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820448; c=relaxed/simple;
	bh=skkQzEobM/qLblQoBB/vgKTEOpa/FapuWAYwq6yH6MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9uHIijyRhIy4FkLmW550Q4E8NcVZ9sfMjScGJ4BZLN2TTFHO/qwSevlzkVD0np2CkxSHylZWTGRxEe0oxXzYQkns9YPq/g8HYetVoA61Cbx3cLWzqY4d5dcUQ44yjzSKCeOmPOiFYuYwxyy1xDgm0DMuOkHTLmLF8ASGPAjfSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zATca0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zATca0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7B6C4CEF4;
	Tue,  2 Sep 2025 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820448;
	bh=skkQzEobM/qLblQoBB/vgKTEOpa/FapuWAYwq6yH6MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zATca0lX+d1LCTPegHnBt1QQDs1+30doW9t8sVRFCVQfKYrJ/PPG/un0tCmoBCb1
	 nw6YTvxZw17E2eVqHcZT3M5ex4wSDJzWca7lL5rpyIVrBbN/I6ChMwbVbjvSM4QFfV
	 YUiFPY+EQV+tWaF3M3h8xzRxZzXoL2YeVGb+uFMU=
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
Subject: [PATCH 6.1 04/50] ftrace: Fix potential warning in trace_printk_seq during ftrace_dump
Date: Tue,  2 Sep 2025 15:20:55 +0200
Message-ID: <20250902131930.685993163@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 874f869ae72e6..7e8ab09d98cc7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10183,10 +10183,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
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



