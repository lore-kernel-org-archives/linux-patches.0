Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C8F381BD;
	Sun,  1 Sep 2024 17:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210203; cv=none; b=K9i7QQhEtLu3w51Tdn+Ts6U9KilI0EIL6o2obWEHw7vr63Q56DPpIh61dwbdSnC+KAGwX/3qgEMNCfq7spjaZx1XoWbo2rHb6r1lI2hqtiQlMRTMvzK9GBINQbRkXE0r7Ac1perzMiZHS0MaAaxDqh3W0mb7ZsjIzBqhsqZHsnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210203; c=relaxed/simple;
	bh=w8G5KHM9Erufzp8I7zw1NRWgUUfX1BxSebAywSSOR3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJTZsWXuHnKrINDW15OgkF9NaOpMoI6QZOlxMx3WfAsfyRLKxwJI3gfq63ShHGcL96TjJuvs++u/44oB3/XIPKGFiQfDDRWZYyKGV8Q/W5ixLPsA2jkhvqi9aShDCbUtN5Gg7QH3RHqB4GqGI12ICLoF0cbH5gJHZW53ne7XCeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1nqaJIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1nqaJIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67241C4CEC3;
	Sun,  1 Sep 2024 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210202;
	bh=w8G5KHM9Erufzp8I7zw1NRWgUUfX1BxSebAywSSOR3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1nqaJIFzwL9IgNZJ99HOGmT/A5ZFwfoKtr0x7UOi5pJJ+lcTZWwVknma7DkejKdc
	 DIS+sWVZnhjqMmRI8OJO6Q0t+KZIbNsDq8wOdOy0kGy1uAYTKiAjEVyr/Wu89G2RBa
	 BAAy9b2CjHDBiMp5tluAAtFrE3XkqggAmfuJwzfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 120/215] sunrpc: pass in the sv_stats struct through svc_create_pooled
Date: Sun,  1 Sep 2024 18:17:12 +0200
Message-ID: <20240901160827.891007905@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit f094323867668d50124886ad884b665de7319537 ]

Since only one service actually reports the rpc stats there's not much
of a reason to have a pointer to it in the svc_program struct.  Adjust
the svc_create_pooled function to take the sv_stats as an argument and
pass the struct through there as desired instead of getting it from the
svc_program->pg_stats.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfssvc.c           |    3 ++-
 include/linux/sunrpc/svc.h |    4 +++-
 net/sunrpc/svc.c           |   12 +++++++-----
 3 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -665,7 +665,8 @@ int nfsd_create_serv(struct net *net)
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
@@ -483,7 +483,9 @@ void		   svc_rqst_replace_page(struct sv
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
@@ -447,8 +447,8 @@ __svc_init_bc(struct svc_serv *serv)
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
@@ -460,7 +460,7 @@ __svc_create(struct svc_program *prog, u
 	serv->sv_name      = prog->pg_name;
 	serv->sv_program   = prog;
 	kref_init(&serv->sv_refcnt);
-	serv->sv_stats     = prog->pg_stats;
+	serv->sv_stats     = stats;
 	if (bufsize > RPCSVC_MAXPAYLOAD)
 		bufsize = RPCSVC_MAXPAYLOAD;
 	serv->sv_max_payload = bufsize? bufsize : 4096;
@@ -522,26 +522,28 @@ __svc_create(struct svc_program *prog, u
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


