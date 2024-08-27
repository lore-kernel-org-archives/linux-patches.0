Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DF41C68A6;
	Tue, 27 Aug 2024 15:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772697; cv=none; b=TfybOeWZLmSmNTMBDm1lglGt+Q2NmEQRNQziXmCVt/+1UMIJgfKDmcU5eXVjf05hkkYkvXBzBYUqEPm2/lZU6dnsOPLzECh2poFTJx4lfsUkDCHdjvUoNkxdN6QHW88RyypTslBkLwsBDG9UtDDgOWpjRtI2sKoVvuNKI8QjKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772697; c=relaxed/simple;
	bh=LIVDikt6JIbMst/xFQBoAGJRjwRO1NeoGT9WDGoF0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CexH9H886sLJb7RQOy4D8G10dtRcJ+/mRaIJdrSVOdGv5yTj5IU2nHIdt6BkAEVVCHKy8d7pAAERuGmBg3z1OYhjDw1EpzPmwiNvCQc0VvHIkDvPGHSJcj3hsGXmwFKf84/T5ID7MjybjekhVSLX+TM13HET5LKsqz+sZc4CFgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxeLheUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxeLheUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF69C4DDF1;
	Tue, 27 Aug 2024 15:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772697;
	bh=LIVDikt6JIbMst/xFQBoAGJRjwRO1NeoGT9WDGoF0AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxeLheUSEkBtCC447bKsEubQRD4LQB0uLFK/1LDNqTxxhd8EbXRtuBSN4nfKcceNy
	 60L07J81lnm7rcuWo845Tm8SaHNMdTq0sACPTQz4N2VdW6gbT7dXc7rsZfun8N/Z3/
	 Q1rYDh3fgq17OYUPKg0KQAH09skT7Rqz3/qvDz5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Jeffrey Layton <jlayton@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 292/321] nfsd: drop the nfsd_put helper
Date: Tue, 27 Aug 2024 16:40:00 +0200
Message-ID: <20240827143849.368691965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   31 +++++++++++++++++--------------
 fs/nfsd/nfsd.h   |    7 -------
 2 files changed, 17 insertions(+), 21 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -709,6 +709,7 @@ static ssize_t __write_ports_addfd(char
 	char *mesg = buf;
 	int fd, err;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	err = get_int(&mesg, &fd);
 	if (err != 0 || fd < 0)
@@ -718,15 +719,15 @@ static ssize_t __write_ports_addfd(char
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
 
@@ -740,6 +741,7 @@ static ssize_t __write_ports_addxprt(cha
 	struct svc_xprt *xprt;
 	int port, err;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
+	struct svc_serv *serv;
 
 	if (sscanf(buf, "%15s %5u", transport, &port) != 2)
 		return -EINVAL;
@@ -751,32 +753,33 @@ static ssize_t __write_ports_addxprt(cha
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
 
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -97,13 +97,6 @@ int		nfsd_pool_stats_open(struct inode *
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


