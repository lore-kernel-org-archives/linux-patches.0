Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9E446AA92;
	Tue, 21 Jul 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649484; cv=none; b=KlYyCqtFKA4DhJ/2jbm4+J99lZQmyqxVFf6SWCfzyMCIBfd7aRW+klMbf2sM/9/f4W5dhfKpp1XSguArEcYweMkP5mH8u2N7J9oG1gbcDG6JPgNvIYdEad9bx0gEVdNhvwBTpGN/DFvn0ZIvRiMmyUVsqGBHHfd0YO3xhyJ5/VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649484; c=relaxed/simple;
	bh=1s/MTXax1Ng7JGyGFfOZ5Hc3xIF4eFIpDu5+7hA8e04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6M1QgfWPe/XT6RDcEPMGzJJGQJNMdbWDqZyi5FptHop0vquJzQeW8bqI5nzH89SOmvpc0ICne68bNUqiDg1m9fd34Cfbigf8Sd8GVjcHQV+btIbkF5uP8bXzJHGjbAItnjw3wdrXqfubNY9TgG23LFY6KZchobcZVqDw/n8FIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SGNUI5OT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SGNUI5OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89CA1F000E9;
	Tue, 21 Jul 2026 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649482;
	bh=wF8KSmtNi/NEs7smFynim7yjmdOWv8Txq7COM1gbz8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGNUI5OT5FDVn4JGoQBXzMHfNEa/BUFK7TigDo7eZJawoyIP3Ht3COvajDRkuasLj
	 YfcqIyQhM8ICV8gYYdZVXLmJYvBZWIkiyiSMSoCW4tLjm+rGOgBy24BykjIST5XstS
	 hIuzfu2EsbFplZl80j15BvZe185KnWAHcuMEEiDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0551/2077] RDMA/nldev: Fix locking when accessing mr->pd
Date: Tue, 21 Jul 2026 17:03:44 +0200
Message-ID: <20260721152605.809074191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 50d5c02ab8e62325548bd3a6e6b758a9dcd6e7c3 ]

Sashiko points out that, due to rereg_mr, the PD is actually variable and
all the touches in nldev are racy.

Use mr->device instead of mr->pd->device.

Getting the PD restrack ID is more tricky. To avoid disturbing all the
happy paths, add an rdma_restrack_sync() operation which is sort of like
flush_workqueue() or synchronize_irq(): after it returns, all the old
nldev touches to the mr are gone and everything sees the new PD. This
makes it safe to reach into the PD pointer.

Fixes: da5c85078215 ("RDMA/nldev: add driver-specific resource tracking")
Link: https://patch.msgid.link/r/4-v1-29ebd2c229b5+fd5-ib_mr_pd_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c      | 15 +++++----
 drivers/infiniband/core/restrack.c   | 49 ++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.h   |  1 +
 drivers/infiniband/core/uverbs_cmd.c | 10 ++++--
 include/rdma/ib_verbs.h              |  5 +++
 5 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 5aaba2b9746ba6..02a0a9c0a4a6ad 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -695,7 +695,7 @@ static int fill_res_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			     struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (has_cap_net_admin) {
 		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_RKEY, mr->rkey))
@@ -711,9 +711,12 @@ static int fill_res_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_MRN, res->id))
 		return -EMSGSIZE;
 
-	if (!rdma_is_kernel_res(res) &&
-	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, mr->pd->res.id))
-		return -EMSGSIZE;
+	if (!rdma_is_kernel_res(res)) {
+		struct ib_pd *pd = READ_ONCE(mr->pd);
+
+		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PDN, pd->res.id))
+			return -EMSGSIZE;
+	}
 
 	if (fill_res_name_pid(msg, res))
 		return -EMSGSIZE;
