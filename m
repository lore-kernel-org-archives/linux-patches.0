Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E80B433E87;
	Thu,  2 Jul 2026 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011282; cv=none; b=UtcUvEr2cBusj2bMg9Hg0lqzgXX/I+UyTyCY8UfWaqRgEDjZ8Cb/kd0GECS3NZO1hvTaQ+sCYmO8jIpW+bXPXta7aAxphN2XJJoj5HiRylKYnhAS/fY8V5ziXvU6JkL3vfvIw6/MijvPb/61+hpdL0I+3QtPuvdU28PdDXFR130=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011282; c=relaxed/simple;
	bh=+7suiI/uf+bQNtLPWyzPUbH9u1rBjElzuBNeT2chkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjPhMVeGo3tpr6qWq6dmIUcbR5Gyfs5hMWSs+ND9wBPykaejmreXmvS/7yO7qZ2b3YvC6n/ZqlKaP+Os/4rD+DwHBpimjV1MEN9WGyA7g+dKIjuq5Fi/Nz2LIbXQK3Z6e9z+NKk61meKS4deCwqrjwD4Jtni76XOYz7Mu3Xbwk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECBN2gfq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECBN2gfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AEA1F000E9;
	Thu,  2 Jul 2026 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011281;
	bh=If+C75Zss9AmZTpiyJPNS6jPBar6/CgjUixjlqA6+Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECBN2gfq11uPsEK39o+jxupI3aazUWjLDTG5Koy562BIzzYy0nLroCSrPAuwsSLR+
	 0QOsEWXTmB4BGwUzXid/qZeHMeNbAmwjQWe+Wvj4m4i/Kt5+aFiTEbp3nAMNLuZZny
	 5mFtl+ggZNaHP4CF4PdJDaC8dPVSYkxdoHauNxuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tj <tj.iam.tj@proton.me>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/108] lockd: fix TEST handling when not all permissions are available.
Date: Thu,  2 Jul 2026 18:20:02 +0200
Message-ID: <20260702155112.225182531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit 0b474240327cebeff08ad429e8ed3cfc6c8ee816 ]

The F_GETLK fcntl can work with either read access or write access or
both.  It can query F_RDLCK and F_WRLCK locks in either case.

However lockd currently treats F_GETLK similar to F_SETLK in that read
access is required to query an F_RDLCK lock and write access is required
to query a F_WRLCK lock.

This is wrong and can cause problems - e.g.  when qemu accesses a
read-only (e.g. iso) filesystem image over NFS (though why it queries
if it can get a write lock - I don't know.  But it does, and this works
with local filesystems).

So we need TEST requests to be handled differently.  To do this:

- change nlm_do_fopen() to accept O_RDWR as a mode and in that case
  succeed if either a O_RDONLY or O_WRONLY file can be opened.
- change nlm_lookup_file() to accept a mode argument from caller,
  instead of deducing base on lock time, and pass that on to nlm_do_fopen()
- change nlm4svc_retrieve_args() and nlmsvc_retrieve_args() to detect
  TEST requests and pass O_RDWR as a mode to nlm_lookup_file, passing
  the same mode as before for other requests.  Also set
   lock->fl.c.flc_file to whichever file is available for TEST requests.
- change nlmsvc_testlock() to also not calculate the mode, but to use
  whatever was stored in lock->fl.c.flc_file.

This behaviour of lockd - requesting O_WRONLY access to TEST for
exclusive locks - has been present at least since git history began.
However it was hidden until recently because knfsd ignored the access
requested by lockd and required only READ access for all locking
requests (unless the underlying filesystem provided an f_op->open
function which checked access permissions).

The commit mentioned in Fixes: below changed nfsd_permission() to NOT
override the access request for LOCK requests and this exposed the bug
that we are now fixing.

