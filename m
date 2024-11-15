Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A091417E015;
	Fri, 15 Nov 2024 06:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653213; cv=none; b=RcRaKT1myIJRUnalMdtk7P3Z8KXkFrPQfN8VkXeZ87igMn6bRjMAeV/+6hikTYLW+5ZScop6beHAPx8WLVkjtRBqbN0O8N9LnluupVayoZvoiqQApk8fo85b1xRfMj0Q+Uwnf9KsbqRcj/wScec2hP4i4+tlIgrmTB1A+p17M1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653213; c=relaxed/simple;
	bh=rEbqL+zwxDzhzNCaMAqPFIFyxa/lVENeVcEMqawWcy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euw948UM/NZjRPX89VPvqIpl6iazu1ICH4TdM9BCkLl87g8U7BkB1raJRlyruS3T5NTvdn7aOV9K3TlXpt3ZLX+oWYm6gsCSCd49/FzdD2+aT3wNcs3loKHsCyA0E45t4uexXYdBfwKfzZfDRr52z2/bIB9YUGiCpWjfdN3U0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEqEj2QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEqEj2QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13422C4CECF;
	Fri, 15 Nov 2024 06:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653213;
	bh=rEbqL+zwxDzhzNCaMAqPFIFyxa/lVENeVcEMqawWcy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEqEj2QSmrMN9n6sINN7nKA35jVpD5Fs8poiQ8a4XKQgd3u4nKJZaJMseQr54rr+7
	 SUF0U7lGhsRBFdOhrtKypJY8UIdVR8qcjrgyKrqmzMAA0TxUPCkhSZGUP0Qt4CYG/I
	 NX+5pSbULdRVKKcaYrKkYpIUZ76vJZvHGbvA21PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 02/63] nvme/host: Fix RCU list traversal to use SRCU primitive
Date: Fri, 15 Nov 2024 07:37:25 +0100
Message-ID: <20241115063725.984256786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 89ad4217f8606..b954e77d3fc56 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3793,7 +3793,8 @@ struct nvme_ns *nvme_find_get_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		if (ns->head->ns_id == nsid) {
 			if (!nvme_get_ns(ns))
 				continue;
@@ -4840,7 +4841,8 @@ void nvme_mark_namespaces_dead(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mark_disk_dead(ns->disk);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4852,7 +4854,8 @@ void nvme_unfreeze(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mq_unfreeze_queue(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 	clear_bit(NVME_CTRL_FROZEN, &ctrl->flags);
@@ -4865,7 +4868,8 @@ int nvme_wait_freeze_timeout(struct nvme_ctrl *ctrl, long timeout)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		timeout = blk_mq_freeze_queue_wait_timeout(ns->queue, timeout);
 		if (timeout <= 0)
 			break;
@@ -4881,7 +4885,8 @@ void nvme_wait_freeze(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_mq_freeze_queue_wait(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4894,7 +4899,8 @@ void nvme_start_freeze(struct nvme_ctrl *ctrl)
 
 	set_bit(NVME_CTRL_FROZEN, &ctrl->flags);
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list)
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu))
 		blk_freeze_queue_start(ns->queue);
 	srcu_read_unlock(&ctrl->srcu, srcu_idx);
 }
@@ -4942,7 +4948,8 @@ void nvme_sync_io_queues(struct nvme_ctrl *ctrl)
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



