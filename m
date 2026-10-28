Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216082;
	b=LtiJ11JjfJrGvvumDDS+t7X2pw1gafQPS5kKe7AmRPNgRyT/L+L/89hJ9pgTZvuTGQqW
	 62xQnGa1PUqHgy6B/V2OLQqRx9oXRLfs/Ax1aPw7oY7zN5y5kqToUrnBLwJGvPM1Z534q
	 nEE7KUkg9oxU5cr+hY+irLj7NdNGJBSkCg5lH7ASveo0mmIYA+FzqJViJ/HHlQK+nWSu/
	 g4CD/NO1qSghQo3KCmJ7q1NmpOjCMuggtMMCMnyyX3+K6Yu5ZzAHhHpQ+xDz25oChE8qa
	 RHQz1Q2ob+AHij1En20KCsW3vKTmjkq6ixEcaQPFc+z/FbBnE0pOjJHIwnSlGAO9j3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnHDZ2XjCCnX+x4mkk2a1yPuify+dpUH5U7jVRS0Yvs=;
	b=XMp/hiK+to5H0jE1XasjeyRuoZNKqCsKR3PdeK9k4rzcOpWeg7MCEmVAn8ITCH1aJ+1z
	 SQEp5Pi9YfTz1pea7xBYlxbLtCqzJ6x6xNMkO8ggVzGSU0dzjYC5ypePX1Vg+o4VVIij8
	 MFVHaeY76bJusG2BxqZDCa2yD0+W6rp+yu4zLwFQpghuzPftvnlhhNo44p2WyxmTVZLtv
	 JgM4hiilaD4nkJeuBjsYh4c1YwPI+XkfABhkK8dzVShCtlTxjUjs25SAUslfRQT3MoXwC
	 c5Fn72UNQieL+hXszgWWc3PFHE4XQmyFT8Bv5RbQg+OxLNTwVn7YavLGT1broADEIJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ks5tupDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39B3606A31C;
	Wed, 28 Oct 2026 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ks5tupDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06D61F01825;
	Wed, 28 Oct 2026 19:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216081;
	bh=BnHDZ2XjCCnX+x4mkk2a1yPuify+dpUH5U7jVRS0Yvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks5tupDYkyKUEt3O4dYhBoV3ow3QO6dXEi8TDmxX1soPtQ0K2TO7DJ9TgzKwPJIL3
	 rVqbdQRK/oON+ma4d34tMHDDYSXQLuc2qijpiL1gyxpXjRiYirSq0V6WBIXynxNwia
	 97xj9xn0cH16xz0qBxmLLK2JFhY3re/O+eDUQf14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1434/1887] lockd, nfsd: RCU-protect nlmsvc_ops dispatch
Date: Wed, 28 Oct 2026 17:58:50 +0100
Message-ID: <20261028170532.093081471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/lockd/svc.c             |  6 ++---
 fs/lockd/svc4proc.c        |  4 ++--
 fs/lockd/svcproc.c         |  4 ++--
 fs/lockd/svcsubs.c         | 45 +++++++++++++++++++++++++++++++++-----
 fs/nfsd/lockd.c            |  6 +++--
 include/linux/lockd/bind.h | 12 +++++++---
 6 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index c33f78513f00f..1905e7a6b9162 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -49,7 +49,7 @@
 
 static struct svc_program	nlmsvc_program;
 
-const struct nlmsvc_binding	*nlmsvc_ops;
+const struct nlmsvc_binding __rcu *nlmsvc_ops;
 EXPORT_SYMBOL_GPL(nlmsvc_ops);
 
 static DEFINE_MUTEX(nlmsvc_mutex);
@@ -113,7 +113,7 @@ static void set_grace_period(struct net *net)
 
 static void restart_grace(void)
 {
-	if (nlmsvc_ops) {
+	if (rcu_access_pointer(nlmsvc_ops)) {
 		struct net *net = &init_net;
 		struct lockd_net *ln = net_generic(net, lockd_net_id);
 
@@ -175,7 +175,7 @@ lockd(void *vrqstp)
 		svc_process(rqstp);
 	}
 	flush_signals(current);
-	if (nlmsvc_ops)
+	if (rcu_access_pointer(nlmsvc_ops))
 		nlmsvc_invalidate_all();
 	nlm_shutdown_hosts();
 	cancel_delayed_work_sync(&ln->grace_period_end);
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 28ba7b1460aa4..bb5653f4bf2e3 100644
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
index 1a44597636441..bf1c22028cf04 100644
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
index bba701e1a6089..fa72f1aef464e 100644
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
index b02886f38925f..35b2a0541dc44 100644
--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -79,6 +79,7 @@ nlm_fclose(struct file *filp)
 }
 
 static const struct nlmsvc_binding nfsd_nlm_ops = {
+	.owner		= THIS_MODULE,
 	.fopen		= nlm_fopen,		/* open file for locking */
 	.fclose		= nlm_fclose,		/* close file */
 };
@@ -87,11 +88,12 @@ void
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
index 3bc9f7410e213..2fef35577f019 100644
--- a/include/linux/lockd/bind.h
+++ b/include/linux/lockd/bind.h
@@ -20,11 +20,17 @@
 /* Dummy declarations */
 struct svc_rqst;
 struct rpc_task;
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
@@ -32,7 +38,7 @@ struct nlmsvc_binding {
 	void			(*fclose)(struct file *);
 };
 
-extern const struct nlmsvc_binding *nlmsvc_ops;
+extern const struct nlmsvc_binding __rcu *nlmsvc_ops;
 
 /*
  * Similar to nfs_client_initdata, but without the NFS-specific
-- 
2.53.0



