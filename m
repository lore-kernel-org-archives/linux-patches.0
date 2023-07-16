Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9528F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D38C433C8;
	Sun, 16 Jul 2023 20:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538610;
	bh=bZ4mPcvZXM0pZba6TbjXQQu+FGoZKOLzIyV/qR0Xkwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5+Zk3tdMGnmpLOwAQJeisWZOZrWz7s1zNF8Ql3kgxCYv9K2IWUaB0iuNhwEiSIkF
	 yRMuc/ad96e7+Bh7yG20YDTU4FhusGSAYgviYAU3nUEq1JVExhR7R/rc1F/raWW73b
	 GdixKEsaLPA7v1s0/91HthTSS+31LHMvRocbXIaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 512/800] NFSv4.2: fix wrong shrinker_id
Date: Sun, 16 Jul 2023 21:46:05 +0200
Message-ID: <20230716195000.984871701@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit 7f7ab336898f281e58540ef781a8fb375acc32a9 ]

Currently, the list_lru::shrinker_id corresponding to the nfs4_xattr
shrinkers is wrong:

>>> prog["nfs4_xattr_cache_lru"].shrinker_id
(int)0
>>> prog["nfs4_xattr_entry_lru"].shrinker_id
(int)0
>>> prog["nfs4_xattr_large_entry_lru"].shrinker_id
(int)0
>>> prog["nfs4_xattr_cache_shrinker"].id
(int)18
>>> prog["nfs4_xattr_entry_shrinker"].id
(int)19
>>> prog["nfs4_xattr_large_entry_shrinker"].id
(int)20

This is not what we expect, which will cause these shrinkers
not to be found in shrink_slab_memcg().

We should assign shrinker::id before calling list_lru_init_memcg(),
so that the corresponding list_lru::shrinker_id will be assigned
the correct value like below:

>>> prog["nfs4_xattr_cache_lru"].shrinker_id
(int)16
>>> prog["nfs4_xattr_entry_lru"].shrinker_id
(int)17
>>> prog["nfs4_xattr_large_entry_lru"].shrinker_id
(int)18
>>> prog["nfs4_xattr_cache_shrinker"].id
(int)16
>>> prog["nfs4_xattr_entry_shrinker"].id
(int)17
>>> prog["nfs4_xattr_large_entry_shrinker"].id
(int)18

So just do it.

Fixes: 95ad37f90c33 ("NFSv4.2: add client side xattr caching.")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xattr.c | 79 +++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 35 deletions(-)

diff --git a/fs/nfs/nfs42xattr.c b/fs/nfs/nfs42xattr.c
index 76ae118342066..911f634ba3da7 100644
--- a/fs/nfs/nfs42xattr.c
+++ b/fs/nfs/nfs42xattr.c
@@ -991,6 +991,29 @@ static void nfs4_xattr_cache_init_once(void *p)
 	INIT_LIST_HEAD(&cache->dispose);
 }
 
+static int nfs4_xattr_shrinker_init(struct shrinker *shrinker,
+				    struct list_lru *lru, const char *name)
+{
+	int ret = 0;
+
+	ret = register_shrinker(shrinker, name);
+	if (ret)
+		return ret;
+
+	ret = list_lru_init_memcg(lru, shrinker);
+	if (ret)
+		unregister_shrinker(shrinker);
+
+	return ret;
+}
+
+static void nfs4_xattr_shrinker_destroy(struct shrinker *shrinker,
+					struct list_lru *lru)
+{
+	unregister_shrinker(shrinker);
+	list_lru_destroy(lru);
+}
+
 int __init nfs4_xattr_cache_init(void)
 {
 	int ret = 0;
@@ -1002,44 +1025,30 @@ int __init nfs4_xattr_cache_init(void)
 	if (nfs4_xattr_cache_cachep == NULL)
 		return -ENOMEM;
 
-	ret = list_lru_init_memcg(&nfs4_xattr_large_entry_lru,
-	    &nfs4_xattr_large_entry_shrinker);
-	if (ret)
-		goto out4;
-
-	ret = list_lru_init_memcg(&nfs4_xattr_entry_lru,
-	    &nfs4_xattr_entry_shrinker);
-	if (ret)
-		goto out3;
-
-	ret = list_lru_init_memcg(&nfs4_xattr_cache_lru,
-	    &nfs4_xattr_cache_shrinker);
-	if (ret)
-		goto out2;
-
-	ret = register_shrinker(&nfs4_xattr_cache_shrinker, "nfs-xattr_cache");
+	ret = nfs4_xattr_shrinker_init(&nfs4_xattr_cache_shrinker,
+				       &nfs4_xattr_cache_lru,
+				       "nfs-xattr_cache");
 	if (ret)
 		goto out1;
 
-	ret = register_shrinker(&nfs4_xattr_entry_shrinker, "nfs-xattr_entry");
+	ret = nfs4_xattr_shrinker_init(&nfs4_xattr_entry_shrinker,
+				       &nfs4_xattr_entry_lru,
+				       "nfs-xattr_entry");
 	if (ret)
-		goto out;
+		goto out2;
 
-	ret = register_shrinker(&nfs4_xattr_large_entry_shrinker,
-				"nfs-xattr_large_entry");
+	ret = nfs4_xattr_shrinker_init(&nfs4_xattr_large_entry_shrinker,
+				       &nfs4_xattr_large_entry_lru,
+				       "nfs-xattr_large_entry");
 	if (!ret)
 		return 0;
 
-	unregister_shrinker(&nfs4_xattr_entry_shrinker);
-out:
-	unregister_shrinker(&nfs4_xattr_cache_shrinker);
-out1:
-	list_lru_destroy(&nfs4_xattr_cache_lru);
+	nfs4_xattr_shrinker_destroy(&nfs4_xattr_entry_shrinker,
+				    &nfs4_xattr_entry_lru);
 out2:
-	list_lru_destroy(&nfs4_xattr_entry_lru);
-out3:
-	list_lru_destroy(&nfs4_xattr_large_entry_lru);
-out4:
+	nfs4_xattr_shrinker_destroy(&nfs4_xattr_cache_shrinker,
+				    &nfs4_xattr_cache_lru);
+out1:
 	kmem_cache_destroy(nfs4_xattr_cache_cachep);
 
 	return ret;
@@ -1047,11 +1056,11 @@ int __init nfs4_xattr_cache_init(void)
 
 void nfs4_xattr_cache_exit(void)
 {
-	unregister_shrinker(&nfs4_xattr_large_entry_shrinker);
-	unregister_shrinker(&nfs4_xattr_entry_shrinker);
-	unregister_shrinker(&nfs4_xattr_cache_shrinker);
-	list_lru_destroy(&nfs4_xattr_large_entry_lru);
-	list_lru_destroy(&nfs4_xattr_entry_lru);
-	list_lru_destroy(&nfs4_xattr_cache_lru);
+	nfs4_xattr_shrinker_destroy(&nfs4_xattr_large_entry_shrinker,
+				    &nfs4_xattr_large_entry_lru);
+	nfs4_xattr_shrinker_destroy(&nfs4_xattr_entry_shrinker,
+				    &nfs4_xattr_entry_lru);
+	nfs4_xattr_shrinker_destroy(&nfs4_xattr_cache_shrinker,
+				    &nfs4_xattr_cache_lru);
 	kmem_cache_destroy(nfs4_xattr_cache_cachep);
 }
-- 
2.39.2



