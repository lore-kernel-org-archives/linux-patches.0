Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685E21F09AC;
	Fri, 21 Nov 2025 13:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731207; cv=none; b=Du5WZ1/ekhgdWIXHexvtJG9he32OdVB8sk449AzBy3+rNj2vbg/qiJG5gB6m6Lou8CTArWm9gFio6M1Pc5Srg66v0sb2MJivEq2Qqoi3Nt2IdwfbXPtBEGC+daboJn1C/Y7cci6JAA3nAUJXWNblbSzpMVJ4Pa3dXhaq1C3Tt6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731207; c=relaxed/simple;
	bh=8gjhL4V7t/Lg+RwJLdMRZATLSuTnVe6oOxfwgt8s/PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVVppRO7liqm0LwpnmGlTDSbkGOZhCcZylRLzWQr89pmD2EpyH/5io23COqKooRBzX6w1lmBDCVT/GnQlmFhaTv1ybfDujf6pC75NIv1FxRA+czzfytvm6NnwGl3HWo0oZh1mYWa15rgj4RWvpHfy9TgA3yjd7q/VjJqZ7D8tow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfWuvRCA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfWuvRCA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE816C4CEF1;
	Fri, 21 Nov 2025 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731207;
	bh=8gjhL4V7t/Lg+RwJLdMRZATLSuTnVe6oOxfwgt8s/PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfWuvRCAiI/SUlRCPIWk5ZfySuUwLeMtcyBhmeH8t/m40y2FK4jH2tfvA5TGrLy6r
	 +z+E0MyrllRDqtr4qkK5t1StVpiQ/9EHC4FQWVd0CcI5aGKdKBVmXj4teJGHo2au72
	 W6F1SP1zCo4okeuU6cYkmfmWtZsl94vQjYGJw5vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Andrei Vagin <avagin@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 128/247] fs/namespace: correctly handle errors returned by grab_requested_mnt_ns
Date: Fri, 21 Nov 2025 14:11:15 +0100
Message-ID: <20251121130159.321599424@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 78f0e33cd6c939a555aa80dbed2fec6b333a7660 ]

grab_requested_mnt_ns was changed to return error codes on failure, but
its callers were not updated to check for error pointers, still checking
only for a NULL return value.

This commit updates the callers to use IS_ERR() or IS_ERR_OR_NULL() and
PTR_ERR() to correctly check for and propagate errors.

This also makes sure that the logic actually works and mount namespace
file descriptors can be used to refere to mounts.

Christian Brauner <brauner@kernel.org> says:

Rework the patch to be more ergonomic and in line with our overall error
handling patterns.

Fixes: 7b9d14af8777 ("fs: allow mount namespace fd")
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
Link: https://patch.msgid.link/20251111062815.2546189-1-avagin@google.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c             | 32 ++++++++++++++++----------------
 include/uapi/linux/mount.h |  2 +-
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fa7c034ac4a69..0026a6e7730e9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -186,7 +186,8 @@ static void mnt_ns_release(struct mnt_namespace *ns)
 		kfree(ns);
 	}
 }
-DEFINE_FREE(mnt_ns_release, struct mnt_namespace *, if (_T) mnt_ns_release(_T))
+DEFINE_FREE(mnt_ns_release, struct mnt_namespace *,
+	    if (!IS_ERR(_T)) mnt_ns_release(_T))
 
 static void mnt_ns_release_rcu(struct rcu_head *rcu)
 {
@@ -5881,7 +5882,7 @@ static int copy_mnt_id_req(const struct mnt_id_req __user *req,
 	ret = copy_struct_from_user(kreq, sizeof(*kreq), req, usize);
 	if (ret)
 		return ret;
-	if (kreq->spare != 0)
+	if (kreq->mnt_ns_fd != 0 && kreq->mnt_ns_id)
 		return -EINVAL;
 	/* The first valid unique mount id is MNT_UNIQUE_ID_OFFSET + 1. */
 	if (kreq->mnt_id <= MNT_UNIQUE_ID_OFFSET)
@@ -5898,16 +5899,12 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 {
 	struct mnt_namespace *mnt_ns;
 
-	if (kreq->mnt_ns_id && kreq->spare)
-		return ERR_PTR(-EINVAL);
-
-	if (kreq->mnt_ns_id)
-		return lookup_mnt_ns(kreq->mnt_ns_id);
-
-	if (kreq->spare) {
+	if (kreq->mnt_ns_id) {
+		mnt_ns = lookup_mnt_ns(kreq->mnt_ns_id);
+	} else if (kreq->mnt_ns_fd) {
 		struct ns_common *ns;
 
-		CLASS(fd, f)(kreq->spare);
+		CLASS(fd, f)(kreq->mnt_ns_fd);
 		if (fd_empty(f))
 			return ERR_PTR(-EBADF);
 
@@ -5922,6 +5919,8 @@ static struct mnt_namespace *grab_requested_mnt_ns(const struct mnt_id_req *kreq
 	} else {
 		mnt_ns = current->nsproxy->mnt_ns;
 	}
+	if (!mnt_ns)
+		return ERR_PTR(-ENOENT);
 
 	refcount_inc(&mnt_ns->passive);
 	return mnt_ns;
@@ -5946,8 +5945,8 @@ SYSCALL_DEFINE4(statmount, const struct mnt_id_req __user *, req,
 		return ret;
 
 	ns = grab_requested_mnt_ns(&kreq);
-	if (!ns)
-		return -ENOENT;
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
 
 	if (kreq.mnt_ns_id && (ns != current->nsproxy->mnt_ns) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
@@ -6056,8 +6055,8 @@ static void __free_klistmount_free(const struct klistmount *kls)
 static inline int prepare_klistmount(struct klistmount *kls, struct mnt_id_req *kreq,
 				     size_t nr_mnt_ids)
 {
-
 	u64 last_mnt_id = kreq->param;
+	struct mnt_namespace *ns;
 
 	/* The first valid unique mount id is MNT_UNIQUE_ID_OFFSET + 1. */
 	if (last_mnt_id != 0 && last_mnt_id <= MNT_UNIQUE_ID_OFFSET)
@@ -6071,9 +6070,10 @@ static inline int prepare_klistmount(struct klistmount *kls, struct mnt_id_req *
 	if (!kls->kmnt_ids)
 		return -ENOMEM;
 
-	kls->ns = grab_requested_mnt_ns(kreq);
-	if (!kls->ns)
-		return -ENOENT;
+	ns = grab_requested_mnt_ns(kreq);
+	if (IS_ERR(ns))
+		return PTR_ERR(ns);
+	kls->ns = ns;
 
 	kls->mnt_parent_id = kreq->mnt_id;
 	return 0;
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index 7fa67c2031a5d..5d3f8c9e3a625 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -197,7 +197,7 @@ struct statmount {
  */
 struct mnt_id_req {
 	__u32 size;
-	__u32 spare;
+	__u32 mnt_ns_fd;
 	__u64 mnt_id;
 	__u64 param;
 	__u64 mnt_ns_id;
-- 
2.51.0



