Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E891E3876A7;
	Sat, 12 Sep 2026 07:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199416; cv=none; b=ruG1Hufi0l9JoTz1hi23l5SS94elyVy/JjF4/XSUi0K2eSDkY6pNaWQ3VmLm3SbEN4f+1ZUjgZsHMz2AJAFUF4ZKiNvnoiFGUPLsEQWzuE7ckZvLOj9horKdGz10UtBXyKAOBVEBAaBidSIzNmGuLNNkdMrpN1U7p1G24n9osjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199416; c=relaxed/simple;
	bh=pbZENTkcaxMShvCSGSw59yiXfgIMgb4OVkAfOukD8Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMaNMimGVNzBfYszoDDfIevZl2TbFrQ8OPx2/qC40zceQtnmW/t+gPt3VYZYSf+e15ZNvCWA66TMaUz0ErWwiTkY40VtE0AgBbvjujXz/xJQ/7V91eRV+ZEu9H77DDc+KODDEJSQb99Yy9ASgsQ2zgQ81A4v3lC7AExr3gX2bIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfO4btch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfO4btch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44BD1F000FF;
	Sat, 12 Sep 2026 07:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199414;
	bh=IEhCd7m2P6G7YXS/wjs5w+2zpqDdD1RQNfOYi55tJDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfO4btchXSHqy4kehXogw+llVDlMZZ1mAbZtkQgO6uxqOoX8xIs55A34xFUHfNOfo
	 D+RjD9gF+Kkoo4Q3Gbg/2incxC+V8mc52X8tq+11E4ORL6+tY5viGRFfuN8eYXtGJP
	 k8ue1HoSBhzPyA3kMBusWbt8JOeZ24SmYrp3FA6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0579/1815] RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations
Date: Sat, 12 Sep 2026 08:38:49 +0200
Message-ID: <20260912065702.472003258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 8d186210677c0322db886973bcec9aa4d21b51cd ]

Add rdma_restrack_abort_del(), rdma_restrack_begin_del() and
rdma_restrack_commit_del() functions to allow deleting a resource from
the xarray to effectively prevent future access to it and wait for all
current users to finish while preserving its index in the xarray to
allow to re-insert it if needed with guaranteed success.

This is a preparatory change for subsequent patches in the series
which will use these functions to fix the cleanup flow.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-1-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 709ba0e5311b ("RDMA/core: Fix use after free in ib_query_qp()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/restrack.c | 165 +++++++++++++++++++++++------
 drivers/infiniband/core/restrack.h |   3 +
 2 files changed, 135 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index cfee2071586c1..0d7e40f63c8a0 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -129,6 +129,46 @@ static void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
 	res->user = true;
 }
 
