Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E054253358;
	Mon, 23 Jun 2025 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685580; cv=none; b=Recc6Hfhce7ksxzK0jsgbX10M0KE63AMNi+cZ9bmTwTDldL8xvpLCGVQUL58NyyMGTNaSpzL2zwcLuEC8s/wKRQDB1yuslB6lFpgadm+PXgwbuPb6Vn/9yr37oIkh/m8zi8Jd1OjjAL/AadBeltNstm6gUhcaa9g4M9raq5wAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685580; c=relaxed/simple;
	bh=96YlGFluljy9DlVc1102v3C7SzxRcFIpQhIwX7iOMd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef2LdS+jyoWQLuicP86ZWCjmhyCp6xO7QEUm/hfOib6gt7FAvq2hzUh9cpiugXxtWmFqJj9EMPjHk2rYjn+M6f3AoJqYK/HjcyEXn49qGWmK2xYSxjMF6WAj9hJ81fZ3FWjK1M/ltIf6hzGhsEWD218waB1XfIYIcOQkgJQSUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLPDPfoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLPDPfoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65FDC4CEEA;
	Mon, 23 Jun 2025 13:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685580;
	bh=96YlGFluljy9DlVc1102v3C7SzxRcFIpQhIwX7iOMd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLPDPfoEqjkGSXA+mYzcwOgE5bsaUI2cF00Asgq81Uh9+wTRqJoyKQsrxKp8aRRsh
	 CwS2JYkfWQ7BZ7eJXgGFCjm7jIHRjAeuPhZsteHhLwYHV/74dXSxQQG6CXOdg8a54j
	 NPaHT8NE7z4jRPVmNSdv8VeAtF+xk9LOL2XOudAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+01affb1491750534256d@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 245/592] workqueue: Fix race condition in wq->stats incrementation
Date: Mon, 23 Jun 2025 15:03:23 +0200
Message-ID: <20250623130706.119801453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 70e1683ca3a6474360af1d3a020a9a98c8492cc0 ]

Fixed a race condition in incrementing wq->stats[PWQ_STAT_COMPLETED] by
moving the operation under pool->lock.

Reported-by: syzbot+01affb1491750534256d@syzkaller.appspotmail.com
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cf62032827375..1ea62b8c76b32 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3241,7 +3241,7 @@ __acquires(&pool->lock)
 	 * point will only record its address.
 	 */
 	trace_workqueue_execute_end(work, worker->current_func);
-	pwq->stats[PWQ_STAT_COMPLETED]++;
+
 	lock_map_release(&lockdep_map);
 	if (!bh_draining)
 		lock_map_release(pwq->wq->lockdep_map);
@@ -3272,6 +3272,8 @@ __acquires(&pool->lock)
 
 	raw_spin_lock_irq(&pool->lock);
 
+	pwq->stats[PWQ_STAT_COMPLETED]++;
+
 	/*
 	 * In addition to %WQ_CPU_INTENSIVE, @worker may also have been marked
 	 * CPU intensive by wq_worker_tick() if @work hogged CPU longer than
-- 
2.39.5



w_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -42,7 +42,6 @@
 #include <rdma/ib_umem.h>
 #include <rdma/uverbs_ioctl.h>
 
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index a03dfde796ca4..07ea5fe4a59bb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -34,6 +34,7 @@
 #define _HNS_ROCE_HW_V2_H
 
 #include <linux/bitops.h>
+#include "hnae3.h"
 
 #define HNS_ROCE_VF_QPC_BT_NUM			256
 #define HNS_ROCE_VF_SCCC_BT_NUM			64
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4fc8e0c8b7ab0..5bafd451ca8da 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -38,7 +38,6 @@
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
 #include <rdma/ib_cache.h>
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
diff --git a/drivers/infiniband/hw/hns/hns_roce_restrack.c b/drivers/infiniband/hw/hns/hns_roce_restrack.c
index 259444c0a6301..8acab99f7ea6a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_restrack.c
+++ b/drivers/infiniband/hw/hns/hns_roce_restrack.c
@@ -4,7 +4,6 @@
 #include <rdma/rdma_cm.h>
 #include <rdma/restrack.h>
 #include <uapi/rdma/rdma_netlink.h>
-#include "hnae3.h"
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hw_v2.h"
-- 
2.39.5



