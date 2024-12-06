Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F17953A7;
	Fri,  6 Dec 2024 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498375; cv=none; b=kT/oP/dcGum+gYyFpiaNN1KuGTRsdQL5ZV5MwHkRBUb8GTqv2/9KwkYtmVuYF6MEi8BOIv+PWfqvs7Fgc2MwhagfMbEacp2A6TnunAdSWVQjDOLUfnsKw96Mpxk6w3zpVR2nlHVoaTMgJMTEMTYdrcu+l88VUv6xgngBqFcrQYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498375; c=relaxed/simple;
	bh=t3c8zr7Pg/pRWGCvurQh+jINwj+zDZlKHoaEacsSErM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptLyyQcCHHnoP7aE+xpFZPrVckImOEP9advd9ntOZ7vgjIFvm7p+pZLab6x1TfFQkt9xIFYr30nX6/1oNre7qmyyc2g1otjzPPPa+YD45dQi9sV/3AKkTPtT3FodBoJSSr3/QjJmFC8/uExPRBAMPs403hQvFTwjouEBzfvxR90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCK9IbGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCK9IbGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80004C4CED1;
	Fri,  6 Dec 2024 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498375;
	bh=t3c8zr7Pg/pRWGCvurQh+jINwj+zDZlKHoaEacsSErM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCK9IbGZFJGuBqjx0nORnTKcQaoa51BUJ2cQNP7t9/pItCRoO3x+9LIGiSzpbYRYd
	 buIQgplXj/qKjOMD3ALkad9QgkdyA4i9volEyiQ6EaaZIuoYfL/FsIABneIT1jWRNI
	 T1RyKx5vqJe34WsK8qJTT/Yh3pYi5juxTg1DUbiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Meneghini <jmeneghi@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 567/676] nvme-multipath: prepare for "queue-depth" iopolicy
Date: Fri,  6 Dec 2024 15:36:26 +0100
Message-ID: <20241206143715.508985820@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: John Meneghini <jmeneghi@redhat.com>

[ Upstream commit 3d7c2fd2ea704812867f9586270a2516377482a3 ]

This patch prepares for the introduction of a new iopolicy by breaking up
the nvme_find_path() code path into sub-routines.

Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5dd18f09ce73 ("nvme/multipath: Fix RCU list traversal to use SRCU primitive")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index ede2a14dad8be..53eee6fc68392 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -290,10 +290,15 @@ static struct nvme_ns *nvme_next_ns(struct nvme_ns_head *head,
 	return list_first_or_null_rcu(&head->list, struct nvme_ns, siblings);
 }
 
-static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head,
-		int node, struct nvme_ns *old)
+static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *ns, *found = NULL;
+	int node = numa_node_id();
+	struct nvme_ns *old = srcu_dereference(head->current_path[node],
+					       &head->srcu);
+
+	if (unlikely(!old))
+		return __nvme_find_path(head, node);
 
 	if (list_is_singular(&head->list)) {
 		if (nvme_path_is_disabled(old))
@@ -339,7 +344,7 @@ static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
 		ns->ana_state == NVME_ANA_OPTIMIZED;
 }
 
-inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
+static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
 {
 	int node = numa_node_id();
 	struct nvme_ns *ns;
@@ -347,14 +352,18 @@ inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
 	ns = srcu_dereference(head->current_path[node], &head->srcu);
 	if (unlikely(!ns))
 		return __nvme_find_path(head, node);
-
-	if (READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_RR)
-		return nvme_round_robin_path(head, node, ns);
 	if (unlikely(!nvme_path_is_optimized(ns)))
 		return __nvme_find_path(head, node);
 	return ns;
 }
 
+inline struct nvme_ns *nvme_find_path(struct nvme_ns_head *head)
+{
+	if (READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_RR)
+		return nvme_round_robin_path(head);
+	return nvme_numa_path(head);
+}
+
 static bool nvme_available_path(struct nvme_ns_head *head)
 {
 	struct nvme_ns *ns;
-- 
2.43.0



