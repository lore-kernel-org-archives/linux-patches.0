Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205541607B7;
	Mon, 24 Feb 2025 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409041; cv=none; b=V7JQO8qIjp7N/Ge8aDOUp6Df/WoVn0hOQSKg2c5kASJsCamFH3QRBzQLTaJAR6j1Lo4ozx1PpsK1P53WIw/HqQtieCNsb59iGbpuPO/9fMXskOXR+LGhJuwiR2znPUG+eFZ8qm4/bx0YWZfva4Wxbx+YMVGWDz267qV4MiSBdRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409041; c=relaxed/simple;
	bh=viy6Q5NKzorMjdjmJBfzFtwaUsnhniUrp0ti8ybuPmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgerq1hj5nsXvBOrszQolNVFOIrzS+yYVCvN1xuleQHAnAEBDn1nXBXSlg2r/d9wrRMboxaTMVens0+9TVjnQapcMDZTwSgAUe8W0neukslx19grTX/foTKiKmy0pOo2Tmu9mSSst0ERsAeFSV2AIWbLnR4sjZUgLyYgX0BD3Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg+QDEvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg+QDEvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E6FC4CED6;
	Mon, 24 Feb 2025 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409041;
	bh=viy6Q5NKzorMjdjmJBfzFtwaUsnhniUrp0ti8ybuPmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg+QDEvT4oVBfr5oRoGMDW7PeEA5TeGWdrXczra/OeX+2ePMW42ydDLEDMxcdcdcf
	 arbUTmtaJmOfk7ONJTzxy0H3EIoSv0YLn7l16RDM+MdyeHGu/mADkRu3ltUlCK62bx
	 oGzPQZXcbC2130meHrJo+85oBk9TGq8DVJ+NGYEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 079/138] nvmet: Fix crash when a namespace is disabled
Date: Mon, 24 Feb 2025 15:35:09 +0100
Message-ID: <20250224142607.584895232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 4082326807072b71496501b6a0c55ffe8d5092a5 ]

The namespace percpu counter protects pending I/O, and we can
only safely diable the namespace once the counter drop to zero.
Otherwise we end up with a crash when running blktests/nvme/058
(eg for loop transport):

[ 2352.930426] [  T53909] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN PTI
[ 2352.930431] [  T53909] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[ 2352.930434] [  T53909] CPU: 3 UID: 0 PID: 53909 Comm: kworker/u16:5 Tainted: G        W          6.13.0-rc6 #232
[ 2352.930438] [  T53909] Tainted: [W]=WARN
[ 2352.930440] [  T53909] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-3.fc41 04/01/2014
[ 2352.930443] [  T53909] Workqueue: nvmet-wq nvme_loop_execute_work [nvme_loop]
[ 2352.930449] [  T53909] RIP: 0010:blkcg_set_ioprio+0x44/0x180

as the queue is already torn down when calling submit_bio();

So we need to init the percpu counter in nvmet_ns_enable(), and
wait for it to drop to zero in nvmet_ns_disable() to avoid having
I/O pending after the namespace has been disabled.

Fixes: 74d16965d7ac ("nvmet-loop: avoid using mutex in IO hotpath")

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 40 ++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index fde6c555af619..56e3c870ab4c3 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -606,6 +606,9 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 			goto out_dev_put;
 	}
 
+	if (percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL))
+		goto out_pr_exit;
+
 	nvmet_ns_changed(subsys, ns->nsid);
 	ns->enabled = true;
 	xa_set_mark(&subsys->namespaces, ns->nsid, NVMET_NS_ENABLED);
@@ -613,6 +616,9 @@ int nvmet_ns_enable(struct nvmet_ns *ns)
 out_unlock:
 	mutex_unlock(&subsys->lock);
 	return ret;
+out_pr_exit:
+	if (ns->pr.enable)
+		nvmet_pr_exit_ns(ns);
 out_dev_put:
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
 		pci_dev_put(radix_tree_delete(&ctrl->p2p_ns_map, ns->nsid));
@@ -638,6 +644,19 @@ void nvmet_ns_disable(struct nvmet_ns *ns)
 
 	mutex_unlock(&subsys->lock);
 
+	/*
+	 * Now that we removed the namespaces from the lookup list, we
+	 * can kill the per_cpu ref and wait for any remaining references
+	 * to be dropped, as well as a RCU grace period for anyone only
+	 * using the namepace under rcu_read_lock().  Note that we can't
+	 * use call_rcu here as we need to ensure the namespaces have
+	 * been fully destroyed before unloading the module.
+	 */
+	percpu_ref_kill(&ns->ref);
+	synchronize_rcu();
+	wait_for_completion(&ns->disable_done);
+	percpu_ref_exit(&ns->ref);
+
 	if (ns->pr.enable)
 		nvmet_pr_exit_ns(ns);
 
@@ -660,22 +679,6 @@ void nvmet_ns_free(struct nvmet_ns *ns)
 	if (ns->nsid == subsys->max_nsid)
 		subsys->max_nsid = nvmet_max_nsid(subsys);
 
-	mutex_unlock(&subsys->lock);
-
-	/*
-	 * Now that we removed the namespaces from the lookup list, we
-	 * can kill the per_cpu ref and wait for any remaining references
-	 * to be dropped, as well as a RCU grace period for anyone only
-	 * using the namepace under rcu_read_lock().  Note that we can't
-	 * use call_rcu here as we need to ensure the namespaces have
-	 * been fully destroyed before unloading the module.
-	 */
-	percpu_ref_kill(&ns->ref);
-	synchronize_rcu();
-	wait_for_completion(&ns->disable_done);
-	percpu_ref_exit(&ns->ref);
-
-	mutex_lock(&subsys->lock);
 	subsys->nr_namespaces--;
 	mutex_unlock(&subsys->lock);
 
@@ -705,9 +708,6 @@ struct nvmet_ns *nvmet_ns_alloc(struct nvmet_subsys *subsys, u32 nsid)
 	ns->nsid = nsid;
 	ns->subsys = subsys;
 
-	if (percpu_ref_init(&ns->ref, nvmet_destroy_namespace, 0, GFP_KERNEL))
-		goto out_free;
-
 	if (ns->nsid > subsys->max_nsid)
 		subsys->max_nsid = nsid;
 
@@ -730,8 +730,6 @@ struct nvmet_ns *nvmet_ns_alloc(struct nvmet_subsys *subsys, u32 nsid)
 	return ns;
 out_exit:
 	subsys->max_nsid = nvmet_max_nsid(subsys);
-	percpu_ref_exit(&ns->ref);
-out_free:
 	kfree(ns);
 out_unlock:
 	mutex_unlock(&subsys->lock);
-- 
2.39.5



