Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B4226545;
	Thu, 12 Dec 2024 16:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022324; cv=none; b=TDB05LR+Yj68WdTyNVzbQPS15ndcUsEsjg8et0t5QMwJ/VMyEZE5+ra5I3jlkDG3JGDektCI6/heNWZhJLn+VV+R2LBIqK8nncGPSmzBM4qrIpVfcoiA/MFJIcJTJO2j1tcRt0E/1gVzq6ORrwrEHt4ZqOoL0D+fHP9k0YS6CXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022324; c=relaxed/simple;
	bh=RJe7bzkSXRrHvZdFtRsHU2UK+6Wsq/zgF9fPDpf4D08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eci25Ma4e08H1SKh2glMOuX8OcoOc461qzoZUXbHn62fJXlxMEyWctuDxKDx1W3n/aWrLMiioW6aJIiNtAR8j/2cZoMl/7+RJq7buI1dADGGfn7nRE7sCjEOYFa3J343JN89sDX6Uuc5vmNljHkM/8wY0UzV+C/KTTtUUyI9t+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ38Ykt5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ38Ykt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91821C4CECE;
	Thu, 12 Dec 2024 16:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022324;
	bh=RJe7bzkSXRrHvZdFtRsHU2UK+6Wsq/zgF9fPDpf4D08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ38Ykt58k6r2WXFzoLXIgvLaC6URVOnPUKqv7FLh9mszJhfksGLAn1DUBuSJcZpu
	 K7/9s+hIDJcQMLYwoQcLyy0BrxW4RGcz0SykxlGvQSV8BjBOWFBLzNYEkomP9BheZX
	 kT9XVRgZIw4PSoxiSjT2l+5QORK1HmWeXjhVWMjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levi Yun <yeoreum.yun@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/565] trace/trace_event_perf: remove duplicate samples on the first tracepoint event
Date: Thu, 12 Dec 2024 15:56:44 +0100
Message-ID: <20241212144319.757253208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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
index 61e3a2620fa3c..f2000cf2b3bba 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -356,10 +356,16 @@ void perf_uprobe_destroy(struct perf_event *p_event)
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



