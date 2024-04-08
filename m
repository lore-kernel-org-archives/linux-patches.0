Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25A27C08C;
	Mon,  8 Apr 2024 13:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584147; cv=none; b=OvGKr5Fi3/IHhd7cjX8wYpboQsmdoHvUKZyAKsoyRhICUrPPk+ZNLqD0HNHrYuTJ6xM9eZseKxCDX9o2OyYIlWnhBBH1N+YcR0y3ybms6n/3Ok7Tqz2QfqvE2qk1JWgq5MFZ9uthKGl5f8X1LqKlu+2C5DSkA39SLzib95tDFI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584147; c=relaxed/simple;
	bh=nRTFhvtz8pChsze8NEQYa2j1K2Is96EedcmqYSKYv4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT+QFef95+UiGRpy0TugdeJeohpjaud8eKwgP2Z+SGIX6InnhCptI4M55dnsf5EIyPJ1pEyMem0xDypEU25cqIQH4++N2JFjucs8fDrRP1mK0cOlwkC5hGN7KYulbWZamsukZm+3nLJFHZvHrLh+LHkyh6PiHtamugLHLNsJCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPV22Lr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPV22Lr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6BDC433F1;
	Mon,  8 Apr 2024 13:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584147;
	bh=nRTFhvtz8pChsze8NEQYa2j1K2Is96EedcmqYSKYv4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPV22Lr/YqEAxg0S4rDH4WbFXDCauHpA1ivTlhaikyzM6d3wC2Ld32HwFS3uz2A/9
	 GAWiZtMmwpKK/Q3w35GYgUopT3z8JPwQQmBSL/vNvM/zkqD7keE4ZfIt0rRI53GrE+
	 iamhR3wvADyhoKFfgy/h8aa7mx/Y+yMq0Dh9T2WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 341/690] NLM: Defend against file_lock changes after vfs_test_lock()
Date: Mon,  8 Apr 2024 14:53:27 +0200
Message-ID: <20240408125411.974031570@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 184cefbe62627730c30282df12bcff9aae4816ea ]

Instead of trusting that struct file_lock returns completely unchanged
after vfs_test_lock() when there's no conflicting lock, stash away our
nlm_lockowner reference so we can properly release it for all cases.

This defends against another file_lock implementation overwriting fl_owner
when the return type is F_UNLCK.

Reported-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Tested-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc4proc.c         |  4 +++-
 fs/lockd/svclock.c          | 10 +---------
 fs/lockd/svcproc.c          |  5 ++++-
 include/linux/lockd/lockd.h |  1 +
 4 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 1c9214801e69e..930e90f21b151 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -95,6 +95,7 @@ __nlm4svc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_host	*host;
 	struct nlm_file	*file;
+	struct nlm_lockowner *test_owner;
 	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST4        called\n");
@@ -104,6 +105,7 @@ __nlm4svc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 	if ((resp->status = nlm4svc_retrieve_args(rqstp, argp, &host, &file)))
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
+	test_owner = argp->lock.fl.fl_owner;
 	/* Now check for conflicting locks */
 	resp->status = nlmsvc_testlock(rqstp, file, host, &argp->lock, &resp->lock, &resp->cookie);
 	if (resp->status == nlm_drop_reply)
@@ -111,7 +113,7 @@ __nlm4svc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 	else
 		dprintk("lockd: TEST4        status %d\n", ntohl(resp->status));
 
-	nlmsvc_release_lockowner(&argp->lock);
+	nlmsvc_put_lockowner(test_owner);
 	nlmsvc_release_host(host);
 	nlm_release_file(file);
 	return rc;
diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index cb3658ab9b7ae..9c1aa75441e1c 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -340,7 +340,7 @@ nlmsvc_get_lockowner(struct nlm_lockowner *lockowner)
 	return lockowner;
 }
 
-static void nlmsvc_put_lockowner(struct nlm_lockowner *lockowner)
+void nlmsvc_put_lockowner(struct nlm_lockowner *lockowner)
 {
 	if (!refcount_dec_and_lock(&lockowner->count, &lockowner->host->h_lock))
 		return;
@@ -590,7 +590,6 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	int			error;
 	int			mode;
 	__be32			ret;
-	struct nlm_lockowner	*test_owner;
 
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
 				nlmsvc_file_inode(file)->i_sb->s_id,
@@ -604,9 +603,6 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 		goto out;
 	}
 
-	/* If there's a conflicting lock, remember to clean up the test lock */
-	test_owner = (struct nlm_lockowner *)lock->fl.fl_owner;
-
 	mode = lock_to_openmode(&lock->fl);
 	error = vfs_test_lock(file->f_file[mode], &lock->fl);
 	if (error) {
@@ -635,10 +631,6 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	conflock->fl.fl_end = lock->fl.fl_end;
 	locks_release_private(&lock->fl);
 
-	/* Clean up the test lock */
-	lock->fl.fl_owner = NULL;
-	nlmsvc_put_lockowner(test_owner);
-
 	ret = nlm_lck_denied;
 out:
 	return ret;
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 99696d3f6dd66..c215a4599d5c8 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -116,6 +116,7 @@ __nlmsvc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 	struct nlm_args *argp = rqstp->rq_argp;
 	struct nlm_host	*host;
 	struct nlm_file	*file;
+	struct nlm_lockowner *test_owner;
 	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST          called\n");
@@ -125,6 +126,8 @@ __nlmsvc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 	if ((resp->status = nlmsvc_retrieve_args(rqstp, argp, &host, &file)))
 		return resp->status == nlm_drop_reply ? rpc_drop_reply :rpc_success;
 
+	test_owner = argp->lock.fl.fl_owner;
+
 	/* Now check for conflicting locks */
 	resp->status = cast_status(nlmsvc_testlock(rqstp, file, host, &argp->lock, &resp->lock, &resp->cookie));
 	if (resp->status == nlm_drop_reply)
@@ -133,7 +136,7 @@ __nlmsvc_proc_test(struct svc_rqst *rqstp, struct nlm_res *resp)
 		dprintk("lockd: TEST          status %d vers %d\n",
 			ntohl(resp->status), rqstp->rq_vers);
 
-	nlmsvc_release_lockowner(&argp->lock);
+	nlmsvc_put_lockowner(test_owner);
 	nlmsvc_release_host(host);
 	nlm_release_file(file);
 	return rc;
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index fcef192e5e45e..70ce419e27093 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -292,6 +292,7 @@ void		  nlmsvc_locks_init_private(struct file_lock *, struct nlm_host *, pid_t);
 __be32		  nlm_lookup_file(struct svc_rqst *, struct nlm_file **,
 					struct nlm_lock *);
 void		  nlm_release_file(struct nlm_file *);
+void		  nlmsvc_put_lockowner(struct nlm_lockowner *);
 void		  nlmsvc_release_lockowner(struct nlm_lock *);
 void		  nlmsvc_mark_resources(struct net *);
 void		  nlmsvc_free_host_resources(struct nlm_host *);
-- 
2.43.0