Note that there is another issue that this patch does not address.
The flock(.., LOCK_EX) call is permitted on a read-only file descriptor.
Linux NFS maps this to NLM locking as whole-file byte-range locks.
nfsd will see this as though it were fcntl( F_SETLK (F_WRLCK)) and will
now require write access, which it might not be able to get.
It is not clear if this is a problem in practice, or what the best
solution might be.  So no attempt is made to address it.

Reported-by: Tj <tj.iam.tj@proton.me>
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1128861
Fixes: 4cc9b9f2bf4d ("nfsd: refine and rename NFSD_MAY_LOCK")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc4proc.c         | 13 ++++++++++---
 fs/lockd/svclock.c          |  4 +---
 fs/lockd/svcproc.c          | 15 ++++++++++++---
 fs/lockd/svcsubs.c          | 35 +++++++++++++++++++++++++----------
 include/linux/lockd/lockd.h |  2 +-
 5 files changed, 49 insertions(+), 20 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 4b6f18d977343d..75e020a8bfd072 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -26,6 +26,8 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	struct nlm_host		*host = NULL;
 	struct nlm_file		*file = NULL;
 	struct nlm_lock		*lock = &argp->lock;
+	bool			is_test = (rqstp->rq_proc == NLMPROC_TEST ||
+					   rqstp->rq_proc == NLMPROC_TEST_MSG);
 	__be32			error = 0;
 
 	/* nfsd callbacks must have been installed for this procedure */
@@ -46,15 +48,20 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	if (filp != NULL) {
 		int mode = lock_to_openmode(&lock->fl);
 
+		if (is_test)
+			mode = O_RDWR;
+
 		lock->fl.c.flc_flags = FL_POSIX;
 
-		error = nlm_lookup_file(rqstp, &file, lock);
+		error = nlm_lookup_file(rqstp, &file, lock, mode);
 		if (error)
 			goto no_locks;
 		*filp = file;
-
 		/* Set up the missing parts of the file_lock structure */
-		lock->fl.c.flc_file = file->f_file[mode];
+		if (is_test)
+			lock->fl.c.flc_file = nlmsvc_file_file(file);
+		else
+			lock->fl.c.flc_file = file->f_file[mode];
 		lock->fl.c.flc_pid = current->tgid;
 		lock->fl.fl_start = (loff_t)lock->lock_start;
 		lock->fl.fl_end = lock->lock_len ?
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index d66e8285159996..c35ffa1b4b89d4 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -611,7 +611,6 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 		struct nlm_lock *conflock)
 {
 	int			error;
-	int			mode;
 	__be32			ret;
 
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
@@ -626,14 +625,13 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 		goto out;
 	}
 
-	mode = lock_to_openmode(&lock->fl);
 	locks_init_lock(&conflock->fl);
 	/* vfs_test_lock only uses start, end, and owner, but tests flc_file */
 	conflock->fl.c.flc_file = lock->fl.c.flc_file;
 	conflock->fl.fl_start = lock->fl.fl_start;
 	conflock->fl.fl_end = lock->fl.fl_end;
 	conflock->fl.c.flc_owner = lock->fl.c.flc_owner;
