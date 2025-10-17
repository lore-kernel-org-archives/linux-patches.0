Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E237A2745E;
	Fri, 17 Oct 2025 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714888; cv=none; b=CCWaGhkZm1hsI7cJwgZbrQ5BMmLmh42kgApssshcXjUdFec1O0E9NMYRTNOkuzvjMIMdSyuHKuTjQnnUM3Tttcglm8lKVN/iPZY5afT7avEKhx8sDMKm/UlafERJTbZiFqRvVBa4JNk9ETVaF2sx6TPgXC0jKjN/pjVWpLPIt38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714888; c=relaxed/simple;
	bh=voRdYrXhtr8LEnaiisGSG8jQi1liwGqtqswuJikdkno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7/z71H/dLIcownuwbvJsMYX3K2oUx6pOVInxNdYjKwyp/ycKXsXko2qwZDYlv9VC1rVnXJZ67svoLsP2GzJo6PbEkzM0S04ORnwmdbNc9wmWngDWJCId7G1OEkJsJ3nXHAwz9mHCciK6ZnGT7ra1opRbM6+f7NyYd1J9qAWzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hc5Xmfne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hc5Xmfne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06405C4CEE7;
	Fri, 17 Oct 2025 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714885;
	bh=voRdYrXhtr8LEnaiisGSG8jQi1liwGqtqswuJikdkno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hc5XmfnelDiIeHCDtl/Ok4Kpi2xy20RYsX/77QO2yd7iTmACI0j9YIhPwhoo0gx6y
	 Zg5BEJK3DNEvFjyOog5roX3IpXBoFoD2gjEn80lu4gwghMoN21npMr9aROuXHvyXSh
	 0c/QsnxDUg5APAe8O7YmifmntRzFStd4tyFbO2Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 007/371] listmount: dont call path_put() under namespace semaphore
Date: Fri, 17 Oct 2025 16:49:42 +0200
Message-ID: <20251017145202.059188281@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit c1f86d0ac322c7e77f6f8dbd216c65d39358ffc0 upstream.

Massage listmount() and make sure we don't call path_put() under the
namespace semaphore. If we put the last reference we're fscked.

Fixes: b4c2bea8ceaa ("add listmount(2) syscall")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   87 ++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 28 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5966,23 +5966,34 @@ retry:
 	return ret;
 }
 
