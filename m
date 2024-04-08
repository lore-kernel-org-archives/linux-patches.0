Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC998128372;
	Mon,  8 Apr 2024 13:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583395; cv=none; b=WqOd2zfJTlTNazE7L1hLRKhicE5PRS7O21gbexc7LtxQZ2gt2fDVbDNV45SBKH+L7cQz/n3XlmcFj/4W4gP+T1Ocipgmy7DZ0XRwD0/LIhm4u1h8Zlnl9R3mt4v9rjFqZ4mh4h5P+qqD5c60eUnwKs5yf8/yb7dZjSrqzMyj8ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583395; c=relaxed/simple;
	bh=igVkDiJg82gO6PSDzff0AeQpaauFcduGPKbVrEymsH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hi+vLLO7CE9w/X9SpCGiyAv9JIiooW7FOSW1QCUbvwlyJ75J+RUHHYIZg0C/1iecjyvMM7jAsIlfOUd/SYCatzq7rFI/T8x4lqKagIpL/LYrx7OLMup2X4UuT3qzwt1Ky8Ajp3lYAExd/xieC59iuzg9s2mQPqSKKK11r0Bt0uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gn9jo7VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gn9jo7VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3C6C433F1;
	Mon,  8 Apr 2024 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583395;
	bh=igVkDiJg82gO6PSDzff0AeQpaauFcduGPKbVrEymsH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn9jo7VY6rFRwUgO8Q4hJ10Q7P12+dN9Qk6C3PVq/+7nYhbslZ94WXGhK37RJ2XuX
	 oyNh+LekTE62idPnd+fJVQFohivYScnGVzuwAX47VY9N5JQK2ikAMrqar1ePd2ni49
	 V2C/136iwNBH9nkqF4dnNbCR09U7QzBjoeGFTt7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 243/690] SUNRPC: always treat sv_nrpools==1 as "not pooled"
Date: Mon,  8 Apr 2024 14:51:49 +0200
Message-ID: <20240408125408.447704931@linuxfoundation.org>
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

[ Upstream commit 93aa619eb0b42eec2f3a9b4d9db41f5095390aec ]

Currently 'pooled' services hold a reference on the pool_map, and
'unpooled' services do not.
svc_destroy() uses the presence of ->svo_function (via
svc_serv_is_pooled()) to determine if the reference should be dropped.
There is no direct correlation between being pooled and the use of
svo_function, though in practice, lockd is the only non-pooled service,
and the only one not to use svo_function.

This is untidy and would cause problems if we changed lockd to use
svc_set_num_threads(), which requires the use of ->svo_function.

So change the test for "is the service pooled" to "is sv_nrpools > 1".

This means that when svc_pool_map_get() returns 1, it must NOT take a
reference to the pool.

We discard svc_serv_is_pooled(), and test sv_nrpools directly.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/svc.c | 54 ++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 8fbfea9f2a04c..fee7a22578b64 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -37,8 +37,6 @@
 
 static void svc_unregister(const struct svc_serv *serv, struct net *net);
 
-#define svc_serv_is_pooled(serv)    ((serv)->sv_ops->svo_function)
-
 #define SVC_POOL_DEFAULT	SVC_POOL_GLOBAL
 
 /*
@@ -240,8 +238,10 @@ svc_pool_map_init_pernode(struct svc_pool_map *m)
 
 /*
  * Add a reference to the global map of cpus to pools (and
- * vice versa).  Initialise the map if we're the first user.
- * Returns the number of pools.
+ * vice versa) if pools are in use.
+ * Initialise the map if we're the first user.
+ * Returns the number of pools. If this is '1', no reference
+ * was taken.
  */
 static unsigned int
 svc_pool_map_get(void)
@@ -253,6 +253,7 @@ svc_pool_map_get(void)
 
 	if (m->count++) {
 		mutex_unlock(&svc_pool_map_mutex);
+		WARN_ON_ONCE(m->npools <= 1);
 		return m->npools;
 	}
 
@@ -268,29 +269,36 @@ svc_pool_map_get(void)
 		break;
 	}
 
-	if (npools < 0) {
+	if (npools <= 0) {
 		/* default, or memory allocation failure */
 		npools = 1;
 		m->mode = SVC_POOL_GLOBAL;
 	}
 	m->npools = npools;
 
+	if (npools == 1)
+		/* service is unpooled, so doesn't hold a reference */
+		m->count--;
+
 	mutex_unlock(&svc_pool_map_mutex);
-	return m->npools;
+	return npools;
 }
 
 /*
- * Drop a reference to the global map of cpus to pools.
+ * Drop a reference to the global map of cpus to pools, if
+ * pools were in use, i.e. if npools > 1.
  * When the last reference is dropped, the map data is
  * freed; this allows the sysadmin to change the pool
  * mode using the pool_mode module option without
  * rebooting or re-loading sunrpc.ko.
  */
 static void
-svc_pool_map_put(void)
+svc_pool_map_put(int npools)
 {
 	struct svc_pool_map *m = &svc_pool_map;
 
+	if (npools <= 1)
+		return;
 	mutex_lock(&svc_pool_map_mutex);
 
 	if (!--m->count) {
@@ -359,21 +367,18 @@ svc_pool_for_cpu(struct svc_serv *serv, int cpu)
 	struct svc_pool_map *m = &svc_pool_map;
 	unsigned int pidx = 0;
 
-	/*
-	 * An uninitialised map happens in a pure client when
-	 * lockd is brought up, so silently treat it the
-	 * same as SVC_POOL_GLOBAL.
-	 */
-	if (svc_serv_is_pooled(serv)) {
-		switch (m->mode) {
-		case SVC_POOL_PERCPU:
-			pidx = m->to_pool[cpu];
-			break;
-		case SVC_POOL_PERNODE:
-			pidx = m->to_pool[cpu_to_node(cpu)];
-			break;
-		}
+	if (serv->sv_nrpools <= 1)
+		return serv->sv_pools;
+
+	switch (m->mode) {
+	case SVC_POOL_PERCPU:
+		pidx = m->to_pool[cpu];
+		break;
+	case SVC_POOL_PERNODE:
+		pidx = m->to_pool[cpu_to_node(cpu)];
+		break;
 	}
+
 	return &serv->sv_pools[pidx % serv->sv_nrpools];
 }
 
@@ -526,7 +531,7 @@ svc_create_pooled(struct svc_program *prog, unsigned int bufsize,
 		goto out_err;
 	return serv;
 out_err:
-	svc_pool_map_put();
+	svc_pool_map_put(npools);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(svc_create_pooled);
@@ -561,8 +566,7 @@ svc_destroy(struct kref *ref)
 
 	cache_clean_deferred(serv);
 
-	if (svc_serv_is_pooled(serv))
-		svc_pool_map_put();
+	svc_pool_map_put(serv->sv_nrpools);
 
 	kfree(serv->sv_pools);
 	kfree(serv);
-- 
2.43.0



