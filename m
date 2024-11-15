Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9E8185924;
	Fri, 15 Nov 2024 06:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653449; cv=none; b=m6EzvVghmuFw0Lp0zVgZrdQ9QkfYNP/u3e3TI5oizLzCisGnmN/EE4wZRdpQ7cmj1cKNJX5uOd+4s1F8sVTpH6c5dP141X8IDoXXbeVjmpxio4TX024+dINbVTCq16b1bvbcym0NIi0tQHpfwIarDAC6kikBH99cDTNxrs86JNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653449; c=relaxed/simple;
	bh=mhP9OY50//nqTXaMky5smWCJTOZVNn1Mey6N/qvmAmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9vvY+3mpUb4Pl2lwk0M2zLai19nyMCRHU2WCgEr52Mgs9kLTkd2dpqe3WanQOiCElFExZtHNf/7jn1hTf8OZJvIGjP3WFY3dUAQYGSHDYO92Q0XlcwEQCEPskFBgzerJ6x5mNBYSafxobU8M0OHUK4vZbvpOWekDr6hjABHL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmXtJf65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmXtJf65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE46C4CECF;
	Fri, 15 Nov 2024 06:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653449;
	bh=mhP9OY50//nqTXaMky5smWCJTOZVNn1Mey6N/qvmAmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmXtJf65Ux3iUsvlHEGSfsTJp9qsf6yaHCwWMMbfP2Rm64SNIh6MyId2E0O63dpbK
	 5Zs+d6zEEzWYvVPWmFgDN4ZU3Iw3Cjg/yT0X6e4Mbddm+P5+q1hs2quPSeGXYx4sYb
	 y4VfW8LegZNjhAjhJYQpK2r6HW+5xwX/8LRGjW4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 25/48] nvme/host: Fix RCU list traversal to use SRCU primitive
Date: Fri, 15 Nov 2024 07:38:14 +0100
Message-ID: <20241115063723.872360048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6d1c69945ce63a9fba22a4abf646cf960d878782 ]

The code currently uses list_for_each_entry_rcu() while holding an SRCU
lock, triggering false positive warnings with CONFIG_PROVE_RCU=y
enabled:

  drivers/nvme/host/core.c:3770 RCU-list traversed in non-reader section!!

While the list is properly protected by SRCU lock, the code uses the wrong
list traversal primitive. Replace list_for_each_entry_rcu() with
list_for_each_entry_srcu() to correctly indicate SRCU-based protection
and eliminate the false warning.

Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b3c5460c6d768..965ca7d7a3de2 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3544,7 +3544,8 @@ struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		if (ns->head->ns_id == nsid) {
 			if (!nvme_get_ns(ns))
 				continue;
@@ -4555,7 +4556,8 @@ void nvme_mark_namespaces_dead(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mark_disk_dead(ns->disk);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4567,7 +4569,8 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mq_unfreeze_queue(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 	clear_bit(NVME_CTRL_FROZEN, &ctrl->flags);
@@ -4580,7 +4583,8 @@ int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		timeout = blk_mq_freeze_queue_wait_timeout(ns->queue, timeout);
 		if (timeout <= 0)
 			break;
@@ -4596,7 +4600,8 @@ void nvme_wait_freeze(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mq_freeze_queue_wait(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4609,7 +4614,8 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl)
 
 	set_bit(NVME_CTRL_FROZEN, &ctrl->flags);
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_freeze_queue_start(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4657,7 +4663,8 @@ void nvme_sync_io_queues(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_sync_queue(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
-- 
2.43.0



