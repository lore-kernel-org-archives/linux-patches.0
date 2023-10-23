Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5F14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvZHHfqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F87C433C9;
	Mon, 23 Oct 2023 11:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059846;
	bh=bXYMbkfq65G3WKqjk6C02cJb/l3fJUSTcHvyXEnST6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvZHHfqIHwNXVqZRqyyt5I8y5/X8CG2YH+l5NS6ndGR0ZqcV0tC0R5dYLOu3b6+h2
	 gUPE0n6fVcGxir7Hf5WuoE/vvej2YLjICcETwoeP4F5UHXR069C9Xe3TqGa0nl2VNI
	 t4XWIfiNaklYuZ9otHHsQ91K+LeGDkDwkVXqh44o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 73/98] tracing: relax trace_event_eval_update() execution with cond_resched()
Date: Mon, 23 Oct 2023 12:57:02 +0200
Message-ID: <20231023104816.150689783@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 23cce5f25491968b23fb9c399bbfb25f13870cd9 ]

When kernel is compiled without preemption, the eval_map_work_func()
(which calls trace_event_eval_update()) will not be preempted up to its
complete execution. This can actually cause a problem since if another
CPU call stop_machine(), the call will have to wait for the
eval_map_work_func() function to finish executing in the workqueue
before being able to be scheduled. This problem was observe on a SMP
system at boot time, when the CPU calling the initcalls executed
clocksource_done_booting() which in the end calls stop_machine(). We
observed a 1 second delay because one CPU was executing
eval_map_work_func() and was not preempted by the stop_machine() task.

Adding a call to cond_resched() in trace_event_eval_update() allows
other tasks to be executed and thus continue working asynchronously
like before without blocking any pending task at boot time.

Link: https://lore.kernel.org/linux-trace-kernel/20230929191637.416931-1-cleger@rivosinc.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Clément Léger <cleger@rivosinc.com>
Tested-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a3dc6c126b3ee..ed39d3ec202e6 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2242,6 +2242,7 @@ void trace_event_eval_update(struct trace_eval_map **map, int len)
 				update_event_printk(call, map[i]);
 			}
 		}
+		cond_resched();
 	}
 	up_write(&trace_event_sem);
 }
-- 
2.40.1



