Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5B2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460E5C433D2;
	Wed, 12 Apr 2023 08:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289543;
	bh=Lopcdp1Clx17cFPIKdazuHwRuYr/qovSXWFq4JdE/90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyJXvg9Vq1NcLqaQin/ed5e26nydlnIobUXENLS/YukH8P6BDbz5bhMWyvRBOYWBS
	 5Xt/BgT2JFtFLKOoMn8mG3YLhlUnYJ9HZ2G5IvNm3LPHMlr1J5XppB991K4LpI2bLq
	 iyzdkzAj0zy/K/imeOWFTJVNGxVB6koT3fLTBAJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 139/173] perf: Optimize perf_pmu_migrate_context()
Date: Wed, 12 Apr 2023 10:34:25 +0200
Message-Id: <20230412082843.730351966@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b168098912926236bbeebaf7795eb7aab76d2b45 ]

Thomas reported that offlining CPUs spends a lot of time in
synchronize_rcu() as called from perf_pmu_migrate_context() even though
he's not actually using uncore events.

Turns out, the thing is unconditionally waiting for RCU, even if there's
no actual events to migrate.

Fixes: 0cda4c023132 ("perf: Introduce perf_pmu_migrate_context()")
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lkml.kernel.org/r/20230403090858.GT4253@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index fad170b475921..4b3205f6bed5e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12875,12 +12875,14 @@ void perf_pmu_migrate_context(struct pmu *pmu, int src_cpu, int dst_cpu)
 	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->pinned_groups, &events);
 	__perf_pmu_remove(src_ctx, src_cpu, pmu, &src_ctx->flexible_groups, &events);
 
-	/*
-	 * Wait for the events to quiesce before re-instating them.
-	 */
-	synchronize_rcu();
+	if (!list_empty(&events)) {
+		/*
+		 * Wait for the events to quiesce before re-instating them.
+		 */
+		synchronize_rcu();
 
-	__perf_pmu_install(dst_ctx, dst_cpu, pmu, &events);
+		__perf_pmu_install(dst_ctx, dst_cpu, pmu, &events);
+	}
 
 	mutex_unlock(&dst_ctx->mutex);
 	mutex_unlock(&src_ctx->mutex);
-- 
2.39.2



