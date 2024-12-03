Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020B20ADD3;
	Tue,  3 Dec 2024 15:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240019; cv=none; b=VlLozhdg/RCqlVeJngGMqy2lScHjUrF8mDZKL0Qb9G1pAjamckUzJJ6KDENILoVydfuEtG3R0zNBqw0oKmxQaMvcCcGEpaPzHqlDTGHyP12ah/wKw6IdquMorwatPsXdR6UUXS1cZO/ZYMbYgFiMS/ubuytI22oK2vAvz2ua3dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240019; c=relaxed/simple;
	bh=UXMryIIcwM6T/26P1frfI46h0DdQ1NqBTzt6TnmXzis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uupBM0twmDoUfMe6hrMXoJIU6OIne6/jckN6COy4GHbQox1FFOO2VMmaJels+jZXnlFD74YSX2paN8J3fMFeuldZWe0IP4ag3TZXJnveIqcTjPsOAYg8WgZhc1Hx8smJxMue1bWc9a8Nf3xqDjM6B0h9OzS3lMj0zuj1x7AvH9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTaVKnOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTaVKnOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30349C4CED6;
	Tue,  3 Dec 2024 15:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240018;
	bh=UXMryIIcwM6T/26P1frfI46h0DdQ1NqBTzt6TnmXzis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTaVKnOw393h5D3YKyLlYrBIgavDoCuq4/kOQAuj9Stsc0zbpIzRBZy+xeo75YiEQ
	 RykEjVgg/a+6naW7a34iPHzODBLGy2WEnu2E2n+HNZEU01vZNe5LeQJUgYDzKtW8KP
	 8b6qmjhwKw6UHfPDRRX0KSybZLqtUZexLZx/ShxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 782/817] nvme/multipath: Fix RCU list traversal to use SRCU primitive
Date: Tue,  3 Dec 2024 15:45:54 +0100
Message-ID: <20241203144026.538403252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

[ Upstream commit 5dd18f09ce7399df6fffe80d1598add46c395ae9 ]

The code currently uses list_for_each_entry_rcu() while holding an SRCU
lock, triggering false positive warnings with CONFIG_PROVE_RCU=y
enabled:

	drivers/nvme/host/multipath.c:168 RCU-list traversed in non-reader section!!
	drivers/nvme/host/multipath.c:227 RCU-list traversed in non-reader section!!
	drivers/nvme/host/multipath.c:260 RCU-list traversed in non-reader section!!

While the list is properly protected by SRCU lock, the code uses the
wrong list traversal primitive. Replace list_for_each_entry_rcu() with
list_for_each_entry_srcu() to correctly indicate SRCU-based protection
and eliminate the false warning.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 6b2decd998de5..07fcf98540c56 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -165,7 +165,8 @@ void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		if (!ns->head->disk)
 			continue;
 		kblockd_schedule_work(&ns->head->requeue_work);
@@ -209,7 +210,8 @@ void nvme_mpath_clear_ctrl_paths(struct nvme_ctrl *ctrl)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		nvme_mpath_clear_current_path(ns);
 		kblockd_schedule_work(&ns->head->requeue_work);
 	}
@@ -224,7 +226,8 @@ void nvme_mpath_revalidate_paths(struct nvme_ns *ns)
 	int srcu_idx;
 
 	srcu_idx = srcu_read_lock(&head->srcu);
-	list_for_each_entry_rcu(ns, &head->list, siblings) {
+	list_for_each_entry_srcu(ns, &head->list, siblings,
+				 srcu_read_lock_held(&head->srcu)) {
 		if (capacity != get_capacity(ns->disk))
 			clear_bit(NVME_NS_READY, &ns->flags);
 	}
@@ -257,7 +260,8 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
 	struct nvme_ns *found = NULL, *fallback = NULL, *ns;
 
-	list_for_each_entry_rcu(ns, &head->list, siblings) {
+	list_for_each_entry_srcu(ns, &head->list, siblings,
+				 srcu_read_lock_held(&head->srcu)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
 
@@ -356,7 +360,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
 	unsigned int min_depth_opt = UINT_MAX, min_depth_nonopt = UINT_MAX;
 	unsigned int depth;
 
-	list_for_each_entry_rcu(ns, &head->list, siblings) {
+	list_for_each_entry_srcu(ns, &head->list, siblings,
+				 srcu_read_lock_held(&head->srcu)) {
 		if (nvme_path_is_disabled(ns))
 			continue;
 
@@ -424,7 +429,8 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
 		return NULL;
 
-	list_for_each_entry_rcu(ns, &head->list, siblings) {
+	list_for_each_entry_srcu(ns, &head->list, siblings,
+				 srcu_read_lock_held(&head->srcu)) {
 		if (test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ns->ctrl->flags))
 			continue;
 		switch (nvme_ctrl_state(ns->ctrl)) {
@@ -786,7 +792,8 @@ static int nvme_update_ana_state(struct nvme_ctrl *ctrl,
 		return 0;
 
 	srcu_idx = srcu_read_lock(&ctrl->srcu);
-	list_for_each_entry_rcu(ns, &ctrl->namespaces, list) {
+	list_for_each_entry_srcu(ns, &ctrl->namespaces, list,
+				 srcu_read_lock_held(&ctrl->srcu)) {
 		unsigned nsid;
 again:
 		nsid = le32_to_cpu(desc->nsids[n]);
-- 
2.43.0



