Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D05129A63;
	Tue, 23 Jan 2024 00:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968732; cv=none; b=kDUm/K5VqmDeRSTZrjBEEEXTdfTPf5wXNHjmdXSUOFpzjcVu2nKG7tGG/VNkTt47LcExw2ykjEfQSOUffuI/x8bbI07LIefCQJxHLYqsr+WqNkKd35cptg3klGEqUHceCEViZPiMFsWdtYzp1T+RmmajVI/qBsStjwiqVuRHsOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968732; c=relaxed/simple;
	bh=gUVse2SdHRuuD43gyMlg0W2uWyu5pFDA5fqtETk9Kyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7Zdk7p7fgY+HTPXx1PeiopMC97foYhtZz04oVs9kWxxUwY8JIDN/ynt5Yja07pzMyv5uaJPxSv23DZUtqnZEflrfNC+MLRibYi8nhfZ1BgmQPWKb7h92zxhRd3fhbXI8+XAXtEpflFjf+pbmaDrbUg7m9dvkZjS7UKvhgfYVLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnCEseSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnCEseSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A107C433F1;
	Tue, 23 Jan 2024 00:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968732;
	bh=gUVse2SdHRuuD43gyMlg0W2uWyu5pFDA5fqtETk9Kyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnCEseStQqXRozdSGSU1nG9SuTKuvmpuzE90W8GhbYH74Toh3SUZA3CRkow8nNUDj
	 69yM4wfg3qYw1zvLaYzqkgbzZR/GNTzGuvAZwT2uBMZdnu102282LCsF/PHB4CxYy8
	 UnqYOJOPK8b1ZgQ9ECGAIpCpdk83o36GL8YBFbbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/194] tracing: Have large events show up as [LINE TOO BIG] instead of nothing
Date: Mon, 22 Jan 2024 15:55:50 -0800
Message-ID: <20240122235720.090812481@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit b55b0a0d7c4aa2dac3579aa7e6802d1f57445096 ]

If a large event was added to the ring buffer that is larger than what the
trace_seq can handle, it just drops the output:

 ~# cat /sys/kernel/tracing/trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 2/2   #P:8
 #
 #                                _-----=> irqs-off/BH-disabled
 #                               / _----=> need-resched
 #                              | / _---=> hardirq/softirq
 #                              || / _--=> preempt-depth
 #                              ||| / _-=> migrate-disable
 #                              |||| /     delay
 #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
 #              | |         |   |||||     |         |
            <...>-859     [001] .....   141.118951: tracing_mark_write           <...>-859     [001] .....   141.148201: tracing_mark_write: 78901234

Instead, catch this case and add some context:

 ~# cat /sys/kernel/tracing/trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 2/2   #P:8
 #
 #                                _-----=> irqs-off/BH-disabled
 #                               / _----=> need-resched
 #                              | / _---=> hardirq/softirq
 #                              || / _--=> preempt-depth
 #                              ||| / _-=> migrate-disable
 #                              |||| /     delay
 #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
 #              | |         |   |||||     |         |
            <...>-852     [001] .....   121.550551: tracing_mark_write[LINE TOO BIG]
            <...>-852     [001] .....   121.550581: tracing_mark_write: 78901234

This now emulates the same output as trace_pipe.

Link: https://lore.kernel.org/linux-trace-kernel/20231209171058.78c1a026@gandalf.local.home

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d7ca8f97b315..35c150085556 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4078,7 +4078,11 @@ static int s_show(struct seq_file *m, void *v)
 		iter->leftover = ret;
 
 	} else {
-		print_trace_line(iter);
+		ret = print_trace_line(iter);
+		if (ret == TRACE_TYPE_PARTIAL_LINE) {
+			iter->seq.full = 0;
+			trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+		}
 		ret = trace_print_seq(m, &iter->seq);
 		/*
 		 * If we overflow the seq_file buffer, then it will
-- 
2.43.0



