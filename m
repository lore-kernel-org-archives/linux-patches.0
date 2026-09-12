Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B05202F71;
	Sat, 12 Sep 2026 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229925; cv=none; b=uPqhsCru5lqR28AO6zsaO3B8HlCFpyE1O4cvYYn0VWVi+KRLuSWJfjIMTYxES3s3uQXueWUNF5nuwt7jMzx2gsVTS4M6ijxZKklWyfhDifr2NOCiVkCm9tNyTBWPfOP3Hg3z1kb3HGz67F7mtzKqtGXaNdnJ/+46xhuQSdjbzGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229925; c=relaxed/simple;
	bh=GwHGgXnel8p7EPtYGBXjbOv32ixQhC6bOQR5gVWitBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU+WpMUkpl6DNDfOgAzmIp4iaSgbxnrImmiOM0VCsYLwcFbNv3Yb76NamF7okjdiqhTa10KJW49L/fEjKHB6B7muXGt/8PLrJV8NnbmhbeAIBGbhTgqNH50c4c3j2dmOBD6mSuFM1zOe3/acia6Yu79zDiQL9enyQDh8novMYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTWFg2SJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTWFg2SJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65C41F000FF;
	Sat, 12 Sep 2026 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229924;
	bh=mObGzgNZrrRJ9Q7iQ9w9hdemiGUYJD6fhA1weAK9Nlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTWFg2SJMgeVf4IomcQd9GzIzPgQ+9Ggj9bthMluuyQZ+at0mIX1Js7KxOHctluJ2
	 R5w9HNYid27iBZIiJndsccy1hKhSrqDTTDiujqjdug+n/PirDy4hsN/5+aeU4NtlMz
	 CH09uPAOorES6lrk5Wo9TuMw2vZP+8GOFdUN6WAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0687/1191] RDMA/core: Add rdma_restrack_begin/abort/commit_del() operations
Date: Sat, 12 Sep 2026 08:56:55 +0200
Message-ID: <20260912065603.692233770@linuxfoundation.org>
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
index 82d0865b32290..c03042dc1ca5a 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -127,6 +127,46 @@ static void rdma_restrack_attach_task(struct rdma_restrack_entry *res,
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
@@ -175,22 +215,23 @@ void rdma_restrack_new(struct rdma_restrack_entry *res,
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
@@ -227,6 +268,28 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
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
@@ -263,7 +326,7 @@ static void restrack_release(struct kref *kref)
 	struct rdma_restrack_entry *res;
 
 	res = container_of(kref, struct rdma_restrack_entry, kref);
-	if (res->task) {
+	if (res->task && !res->valid) {
 		put_task_struct(res->task);
 		res->task = NULL;
 	}
@@ -289,37 +352,20 @@ EXPORT_SYMBOL(rdma_restrack_put);
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
 
@@ -331,7 +377,6 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
 {
 	struct rdma_restrack_entry *old;
 	struct rdma_restrack_root *rt;
-	struct ib_device *dev;
 
 	if (!res->valid) {
 		if (res->task) {
@@ -344,12 +389,10 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
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
 
@@ -357,5 +400,61 @@ void rdma_restrack_del(struct rdma_restrack_entry *res)
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



