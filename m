Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503D5127B5F;
	Mon,  8 Apr 2024 13:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583387; cv=none; b=i2WSkflSk5xlx/cygvfRHZPdgecyteOP1vhpwZTnhbaEu6KB1yPFZUHUJci0KIyILTKKK1ytQZq5rSFd6bqkuODqzrRZ3DWzKbW9mPjL7o/PaGpuQD/Fcxov8Cz6rgDsOS8DoiOXYA2mIVsdTuuIRQPOJ2BtN2+zP30GQgZRNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583387; c=relaxed/simple;
	bh=iB+30781Vv4OkQt4qYcChy2LmBCScrq0EI/LAIDEqmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpKGfma4DGbHAnsxEt/6Yc95F+dUXcts5SzNvqeYwbpNd86TrLg2UmFjdgE/EqrL/uFeEzkCsbFJWhEC7Oz0BsTC7AbGulg21PTVtdGTF7iYYIRwXA29k9jHgabkfPBSzWHH7htzVVCi0XzPOCfyn8dUCWL1lF2t4wCr94gPyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdK+/DUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdK+/DUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B423C433C7;
	Mon,  8 Apr 2024 13:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583387;
	bh=iB+30781Vv4OkQt4qYcChy2LmBCScrq0EI/LAIDEqmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdK+/DUZKzjD9ugIW5xhC4g7FkUpTtSxbhdHQs4/80rBvLp5Jt/iwCUVrNziVJOkv
	 Y5NfQA5SqOimoEqvsRxc1pKy1APZxPdeSgi2GSZjgWp7sjLrNhhVJDHROx3yyk8EAM
	 kbNBU7SowPTLlpsvNLTZhSmYEbEFy/fgZ1WMAjmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 242/690] SUNRPC: move the pool_map definitions (back) into svc.c
Date: Mon,  8 Apr 2024 14:51:48 +0200
Message-ID: <20240408125408.416906144@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit cf0e124e0a489944d08fcc3c694d2b234d2cc658 ]

These definitions are not used outside of svc.c, and there is no
evidence that they ever have been.  So move them into svc.c
and make the declarations 'static'.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/sunrpc/svc.h | 25 -------------------------
 net/sunrpc/svc.c           | 31 +++++++++++++++++++++++++------
 2 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 71b3a9e3fc4a8..35bb1c4393400 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -496,29 +496,6 @@ struct svc_procedure {
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
@@ -535,8 +512,6 @@ void		   svc_rqst_replace_page(struct svc_rqst *rqstp,
 					 struct page *page);
 void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
-unsigned int	   svc_pool_map_get(void);
-void		   svc_pool_map_put(void);
 struct svc_serv *  svc_create_pooled(struct svc_program *, unsigned int,
 			const struct svc_serv_ops *);
 int		   svc_set_num_threads(struct svc_serv *, struct svc_pool *, int);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 07443f7e2d870..8fbfea9f2a04c 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -41,14 +41,35 @@ static void svc_unregister(const struct svc_serv *serv, struct net *net);
 
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
 
@@ -222,7 +243,7 @@ svc_pool_map_init_pernode(struct svc_pool_map *m)
  * vice versa).  Initialise the map if we're the first user.
  * Returns the number of pools.
  */
-unsigned int
+static unsigned int
 svc_pool_map_get(void)
 {
 	struct svc_pool_map *m = &svc_pool_map;
@@ -257,7 +278,6 @@ svc_pool_map_get(void)
 	mutex_unlock(&svc_pool_map_mutex);
 	return m->npools;
 }
-EXPORT_SYMBOL_GPL(svc_pool_map_get);
 
 /*
  * Drop a reference to the global map of cpus to pools.
@@ -266,7 +286,7 @@ EXPORT_SYMBOL_GPL(svc_pool_map_get);
  * mode using the pool_mode module option without
  * rebooting or re-loading sunrpc.ko.
  */
-void
+static void
 svc_pool_map_put(void)
 {
 	struct svc_pool_map *m = &svc_pool_map;
@@ -283,7 +303,6 @@ svc_pool_map_put(void)
 
 	mutex_unlock(&svc_pool_map_mutex);
 }
-EXPORT_SYMBOL_GPL(svc_pool_map_put);
 
 static int svc_pool_map_get_node(unsigned int pidx)
 {
-- 
2.43.0