@@ -727,7 +730,7 @@ static int fill_res_mr_raw_entry(struct sk_buff *msg, bool has_cap_net_admin,
 				 struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (!dev->ops.fill_res_mr_entry_raw)
 		return -EINVAL;
@@ -1017,7 +1020,7 @@ static int fill_stat_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			      struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_MRN, res->id))
 		goto err;
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index ac3688952cabbf..cfee2071586c16 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -71,6 +71,8 @@ int rdma_restrack_count(struct ib_device *dev, enum rdma_restrack_type type,
 
 	xa_lock(&rt->xa);
 	xas_for_each(&xas, e, U32_MAX) {
+		if (xa_is_zero(e))
+			continue;
 		if (xa_get_mark(&rt->xa, e->id, RESTRACK_DD) && !show_details)
 			continue;
 		cnt++;
@@ -276,6 +278,53 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
 }
 EXPORT_SYMBOL(rdma_restrack_put);
 
+/**
+ * rdma_restrack_sync() - Fence concurrent netlink dumps on an entry
+ * @res:  resource entry
+ *
+ * After this returns any concurrent netlink dump threads will see the current
+ * value of the object. This is useful if the object has to be changed and there
+ * is not locking to protect the nl side. Eg for mr->pd. This effectively
+ * destroys the object from a kref/xarray perspective and then immediately
+ * restores it. The kref is acting like a lock to barrier concurrent nl threads.
+ * Callers must ensure rdma_restrack_del() is not concurrently called.
+ */
+void rdma_restrack_sync(struct rdma_restrack_entry *res)
+{
+	struct rdma_restrack_entry *old;
+	struct rdma_restrack_root *rt;
+	struct task_struct *task;
+	struct ib_device *dev;
+
+	if (!res->valid || res->no_track)
+		return;
+
+	dev = res_to_dev(res);
+	if (WARN_ON(!dev))
+		return;
+
+	rt = &dev->res[res->type];
+	if (WARN_ON(xa_get_mark(&rt->xa, res->id, RESTRACK_DD)))
+		return;
+
+	old = xa_cmpxchg(&rt->xa, res->id, res, XA_ZERO_ENTRY, GFP_KERNEL);
+	if (WARN_ON(old != res))
+		return;
+
+	task = res->task;
+	if (task)
+		get_task_struct(task);
+	rdma_restrack_put(res);
+	wait_for_completion(&res->comp);
+	reinit_completion(&res->comp);
+	if (task)
+		res->task = task;
+	kref_init(&res->kref);
+
+	xa_cmpxchg(&rt->xa, res->id, XA_ZERO_ENTRY, res, GFP_KERNEL);
+}
+EXPORT_SYMBOL(rdma_restrack_sync);
+
 /**
  * rdma_restrack_del() - delete object from the resource tracking database
  * @res:  resource entry
diff --git a/drivers/infiniband/core/restrack.h b/drivers/infiniband/core/restrack.h
index 6a04fc41f73801..75b8d1005a984b 100644
--- a/drivers/infiniband/core/restrack.h
+++ b/drivers/infiniband/core/restrack.h
@@ -27,6 +27,7 @@ int rdma_restrack_init(struct ib_device *dev);
 void rdma_restrack_clean(struct ib_device *dev);
 void rdma_restrack_add(struct rdma_restrack_entry *res);
 void rdma_restrack_del(struct rdma_restrack_entry *res);
+void rdma_restrack_sync(struct rdma_restrack_entry *res);
 void rdma_restrack_new(struct rdma_restrack_entry *res,
 		       enum rdma_restrack_type type);
 void rdma_restrack_set_name(struct rdma_restrack_entry *res,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 91a62d2ade4dd0..22793e4b1895e4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -47,6 +47,7 @@
 
 #include "uverbs.h"
 #include "core_priv.h"
+#include "restrack.h"
 
 /*
  * Copy a response to userspace. If the provided 'resp' is larger than the
@@ -819,6 +820,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 			ret = PTR_ERR(new_pd);
 			goto put_uobjs;
 		}
+		if (new_pd == orig_pd) {
+			uobj_put_obj_read(new_pd);
+			cmd.flags &= ~IB_MR_REREG_PD;
+		}
 	} else {
 		new_pd = mr->pd;
 	}
@@ -866,9 +871,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 		mr = new_mr;
 	} else {
 		if (cmd.flags & IB_MR_REREG_PD) {
-			atomic_dec(&orig_pd->usecnt);
-			mr->pd = new_pd;
 			atomic_inc(&new_pd->usecnt);
+			WRITE_ONCE(mr->pd, new_pd);
+			rdma_restrack_sync(&mr->res);
+			atomic_dec(&orig_pd->usecnt);
 		}
 		if (cmd.flags & IB_MR_REREG_TRANS) {
 			mr->iova = cmd.hca_va;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 9dd76f489a0ba4..46568a5221f403 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1977,6 +1977,11 @@ struct ib_dmah {
 
 struct ib_mr {
 	struct ib_device  *device;
+	/*
+	 * Due to IB_MR_REREG_PD pd is not a fixed pointer and can change. For a
+	 * user MR, this value should only be read from a system call that holds
+	 * the uobject lock, or the driver should disable in-place REREG_PD.
+	 */
 	struct ib_pd	  *pd;
 	u32		   lkey;
 	u32		   rkey;
-- 
2.53.0



