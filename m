Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8A67F7FE;
	Mon,  8 Apr 2024 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584862; cv=none; b=Hgs1fvATeCNQ//SyJ+J7/noLlIncdwl/b7yGE4Qb8mWnDQdGZTDqwo93Hu13PTD5dF4aPNyxOYJlrvdph18fdhg9eW8E6LCTbsTQEIAvAkRhKj+hKJp2oO7MWPoJ4oIU3YLiK0BIE/gfnsOOLeG5y1E8Dz0J+8ikZ5gKT5LHTM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584862; c=relaxed/simple;
	bh=1qO7FjhlmI0/qI5p/w69t3y8/hHHw4u0uqOrjx2VjrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cosdyFBqhyiR4ERv39KRYSse4nDyuOxYpQ6hcawPo8SUork6okcI1crPM+N0YnnYFa3oR2oFVXzn3ld8dJDDUFUz6ocMFFKokZxqhi9/AClV88N4NfRIY4qvd7ww0ppYnn9t6dtcymfJLeOPgOmzWtd0eq1bz7CaZGlrvdLbtdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8LlJ/am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8LlJ/am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BFAC43399;
	Mon,  8 Apr 2024 14:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584862;
	bh=1qO7FjhlmI0/qI5p/w69t3y8/hHHw4u0uqOrjx2VjrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8LlJ/amXDb2USCbaHpLq1kco6+NlAXV6aqQCRWUULfquBuAFO7ma52gySNOm/7sK
	 aNml44mYx3RlYuwwVI8UYMedycuzXbL2rgRIhGSw3pNiUBDjDIzbP87rNRjMlMxCFo
	 dd3Xm3IEV4ynKN/5MKTKOZJ2bZfoejKwm0dSz6ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Jeffrey Layton <jlayton@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 552/690] nfsd: drop the nfsd_put helper
Date: Mon,  8 Apr 2024 14:56:58 +0200
Message-ID: <20240408125419.622704589@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 64e6304169f1e1f078e7f0798033f80a7fb0ea46 ]

It's not safe to call nfsd_put once nfsd_last_thread has been called, as
that function will zero out the nn->nfsd_serv pointer.

Drop the nfsd_put helper altogether and open-code the svc_put in its
callers instead. That allows us to not be reliant on the value of that
pointer when handling an error.

Fixes: 2a501f55cd64 ("nfsd: call nfsd_last_thread() before final nfsd_put()")
Reported-by: Zhi Li <yieli@redhat.com>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Jeffrey Layton <jlayton@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c | 31 +++++++++++++++++--------------
 fs/nfsd/nfsd.h   |  7 -------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index eec442edb6556..f77f00c931723 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -709,6 +709,7 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 	char *mesg = buf;
 	int fd, err;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	err = get_int(&mesg, &fd);
 	if (err != 0 || fd < 0)
@@ -718,15 +719,15 @@ static ssize_t __write_ports_addfd(char *buf, struct net *net, const struct cred
 	if (err != 0)
 		return err;
 
-	err = svc_addsock(nn->nfsd_serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
+	serv = nn->nfsd_serv;
+	err = svc_addsock(serv, net, fd, buf, SIMPLE_TRANSACTION_LIMIT, cred);
 
-	if (err < 0 && !nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
+	if (err < 0 && !serv->sv_nrthreads && !nn->keep_active)
 		nfsd_last_thread(net);
-	else if (err >= 0 &&
-		 !nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
-		svc_get(nn->nfsd_serv);
+	else if (err >= 0 && !serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+		svc_get(serv);
 
-	nfsd_put(net);
+	svc_put(serv);
 	return err;
 }
 
@@ -740,6 +741,7 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 	struct svc_xprt *xprt;
 	int port, err;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	if (sscanf(buf, "%15s %5u", transport, &port) != 2)
 		return -EINVAL;
@@ -751,32 +753,33 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 	if (err != 0)
 		return err;
 
-	err = svc_xprt_create(nn->nfsd_serv, transport, net,
+	serv = nn->nfsd_serv;
+	err = svc_xprt_create(serv, transport, net,
 			      PF_INET, port, SVC_SOCK_ANONYMOUS, cred);
 	if (err < 0)
 		goto out_err;
 
-	err = svc_xprt_create(nn->nfsd_serv, transport, net,
+	err = svc_xprt_create(serv, transport, net,
 			      PF_INET6, port, SVC_SOCK_ANONYMOUS, cred);
 	if (err < 0 && err != -EAFNOSUPPORT)
 		goto out_close;
 
-	if (!nn->nfsd_serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
-		svc_get(nn->nfsd_serv);
+	if (!serv->sv_nrthreads && !xchg(&nn->keep_active, 1))
+		svc_get(serv);
 
-	nfsd_put(net);
+	svc_put(serv);
 	return 0;
 out_close:
-	xprt = svc_find_xprt(nn->nfsd_serv, transport, net, PF_INET, port);
+	xprt = svc_find_xprt(serv, transport, net, PF_INET, port);
 	if (xprt != NULL) {
 		svc_xprt_close(xprt);
 		svc_xprt_put(xprt);
 	}
 out_err:
-	if (!nn->nfsd_serv->sv_nrthreads && !nn->keep_active)
+	if (!serv->sv_nrthreads && !nn->keep_active)
 		nfsd_last_thread(net);
 
-	nfsd_put(net);
+	svc_put(serv);
 	return err;
 }
 
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 3796015dc7656..013bfa24ced21 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -96,13 +96,6 @@ int		nfsd_pool_stats_open(struct inode *, struct file *);
 int		nfsd_pool_stats_release(struct inode *, struct file *);
 void		nfsd_shutdown_threads(struct net *net);
 
-static inline void nfsd_put(struct net *net)
-{
-	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
-
-	svc_put(nn->nfsd_serv);
-}
-
 bool		i_am_nfsd(void);
 
 struct nfsdfs_client {
-- 
2.43.0



