Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E5233E345;
	Wed, 30 Sep 2026 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786082; cv=none; b=WTOKnFlVSnvxEeHKIcK2si7sUJicTjGsVJf93AfkjfeqDMcKw+jLQF7NNUGHqWTwpr6rh4+4DMx92Rw49g6+VEi/WftGTYXN+kFk5rZJRsHhLDlpna1pwyTzYMoXmRQqOOHl+e3FpGPO7b/VHSkjCd0nhmZDIGnKkT75gkmA9j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786082; c=relaxed/simple;
	bh=/8s0d3jDTBEgbezA5i/5nA/V4F6apgQ9i0XnwQgTyeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPWjk59A0WLX5OV8pImAwYGZH7kYyI8aigba8fSiJwLLqAttyyaojyBtmnbbRNkLGJZB/031Sb5MoADfbojbHivVq0kOQ5SfTm6wNrS20sB2IgtUHKUZc3n9tBO2eldp5GQ/ypCQfiezUFgWUEmpgupRxfI0A6Rzfw7u2JItUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTIscYIF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTIscYIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A96C1F000FF;
	Wed, 30 Sep 2026 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786081;
	bh=llW0w9zA3Z2eSmXDxq89Nloy0D2+qpdZ8FbFe+jwrIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jTIscYIFKqpK44MAtaW+odQrrdhWMWQLvxrQCalV1Cj+zTcdQuyHOX1w6j9JZdLzI
	 mzYzkuVxIU5GCJYJfYXFe3xR3x21VexAPbWZokQWxoGmaGYr9rw6QtdZwI92aUE51A
	 hDp781mUrrzjXUpafJnEbOYrA/sXgvEPF1W9oORA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 691/982] sched/fair: Move is_core_idle() out of CONFIG_NUMA
Date: Wed, 30 Sep 2026 17:23:47 +0200
Message-ID: <20260930152431.602972581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 8b36d07f1d63de102d464f44a89704bc62d00811 ]

asym_packing needs this function to determine whether an SMT core is a
suitable destination for load balancing.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20230406203148.19182-2-ricardo.neri-calderon@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a329bd89f1e3d..879843e807fc6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1049,6 +1049,23 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * Scheduling class queueing methods:
  */
 
+static inline bool is_core_idle(int cpu)
+{
+#ifdef CONFIG_SCHED_SMT
+	int sibling;
+
+	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
+		if (cpu == sibling)
+			continue;
+
+		if (!idle_cpu(sibling))
+			return false;
+	}
+#endif
+
+	return true;
+}
+
 #ifdef CONFIG_NUMA
 #define NUMA_IMBALANCE_MIN 2
 
@@ -1688,23 +1705,6 @@ struct numa_stats {
 	int idle_cpu;
 };
 
-static inline bool is_core_idle(int cpu)
-{
-#ifdef CONFIG_SCHED_SMT
-	int sibling;
-
-	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
-		if (cpu == sibling)
-			continue;
-
-		if (!idle_cpu(sibling))
-			return false;
-	}
-#endif
-
-	return true;
-}
-
 struct task_numa_env {
 	struct task_struct *p;
 
-- 
2.53.0



