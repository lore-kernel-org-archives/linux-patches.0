Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFB4171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2539C433D2;
	Mon,  8 May 2023 11:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546294;
	bh=qV7e3zp2q6OjE6JYfWeD2dZjhIBCtN/EiwElWi2lUZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R2yXrPSqypVBiZxvDKNbgB6NcrpU+6uQ/8e0TXQCxOaaHfrWAI30TARW0pAWWnsiE
	 VmqnaykO4lNcD8Gwd4h8Zdn+9M+pTAC6uHOrr8exkv4mBBNusBhWfjvdH9zvePlsh5
	 XlH1Q7BOUqLnyfJrtytueBtiU02dJAZ43bANfl4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Jihong <yangjihong1@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/371] perf/core: Fix hardlockup failure caused by perf throttle
Date: Mon,  8 May 2023 11:48:10 +0200
Message-Id: <20230508094823.501457618@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 15def34e2635ab7e0e96f1bc32e1b69609f14942 ]

commit e050e3f0a71bf ("perf: Fix broken interrupt rate throttling")
introduces a change in throttling threshold judgment. Before this,
compare hwc->interrupts and max_samples_per_tick, then increase
hwc->interrupts by 1, but this commit reverses order of these two
behaviors, causing the semantics of max_samples_per_tick to change.
In literal sense of "max_samples_per_tick", if hwc->interrupts ==
max_samples_per_tick, it should not be throttled, therefore, the judgment
condition should be changed to "hwc->interrupts > max_samples_per_tick".

In fact, this may cause the hardlockup to fail, The minimum value of
max_samples_per_tick may be 1, in this case, the return value of
__perf_event_account_interrupt function is 1.
As a result, nmi_watchdog gets throttled, which would stop PMU (Use x86
architecture as an example, see x86_pmu_handle_irq).

Fixes: e050e3f0a71b ("perf: Fix broken interrupt rate throttling")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230227023508.102230-1-yangjihong1@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dc57835e70966..97052b2dff7ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9271,8 +9271,8 @@ __perf_event_account_interrupt(struct perf_event *event, int throttle)
 		hwc->interrupts = 1;
 	} else {
 		hwc->interrupts++;
-		if (unlikely(throttle
-			     && hwc->interrupts >= max_samples_per_tick)) {
+		if (unlikely(throttle &&
+			     hwc->interrupts > max_samples_per_tick)) {
 			__this_cpu_inc(perf_throttled_count);
 			tick_dep_set_cpu(smp_processor_id(), TICK_DEP_BIT_PERF_EVENTS);
 			hwc->interrupts = MAX_INTERRUPTS;
-- 
2.39.2