-	error = vfs_test_lock(file->f_file[mode], &conflock->fl);
+	error = vfs_test_lock(lock->fl.c.flc_file, &conflock->fl);
 	if (error) {
 		/* We can't currently deal with deferred test requests */
 		if (error == FILE_LOCK_DEFERRED)
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 5817ef272332d9..d98e8d684376b7 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -55,6 +55,8 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 	struct nlm_host		*host = NULL;
 	struct nlm_file		*file = NULL;
 	struct nlm_lock		*lock = &argp->lock;
+	bool			is_test = (rqstp->rq_proc == NLMPROC_TEST ||
+					   rqstp->rq_proc == NLMPROC_TEST_MSG);
 	int			mode;
 	__be32			error = 0;
 
@@ -70,15 +72,22 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		error = cast_status(nlm_lookup_file(rqstp, &file, lock));
+		mode = lock_to_openmode(&lock->fl);
+
+		if (is_test)
+			mode = O_RDWR;
+
+		error = cast_status(nlm_lookup_file(rqstp, &file, lock, mode));
 		if (error != 0)
 			goto no_locks;
 		*filp = file;
 
 		/* Set up the missing parts of the file_lock structure */
-		mode = lock_to_openmode(&lock->fl);
 		lock->fl.c.flc_flags = FL_POSIX;
-		lock->fl.c.flc_file  = file->f_file[mode];
+		if (is_test)
+			lock->fl.c.flc_file = nlmsvc_file_file(file);
+		else
+			lock->fl.c.flc_file = file->f_file[mode];
 		lock->fl.c.flc_pid = current->tgid;
 		lock->fl.fl_lmops = &nlmsvc_lock_operations;
 		nlmsvc_locks_init_private(&lock->fl, host, (pid_t)lock->svid);
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 9103896164f688..7ea204eadfcace 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -82,18 +82,35 @@ int lock_to_openmode(struct file_lock *lock)
  *
  * We have to make sure we have the right credential to open
  * the file.
+ *
+ * mode can be O_RDONLY(0), O_WRONLY(1) or O_RDWR(2). The latter
+ * means success can be achieved with EITHER O_RDONLY or O_WRONLY.
+ * It does NOT mean both read and write are required.
  */
 static __be32 nlm_do_fopen(struct svc_rqst *rqstp,
 			   struct nlm_file *file, int mode)
 {
-	struct file **fp = &file->f_file[mode];
-	__be32	nfserr;
+	__be32 nfserr = nlm_lck_denied_nolocks;
+	__be32 deferred = 0;
+	struct file **fp;
+	int m;
 
-	if (*fp)
-		return 0;
-	nfserr = nlmsvc_ops->fopen(rqstp, &file->f_handle, fp, mode);
-	if (nfserr)
-		dprintk("lockd: open failed (error %d)\n", nfserr);
+	for (m = O_RDONLY ; m <= O_WRONLY ; m++) {
+		if (mode != O_RDWR && mode != m)
+			continue;
+
+		fp = &file->f_file[m];
+		if (*fp)
+			return 0;
+		nfserr = nlmsvc_ops->fopen(rqstp, &file->f_handle, fp, m);
+		if (!nfserr)
+			return 0;
+		if (nfserr == nlm_drop_reply)
+			deferred = nfserr;
+	}
+	if (deferred)
+		return deferred;
+	dprintk("lockd: open failed (error %d)\n", ntohl(nfserr));
 	return nfserr;
 }
 
@@ -103,17 +120,15 @@ static __be32 nlm_do_fopen(struct svc_rqst *rqstp,
  */
 __be32
 nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
-					struct nlm_lock *lock)
+		struct nlm_lock *lock, int mode)
 {
 	struct nlm_file	*file;
 	unsigned int	hash;
 	__be32		nfserr;
-	int		mode;
 
 	nlm_debug_print_fh("nlm_lookup_file", &lock->fh);
 
 	hash = file_hash(&lock->fh);
-	mode = lock_to_openmode(&lock->fl);
 
 	/* Lock file table */
 	mutex_lock(&nlm_file_mutex);
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index c8f0f9458f2cc0..d9930fc43ca540 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -293,7 +293,7 @@ void		  nlmsvc_locks_init_private(struct file_lock *, struct nlm_host *, pid_t);
  * File handling for the server personality
  */
 __be32		  nlm_lookup_file(struct svc_rqst *, struct nlm_file **,
-					struct nlm_lock *);
+				  struct nlm_lock *, int);
 void		  nlm_release_file(struct nlm_file *);
 void		  nlmsvc_put_lockowner(struct nlm_lockowner *);
 void		  nlmsvc_release_lockowner(struct nlm_lock *);
-- 
2.53.0



