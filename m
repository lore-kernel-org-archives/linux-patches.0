Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9666A4BEE43;
	Sat, 12 Sep 2026 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229920; cv=none; b=f1tBkVdAnu0TN31xnMmSooStVa0z4g+GSRpXhpgxJ6wc+FDTrnSsxluBooXLIUVQhn9RJ6x54cYdygc5RtsET7P1bOINcgvNP1q/7iMQrkdEWgx47V9OD52P3OPG6eVcfX2rFP43zWVZoaPxXPDI4RQ8NvXvx7ZxbVOuayGLuQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229920; c=relaxed/simple;
	bh=XjkWLhAw3y4JRwe0Xk14skux5Xv8U26GYwbF/RfagLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktzvEiPYgLbx05H5VELemubr+xrK8d4zImDp2SMaFj6o5R/REHaP+zBOiGzHn/4eGVUJWgmfyh1POdwFBEOrKrjsD5gh8LZ7PqaZKEWy0nKpUZyS1BmF+nTcxuvwHx9io5EwWs8OQnE6NNDr5d/8Z9HBVE4diqp672B0RoboApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiwZjzSv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiwZjzSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2869B1F000FF;
	Sat, 12 Sep 2026 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229919;
	bh=P/oSpzgZdI9nVtMibVIsaawoKHLwCsbxh+/Uv5bnP7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiwZjzSvA9Zo+U5Yh3s3cvpfgF0E0qauQdPmyo50f9XCOrXnlZB1B4VTjV6iw3jCp
	 wX8FMq8yzRRboXeFIGdxfYB6GqzQrmPTaRCjTYty3mObXatHEfaaIWXBHtKnG9UaSs
	 LkGcKbMFOYl3uWtGPiy3xIoVlGBkfG8KSRSQf7PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0686/1191] RDMA/nldev: Fix locking when accessing mr->pd
Date: Sat, 12 Sep 2026 08:56:54 +0200
Message-ID: <20260912065603.668928149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c      | 15 +++++----
 drivers/infiniband/core/restrack.c   | 49 ++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.h   |  1 +
 drivers/infiniband/core/uverbs_cmd.c | 10 ++++--
 include/rdma/ib_verbs.h              |  5 +++
 5 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 88c9caebb9677..7607aee5994eb 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -662,7 +662,7 @@ static int fill_res_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			     struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (has_cap_net_admin) {
 		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_RKEY, mr->rkey))
@@ -678,9 +678,12 @@ static int fill_res_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
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
@@ -694,7 +697,7 @@ static int fill_res_mr_raw_entry(struct sk_buff *msg, bool has_cap_net_admin,
 				 struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (!dev->ops.fill_res_mr_entry_raw)
 		return -EINVAL;
@@ -966,7 +969,7 @@ static int fill_stat_mr_entry(struct sk_buff *msg, bool has_cap_net_admin,
 			      struct rdma_restrack_entry *res, uint32_t port)
 {
 	struct ib_mr *mr = container_of(res, struct ib_mr, res);
-	struct ib_device *dev = mr->pd->device;
+	struct ib_device *dev = mr->device;
 
 	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_MRN, res->id))
 		goto err;
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index a587b6e92d081..82d0865b32290 100644
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
@@ -274,6 +276,53 @@ int rdma_restrack_put(struct rdma_restrack_entry *res)
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
index 6a04fc41f7380..75b8d1005a984 100644
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
index 0890f56c0ec48..1c80ff41896de 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -46,6 +46,7 @@
 
 #include "uverbs.h"
 #include "core_priv.h"
+#include "restrack.h"
 
 /*
  * Copy a response to userspace. If the provided 'resp' is larger than the
@@ -813,6 +814,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
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
@@ -858,9 +863,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
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
index 4806be124127b..6f3a2aaccd445 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1817,6 +1817,11 @@ struct ib_dm {
 
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