+static struct rdma_restrack_root *res_to_rt(struct rdma_restrack_entry *res)
+{
+	struct ib_device *dev = res_to_dev(res);
+
+	if (WARN_ON(!dev))
+		return NULL;
+
+	return &dev->res[res->type];
+}
+
+static void restrack_drain_res(struct rdma_restrack_root *rt,
+			       struct rdma_restrack_entry *res)
+{
+	if (rt) {
+		struct rdma_restrack_entry *old;
+
+		old = xa_cmpxchg(&rt->xa, res->id, res, XA_ZERO_ENTRY,
+				 GFP_KERNEL);
+		WARN_ON(old != res);
+	}
+
+	rdma_restrack_put(res);
+	wait_for_completion(&res->comp);
+}
+
+static void restrack_restore_res(struct rdma_restrack_root *rt,
+				 struct rdma_restrack_entry *res)
+{
+	reinit_completion(&res->comp);
+	kref_init(&res->kref);
+
+	if (rt) {
+		struct rdma_restrack_entry *old;
+
+		old = xa_cmpxchg(&rt->xa, res->id, XA_ZERO_ENTRY, res,
+				 GFP_KERNEL);
+		WARN_ON(old);
+	}
+}
+
 /**
  * rdma_restrack_set_name() - set the task for this resource
  * @res:  resource entry
@@ -177,22 +217,23 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
 EXPORT_SYMBOL(rdma_restrack_new);
 
 /**
- * rdma_restrack_add() - add object to the resource tracking database
+ * rdma_restrack_add() - add object to the resource tracking database.
+ * If this resource reuses an ID of a resource that was already destroyed
+ * after calling rdma_restrack_begin() but didn't yet call
+ * rdma_restrack_commit_del() it can result in an untracked QP.
  * @res:  resource entry
  */
 void rdma_restrack_add(struct rdma_restrack_entry *res)
 {
-	struct ib_device *dev = res_to_dev(res);
 	struct rdma_restrack_root *rt;
 	int ret = 0;
 
-	if (!dev)
-		return;
-
 	if (res->no_track)
 		goto out;
 
-	rt = &dev->res[res->type];
+	rt = res_to_rt(res);
+	if (!rt)
+		return;
 
 	if (res->type == RDMA_RESTRACK_QP) {
 		/* Special case to ensure that LQPN points to right QP */
@@ -229,6 +270,28 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 }
 EXPORT_SYMBOL(rdma_restrack_add);
 
+/**
+ * rdma_restrack_abort_del() - re-add object to the resource tracking database
+ * it can only be used after rdma_restrack_begin_del().
+ * @res:  resource entry
+ */
+void rdma_restrack_abort_del(struct rdma_restrack_entry *res)
+{
+	struct rdma_restrack_root *rt = NULL;
+
+	if (!res->valid)
+		return;
+
+	if (!res->no_track) {
+		rt = res_to_rt(res);
+		if (!rt)
+			return;
+	}
+
+	restrack_restore_res(rt, res);
+}
+EXPORT_SYMBOL(rdma_restrack_abort_del);
+
 int __must_check rdma_restrack_get(struct rdma_restrack_entry *res)
 {
 	return kref_get_unless_zero(&res->kref);
@@ -265,7 +328,7 @@ static void restrack_release(struct kref *kref)
 	struct rdma_restrack_entry *res;
 
 	res = container_of(kref, struct rdma_restrack_entry, kref);
-	if (res->task) {
+	if (res->task && !res->valid) {
 		put_task_struct(res->task);
 		res->task = NULL;
 	}
@@ -291,37 +354,20 @@ EXPORT_SYMBOL(rdma_restrack_put);
  */
 void rdma_restrack_sync(struct rdma_restrack_entry *res)
 {
-	struct rdma_restrack_entry *old;
 	struct rdma_restrack_root *rt;
-	struct task_struct *task;
-	struct ib_device *dev;
 
 	if (!res->valid || res->no_track)
 		return;
 
-	dev = res_to_dev(res);
-	if (WARN_ON(!dev))
+	rt = res_to_rt(res);
+	if (!rt)
 		return;
 
-	rt = &dev->res[res->type];
 	if (WARN_ON(xa_get_mark(&rt->xa, res->id, RESTRACK_DD)))
 		return;
 
-	old = xa_cmpxchg(&rt->xa, res->id, res, XA_ZERO_ENTRY, GFP_KERNEL);
-	if (WARN_ON(old != res))
-		return;
-
-	task = res->task;
-	if (task)
-		get_task_struct(task);
-	rdma_restrack_put(res);
-	wait_for_completion(&res->comp);
-	reinit_completion(&res->comp);
-	if (task)
-		res->task = task;
-	kref_init(&res->kref);
-
-	xa_cmpxchg(&rt->xa, res->id, XA_ZERO_ENTRY, res, GFP_KERNEL);
+	restrack_drain_res(rt, res);
+	restrack_restore_res(rt, res);
 }
 EXPORT_SYMBOL(rdma_restrack_sync);
 
@@ -333,7 +379,6 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 {
 	struct rdma_restrack_entry *old;
 	struct rdma_restrack_root *rt;
-	struct ib_device *dev;
 
 	if (!res->valid) {
 		if (res->task) {
@@ -346,12 +391,10 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	if (res->no_track)
 		goto out;
 
-	dev = res_to_dev(res);
-	if (WARN_ON(!dev))
+	rt = res_to_rt(res);
+	if (!rt)
 		return;
 
-	rt = &dev->res[res->type];
-
 	old = xa_erase(&rt->xa, res->id);
 	WARN_ON(old != res);
 
@@ -359,5 +402,61 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 	res->valid = false;
 	rdma_restrack_put(res);
 	wait_for_completion(&res->comp);
+	if (res->task) {
+		put_task_struct(res->task);
+		res->task = NULL;
+	}
 }
 EXPORT_SYMBOL(rdma_restrack_del);
+
+/**
+ * rdma_restrack_begin_del() - invalidate the object from the resource tracking
+ * database but preserve its index in the array.
+ * Since this preserves the index in the array until rdma_restrack_commit_del()
+ * is called, if rdma_restrack_add() is called in between with an old QP ID it
+ * can result in an untracked QP.
+ * @res:  resource entry
+ */
+void rdma_restrack_begin_del(struct rdma_restrack_entry *res)
+{
+	struct rdma_restrack_root *rt = NULL;
+
+	if (!res->valid)
+		return;
+
+	if (!res->no_track) {
+		rt = res_to_rt(res);
+		if (!rt)
+			return;
+	}
+
+	restrack_drain_res(rt, res);
+}
+EXPORT_SYMBOL(rdma_restrack_begin_del);
+
+/**
+ * rdma_restrack_commit_del() - delete object from the resource tracking
+ * database and free the task.
+ * @res:  resource entry
+ */
+void rdma_restrack_commit_del(struct rdma_restrack_entry *res)
+{
+	struct rdma_restrack_root *rt;
+
+	if (!res->valid || res->no_track)
+		goto out;
+
+	rt = res_to_rt(res);
+	if (!rt)
+		return;
+
+	xa_erase(&rt->xa, res->id);
+
+out:
+	res->valid = false;
+	if (res->task) {
+		put_task_struct(res->task);
+		res->task = NULL;
+	}
+}
+EXPORT_SYMBOL(rdma_restrack_commit_del);
diff --git a/drivers/infiniband/core/restrack.h b/drivers/infiniband/core/restrack.h
index 75b8d1005a984..2df78e084e107 100644
--- a/drivers/infiniband/core/restrack.h
+++ b/drivers/infiniband/core/restrack.h
@@ -26,8 +26,11 @@ struct rdma_restrack_root {
 int rdma_restrack_init(struct ib_device *dev);
 void rdma_restrack_clean(struct ib_device *dev);
 void rdma_restrack_add(struct rdma_restrack_entry *res);
+void rdma_restrack_abort_del(struct rdma_restrack_entry *res);
 void rdma_restrack_del(struct rdma_restrack_entry *res);
 void rdma_restrack_sync(struct rdma_restrack_entry *res);
+void rdma_restrack_begin_del(struct rdma_restrack_entry *res);
+void rdma_restrack_commit_del(struct rdma_restrack_entry *res);
 void rdma_restrack_new(struct rdma_restrack_entry *res,
 		       enum rdma_restrack_type type);
 void rdma_restrack_set_name(struct rdma_restrack_entry *res,
-- 
2.53.0



