Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72303C061E;
	Fri, 24 Apr 2026 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038079; cv=none; b=Vkekaeop3T52ESAcuAAqSeJmd9qocjTJB2Q1yBZlaBrcTInRKZJmaSAt8r3kdV7f64XEiBTkE+B5VL/G6glxg/W0yKfCqaNKrRp7lnXMK+8kPo+gBsbmfKrfS90II35J5ZxwbdAtjAiSqfJBzh2onE9GONTdz04FggVb3tmDzsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038079; c=relaxed/simple;
	bh=xJYkHD2FPGcXbinNQavm0Kf9gqGERdbrJtrG4+4pc1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5FxUl62+RUSTTQpR+GKIV7KVhzyPnIggcnsAaFxTgvZgUcHeYcR+vyBX0KXrpioyxI7u4XMIgl+6JLRbjgesjxJKCPVPxXD3FoqGMv/8EL5oO3NAjo9DEqQQR8KAkxnZLDwN4R90PS9C/7LjG/nPFs10Wj3WYc1IgHuNp472Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhxeCEoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhxeCEoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA25C19425;
	Fri, 24 Apr 2026 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038078;
	bh=xJYkHD2FPGcXbinNQavm0Kf9gqGERdbrJtrG4+4pc1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NhxeCEoR6Eb2TKCqLzo4BhpZ46vhPSYkFtQuXVspEu7N3ZHKbgwV4bLIQXDwVcHI8
	 +FP+pgHd6yo7gd4emE07oBwUdZOHlOYapu4M1utI00w/mFBUGjfqDMl1bNmoxb54JW
	 D+djw4qI3Y5Hwbu+hpsQhAw60yGeIzQ56icC3GSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.18 16/55] sched/debug: Fix avg_vruntime() usage
Date: Fri, 24 Apr 2026 15:30:55 +0200
Message-ID: <20260424132433.486302433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit e08d007f9d813616ce7093600bc4fdb9c9d81d89 upstream.

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
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/debug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -798,6 +798,7 @@ static void print_rq(struct seq_file *m,
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 {
 	s64 left_vruntime = -1, zero_vruntime, right_vruntime = -1, left_deadline = -1, spread;
+	u64 avruntime;
 	struct sched_entity *last, *first, *root;
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
@@ -821,6 +822,7 @@ void print_cfs_rq(struct seq_file *m, in
 	if (last)
 		right_vruntime = last->vruntime;
 	zero_vruntime = cfs_rq->zero_vruntime;
+	avruntime = avg_vruntime(cfs_rq);
 	raw_spin_rq_unlock_irqrestore(rq, flags);
 
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "left_deadline",
@@ -830,7 +832,7 @@ void print_cfs_rq(struct seq_file *m, in
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "zero_vruntime",
 			SPLIT_NS(zero_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "avg_vruntime",
-			SPLIT_NS(avg_vruntime(cfs_rq)));
+			SPLIT_NS(avruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "right_vruntime",
 			SPLIT_NS(right_vruntime));
 	spread = right_vruntime - left_vruntime;


