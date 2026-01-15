Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E432A3D3337;
	Thu, 15 Jan 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499904; cv=none; b=UCkKJOBArWMzuhd22q2hNWtIgmqRRea8qwDl06V4jpjQ7LLG1Gk1fYytkoL6lfmOUDSEqJjkeFGvIUpc4dIDjJqqe+u3Uc/Iq2AgkG0KM1owJ4pwY/qXjIMEp/DVAYjmqpGqyptMxewtyUtj2FEnN8NvWtkEloKIv0WzwnhAwrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499904; c=relaxed/simple;
	bh=hkCjF1Y7fAay2k4IZ2G3npKLmeZ8CBXZg8j7l0qnjtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hENIvTWdEpkY7az3Vx9iSw5iuRwK2x2XahC7n5QJTAJV8+RxuElZgbqmKUkLw5BEvAUJqNo8z4H/CAsYwRTlUkLxtANDrYKrF8KUx2BbEg+m90VpODOASmhVQzNRJVCXs9HMoumVXhwdB7mP6lAlMJYiphVOa6eHSsaaeBqXrkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXcLel8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXcLel8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5C6C116D0;
	Thu, 15 Jan 2026 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499903;
	bh=hkCjF1Y7fAay2k4IZ2G3npKLmeZ8CBXZg8j7l0qnjtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXcLel8A3ObVd8GISh1FtLyMGgKl4lE9BMfUJDQwFH/lWOSqklVbtoq658vGJObgS
	 ur+b5ClSxkYORMQCbXl8CLL/pWTT5cblgT/AjlOOK4h+HtagzwAUcc/GLhXdcMOr+z
	 mO9lP8gTxc++fbMhKNbCviWom8XVtTTTltmKopSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 390/451] lockd: fix vfs_test_lock() calls
Date: Thu, 15 Jan 2026 17:49:51 +0100
Message-ID: <20260115164245.039670056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

[ Upstream commit a49a2a1baa0c553c3548a1c414b6a3c005a8deba ]

Usage of vfs_test_lock() is somewhat confused.  Documentation suggests
it is given a "lock" but this is not the case.  It is given a struct
file_lock which contains some details of the sort of lock it should be
looking for.

In particular passing a "file_lock" containing fl_lmops or fl_ops is
meaningless and possibly confusing.

This is particularly problematic in lockd.  nlmsvc_testlock() receives
an initialised "file_lock" from xdr-decode, including manager ops and an
owner.  It then mistakenly passes this to vfs_test_lock() which might
replace the owner and the ops.  This can lead to confusion when freeing
the lock.

The primary role of the 'struct file_lock' passed to vfs_test_lock() is
to report a conflicting lock that was found, so it makes more sense for
nlmsvc_testlock() to pass "conflock", which it uses for returning the
conflicting lock.

With this change, freeing of the lock is not confused and code in
__nlm4svc_proc_test() and __nlmsvc_proc_test() can be simplified.

Documentation for vfs_test_lock() is improved to reflect its real
purpose, and a WARN_ON_ONCE() is added to avoid a similar problem in the
future.

Reported-by: Olga Kornievskaia <okorniev@redhat.com>
Closes: https://lore.kernel.org/all/20251021130506.45065-1-okorniev@redhat.com
Signed-off-by: NeilBrown <neil@brown.name>
Fixes: 20fa19027286 ("nfs: add export operations")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ adapted c.flc_* field accesses to direct fl_* fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svc4proc.c |    4 +---
 fs/lockd/svclock.c  |   21 ++++++++++++---------
 fs/lockd/svcproc.c  |    5 +----
 fs/locks.c          |   13 +++++++++++--
 4 files changed, 25 insertions(+), 18 deletions(-)

