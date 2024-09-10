Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB68DC8DF;
	Tue, 10 Sep 2024 10:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965069; cv=none; b=uA/zuFb5jVFukXu7PTl2CzDDalQuo7PfB3ZR3ClFLkX04PkSZaRq+1nQUEfiDtM3urDWkZ1JzMMQ4QEKUcxpqG0g8ZFbrVAoZc0otuGhn7ccU1sGIBWSEQ0FIz4dJtXAQVbx/Sn+ETbd2T90lXp3z61v3TCv4DD9zxMEi3WlEYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965069; c=relaxed/simple;
	bh=zCeEfly6CINOh48iJlYgFAiqAJp7f5AShNkbLwiVdSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RofWJ7YwAX9E0cSOC8WmWzdhldKEaCx8CeBMCf5RJdaReyAFt89P3YggGqf0dQx3yq6fLyx6BW0mXozVaLSUY68Rsoug4A8Vm95V058ksrcSS7EVecSiwQR9rMep+HjPnVv/qh8oXSBoEyaCamXV0jkW1U6cO+FQYXhUG8X10+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vhai70s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vhai70s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5A3C4CEC3;
	Tue, 10 Sep 2024 10:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965069;
	bh=zCeEfly6CINOh48iJlYgFAiqAJp7f5AShNkbLwiVdSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vhai70sdF2kNVsn2FIW/KsJChIS2BctxQmbjL/eZRYq3JCoIvgWlUWH8UvQR+vHq
	 B6iZpatcljBrNLXXtot8djQiN0eaqRa1E+HiSxAp9fGml1oY5fCo29e4OL3vsrUHPT
	 f/BTWB5/+zqacIkUP2ahDJpGPTDFOZqomTszjtfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 089/186] sunrpc: pass in the sv_stats struct through svc_create_pooled
Date: Tue, 10 Sep 2024 11:33:04 +0200
Message-ID: <20240910092558.168470500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f094323867668d50124886ad884b665de7319537 ]

Since only one service actually reports the rpc stats there's not much
of a reason to have a pointer to it in the svc_program struct.  Adjust
the svc_create_pooled function to take the sv_stats as an argument and
pass the struct through there as desired instead of getting it from the
svc_program->pg_stats.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c           |    3 ++-
 include/linux/sunrpc/svc.h |    4 +++-
 net/sunrpc/svc.c           |   12 +++++++-----
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -664,7 +664,8 @@ int nfsd_create_serv(struct net *net)
 	if (nfsd_max_blksize == 0)
 		nfsd_max_blksize = nfsd_get_default_max_blksize();
 	nfsd_reset_versions(nn);
-	serv = svc_create_pooled(&nfsd_program, nfsd_max_blksize, nfsd);
+	serv = svc_create_pooled(&nfsd_program, &nfsd_svcstats,
+				 nfsd_max_blksize, nfsd);
 	if (serv == NULL)
 		return -ENOMEM;
 
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -484,7 +484,9 @@ void		   svc_rqst_replace_page(struct sv
 					 struct page *page);
 void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
-struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
+struct svc_serv *  svc_create_pooled(struct svc_program *prog,
+				     struct svc_stat *stats,
+				     unsigned int bufsize,
 				     int (*threadfn)(void *data));
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
 int		   svc_pool_stats_open(struct svc_serv *serv, struct file *file);
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -445,8 +445,8 @@ __svc_init_bc(struct svc_serv *serv)
  * Create an RPC service
  */
 static struct svc_serv *
-__svc_create(struct svc_program *prog, unsigned int bufsize, int npools,
-	     int (*threadfn)(void *data))
+__svc_create(struct svc_program *prog, struct svc_stat *stats,
+	     unsigned int bufsize, int npools, int (*threadfn)(void *data))
 {
 	struct svc_serv	*serv;
 	unsigned int vers;
@@ -458,7 +458,7 @@ __svc_create(struct svc_program *prog, u
 	serv->sv_name      = prog->pg_name;
 	serv->sv_program   = prog;
 	kref_init(&serv->sv_refcnt);
-	serv->sv_stats     = prog->pg_stats;
+	serv->sv_stats     = stats;
 	if (bufsize > RPCSVC_MAXPAYLOAD)
 		bufsize = RPCSVC_MAXPAYLOAD;
 	serv->sv_max_payload = bufsize? bufsize : 4096;
@@ -520,26 +520,28 @@ __svc_create(struct svc_program *prog, u
 struct svc_serv *svc_create(struct svc_program *prog, unsigned int bufsize,
 			    int (*threadfn)(void *data))
 {
-	return __svc_create(prog, bufsize, 1, threadfn);
+	return __svc_create(prog, NULL, bufsize, 1, threadfn);
 }
 EXPORT_SYMBOL_GPL(svc_create);
 
 /**
  * svc_create_pooled - Create an RPC service with pooled threads
  * @prog: the RPC program the new service will handle
+ * @stats: the stats struct if desired
  * @bufsize: maximum message size for @prog
  * @threadfn: a function to service RPC requests for @prog
  *
  * Returns an instantiated struct svc_serv object or NULL.
  */
 struct svc_serv *svc_create_pooled(struct svc_program *prog,
+				   struct svc_stat *stats,
 				   unsigned int bufsize,
 				   int (*threadfn)(void *data))
 {
 	struct svc_serv *serv;
 	unsigned int npools = svc_pool_map_get();
 
-	serv = __svc_create(prog, bufsize, npools, threadfn);
+	serv = __svc_create(prog, stats, bufsize, npools, threadfn);
 	if (!serv)
 		goto out_err;
 	return serv;


