Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC310168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7110CC433EF;
	Mon,  8 May 2023 11:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544917;
	bh=D0dVM0JgN5QjoyEAvVxIgpO2OFtjotW5Z0NgnqhTwN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qoqxiE2ixHthhobcjGbX1SGCnNeyQfRA7OJa6JW4j1TNdhKeeGu6ZVxjmtz+IuzAM
	 UCjFisC1nk4VE8Hr83qqdIkJYozb8CLBugdk8AE8sxh+B+TuDtXTZ0s4LssxR0UtgU
	 /84bmw0QzpOlDJZpjG/n1CQKVlzxdIctDxbUPSu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Libo Chen <libo.chen@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 565/694] sched/fair: Fix inaccurate tally of ttwu_move_affine
Date: Mon,  8 May 2023 11:46:40 +0200
Message-Id: <20230508094453.090936474@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Libo Chen <libo.chen@oracle.com>

[ Upstream commit 39afe5d6fc59237ff7738bf3ede5a8856822d59d ]

There are scenarios where non-affine wakeups are incorrectly counted as
affine wakeups by schedstats.

When wake_affine_idle() returns prev_cpu which doesn't equal to
nr_cpumask_bits, it will slip through the check: target == nr_cpumask_bits
in wake_affine() and be counted as if target == this_cpu in schedstats.

Replace target == nr_cpumask_bits with target != this_cpu to make sure
affine wakeups are accurately tallied.

Fixes: 806486c377e33 (sched/fair: Do not migrate if the prev_cpu is idle)
Suggested-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Libo Chen <libo.chen@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://lore.kernel.org/r/20220810223313.386614-1-libo.chen@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5f6587d94c1dd..ed89be0aa6503 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6614,7 +6614,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p,
 		target = wake_affine_weight(sd, p, this_cpu, prev_cpu, sync);
 
 	schedstat_inc(p->stats.nr_wakeups_affine_attempts);
-	if (target == nr_cpumask_bits)
+	if (target != this_cpu)
 		return prev_cpu;
 
 	schedstat_inc(sd->ttwu_move_affine);
-- 
2.39.2



