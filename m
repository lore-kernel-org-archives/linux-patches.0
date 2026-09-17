Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD49D3D25CC;
	Thu, 17 Sep 2026 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670786; cv=none; b=ec0az8ToLkaV/UmjExKO8GX8J4kdv1CtFbTjKaMYVooZrKAwdm0aDloZCyP1iM70/WVMsfVzpR3SYYp4sDK0R6EamBolF9EgkvEbjtoeSX3lZawn48GS2GqqI7u98XlBCrESPZ35ZrM3XqBkjrT1d7LXjvyAgy/KOTNjoP0pjUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670786; c=relaxed/simple;
	bh=GQcoCEDm0tXdk0jUgjnwN907QaKPgKZqZpb54VEhKZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0ocvXPxcXfaNhsufIv6/S+0Z/C25sTAy2j6dMDJpzDsCy/nQj2r+/kmy0nGj0Wbx2ZIkfECi8/LRZT1lM5++/HICriw2qSlS10NSuiE4Sra6fY4T1kbEtkBR9GlOzJQI039lPjvWCzBDmTY5s7A46vX/IHv3rehDXSFew0diD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv9wU4Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv9wU4Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0251F000FF;
	Thu, 17 Sep 2026 18:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670785;
	bh=Dsi3qmP13EGEaiiK0hJtAZnW1hXHzrmy5u+3sXbtC8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv9wU4Wvee7twCIo0PXd0ct9anWKCwju9MPPbIxhHbE1n+5aglsjRHq+7GrKUIiWo
	 wRX/BB1MdV40gyKWX8wC7NQTqILkZ1Jku8Xk8pGLDpNMGg+09Qy3Sfo2Dwk/2HF1pB
	 Zg/al6cb4F1zQYPoR2pcF1sPRPuRNxWZulRgGV9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0770/1102] perf/core: Allow list_del during perf_event_overflow()
Date: Thu, 17 Sep 2026 16:11:53 +0100
Message-ID: <20260917151559.779694175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2eab949a1ba09..bdc90afc0e376 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3765,13 +3765,13 @@ static void perf_pmu_sched_task(struct task_struct *prev,
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



