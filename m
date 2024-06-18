Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D6213BAFB;
	Tue, 18 Jun 2024 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715814; cv=none; b=NjvStj7V2qFhv5WQ3D6PcsBn6mSKXJoSSg8RtdFkBjZjukMmPvYAvA26thUxObJi3ApOxTY9L9TqhQG7N8jOPNl7fmBYAhkYQ6GVIWV3tu69DBqUS0q/BRSVXtqZd1j+O46xL8yPDKW9IosfavKADaga718rq+y7UWTnaBGGoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715814; c=relaxed/simple;
	bh=ugfnh8Rib7i0xR3pJj9S9MB5rmOdjVqY7V4sYV8Vut8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKgno23CgO8bhxlQUL8WCuf9Z6rlEPJVlGYJFewgLTwJI3hmXKpYCzDojzc0o4/tjPOqgex27GyhRLvFh0AqtNvGckeSUG7cWkPPIib52RifDP46+FeqRTu3aTLn0xdMTMrWCmwwBqwRKTRGDDwrLy6kY96G9qXlqb7J8Wf+/L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRq86dS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRq86dS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C48C3277B;
	Tue, 18 Jun 2024 13:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715814;
	bh=ugfnh8Rib7i0xR3pJj9S9MB5rmOdjVqY7V4sYV8Vut8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRq86dS26n34WICi8ycB2c2y5UaMm35obp3FiWF7i8Y4SawJdowcifjpS1nogYbo7
	 vkZxf0vD3bNv7Nt8PRZn1mbOlLrjgCVyT0GypHsFiivVoHJXmJSjT2ctIaVVV9uJYt
	 uZP2PF1/a+QYIsyr1W+DiQaPkC5A8+wRSC02amgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/770] SUNRPC: move the pool_map definitions (back) into svc.c
Date: Tue, 18 Jun 2024 14:34:48 +0200
Message-ID: <20240618123424.077927094@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit cf0e124e0a489944d08fcc3c694d2b234d2cc658 ]

These definitions are not used outside of svc.c, and there is no
evidence that they ever have been.  So move them into svc.c
and make the declarations 'static'.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h | 25 -------------------------
 net/sunrpc/svc.c           | 31 +++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 165719a6229ab..89e9d00af601b 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -497,29 +497,6 @@ struct svc_procedure {
 	const char *		pc_name;	/* for display */
 };
 
-/*
- * Mode for mapping cpus to pools.
- */
-enum {
-	SVC_POOL_AUTO = -1,	/* choose one of the others */
-	SVC_POOL_GLOBAL,	/* no mapping, just a single global pool
-				 * (legacy & UP mode) */
-	SVC_POOL_PERCPU,	/* one pool per cpu */
-	SVC_POOL_PERNODE	/* one pool per numa node */
-};
-
-struct svc_pool_map {
-	int count;			/* How many svc_servs use us */
-	int mode;			/* Note: int not enum to avoid
-					 * warnings about "enumeration value
-					 * not handled in switch" */
-	unsigned int npools;
-	unsigned int *pool_to;		/* maps pool id to cpu or node */
-	unsigned int *to_pool;		/* maps cpu or node to pool id */
-};
-
-extern struct svc_pool_map svc_pool_map;
-
 /*
  * Function prototypes.
  */
@@ -536,8 +513,6 @@ void		   svc_rqst_replace_page(struct svc_rqst *rqstp,
 					 struct page *page);
 void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
-unsigned int	   svc_pool_map_get(void);
-void		   svc_pool_map_put(void);
 struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 			const struct svc_serv_ops *);
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index da5f008b8d27c..c681ac1c9d569 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -39,14 +39,35 @@ static void svc_unregister(const struct svc_serv *serv, struct net *net);
 
 #define SVC_POOL_DEFAULT	SVC_POOL_GLOBAL
 
+/*
+ * Mode for mapping cpus to pools.
+ */
+enum {
+	SVC_POOL_AUTO = -1,	/* choose one of the others */
+	SVC_POOL_GLOBAL,	/* no mapping, just a single global pool
+				 * (legacy & UP mode) */
+	SVC_POOL_PERCPU,	/* one pool per cpu */
+	SVC_POOL_PERNODE	/* one pool per numa node */
+};
+
 /*
  * Structure for mapping cpus to pools and vice versa.
  * Setup once during sunrpc initialisation.
  */
-struct svc_pool_map svc_pool_map = {
+
+struct svc_pool_map {
+	int count;			/* How many svc_servs use us */
+	int mode;			/* Note: int not enum to avoid
+					 * warnings about "enumeration value
+					 * not handled in switch" */
+	unsigned int npools;
+	unsigned int *pool_to;		/* maps pool id to cpu or node */
+	unsigned int *to_pool;		/* maps cpu or node to pool id */
+};
+
+static struct svc_pool_map svc_pool_map = {
 	.mode = SVC_POOL_DEFAULT
 };
-EXPORT_SYMBOL_GPL(svc_pool_map);
 
 static DEFINE_MUTEX(svc_pool_map_mutex);/* protects svc_pool_map.count only */
 
@@ -220,7 +241,7 @@ svc_pool_map_init_pernode(struct svc_pool_map *m)
  * vice versa).  Initialise the map if we're the first user.
  * Returns the number of pools.
  */
-unsigned int
+static unsigned int
 svc_pool_map_get(void)
 {
 	struct svc_pool_map *m = &svc_pool_map;
@@ -255,7 +276,6 @@ svc_pool_map_get(void)
 	mutex_unlock(&svc_pool_map_mutex);
 	return m->npools;
 }
-EXPORT_SYMBOL_GPL(svc_pool_map_get);
 
 /*
  * Drop a reference to the global map of cpus to pools.
@@ -264,7 +284,7 @@ EXPORT_SYMBOL_GPL(svc_pool_map_get);
  * mode using the pool_mode module option without
  * rebooting or re-loading sunrpc.ko.
  */
-void
+static void
 svc_pool_map_put(void)
 {
 	struct svc_pool_map *m = &svc_pool_map;
@@ -281,7 +301,6 @@ svc_pool_map_put(void)
 
 	mutex_unlock(&svc_pool_map_mutex);
 }
-EXPORT_SYMBOL_GPL(svc_pool_map_put);
 
 static int svc_pool_map_get_node(unsigned int pidx)
 {
-- 
2.43.0



