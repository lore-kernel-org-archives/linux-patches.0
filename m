Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A98B2D3A94;
	Tue, 12 Aug 2025 19:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026669; cv=none; b=D1pSLpW1lH97bj2rQu5w+4o65I9NqzuWIZq4anKTVwZtsWAtGo5ao9sR+G437tU4w9mGAVmnyhtLp6v5ca2b7YSPaBNducRX3fYIK56bREHYnguu+0qEkBPQ7pxccHbYgU+horq9u4qqB7+TG6vZl8ALmdUiSD0xhXMxACJibVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026669; c=relaxed/simple;
	bh=6tPsfQUQUhr1y5AFpTKibYbdpuTJ963pddKZN62udUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YinHmwLMPauFFqGQdTD+LgPuxmyJUfKySY7eECObg6tNFj9QuCRMBUDLYFfVSVQ02NxkwOE/1ok0KGDZaTyG+jN0fgArGxzwNxOESNQYpObCgeA4vvatRpMCzEkGLxK0R+V3v45Pk+bu2RBWvwyKNdql1vkPZ6UNypH4jKI1NhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhLIJGlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhLIJGlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF53C4CEF1;
	Tue, 12 Aug 2025 19:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026669;
	bh=6tPsfQUQUhr1y5AFpTKibYbdpuTJ963pddKZN62udUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhLIJGlVYe6LxIssJXhLVyG0bL/Ebm6+QHn4txKoy1NFgkPfEix80q6meVKsm4XPV
	 WlGSHaWZ4n7nHhb1AZHckevmvIbE8n2xPrOXejjytohMgH8zJvcw8h4VocJKos4dYX
	 3VWquvqYqXdeDP1XW0snxlwhmgapzlNc2vqAh/Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Beata Michalska <beata.michalska@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 372/480] sched/psi: Fix psi_seq initialization
Date: Tue, 12 Aug 2025 19:49:40 +0200
Message-ID: <20250812174412.777765295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c62f4316a2b9..e0ad56b26171 100644
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



