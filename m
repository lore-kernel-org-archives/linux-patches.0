Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7486453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2A4C340F3;
	Tue, 22 Mar 2022 21:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985270;
	bh=smRsLR5KE1eDlWG0M4YVDorxzhzKWgs3LdA4p0yZgwU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=hN0XTY1q9p8lnfHVUwqoyvjJe+iGAnx0czNZZugCFyrj4LMZP+5T7bGLwahIuOIaW
	 C6kInRkyvmyPWExuEIoAVHZBRpEmHweGXYlM1oGDZ0osTFTlmXaJxF6Vj3c/MM7JtR
	 nASThRJ0ccMW1sr5dIizc2wNQLv3hdhjQVmjUtKc=
Date: Tue, 22 Mar 2022 14:41:09 -0700
To: zhengqi.arch@bytedance.com,willy@infradead.org,vdavydov.dev@gmail.com,vbabka@suse.cz,tytso@mit.edu,trond.myklebust@hammerspace.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,richard.weiyang@gmail.com,mhocko@kernel.org,kari.argillander@gmail.com,jaegeuk@kernel.org,hannes@cmpxchg.org,fam.zheng@bytedance.com,duanxiongchun@bytedance.com,david@fromorbit.com,chao@kernel.org,Anna.Schumaker@Netapp.com,alexs@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 052/227] mm: dcache: use kmem_cache_alloc_lru() to allocate dentry
Message-Id: <20220322214110.3B2A4C340F3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: dcache: use kmem_cache_alloc_lru() to allocate dentry

Like inode cache, the dentry will also be added to its memcg list_lru.  So
replace kmem_cache_alloc() with kmem_cache_alloc_lru() to allocate dentry.

Link: https://lkml.kernel.org/r/20220228122126.37293-8-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/dcache.c~mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry
+++ a/fs/dcache.c
@@ -1766,7 +1766,8 @@ static struct dentry *__d_alloc(struct s
 	char *dname;
 	int err;
 
-	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
+	dentry = kmem_cache_alloc_lru(dentry_cache, &sb->s_dentry_lru,
+				      GFP_KERNEL);
 	if (!dentry)
 		return NULL;
 
_
