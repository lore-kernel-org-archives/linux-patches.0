Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D597404E;
	Sat, 17 Oct 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254825; cv=none; b=JQ4YgSzzGr6+KgYNWlr3xetVuPVSTYCUHyKpPtNNx9Kyqk7+Rp+Pr97JtWAWCGvoEMhKEdEFTYj2CmsNQVfRo0ZAhlC9DpZK2CqCUOzAiPXfZOw9PL/l17ztn2SGEnXqc6lYgwUEl3W+LibdHkST7VJBl6mukWLXZF3vHWfZ23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254825; c=relaxed/simple;
	bh=QYtOxTw4P5GaYice/y4f4aoFEP8eGAcRLUJ8UYVbd+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMBdJ+2SvEcx7FYnL0cEDUrBGCTU8zb9dymfukSCgDWhKhSPz4/Qx4Ss3AUEgbTGuyru5T7C0MA1CHmCmlAKmsJyHvvGMJOgErT75PwSo5iAtqvUzzx0FL3esecQe17Obdjm0y53ihlfF28/YCBL4rtz3Z7HaLzN6KvistAnZ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkfNOxB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkfNOxB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767651F000C4;
	Sat, 17 Oct 2026 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254824;
	bh=mtCRAIwSxSpVkknq0t+IhyPjcs6hzJKSIGakPiYXNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkfNOxB3igIy+kmHTkAKnzLveuU4nuv8BZ1cwc6XiEUAJCbIaTbr3DQYwVAwsmadC
	 Zmlz7vK/g0Hw/YTts9OWua8Xzqh6M99WMmXB7HbpbhKkeX4BYBCMt3qe6VMWK4EKMS
	 imbhXqwQPBZ+UYUqS38Ki1tpiBIQO2FLpvwhY2rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 575/869] lockd, nfsd: RCU-protect nlmsvc_ops dispatch
Date: Sat, 17 Oct 2026 17:56:56 +0200
Message-ID: <20261017160051.805328232@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 641e5e20852359b8c31149be4598884e30652f60 ]

nlmsvc_ops is published by nfsd_lockd_init() and cleared by
nfsd_lockd_shutdown() with plain stores, while lockd dereferences
it unguarded from dispatch sites in fs/lockd/svcsubs.c. The pointer
targets nfsd's .rodata and the fopen/fclose callbacks live in nfsd's
.text, so a stale load after rmmod nfsd results in either a NULL
deref or a module-text use-after-free.

Declare nlmsvc_ops as __rcu, publish via rcu_assign_pointer(), clear
via RCU_INIT_POINTER() + synchronize_rcu(). Add a struct module
*owner field to nlmsvc_binding and pin the module across indirect
calls with try_module_get/module_put. When the binding is torn down,
fall back to fput() to avoid leaking struct file references.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260611-nfsd-testing-v2-16-5b90e276f2d9@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c             |  4 ++--
 fs/lockd/svc4proc.c        |  4 ++--
 fs/lockd/svcproc.c         |  4 ++--
 fs/lockd/svcsubs.c         | 45 +++++++++++++++++++++++++++++++++-----
 fs/nfsd/lockd.c            |  6 +++--
 include/linux/lockd/bind.h | 12 +++++++---
 6 files changed, 59 insertions(+), 16 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 4ec22c2f2ea3c..87f20d1edb2c2 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -47,7 +47,7 @@
 
 static struct svc_program	nlmsvc_program;
 
-const struct nlmsvc_binding	*nlmsvc_ops;
+const struct nlmsvc_binding __rcu *nlmsvc_ops;
 EXPORT_SYMBOL_GPL(nlmsvc_ops);
 
 static DEFINE_MUTEX(nlmsvc_mutex);
@@ -142,7 +142,7 @@ lockd(void *vrqstp)
 		nlmsvc_retry_blocked(rqstp);
 		svc_recv(rqstp);
 	}
-	if (nlmsvc_ops)
+	if (rcu_access_pointer(nlmsvc_ops))
 		nlmsvc_invalidate_all();
 	nlm_shutdown_hosts();
 	cancel_delayed_work_sync(&ln->grace_period_end);
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 3f633bb24623a..ea3b689f8b93a 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -29,7 +29,7 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	__be32			error = 0;
 
 	/* nfsd callbacks must have been installed for this procedure */
