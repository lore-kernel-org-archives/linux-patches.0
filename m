Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2FE215178;
	Thu, 12 Dec 2024 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025187; cv=none; b=L5uv95viwtXDPAhVVsssUnH7D3lrEGPZbZi22qZuOnYPW9Z7R1u2aKMLcRgnpuk9G2PsCSraIqQ2q/aBuxzyJfjcCcr/DrjsjYA8fBk4lJEIJIz4YcbhqKrlWK5lQTjgyQRb43Hx4egcvculruRJEXeatLetoiJ3W8IzD2qb6TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025187; c=relaxed/simple;
	bh=o5x5yXPsvBARClWBhV/R0Tuft4SzUFEgjeaghEr5+4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiwHGZ+MqL7dby5is9j96x5vYTlcxczY2IiLN0WLIYSdM+9DqkajkWLxixmRe3lqGIexGkfGzILdXvBCwRJPgPIF+J91MDnP/Uxb9OhICwm3+bbWn1SSxKbV/arymjj9YaseW1r2tSew/ZpHqsu3Z4jzpNRDihWx7yx9LjnDbbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5/bYv95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5/bYv95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAF2C4CED0;
	Thu, 12 Dec 2024 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025187;
	bh=o5x5yXPsvBARClWBhV/R0Tuft4SzUFEgjeaghEr5+4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5/bYv95YWrx5GmiCjx+jCpUK6VtHEMWA4ggVF0DyakVFDAZP52JPXA2wU0BduSSz
	 LD+wG/GPIRfJIan2czgqjb+vY+62U7R6jS/SEa0cRXrtNMQORmlT4qEU4f6oxyTxTS
	 FF8I4vNsUENKdFT35Aq0gROM2m6VmPlstxe6gft8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levi Yun <yeoreum.yun@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 086/321] trace/trace_event_perf: remove duplicate samples on the first tracepoint event
Date: Thu, 12 Dec 2024 16:00:04 +0100
Message-ID: <20241212144233.380017571@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 563c0e659a40e..3de49b3f4cae1 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -350,10 +350,16 @@ void perf_uprobe_destroy(struct perf_event *p_event)
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