--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -96,7 +96,6 @@ __nlm4svc_proc_test(struct svc_rqst *rqs
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	struct nlm_lockowner *test_owner;
 	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST4        called\n");
@@ -106,7 +105,6 @@ __nlm4svc_proc_test(struct svc_rqst *rqs
 	if ((resp->status = nlm4svc_retrieve_args(rqstp, argp, &host, &file)))
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
-	test_owner = argp->lock.fl.fl_owner;
 	/* Now check for conflicting locks */
 	resp->status = nlmsvc_testlock(rqstp, file, host, &argp->lock, &resp->lock, &resp->cookie);
 	if (resp->status == nlm_drop_reply)
@@ -114,7 +112,7 @@ __nlm4svc_proc_test(struct svc_rqst *rqs
 	else
 		dprintk("lockd: TEST4        status %d\n", ntohl(resp->status));
 
-	nlmsvc_put_lockowner(test_owner);
+	nlmsvc_release_lockowner(&argp->lock);
 	nlmsvc_release_host(host);
 	nlm_release_file(file);
 	return rc;
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -604,7 +604,13 @@ nlmsvc_testlock(struct svc_rqst *rqstp,
 	}
 
 	mode = lock_to_openmode(&lock->fl);
-	error = vfs_test_lock(file->f_file[mode], &lock->fl);
+	locks_init_lock(&conflock->fl);
+	/* vfs_test_lock only uses start, end, and owner, but tests fl_file */
+	conflock->fl.fl_file = lock->fl.fl_file;
+	conflock->fl.fl_start = lock->fl.fl_start;
+	conflock->fl.fl_end = lock->fl.fl_end;
+	conflock->fl.fl_owner = lock->fl.fl_owner;
+	error = vfs_test_lock(file->f_file[mode], &conflock->fl);
 	if (error) {
 		/* We can't currently deal with deferred test requests */
 		if (error == FILE_LOCK_DEFERRED)
@@ -614,22 +620,19 @@ nlmsvc_testlock(struct svc_rqst *rqstp,
 		goto out;
 	}
 
-	if (lock->fl.fl_type == F_UNLCK) {
+	if (conflock->fl.fl_type == F_UNLCK) {
 		ret = nlm_granted;
 		goto out;
 	}
 
 	dprintk("lockd: conflicting lock(ty=%d, %Ld-%Ld)\n",
-		lock->fl.fl_type, (long long)lock->fl.fl_start,
-		(long long)lock->fl.fl_end);
+		conflock->fl.fl_type, (long long)conflock->fl.fl_start,
+		(long long)conflock->fl.fl_end);
 	conflock->caller = "somehost";	/* FIXME */
 	conflock->len = strlen(conflock->caller);
 	conflock->oh.len = 0;		/* don't return OH info */
-	conflock->svid = lock->fl.fl_pid;
-	conflock->fl.fl_type = lock->fl.fl_type;
-	conflock->fl.fl_start = lock->fl.fl_start;
-	conflock->fl.fl_end = lock->fl.fl_end;
-	locks_release_private(&lock->fl);
+	conflock->svid = conflock->fl.fl_pid;
+	locks_release_private(&conflock->fl);
 
 	ret = nlm_lck_denied;
 out:
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -117,7 +117,6 @@ __nlmsvc_proc_test(struct svc_rqst *rqst
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	struct nlm_lockowner *test_owner;
 	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST          called\n");
@@ -127,8 +126,6 @@ __nlmsvc_proc_test(struct svc_rqst *rqst
 	if ((resp->status = nlmsvc_retrieve_args(rqstp, argp, &host, &file)))
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
-	test_owner = argp->lock.fl.fl_owner;
-
 	/* Now check for conflicting locks */
 	resp->status = cast_status(nlmsvc_testlock(rqstp, file, host, &argp->lock, &resp->lock, &resp->cookie));
 	if (resp->status == nlm_drop_reply)
@@ -137,7 +134,7 @@ __nlmsvc_proc_test(struct svc_rqst *rqst
 		dprintk("lockd: TEST          status %d vers %d\n",
 			ntohl(resp->status), rqstp->rq_vers);
 
-	nlmsvc_put_lockowner(test_owner);
+	nlmsvc_release_lockowner(&argp->lock);
 	nlmsvc_release_host(host);
 	nlm_release_file(file);
 	return rc;
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2325,13 +2325,22 @@ SYSCALL_DEFINE2(flock, unsigned int, fd,
 /**
  * vfs_test_lock - test file byte range lock
  * @filp: The file to test lock for
- * @fl: The lock to test; also used to hold result
+ * @fl: The byte-range in the file to test; also used to hold result
  *
+ * On entry, @fl does not contain a lock, but identifies a range (fl_start, fl_end)
+ * in the file (c.flc_file), and an owner (c.flc_owner) for whom existing locks
+ * should be ignored.  c.flc_type and c.flc_flags are ignored.
+ * Both fl_lmops and fl_ops in @fl must be NULL.
  * Returns -ERRNO on failure.  Indicates presence of conflicting lock by
- * setting conf->fl_type to something other than F_UNLCK.
+ * setting fl->fl_type to something other than F_UNLCK.
+ *
+ * If vfs_test_lock() does find a lock and return it, the caller must
+ * use locks_free_lock() or locks_release_private() on the returned lock.
  */
 int vfs_test_lock(struct file *filp, struct file_lock *fl)
 {
+	WARN_ON_ONCE(fl->fl_ops || fl->fl_lmops);
+	WARN_ON_ONCE(filp != fl->fl_file);
 	if (filp->f_op->lock)
 		return filp->f_op->lock(filp, F_GETLK, fl);
 	posix_test_lock(filp, fl);


