Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B811F669E;
	Tue,  3 Dec 2024 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236574; cv=none; b=fnWVdEpNBYOj0tlO2RgUMubMa+y45i/Ts336dmigkmy3yVCzth/5MOcWHgksO8BjsCQhjMRRhcxwk7cakg3bTa9vklHFBIHpz43C/H/TyMBuUCBB+Q/7g5BjiaTcYiN0pBPL6z1y10NAiyVr+EmBAD6qqshq9XA/oCjtZVnlncQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236574; c=relaxed/simple;
	bh=rHXY7zmtCQMU+Xs2LgRvhvNDM37oAp77iKI62IpOYXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9coh+66pBONZTv95XppAovepX1gq8jkchD4aN1FSdhxierI5CvcAL+ddN/gM44wAdDjhKh+koLirkiFvp96c+JyQ9BqBZnvdoZg9HGjGCvVfz7Jb737/LttZJi6Mb2tDK4SLSeoRcix4OXlciMzBYDcTztKpYPSbTBxHK2iQk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+5zW26R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+5zW26R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF96C4CED9;
	Tue,  3 Dec 2024 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236574;
	bh=rHXY7zmtCQMU+Xs2LgRvhvNDM37oAp77iKI62IpOYXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+5zW26RaApPKZDPqHGO+YijH0zBOTi8Xu8/tNM9H5pK1O6QUNaH/lCFDJR61evq9
	 qQJJbTIdObrKj6ieN9hG8pkarhWRIFTbxKpDVhxIR0UvJbQkK+ycafqpO44xU120Wz
	 bYtAiH1eb1ZGmLv6JglscmUDXa7ehrk6NDDqGxRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levi Yun <yeoreum.yun@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 058/138] trace/trace_event_perf: remove duplicate samples on the first tracepoint event
Date: Tue,  3 Dec 2024 15:31:27 +0100
Message-ID: <20241203141925.778659473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levi Yun <yeoreum.yun@arm.com>

[ Upstream commit afe5960dc208fe069ddaaeb0994d857b24ac19d1 ]

When a tracepoint event is created with attr.freq = 1,
'hwc->period_left' is not initialized correctly. As a result,
in the perf_swevent_overflow() function, when the first time the event occurs,
it calculates the event overflow and the perf_swevent_set_period() returns 3,
this leads to the event are recorded for three duplicate times.

Step to reproduce:
    1. Enable the tracepoint event & starting tracing
         $ echo 1 > /sys/kernel/tracing/events/module/module_free
         $ echo 1 > /sys/kernel/tracing/tracing_on

    2. Record with perf
         $ perf record -a --strict-freq -F 1 -e "module:module_free"

    3. Trigger module_free event.
         $ modprobe -i sunrpc
         $ modprobe -r sunrpc

Result:
     - Trace pipe result:
         $ cat trace_pipe
         modprobe-174509  [003] .....  6504.868896: module_free: sunrpc

     - perf sample:
         modprobe  174509 [003]  6504.868980: module:module_free: sunrpc
         modprobe  174509 [003]  6504.868980: module:module_free: sunrpc
         modprobe  174509 [003]  6504.868980: module:module_free: sunrpc

By setting period_left via perf_swevent_set_period() as other sw_event did,
This problem could be solved.

After patch:
     - Trace pipe result:
         $ cat trace_pipe
         modprobe 1153096 [068] 613468.867774: module:module_free: xfs

     - perf sample
         modprobe 1153096 [068] 613468.867794: module:module_free: xfs

Link: https://lore.kernel.org/20240913021347.595330-1-yeoreum.yun@arm.com
Fixes: bd2b5b12849a ("perf_counter: More aggressive frequency adjustment")
Signed-off-by: Levi Yun <yeoreum.yun@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_event_perf.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5e68447588b7c..22cce5dc0e287 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -349,10 +349,16 @@ void perf_uprobe_destroy(struct perf_event *p_event)
 int perf_trace_add(struct perf_event *p_event, int flags)
 {
 	struct trace_event_call *tp_event = p_event->tp_event;
+	struct hw_perf_event *hwc = &p_event->hw;
 
 	if (!(flags & PERF_EF_START))
 		p_event->hw.state = PERF_HES_STOPPED;
 
+	if (is_sampling_event(p_event)) {
+		hwc->last_period = hwc->sample_period;
+		perf_swevent_set_period(p_event);
+	}
+
 	/*
 	 * If TRACE_REG_PERF_ADD returns false; no custom action was performed
 	 * and we need to take the default action of enqueueing our event on
-- 
2.43.0



