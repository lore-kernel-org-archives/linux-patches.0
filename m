Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827D83CAA55;
	Wed, 30 Sep 2026 19:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795206; cv=none; b=Q1rI5Bc1Dx4V9HSODuc+YuyuMajQsU1wtIuwExdA/KOUt4d7g3voH2tX3r5W1re6pTFpXFFZ1cbnhTkkoQfNsSTb/HetORf4gdmBJ59BVV7dAZRtRVUve3I1Y7bfUQIJP/Fu2+WGOdLwuXNJAC8fq09FJjX5viaTy2FkchFPJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795206; c=relaxed/simple;
	bh=X+AoABO7eShLgUtIzaPKKQEw8/DCmo6gXgepP4HFxgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8LijmhqA0hWg9vDArY+MuyRleXAG/k5CWhjO7Fj89j3vDDNXfIl1zEWtQKXkaiN/85qOQ13EQM0KAp7WTavGTTbzzY1UUIj0ycTybSrrbUiiTu37u0XDFpe+x9kHlgJFgL13zjPdnU40wYzkb0UEdtCMuPagOVEkOwr/kUs9ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXCJpjDW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXCJpjDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA901F00898;
	Wed, 30 Sep 2026 19:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795205;
	bh=o8eVtCRKEcRWizvOxpeAL4sMkjKEEbQLKUxz4n2Ejjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXCJpjDWe6+Vk9Xj74Fjia1GyPbeV2o9n42OirUSN+Pv5aQ/VtjvRGuHqU5GV95KF
	 f34a9cyAL98YQA7QM9XSoykNq9UKctw5NY4M2dqE2YGoAfawVgY/y+lMecorIhbGzU
	 V3f/arjR1DjS4bLmuDArozliNBcShJwAtd4cBm58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Randy Jennings <randyj@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0481/1193] nvme: remove stale namespaces by NSID range during scan
Date: Wed, 30 Sep 2026 17:19:25 +0200
Message-ID: <20260930152444.843998566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 4ed7f3d7d435bf5b63da2814dc9270f5ba896011 ]

nvme_scan_ns_list() drops the stale namespaces in each gap in the
reported NSID list one NSID at a time. Every iteration calls
nvme_find_get_ns() to look the namespace up and removes it if it is
present. The loop runs once per NSID in the gap rather than once per
namespace actually present.

NSIDs are 32-bit, so a target with a sparse NSID space can make a
single gap spin the loop billions of times with nothing to remove.

  watchdog: BUG: soft lockup - CPU#4 stuck for 26s!
  Workqueue: nvme-wq nvme_scan_work [nvme_core]
  RIP: 0010:__srcu_read_unlock+0xb/0x20
  Call Trace:
   nvme_find_get_ns+0x7d/0xb0 [nvme_core]
   nvme_scan_ns_list+0xe8/0x280 [nvme_core]
   nvme_scan_work+0x18a/0x280 [nvme_core]
   process_one_work+0x197/0x380
   worker_thread+0x2fe/0x410
   kthread+0xe0/0x100

Rename nvme_remove_invalid_namespaces() to nvme_remove_nsid_range()
and give it an open (start, end) NSID range. ctrl->namespaces is
sorted by NSID, so the whole gap is dropped in a single walk that
stops once end is reached. This bounds the work by the namespaces
that are present instead of by the size of the gap.

Fixes: 540c801c65eb ("NVMe: Implement namespace list scanning")
Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Randy Jennings <randyj@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index a8f0329393b00..a9e2f1dd8a38b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -122,8 +122,6 @@ static dev_t nvme_ns_chr_devt;
 static struct class *nvme_ns_chr_class;
 
 static void nvme_put_subsystem(struct nvme_subsystem *subsys);
-static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
-					   unsigned nsid);
 static void nvme_update_keep_alive(struct nvme_ctrl *ctrl,
 				   struct nvme_command *cmd);
 
@@ -3859,15 +3857,16 @@ static void nvme_scan_ns_async(void *data, async_cookie_t cookie)
 	nvme_scan_ns(scan_info->ctrl, nsid);
 }
 
-static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
-					unsigned nsid)
+static void nvme_remove_nsid_range(struct nvme_ctrl *ctrl, u32 start, u32 end)
 {
 	struct nvme_ns *ns, *next;
 	LIST_HEAD(rm_list);
 
 	mutex_lock(&ctrl->namespaces_lock);
 	list_for_each_entry_safe(ns, next, &ctrl->namespaces, list) {
-		if (ns->head->ns_id > nsid) {
+		if (ns->head->ns_id >= end)
+			break;
+		if (ns->head->ns_id > start) {
 			list_del_rcu(&ns->list);
 			synchronize_srcu(&ctrl->srcu);
 			list_add_tail_rcu(&ns->list, &rm_list);
@@ -3917,13 +3916,14 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
 				goto out;
 			async_schedule_domain(nvme_scan_ns_async, &scan_info,
 						&domain);
-			while (++prev < nsid)
-				nvme_ns_remove_by_nsid(ctrl, prev);
+			if (prev + 1 < nsid)
+				nvme_remove_nsid_range(ctrl, prev, nsid);
+			prev = max(prev + 1, nsid);
 		}
 		async_synchronize_full_domain(&domain);
 	}
  out:
-	nvme_remove_invalid_namespaces(ctrl, prev);
+	nvme_remove_nsid_range(ctrl, prev, UINT_MAX);
  free:
 	async_synchronize_full_domain(&domain);
 	kfree(ns_list);
@@ -3943,7 +3943,7 @@ static void nvme_scan_ns_sequential(struct nvme_ctrl *ctrl)
 	for (i = 1; i <= nn; i++)
 		nvme_scan_ns(ctrl, i);
 
-	nvme_remove_invalid_namespaces(ctrl, nn);
+	nvme_remove_nsid_range(ctrl, nn, UINT_MAX);
 }
 
 static void nvme_clear_changed_ns_log(struct nvme_ctrl *ctrl)
-- 
2.53.0