-static ssize_t do_listmount(struct mnt_namespace *ns, u64 mnt_parent_id,
-			    u64 last_mnt_id, u64 *mnt_ids, size_t nr_mnt_ids,
-			    bool reverse)
+struct klistmount {
+	u64 last_mnt_id;
+	u64 mnt_parent_id;
+	u64 *kmnt_ids;
+	u32 nr_mnt_ids;
+	struct mnt_namespace *ns;
+	struct path root;
+};
+
+static ssize_t do_listmount(struct klistmount *kls, bool reverse)
 {
-	struct path root __free(path_put) = {};
+	struct mnt_namespace *ns = kls->ns;
+	u64 mnt_parent_id = kls->mnt_parent_id;
+	u64 last_mnt_id = kls->last_mnt_id;
+	u64 *mnt_ids = kls->kmnt_ids;
+	size_t nr_mnt_ids = kls->nr_mnt_ids;
 	struct path orig;
 	struct mount *r, *first;
 	ssize_t ret;
 
 	rwsem_assert_held(&namespace_sem);
 
-	ret = grab_requested_root(ns, &root);
+	ret = grab_requested_root(ns, &kls->root);
 	if (ret)
 		return ret;
 
 	if (mnt_parent_id == LSMT_ROOT) {
-		orig = root;
+		orig = kls->root;
 	} else {
 		orig.mnt = lookup_mnt_in_ns(mnt_parent_id, ns);
 		if (!orig.mnt)
@@ -5994,7 +6005,7 @@ static ssize_t do_listmount(struct mnt_n
 	 * Don't trigger audit denials. We just want to determine what
 	 * mounts to show users.
 	 */
-	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &root) &&
+	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &kls->root) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -6027,14 +6038,45 @@ static ssize_t do_listmount(struct mnt_n
 	return ret;
 }
 
+static void __free_klistmount_free(const struct klistmount *kls)
+{
+	path_put(&kls->root);
+	kvfree(kls->kmnt_ids);
+	mnt_ns_release(kls->ns);
+}
+
+static inline int prepare_klistmount(struct klistmount *kls, struct mnt_id_req *kreq,
+				     size_t nr_mnt_ids)
+{
+
+	u64 last_mnt_id = kreq->param;
+
+	/* The first valid unique mount id is MNT_UNIQUE_ID_OFFSET + 1. */
+	if (last_mnt_id != 0 && last_mnt_id <= MNT_UNIQUE_ID_OFFSET)
+		return -EINVAL;
+
+	kls->last_mnt_id = last_mnt_id;
+
+	kls->nr_mnt_ids = nr_mnt_ids;
+	kls->kmnt_ids = kvmalloc_array(nr_mnt_ids, sizeof(*kls->kmnt_ids),
+				       GFP_KERNEL_ACCOUNT);
+	if (!kls->kmnt_ids)
+		return -ENOMEM;
+
+	kls->ns = grab_requested_mnt_ns(kreq);
+	if (!kls->ns)
+		return -ENOENT;
+
+	kls->mnt_parent_id = kreq->mnt_id;
+	return 0;
+}
+
 SYSCALL_DEFINE4(listmount, const struct mnt_id_req __user *, req,
 		u64 __user *, mnt_ids, size_t, nr_mnt_ids, unsigned int, flags)
 {
-	u64 *kmnt_ids __free(kvfree) = NULL;
+	struct klistmount kls __free(klistmount_free) = {};
 	const size_t maxcount = 1000000;
-	struct mnt_namespace *ns __free(mnt_ns_release) = NULL;
 	struct mnt_id_req kreq;
-	u64 last_mnt_id;
 	ssize_t ret;
 
 	if (flags & ~LISTMOUNT_REVERSE)
@@ -6055,22 +6097,12 @@ SYSCALL_DEFINE4(listmount, const struct
 	if (ret)
 		return ret;
 
-	last_mnt_id = kreq.param;
-	/* The first valid unique mount id is MNT_UNIQUE_ID_OFFSET + 1. */
-	if (last_mnt_id != 0 && last_mnt_id <= MNT_UNIQUE_ID_OFFSET)
-		return -EINVAL;
-
-	kmnt_ids = kvmalloc_array(nr_mnt_ids, sizeof(*kmnt_ids),
-				  GFP_KERNEL_ACCOUNT);
-	if (!kmnt_ids)
-		return -ENOMEM;
-
-	ns = grab_requested_mnt_ns(&kreq);
-	if (!ns)
-		return -ENOENT;
+	ret = prepare_klistmount(&kls, &kreq, nr_mnt_ids);
+	if (ret)
+		return ret;
 
-	if (kreq.mnt_ns_id && (ns != current->nsproxy->mnt_ns) &&
-	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
+	if (kreq.mnt_ns_id && (kls.ns != current->nsproxy->mnt_ns) &&
+	    !ns_capable_noaudit(kls.ns->user_ns, CAP_SYS_ADMIN))
 		return -ENOENT;
 
 	/*
@@ -6078,12 +6110,11 @@ SYSCALL_DEFINE4(listmount, const struct
 	 * listmount() doesn't care about any mount properties.
 	 */
 	scoped_guard(rwsem_read, &namespace_sem)
-		ret = do_listmount(ns, kreq.mnt_id, last_mnt_id, kmnt_ids,
-				   nr_mnt_ids, (flags & LISTMOUNT_REVERSE));
+		ret = do_listmount(&kls, (flags & LISTMOUNT_REVERSE));
 	if (ret <= 0)
 		return ret;
 
-	if (copy_to_user(mnt_ids, kmnt_ids, ret * sizeof(*mnt_ids)))
+	if (copy_to_user(mnt_ids, kls.kmnt_ids, ret * sizeof(*mnt_ids)))
 		return -EFAULT;
 
 	return ret;


