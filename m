Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BA23208;
	Fri, 17 Oct 2025 15:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714828; cv=none; b=suMZU/NDUEIZqfqO+MRRG3dZUvj8Xl9m+R3iBVHua1fNhQ3MvjS984pQrBomDVOlI5k5YIrOETRSelQ8+cNmOOIqNcFj0IRTyaNjeS5auc9NapAzVkeubnwviNqRufY8O1JGoN+UaLU7eOs7fBJzAxZSElNyKgvlc735eomXdYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714828; c=relaxed/simple;
	bh=Y347/JGdeW8yFuxpZy4b+uMOfsBKE3/xPfka3EjAgcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNejQHSE627NWpL+Hr1NJfvOh+f5XjU4I6/1ZQrqcfuluSsVrNMI9RFYpkuwGwoxJ+CLPLnRulz/0vFBjzjWIC9qOlIXksBRrnuJgSIis8PtrY09lrjiYz3hV2TPyIlInSPNBekdId0Yw8lGi49vbqsreLQTenX296Y4KSjiDKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR9Decud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR9Decud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE322C4CEE7;
	Fri, 17 Oct 2025 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714825;
	bh=Y347/JGdeW8yFuxpZy4b+uMOfsBKE3/xPfka3EjAgcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR9DecudJqQBV2sMhkWHhlkRxpFSPfW8O5Qr9VyjSXbacSJDLRAvtT8aRnXrzmm9b
	 ZI862fo7P0HSgm44IO1oy//B/Qjh8ECACJC+nyayVxavninB/kH3EhmEwUAC/TUY/A
	 oVIXA1o+ReX2ckztDOM02wNfB3rbuJ+PaPRxB5TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 246/277] nfsd: dont use sv_nrthreads in connection limiting calculations.
Date: Fri, 17 Oct 2025 16:54:13 +0200
Message-ID: <20251017145156.130086673@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit eccbbc7c00a5aae5e704d4002adfaf4c3fa4b30d ]

The heuristic for limiting the number of incoming connections to nfsd
currently uses sv_nrthreads - allowing more connections if more threads
were configured.

A future patch will allow number of threads to grow dynamically so that
there will be no need to configure sv_nrthreads.  So we need a different
solution for limiting connections.

It isn't clear what problem is solved by limiting connections (as
mentioned in a code comment) but the most likely problem is a connection
storm - many connections that are not doing productive work.  These will
be closed after about 6 minutes already but it might help to slow down a
storm.

This patch adds a per-connection flag XPT_PEER_VALID which indicates
that the peer has presented a filehandle for which it has some sort of
access.  i.e the peer is known to be trusted in some way.  We now only
count connections which have NOT been determined to be valid.  There
should be relative few of these at any given time.

If the number of non-validated peer exceed a limit - currently 64 - we
close the oldest non-validated peer to avoid having too many of these
useless connections.

Note that this patch significantly changes the meaning of the various
configuration parameters for "max connections".  The next patch will
remove all of these.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 898374fdd7f0 ("nfsd: unregister with rpcbind when deleting a transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/callback.c               |    4 ----
 fs/nfs/callback_xdr.c           |    1 +
 fs/nfsd/netns.h                 |    4 ++--
 fs/nfsd/nfsfh.c                 |    2 ++
 include/linux/sunrpc/svc.h      |    2 +-
 include/linux/sunrpc/svc_xprt.h |   16 ++++++++++++++++
 net/sunrpc/svc_xprt.c           |   32 ++++++++++++++++----------------
 7 files changed, 38 insertions(+), 23 deletions(-)

--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -211,10 +211,6 @@ static struct svc_serv *nfs_callback_cre
 		return ERR_PTR(-ENOMEM);
 	}
 	cb_info->serv = serv;
-	/* As there is only one thread we need to over-ride the
-	 * default maximum of 80 connections
-	 */
-	serv->sv_maxconn = 1024;
 	dprintk("nfs_callback_create_svc: service created\n");
 	return serv;
 }
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -984,6 +984,7 @@ static __be32 nfs4_callback_compound(str
 			nfs_put_client(cps.clp);
 			goto out_invalidcred;
 		}
