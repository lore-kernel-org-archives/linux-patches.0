Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C16465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18317C340EC;
	Tue, 22 Mar 2022 21:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985267;
	bh=u35NPKd+jo0oNE7KcZHC2ivXPW2a9Q+TDXL+8CzoOgE=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Xu+lac8k+pprIeiogfeGqT6JILDp4qI6LqfvnRoCxjCRaKbOtnLQn9Mqzkou3YSVt
	 9flF6NDjbOLW8XJlYOABHxqQl3rg4h6tZiGna1aeL8wQNwlsGl0VM1kCNrUwPqF5MC
	 OCzY23fm6QQSU0dG7fTtlJ9u7yL9BuY9p+coAA/k=
Date: Tue, 22 Mar 2022 14:41:06 -0700
To: zhengqi.arch@bytedance.com,willy@infradead.org,vdavydov.dev@gmail.com,vbabka@suse.cz,tytso@mit.edu,trond.myklebust@hammerspace.com,shy828301@gmail.com,shakeelb@google.com,roman.gushchin@linux.dev,richard.weiyang@gmail.com,mhocko@kernel.org,kari.argillander@gmail.com,jaegeuk@kernel.org,hannes@cmpxchg.org,fam.zheng@bytedance.com,duanxiongchun@bytedance.com,david@fromorbit.com,chao@kernel.org,Anna.Schumaker@Netapp.com,alexs@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 051/227] f2fs: allocate inode by using alloc_inode_sb()
Message-Id: <20220322214107.18317C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Muchun Song <songmuchun@bytedance.com>
Subject: f2fs: allocate inode by using alloc_inode_sb()

The inode allocation is supposed to use alloc_inode_sb(), so convert
kmem_cache_alloc() to alloc_inode_sb().

Link: https://lkml.kernel.org/r/20220228122126.37293-6-songmuchun@bytedance.com
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

 fs/f2fs/super.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/f2fs/super.c~f2fs-allocate-inode-by-using-alloc_inode_sb
+++ a/fs/f2fs/super.c
@@ -1345,8 +1345,12 @@ static struct inode *f2fs_alloc_inode(st
 {
 	struct f2fs_inode_info *fi;
 
-	fi = f2fs_kmem_cache_alloc(f2fs_inode_cachep,
-				GFP_F2FS_ZERO, false, F2FS_SB(sb));
+	if (time_to_inject(F2FS_SB(sb), FAULT_SLAB_ALLOC)) {
+		f2fs_show_injection_info(F2FS_SB(sb), FAULT_SLAB_ALLOC);
+		return NULL;
+	}
+
+	fi = alloc_inode_sb(sb, f2fs_inode_cachep, GFP_F2FS_ZERO);
 	if (!fi)
 		return NULL;
 
_
