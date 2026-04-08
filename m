Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA4B3176E4;
	Wed,  8 Apr 2026 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674590; cv=none; b=tdeoe7YvycNupG/hRyaSFIc+w4k9kmIf36iK/1C4nydmbynadE7d4VK7hF1F6a3t+SYAfZbN4Do4AgaXRcG0anU4jFOIhZhJzcEnLHwtfJRmpHHW8ox58cFJmZHYLWkOpmCimeWWcGg/+l3A51mufT1fpBHjVghEgkcTphSIBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674590; c=relaxed/simple;
	bh=hSvLg6pm9MbsoMqL/vTRxpAemWso7iewI89VsCFlFDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozL7m+91p2ZX39NPVNewES3oU0pONKhmEL6ryoQe1gGD+BZ1czwu30LX4DMyD85s7t469G7bAIrCgo8Yhx60e6LKVDU8uM8nbMXFFistAmWiKB8/Voo7n/4POdhBzJ1xBLT3dCknpiDOXaBfz3ZplDT/N9eRtxAqwiITR+9oDhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIDYQlhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIDYQlhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD5FC19421;
	Wed,  8 Apr 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674589;
	bh=hSvLg6pm9MbsoMqL/vTRxpAemWso7iewI89VsCFlFDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIDYQlhLtwGAD/+RPDqcyRIiuh2EXqYJp65wd+V5MUNqFK22yP4MiyY26JHaR0dpx
	 xkrWPztHfJLGVReXj8mpwkq6knv1vKoky1Ed4MTp5oNT+Tnh0AQSa7MHcKhua45TtV
	 SuTxRpN1/nrubOnt8JX1h36r6ixpqvg9gZtrSgQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 156/311] sched/debug: Fix avg_vruntime() usage
Date: Wed,  8 Apr 2026 20:02:36 +0200
Message-ID: <20260408175945.231659867@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e08d007f9d813616ce7093600bc4fdb9c9d81d89 ]

John reported that stress-ng-yield could make his machine unhappy and
managed to bisect it to commit b3d99f43c72b ("sched/fair: Fix
zero_vruntime tracking").

The commit in question changes avg_vruntime() from a function that is
a pure reader, to a function that updates variables. This turns an
unlocked sched/debug usage of this function from a minor mistake into
a data corruptor.

Fixes: af4cf40470c2 ("sched/fair: Add cfs_rq::avg_vruntime")
Fixes: b3d99f43c72b ("sched/fair: Fix zero_vruntime tracking")
Reported-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: John Stultz <jstultz@google.com>
Link: https://patch.msgid.link/20260401132355.196370805@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 93f009e1076d8..3504ec9bd7307 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -798,6 +798,7 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 left_vruntime = -1, zero_vruntime, right_vruntime = -1, left_deadline = -1, spread;
+	u64 avruntime;
 	struct sched_entity *last, *first, *root;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -821,6 +822,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	if (last)
 		right_vruntime = last->vruntime;
 	zero_vruntime = cfs_rq->zero_vruntime;
+	avruntime = avg_vruntime(cfs_rq);
 	raw_spin_rq_unlock_irqrestore(rq, flags);
 
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "left_deadline",
@@ -830,7 +832,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "zero_vruntime",
 			SPLIT_NS(zero_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
-			SPLIT_NS(avg_vruntime(cfs_rq)));
+			SPLIT_NS(avruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "right_vruntime",
 			SPLIT_NS(right_vruntime));
 	spread = right_vruntime - left_vruntime;
-- 
2.53.0