+		svc_xprt_set_valid(rqstp->rq_xprt);
 	}
 
 	cps.minorversion = hdr_arg.minorversion;
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -129,8 +129,8 @@ struct nfsd_net {
 	unsigned char writeverf[8];
 
 	/*
-	 * Max number of connections this nfsd container will allow. Defaults
-	 * to '0' which is means that it bases this on the number of threads.
+	 * Max number of non-validated connections this nfsd container
+	 * will allow.  Defaults to '0' gets mapped to 64.
 	 */
 	unsigned int max_connections;
 
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -382,6 +382,8 @@ __fh_verify(struct svc_rqst *rqstp,
 	if (error)
 		goto out;
 
+	svc_xprt_set_valid(rqstp->rq_xprt);
+
 	/* Finally, check access permissions. */
 	error = nfsd_permission(cred, exp, dentry, access);
 out:
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -81,7 +81,7 @@ struct svc_serv {
 	unsigned int		sv_xdrsize;	/* XDR buffer size */
 	struct list_head	sv_permsocks;	/* all permanent sockets */
 	struct list_head	sv_tempsocks;	/* all temporary sockets */
-	int			sv_tmpcnt;	/* count of temporary sockets */
+	int			sv_tmpcnt;	/* count of temporary "valid" sockets */
 	struct timer_list	sv_temptimer;	/* timer for aging temporary sockets */
 
 	char *			sv_name;	/* service name */
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -99,8 +99,24 @@ enum {
 	XPT_HANDSHAKE,		/* xprt requests a handshake */
 	XPT_TLS_SESSION,	/* transport-layer security established */
 	XPT_PEER_AUTH,		/* peer has been authenticated */
+	XPT_PEER_VALID,		/* peer has presented a filehandle that
+				 * it has access to.  It is NOT counted
+				 * in ->sv_tmpcnt.
+				 */
 };
 
+static inline void svc_xprt_set_valid(struct svc_xprt *xpt)
+{
+	if (test_bit(XPT_TEMP, &xpt->xpt_flags) &&
+	    !test_and_set_bit(XPT_PEER_VALID, &xpt->xpt_flags)) {
+		struct svc_serv *serv = xpt->xpt_server;
+
+		spin_lock(&serv->sv_lock);
+		serv->sv_tmpcnt -= 1;
+		spin_unlock(&serv->sv_lock);
+	}
+}
+
 static inline void unregister_xpt_user(struct svc_xprt *xpt, struct svc_xpt_user *u)
 {
 	spin_lock(&xpt->xpt_lock);
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -606,7 +606,8 @@ int svc_port_is_privileged(struct sockad
 }
 
 /*
- * Make sure that we don't have too many active connections. If we have,
+ * Make sure that we don't have too many connections that have not yet
+ * demonstrated that they have access to the NFS server. If we have,
  * something must be dropped. It's not clear what will happen if we allow
  * "too many" connections, but when dealing with network-facing software,
  * we have to code defensively. Here we do that by imposing hard limits.
@@ -625,27 +626,25 @@ int svc_port_is_privileged(struct sockad
  */
 static void svc_check_conn_limits(struct svc_serv *serv)
 {
-	unsigned int limit = serv->sv_maxconn ? serv->sv_maxconn :
-				(serv->sv_nrthreads+3) * 20;
+	unsigned int limit = serv->sv_maxconn ? serv->sv_maxconn : 64;
 
 	if (serv->sv_tmpcnt > limit) {
-		struct svc_xprt *xprt = NULL;
+		struct svc_xprt *xprt = NULL, *xprti;
 		spin_lock_bh(&serv->sv_lock);
 		if (!list_empty(&serv->sv_tempsocks)) {
-			/* Try to help the admin */
-			net_notice_ratelimited("%s: too many open connections, consider increasing the %s\n",
-					       serv->sv_name, serv->sv_maxconn ?
-					       "max number of connections" :
-					       "number of threads");
 			/*
 			 * Always select the oldest connection. It's not fair,
-			 * but so is life
+			 * but nor is life.
 			 */
-			xprt = list_entry(serv->sv_tempsocks.prev,
-					  struct svc_xprt,
-					  xpt_list);
-			set_bit(XPT_CLOSE, &xprt->xpt_flags);
-			svc_xprt_get(xprt);
+			list_for_each_entry_reverse(xprti, &serv->sv_tempsocks,
+						    xpt_list) {
+				if (!test_bit(XPT_PEER_VALID, &xprti->xpt_flags)) {
+					xprt = xprti;
+					set_bit(XPT_CLOSE, &xprt->xpt_flags);
+					svc_xprt_get(xprt);
+					break;
+				}
+			}
 		}
 		spin_unlock_bh(&serv->sv_lock);
 
@@ -1039,7 +1038,8 @@ static void svc_delete_xprt(struct svc_x
 
 	spin_lock_bh(&serv->sv_lock);
 	list_del_init(&xprt->xpt_list);
-	if (test_bit(XPT_TEMP, &xprt->xpt_flags))
+	if (test_bit(XPT_TEMP, &xprt->xpt_flags) &&
+	    !test_bit(XPT_PEER_VALID, &xprt->xpt_flags))
 		serv->sv_tmpcnt--;
 	spin_unlock_bh(&serv->sv_lock);
 


