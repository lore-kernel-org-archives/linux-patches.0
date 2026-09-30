Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7F24E01FA;
	Wed, 30 Sep 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793567; cv=none; b=K33Fap7ZqA8y/jC+JqqB4NNjlsO9lny1hq+WapBNNYXFd5CTDR14ubcTOpMGF0Q3mJgFMV5bYQZw+FX1VnwT32tKV2u1YRPchnhs0jCpvmRRaAl3ALqrarfUgSPeipcfK+hwRQDtXdrGlRRZlCdIVzdUuYd+cIFxJU1SfNZearo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793567; c=relaxed/simple;
	bh=RwLHCdWsReS/forkjiP+zgCCtXd/Mpk+mxE0na4M9qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPShQrvveosAH64CKvhpeHSSELp+eGzax1+IbxzigaomaJGG6EIYtIqkoesYilCVsxlyk63DWFGqqEQjf2bOWrI6vmnugH+hljIJEb8AWFEm5omIW/6VAxLyFGFOTv7MKgHFQMpUJLfl3K6pomCc+CuMlYr23ylzcbxoWKAQKYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz8Mu2Cx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz8Mu2Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503931F00899;
	Wed, 30 Sep 2026 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793565;
	bh=19Ol0aFtiXsevNUsEfP/9pcHQ66P14NvOr8gyu3ghao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qz8Mu2Cxy5hVlnMhLUhQEFNxhI4F+BSda4Qg9IUXy1xEhG3Mds4OooWqcppPxC1Ku
	 tSAKQeAMgM2pZ1ozCw/ur8pxSPxayfVBgsJj5mWSEvKE5wSAL9fk400uW+kNHFjK7L
	 kSVyyK7I2PlkxVf0K/ckSzV7ZMkb8uFNfdGxv3b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yifan Wu <wuyifan50@huawei.com>
Subject: [PATCH 6.18 299/395] perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()
Date: Wed, 30 Sep 2026 17:29:21 +0200
Message-ID: <20260930152347.140319030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

commit 36bb85cf36cab15fb611cb44b78a5df06e4e69a2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3805,7 +3805,7 @@ static void __perf_pmu_sched_task(struct
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(pmu);
 
-	pmu->sched_task(cpc->task_epc, task, sched_in);
+	pmu->sched_task(&cpc->epc, task, sched_in);
 
 	perf_pmu_enable(pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);


