Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFC61AD3E4;
	Tue, 18 Jun 2024 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716795; cv=none; b=NQxoTgKGwBtVHc1nfl16OcrUWRRoeEOg9PJ8H+k2ySHX6YEzaGUq1sDO3T9n54G6uyu3ikKYbn6QVMPNru8eRysb9LgHOAcKlXBRXOzvsWK89cklsU034XXPcIfdwPhdaRRYLIP3HKE1eMCeZtGm0zRxNEUaPEs3LveYi6MP+TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716795; c=relaxed/simple;
	bh=dRMkyPaMfPY9OnzXS7Z14gpdzjWiIhLfFFLOuhFO6kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qp8XckhpHkymZsD67jNMZ+W9IlhdbDmlgPUT4HItBUyGvfiNROHwEXtVyIkZCty2Ts4prSV1ofk3blUWdjVAejB/SH455/gGPnQcHJkx7pyI8lcV0vJiMpST/6mRf8HchzpJuwZRvV4AjKybpw2Rumr6Gvx1umhpVEIzy5HXZqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBfmm2Iu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBfmm2Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D00C32786;
	Tue, 18 Jun 2024 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716795;
	bh=dRMkyPaMfPY9OnzXS7Z14gpdzjWiIhLfFFLOuhFO6kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBfmm2Iuh5duTpEwBpq1XQbNo0ox4dPE25AtbLjzMtzkOTn5CR4aznIV/1hsmAlte
	 M96zdl4O7VuAFmlCZHpbfInYCf1x7j8s5d+pnzCTelB/2rtKK/KkDQXCu+tJQZoTO3
	 dymNWg/+pUmx+syj/EzUyyTM448gCx36ph6CaPnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Li <yieli@redhat.com>,
	NeilBrown <neilb@suse.de>,
	Jeffrey Layton <jlayton@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 766/770] nfsd: drop the nfsd_put helper
Date: Tue, 18 Jun 2024 14:40:19 +0200
Message-ID: <20240618123436.839648694@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



