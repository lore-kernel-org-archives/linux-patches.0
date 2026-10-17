Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A1A0277026;
	Sat, 17 Oct 2026 16:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256150; cv=none; b=rs7Oc136viev1JUEVwnYonijbLfxFUQcnAnBJIcG2v5CsYjx1oD/b4I2/btSD89Sts+jz/dHJfBdUonpj81eJ89Hu48ynVfkO3jj7hAsQ9KOrGgRX60OFsXmlO3PUITPafohKHDn50l/Y1bNMjkeOS4a3PV0qojgDgjZYR0P8TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256150; c=relaxed/simple;
	bh=PeFViZgplNDBg8X1/aLpTLJpTRMV/Z0PKzj/zhkFiyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChdLlq+3PYp95Dg2T/O7vlsXibyFynSuYcIBAQyZTf321Zfj6OWn7qaPus5Amo/aWMmTbmZOlimsDLPJgzjLe43EyXC8jgY1yROKwE5v7PGphW4FOgZxsdlY00efr0gzvLVXAKqRCMM0rzUv44UYQiXO69t3m4ufMVBZlbxzvF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcFYTDUI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcFYTDUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1E91F000C4;
	Sat, 17 Oct 2026 16:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256149;
	bh=i8SEhN93K00rrEK+qmx/eNPHol5u3dduzZW+U7xP4eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcFYTDUIt3oFejlURqjFVrAdqsSiirxkl8pLszp7qMh6rS5ZtxeW3xhQ3HKwOHgcB
	 lIOy/781I8cD/FNvegNq76NDZdoEjuPyQIMjshxfKag0r9E1niVdR5kcAw3NGVDtDq
	 t9lWW4uHEO473iJG/59LMIk8QE/QqZjl8oGW611U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yifan Wu <wuyifan50@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0141/1674] perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()
Date: Sat, 17 Oct 2026 17:40:13 +0200
Message-ID: <20261017160434.778330700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 36bb85cf36cab15fb611cb44b78a5df06e4e69a2 ]

perf_pmu_sched_task() returns early when cpuctx->task_ctx is set, and
cpc->task_epc is only non-NULL while a task context is scheduled in on
this CPU. __perf_pmu_sched_task() therefore always passes NULL:

  Unable to handle kernel NULL pointer dereference at virtual address 00
  pc : armv8pmu_sched_task+0x14/0x50
  Call trace:
   armv8pmu_sched_task+0x14/0x50 (P)
   perf_pmu_sched_task+0xac/0x108
   __perf_event_task_sched_out+0x6c/0xe0

Pass &cpc->epc instead, the CPU-wide context for this PMU, which the
function already dereferences a few lines up to find pmu.

armv8pmu_sched_task() is the only in-tree implementation that
dereferences the argument, and it only reads ->pmu, so the oops needs
BRBE, added in v6.17.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Yifan Wu <wuyifan50@huawei.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260810133540.1947118-2-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7cb8cb1f0f68e..c9ec3d08940e1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3679,7 +3679,7 @@ static void __perf_pmu_sched_task(struct perf_cpu_pmu_context *cpc,
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(pmu);
 
-	pmu->sched_task(cpc->task_epc, task, sched_in);
+	pmu->sched_task(&cpc->epc, task, sched_in);
 
 	perf_pmu_enable(pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-- 
2.53.0



