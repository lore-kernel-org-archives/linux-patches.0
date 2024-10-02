Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBC91D07B2;
	Wed,  2 Oct 2024 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877547; cv=none; b=epqM7Cq2SdG/XIWLJrax05yELa5iguX2p6WlUbkduDv5C5GS4TBRjWANE17RCGvMsrdIvThUaV3q64ag+rgsR4f9mgpXNoI2QvY78Vdo4P1YBrhYYYGfpq6/prWoB8MW0+xzH8+P/EktqpGpBfHMUgsTH5AOndYT59H/FqaklPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877547; c=relaxed/simple;
	bh=bcOEN+FpJkKwE2RXfoMfMSZApXe0VuivfKedEHvdQQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyHZOVxs/1IDICiKaOm90efqyh1dml7ll4KtR2yKhLCArmhxThCV/zP/OE+SXz9mT/iZUplF5ZM7ZoAkb9HiMV3Qlf9lRmjHAbegAKaFdmt+z6XDgExN1XvAqGplOtqVOc4K7msBur2HTRxzhGxHkbGmxpiuMWEfedMBdip7mgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPMgmKWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPMgmKWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8711FC4CEC2;
	Wed,  2 Oct 2024 13:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877546;
	bh=bcOEN+FpJkKwE2RXfoMfMSZApXe0VuivfKedEHvdQQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPMgmKWOfawSucTIhaIHN83KFMO5eocCGyynbTY+ONuYgwkdIlXNLf66SWWl39kVb
	 u9LTpasur9EUGIlhaFx1YRTfuKZ20Fc3WhJhdKml2WMP6djPPYHHvSEdg/fGm0kJab
	 u83Hx9OeVxKm6qBguVUKflOR4R6ep4vT6T3DIng0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 114/634] io_uring/io-wq: do not allow pinning outside of cpuset
Date: Wed,  2 Oct 2024 14:53:34 +0200
Message-ID: <20241002125815.612739686@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Moessbauer <felix.moessbauer@siemens.com>

[ Upstream commit 0997aa5497c714edbb349ca366d28bd550ba3408 ]

The io worker threads are userland threads that just never exit to the
userland. By that, they are also assigned to a cgroup (the group of the
creating task).

When changing the affinity of the io_wq thread via syscall, we must only
allow cpumasks within the limits defined by the cpuset controller of the
cgroup (if enabled).

Fixes: da64d6db3bd3 ("io_uring: One wqe per wq")
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Link: https://lore.kernel.org/r/20240910171157.166423-2-felix.moessbauer@siemens.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 22dac5850327f..e38bbd07563ee 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/rculist_nulls.h>
 #include <linux/cpu.h>
+#include <linux/cpuset.h>
 #include <linux/task_work.h>
 #include <linux/audit.h>
 #include <linux/mmu_context.h>
@@ -1321,17 +1322,29 @@ static int io_wq_cpu_offline(unsigned int cpu, struct hlist_node *node)
 
 int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask)
 {
+	cpumask_var_t allowed_mask;
+	int ret = 0;
+
 	if (!tctx || !tctx->io_wq)
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&allowed_mask, GFP_KERNEL))
+		return -ENOMEM;
+
 	rcu_read_lock();
-	if (mask)
-		cpumask_copy(tctx->io_wq->cpu_mask, mask);
-	else
-		cpumask_copy(tctx->io_wq->cpu_mask, cpu_possible_mask);
+	cpuset_cpus_allowed(tctx->io_wq->task, allowed_mask);
+	if (mask) {
+		if (cpumask_subset(mask, allowed_mask))
+			cpumask_copy(tctx->io_wq->cpu_mask, mask);
+		else
+			ret = -EINVAL;
+	} else {
+		cpumask_copy(tctx->io_wq->cpu_mask, allowed_mask);
+	}
 	rcu_read_unlock();
 
-	return 0;
+	free_cpumask_var(allowed_mask);
+	return ret;
 }
 
 /*
-- 
2.43.0



