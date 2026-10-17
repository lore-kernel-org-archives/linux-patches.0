Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D183A7F4D;
	Sat, 17 Oct 2026 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260714; cv=none; b=DS0Dy/1dB5t5LvZgQ5Udbj6yjZVxQgZU26m/cTNNwdyjj1IOCeHppqTY9hnZ1vvC1vHsJn1Nhy0BXcOMkM+dTjTgLyNCJ5QZ1aPGkyCfYbnn94jl29+JlVwgLzRBfpSignyi4XZk4ULiT+lVqRO/DAGLy5/qyU1nD5+vdbQ2xdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260714; c=relaxed/simple;
	bh=GTc5Zpa5bj18xwxnRfsX+hU80xvyvL6xbJspvY9+c3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrN9YghQGGkyFTtCWEu5fwftza0suxy7clYNIu+pF0JH2whwHitnKA71Uu9bg5zGatJY5jf4t/j1nyKNlJBrxmJPCTJk03jQr1mmhGzc8Pd5yfhCrJ9vdcAw7B4C4aj0n/8xNlOE8dEGT5i3Tt/TsyRtrvTTzYI4pdoT5oIr5H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzheC08c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzheC08c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C501F000C4;
	Sat, 17 Oct 2026 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260713;
	bh=X6MGW/3rmt4NWcL0VI6+5gapsC+Q/Itb21q7HZ81etA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzheC08cr5eXKI/L7JUdU0yl9ADBeX2VF1qZ/BbTfP6jr5CwitpgnOG8g/gagJK5U
	 0yGXk06BRNwS4z2T0/eLEewdTEqdTH9zfLbACmSPSYG841Uci2v0jmaLZcbBm+cBg1
	 id8YP2qncV9Rn22664AMx+jtA/4ymCL+nzN0Dl6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Randy Jennings <randyj@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1637/1674] nvme: remove stale namespaces by NSID range during scan
Date: Sat, 17 Oct 2026 18:05:09 +0200
Message-ID: <20261017160513.098414464@linuxfoundation.org>
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
index c8c62523653db..af71dd259c3c3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -122,8 +122,6 @@ static dev_t nvme_ns_chr_devt;
 static struct class *nvme_ns_chr_class;
 
 static void nvme_put_subsystem(struct nvme_subsystem *subsys);
-static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
-					   unsigned nsid);
 static void nvme_update_keep_alive(struct nvme_ctrl *ctrl,
 				   struct nvme_command *cmd);
 
@@ -3862,15 +3860,16 @@ static void nvme_scan_ns_async(void *data, async_cookie_t cookie)
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
@@ -3920,13 +3919,14 @@ static int nvme_scan_ns_list(struct nvme_ctrl *ctrl)
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
@@ -3946,7 +3946,7 @@ static void nvme_scan_ns_sequential(struct nvme_ctrl *ctrl)
 	for (i = 1; i <= nn; i++)
 		nvme_scan_ns(ctrl, i);
 
-	nvme_remove_invalid_namespaces(ctrl, nn);
+	nvme_remove_nsid_range(ctrl, nn, UINT_MAX);
 }
 
 static void nvme_clear_changed_ns_log(struct nvme_ctrl *ctrl)
-- 
2.53.0



