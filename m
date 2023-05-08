Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37071168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEEEC43446;
	Mon,  8 May 2023 10:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540700;
	bh=wqRqVd+951/tkOwopTKV8hanfY8Yt2y9KxAVEfydkRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuHrF1D7PeVOLouzud+6/GbugCvdMitNgQZr68aYFE9fdQ54t52zsqzsO6LM0Bdvx
	 Oeql70e4HeBvbbHCWpYFiVzlP2dSiUW4istGy0gJjHFPA3cGyDTzEKepRosqGprqp3
	 vj0v0f8Xl71qsCzremn5y8LSNqWQbrgMauZ9SawQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Libo Chen <libo.chen@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 465/611] sched/fair: Fix inaccurate tally of ttwu_move_affine
Date: Mon,  8 May 2023 11:45:07 +0200
Message-Id: <20230508094437.247575654@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index f70c4a7fb4ef3..fa33c441ae867 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6475,7 +6475,7 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p,
 		target = wake_affine_weight(sd, p, this_cpu, prev_cpu, sync);
 
 	schedstat_inc(p->stats.nr_wakeups_affine_attempts);
-	if (target == nr_cpumask_bits)
+	if (target != this_cpu)
 		return prev_cpu;
 
 	schedstat_inc(sd->ttwu_move_affine);
-- 
2.39.2



