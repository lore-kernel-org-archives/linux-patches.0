Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6DD303A0D;
	Sat, 17 Oct 2026 16:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256153; cv=none; b=gSHIfIdU4wXBZR9tdq8Mxtrxa03S4jd16bNW0Di/QdZAJQc2hmdZhs5o9tvzsumOY9T+xBLLJ2Eu+JLEgpotsb00p/217+PvVMys4MdFHM2oV0J7CvAvMGLTzFcGWAnOa8tvve+BfHz8vg+1p9MDjGOmd2aeuYTQ/jLqpzWdKsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256153; c=relaxed/simple;
	bh=uiJ5n5LRSOtONpnSekrkfftfvABSawKNN8/aGbWZFCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qImKuvmNvmlHkWbiPG0I+GZcSP++uFFVloPjDJIcZOBAmIuhax/TlnsR41fbHAi50sO9Ixk1AZ+lj5W+F/A8lKmP3/tsa3AW+EcPLwwSdOQSXsJ91AW1BpMcoXI4tkMEUFAf8+x4HIoT3TIo0UErZnLVzzu+2w7LJZiiSDdTfQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rR7kLJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rR7kLJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623421F000C4;
	Sat, 17 Oct 2026 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256151;
	bh=vwO+u7rtu0sJTyBTNikYQSPG2HcJurzntSDywKGKBq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rR7kLJiSgfr1GrkIVAHqc8rIVMywlrfaRRcniDZrncIVGEjwdHJVaYkJRIrBRIO8
	 itefRUM+nI+AtUzvfVl4vjWQpwVqV9I4Xw1RubtQrkRnt9eZDnAJCAx0HZBZtLgpZ2
	 yRhv//Dcp5rC+eh2qkAndS0YFT4NhbWj2u7chLT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0142/1674] perf/core: Allow list_del during perf_event_overflow()
Date: Sat, 17 Oct 2026 17:40:14 +0200
Message-ID: <20261017160434.804414594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 59e63416f5153e7d58652c616fbdcb7d5e01fff7 ]

A PMU might use perf_sched_cb_inc() and perf_sched_cb_dec()
interface to get the PMU call back function pmu::sched_task
invoked at schedule in and schedule out. This is achieved
by walking along the list anchored by sched_cb_list.

The following scenario might lead to a list corruption.

   perf_pmu_sched_task()
      for_each_list_entry(..., &sched_cb_list)
      +--> __perf_pmu_sched_task()
           +--> event->pmu->sched_task())
                +--> PMU_push_sample()
                     +--> perf_event_overflow()
                          +--> __perf_event_overflow()
                               +--> pmu->stop()
                                    +--> perf_sched_cb_dec()
                                         remove entry from sched_cb_list
                                         while list node in use.

This happens when ioctl(fd, PERF_EVENT_IOC_REFRESH, xxx) has been
invoked and perf_event::event_limit hits zero.

Prevent the list corruption and convert for_each_list_entry()
to for_each_list_entry_safe().

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260908105637.627004-1-tmricht@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c9ec3d08940e1..0567303b63fb8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3690,13 +3690,13 @@ static void perf_pmu_sched_task(struct task_struct *prev,
 				bool sched_in)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
-	struct perf_cpu_pmu_context *cpc;
+	struct perf_cpu_pmu_context *cpc, *cpc2;
 
 	/* cpuctx->task_ctx will be handled in perf_event_context_sched_in/out */
 	if (prev == next || cpuctx->task_ctx)
 		return;
 
-	list_for_each_entry(cpc, this_cpu_ptr(&sched_cb_list), sched_cb_entry)
+	list_for_each_entry_safe(cpc, cpc2, this_cpu_ptr(&sched_cb_list), sched_cb_entry)
 		__perf_pmu_sched_task(cpc, sched_in ? next : prev, sched_in);
 }
 
-- 
2.53.0