-	if (!nlmsvc_ops)
+	if (!rcu_access_pointer(nlmsvc_ops))
 		return nlm_lck_denied_nolocks;
 
 	if (lock->lock_start > OFFSET_MAX ||
@@ -487,7 +487,7 @@ nlm4svc_proc_granted_res(struct svc_rqst *rqstp)
 {
 	struct nlm_res *argp = rqstp->rq_argp;
 
-        if (!nlmsvc_ops)
+        if (!rcu_access_pointer(nlmsvc_ops))
                 return rpc_success;
 
         dprintk("lockd: GRANTED_RES   called\n");
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 8cda2aba82d25..44da63392a09d 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -59,7 +59,7 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	__be32			error = 0;
 
 	/* nfsd callbacks must have been installed for this procedure */
-	if (!nlmsvc_ops)
+	if (!rcu_access_pointer(nlmsvc_ops))
 		return nlm_lck_denied_nolocks;
 
 	/* Obtain host handle */
@@ -521,7 +521,7 @@ nlmsvc_proc_granted_res(struct svc_rqst *rqstp)
 {
 	struct nlm_res *argp = rqstp->rq_argp;
 
-	if (!nlmsvc_ops)
+	if (!rcu_access_pointer(nlmsvc_ops))
 		return rpc_success;
 
 	dprintk("lockd: GRANTED_RES   called\n");
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 90c6527ad712c..3e3cd67e167a2 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -86,12 +86,23 @@ int lock_to_openmode(struct file_lock *lock)
 static __be32 nlm_do_fopen(struct svc_rqst *rqstp,
 			   struct nlm_file *file, int mode)
 {
+	const struct nlmsvc_binding *ops;
 	struct file **fp = &file->f_file[mode];
 	__be32	nfserr;
 
 	if (*fp)
 		return 0;
-	nfserr = nlmsvc_ops->fopen(rqstp, &file->f_handle, fp, mode);
+
+	rcu_read_lock();
+	ops = rcu_dereference(nlmsvc_ops);
+	if (!ops || !try_module_get(ops->owner)) {
+		rcu_read_unlock();
+		return nlm_lck_denied_nolocks;
+	}
+	rcu_read_unlock();
+
+	nfserr = ops->fopen(rqstp, &file->f_handle, fp, mode);
+	module_put(ops->owner);
 	if (nfserr)
 		dprintk("lockd: open failed (error %d)\n", nfserr);
 	return nfserr;
@@ -159,6 +170,33 @@ nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
 	goto out_unlock;
 }
 
+/*
+ * Release the struct file references held by a nlm_file.
+ */
+static void nlm_release_files(struct nlm_file *file)
+{
+	const struct nlmsvc_binding *ops;
+	bool have_ops;
+
+	rcu_read_lock();
+	ops = rcu_dereference(nlmsvc_ops);
+	have_ops = ops && try_module_get(ops->owner);
+	rcu_read_unlock();
+
+	if (have_ops) {
+		if (file->f_file[O_RDONLY])
+			ops->fclose(file->f_file[O_RDONLY]);
+		if (file->f_file[O_WRONLY])
+			ops->fclose(file->f_file[O_WRONLY]);
+		module_put(ops->owner);
+	} else {
+		if (file->f_file[O_RDONLY])
+			fput(file->f_file[O_RDONLY]);
+		if (file->f_file[O_WRONLY])
+			fput(file->f_file[O_WRONLY]);
+	}
+}
+
 /*
  * Delete a file after having released all locks, blocks and shares
  */
@@ -168,10 +206,7 @@ nlm_delete_file(struct nlm_file *file)
 	nlm_debug_print_file("closing file", file);
 	if (!hlist_unhashed(&file->f_list)) {
 		hlist_del(&file->f_list);
-		if (file->f_file[O_RDONLY])
-			nlmsvc_ops->fclose(file->f_file[O_RDONLY]);
-		if (file->f_file[O_WRONLY])
-			nlmsvc_ops->fclose(file->f_file[O_WRONLY]);
+		nlm_release_files(file);
 		kfree(file);
 	} else {
 		printk(KERN_WARNING "lockd: attempt to release unknown file!\n");
diff --git a/fs/nfsd/lockd.c b/fs/nfsd/lockd.c
index 6b042218668b8..e933788e7a350 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -88,6 +88,7 @@ nlm_fclose(struct file *filp)
 }
 
 static const struct nlmsvc_binding nfsd_nlm_ops = {
+	.owner		= THIS_MODULE,
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
 };
@@ -96,11 +97,12 @@ void
 nfsd_lockd_init(void)
 {
 	dprintk("nfsd: initializing lockd\n");
-	nlmsvc_ops = &nfsd_nlm_ops;
+	rcu_assign_pointer(nlmsvc_ops, &nfsd_nlm_ops);
 }
 
 void
 nfsd_lockd_shutdown(void)
 {
-	nlmsvc_ops = NULL;
+	RCU_INIT_POINTER(nlmsvc_ops, NULL);
+	synchronize_rcu();
 }
diff --git a/include/linux/lockd/bind.h b/include/linux/lockd/bind.h
index c53c81242e727..e25943e485c5c 100644
--- a/include/linux/lockd/bind.h
+++ b/include/linux/lockd/bind.h
@@ -21,11 +21,17 @@
 struct svc_rqst;
 struct rpc_task;
 struct rpc_clnt;
+struct module;
 
-/*
- * This is the set of functions for lockd->nfsd communication
+/**
+ * struct nlmsvc_binding - lockd -> nfsd callback table
+ * @owner:  module that provides this binding.
+ * @fopen:  open a file by NFS file handle on behalf of an NLM request.
+ * @fclose: close a file that was previously opened via @fopen.
+ *          Implementations MUST be semantically equivalent to fput().
  */
 struct nlmsvc_binding {
+	struct module		*owner;
 	__be32			(*fopen)(struct svc_rqst *,
 						struct nfs_fh *,
 						struct file **,
@@ -33,7 +39,7 @@ struct nlmsvc_binding {
 	void			(*fclose)(struct file *);
 };
 
-extern const struct nlmsvc_binding *nlmsvc_ops;
+extern const struct nlmsvc_binding __rcu *nlmsvc_ops;
 
 /*
  * Similar to nfs_client_initdata, but without the NFS-specific
-- 
2.53.0



