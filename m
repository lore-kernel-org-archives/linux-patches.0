Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF1851357A;
	Wed, 30 Sep 2026 17:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787809; cv=none; b=VMVz/tyeb9PCY6Cd+7mcFZUvPY90lxnlbYvSopCzcoi+wDIJ5FfE2mShn6Q5SxTQiT39xZTboWZavFthOoY0ENT2QgwpUZEceIAcriwXFiHnGXFEO0wZ1DBveaoXPmeSz5sjpvpb6QpMwh/5s80UWnv84Aami97PtYF8lW+O/mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787809; c=relaxed/simple;
	bh=HvcvsrPWqHcM3AiClRCMu6wB844iaMgIbCQ/Jf2Gi/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlc/5v7xbFvjsoh5/I0STZaMMQ1LRe2hk2849TyopRSMhPNvc0hIvx7OrCVN219WMnDditu5IK14sicebUQZ2IX2lTZ2DX3W1ULHfo+Oz1VARROWxs5XqeWwCdYLH+2MLQa9D/dUIXgJS2+ragVQ0i6cBZG4aJGJo66CfBCWyk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xyYczs8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xyYczs8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E763C1F000FF;
	Wed, 30 Sep 2026 17:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787808;
	bh=ocPaO3iCSflWFx0lQ1TighoeIUHEzyqJdCiq83CaZmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xyYczs8r5ncXE9sPxZ2VeF3gmAZKEgw26vrTdJrjGj5z4Ln5z5qbbHlsZoWX/jlAu
	 L6ZlCw/WzD4NFVgipVjrG81uaxx8mBZLE+6biBtFyP8+4WBi7oeI4iqcwBqvmeneHV
	 PL1LzEuExjDzc6JF/gs4FCUOtHR+49sX2wQoU9YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Yifan Wu <wuyifan50@huawei.com>
Subject: [PATCH 7.2 362/457] perf/core: Fix NULL pmu_ctx passed to pmu->sched_task()
Date: Wed, 30 Sep 2026 17:27:47 +0200
Message-ID: <20260930152353.819139831@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3914,7 +3914,7 @@ static void __perf_pmu_sched_task(struct
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(pmu);
 
-	pmu->sched_task(cpc->task_epc, task, sched_in);
+	pmu->sched_task(&cpc->epc, task, sched_in);
 
 	perf_pmu_enable(pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);


