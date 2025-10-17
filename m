Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD68323EA9E;
	Fri, 17 Oct 2025 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714107; cv=none; b=TbLSdChZb9RgVRKQMz6xRCNnAqg/b7ANgyj0bMpVNLx9c2rR35qIHihoaxxGgoiSJ8IkOUMKfDCq6mZu6R0fKc1odnkqGRxIHkf9ROdLuwiiqrYszUcvggVmBEJgcYqYNByb2+b4gQvwW5hkqu1lwI6prLjGyNH6Xxvau1RIfMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714107; c=relaxed/simple;
	bh=XMuu7CymE/grA6h2y4DSPpROhXL/kbjGJLAHL0eT7IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAwSduEA1oiaS0fxmMCP/sARopmeVpUPbFOl6chQ2Jius8H7Bb+HHjVnNdd34q0n3BJKQ53tZSDKrdVgzkEmbIk/MATV8rBEDm4+RAr3KKCBnY6mD6S3AT9D387W1c4lobxoZQ/d5Cd9QfJyhwIlH1+bXR7at/ChAEV6AZ9MA+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfd8wT4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfd8wT4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A70CC4CEE7;
	Fri, 17 Oct 2025 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714107;
	bh=XMuu7CymE/grA6h2y4DSPpROhXL/kbjGJLAHL0eT7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfd8wT4U8/0nPxV826zpz7mMJnzKCc359/O4Pn9xZhI94PCOcbm0bWV/xw0EQOpa2
	 /VfsOTtzqTp7jZ7AOFDICc8muHkdm4p3Gbpfwo0tSHyP45RDdSyf9B8ZwrQF8Q60Ut
	 NBT7hAjsT1FUZ1oFpapX+qbDODRJ8estvDYdkS88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 005/277] listmount: dont call path_put() under namespace semaphore
Date: Fri, 17 Oct 2025 16:50:12 +0200
Message-ID: <20251017145147.341066836@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5411,23 +5411,34 @@ retry:
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
@@ -5439,7 +5450,7 @@ static ssize_t do_listmount(struct mnt_n
 	 * Don't trigger audit denials. We just want to determine what
 	 * mounts to show users.
 	 */
-	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &root) &&
+	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &kls->root) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -5472,14 +5483,45 @@ static ssize_t do_listmount(struct mnt_n
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
@@ -5500,31 +5542,20 @@ SYSCALL_DEFINE4(listmount, const struct
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


