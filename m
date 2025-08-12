Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AB1280037;
	Tue, 12 Aug 2025 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022841; cv=none; b=Z9tbMs0n/8efnCToXCZXA3HvJTELGoydXgxx31Aj1tars7c9R2l9gyfpotsZHKjc8/MQPXgmNbodXi7mViXVMJGsLhSG965Ryl3mQhkjvwQwaWswnkNAiZxO5rdV87zCbwNhbKKB/euN7ih0APdRKuGKm7YSMd+kl4JpaqR6yi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022841; c=relaxed/simple;
	bh=Qci8POTMxmH5xZCw1Xc+80CQ25okeg+VlexHxP4BKRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIU7d+gJQakFzrVu/HiCb9z1ki9kDU3cDfgH2AoZPstnPxFyQWSH5VQW2tERqdJvEa7WN6DpUUDgPF2uz87ONk/Hg3GdPlYRz6u8cXKeVse3hBSFVhQzavPVjT9gxN+1jeZm5UxYAehGWiFzC+FldcJhVtw9t8mZKzcmFJDz2sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0JRaWW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0JRaWW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3677C4CEF1;
	Tue, 12 Aug 2025 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022841;
	bh=Qci8POTMxmH5xZCw1Xc+80CQ25okeg+VlexHxP4BKRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0JRaWW3iBL3soV9CloCK9P/c7SBMq9q5et+DpjfiXn7zCs0RxcFRjVy0WYw1CHo9
	 kQMjpz9p2l9gVs6kasu78XA+ESqGq1JxOo7rONzwkCKnKMPHqV95a5Zq9C8SsicLB3
	 B8ngfpfklwQ88+G4ibBUB/3Kb57UbsFE62klH/nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Beata Michalska <beata.michalska@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/369] sched/psi: Fix psi_seq initialization
Date: Tue, 12 Aug 2025 19:29:31 +0200
Message-ID: <20250812173025.437395523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 99b773d720aeea1ef2170dce5fcfa80649e26b78 ]

With the seqcount moved out of the group into a global psi_seq,
re-initializing the seqcount on group creation is causing seqcount
corruption.

Fixes: 570c8efd5eb7 ("sched/psi: Optimize psi_group_change() cpu_clock() usage")
Reported-by: Chris Mason <clm@meta.com>
Suggested-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 81cfefc4d892..7d0f8fdd48a3 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -172,7 +172,7 @@ struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-static DEFINE_PER_CPU(seqcount_t, psi_seq);
+static DEFINE_PER_CPU(seqcount_t, psi_seq) = SEQCNT_ZERO(psi_seq);
 
 static inline void psi_write_begin(int cpu)
 {
@@ -200,11 +200,7 @@ static void poll_timer_fn(struct timer_list *t);
 
 static void group_init(struct psi_group *group)
 {
-	int cpu;
-
 	group->enabled = true;
-	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&psi_seq, cpu));
 	group->avg_last_update = sched_clock();
 	group->avg_next_update = group->avg_last_update + psi_period;
 	mutex_init(&group->avgs_lock);
-- 
2.39.5



