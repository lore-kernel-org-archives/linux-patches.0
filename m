Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062594;
	b=YoOxV1lQtKBG0EWW4xkxolnN535ZYqZpo3S55hwnPVB+N1BCUkOQFm+gY4mota8sqjUC
	 nwX1o/zxN7tXTIytpvqS1B6BjjKWmjD+t/hhqZolGm/GgpCGkw7SYCLLrf8NpoS5SvGKd
	 V4+5hqhiyv6AGMTHl6sNHsjO4/7kNM5zFIOxx7Zmo8Hs5OwBLPOsUj2doWc3rE6SwlUMC
	 gsgGskSMeRxXoszXu0z9c7S5cQLKing6sKugRZ4P5uELT2LfgbMLEQ8h6g47CCmRidvnF
	 2pBv/owIiKkG7j7l1EpNYath8hGh8y4C5nqZFjn88JZpMvPBVm0gHQ7TCqGIGdGXmBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wmjEMVaZwk5240j4NUCUN/GIoNDB4rpDgBMo0qjEMns=;
	b=LQf6tCIXsXYfbEIVXFmSSDLiQKM2SGoQCtmyH6FbqMBmJ3QLTs3TOc5Tqm/4T9x9B9XW
	 6Xh8/iiKoWEkTaCBwxz2wi+Io8oQ7BDkTXaGL3ggbFrYuSpfhFP/0kaIvm3LuIZahA+Q4
	 bMaMDG9eYrT2TO3TLTSZzpzPXt0Lft2YzMWmusVDNLEg9QwGzse/HNxHTI80zrlv+f7MX
	 rOwfjFneDEvQKkY5qOsoSdyDV3uGup88VKoKN6ojtmuTyNJJDFcjdBF766GUK9tc0FZkO
	 Di+r+L/XTIAnYRVCwZjgE1DVvOhL2HAXOIov0n2OU5cEzW6clbWb4orWpukulo7A6pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuVsH1KH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53191606A330;
	Sat,  7 Nov 2026 14:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuVsH1KH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008CA1F008A1;
	Sat,  7 Nov 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062594;
	bh=wmjEMVaZwk5240j4NUCUN/GIoNDB4rpDgBMo0qjEMns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuVsH1KH6zEIBCaE+/wStfkudEy1MSnTsqQcy+l1Mf2OwvUsFgiDO5fXzyOmScvh7
	 i5jXC1eOuzrNHSpskqx6Dw92u3CoA1TlYF914F3i9pJYqz0jXscLbnWriIiTpBoa15
	 UiJuOOFJCXvnTc6S+aBq97b00ZrB7Pu0Fb+qJ/sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weilin Tong <tongweilin@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dan Carpenter <error27@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1444/1536] ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Sat,  7 Nov 2026 08:57:40 -0500
Message-ID: <20261107135038.393938416@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weilin Tong <tongweilin@linux.alibaba.com>

[ Upstream commit e387ebe5cd31720b1e0281fd045be4eef36fadb3 ]

Commit a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in
filemap.c") changed mapping->nrpages to count base pages for hugetlb
folios.  However, shm_add_rss_swap() still multiplies it by
pages_per_huge_page(), overcounting RSS in both SHM_INFO and
/proc/sysvipc/shm.

Use mapping->nrpages for RSS accounting across all backing types, and
account swap only for non-hugetlb shmem.  Use READ_ONCE() for both
counters instead of info->lock, which does not protect nrpages and cannot
provide a consistent snapshot.

Link: https://lore.kernel.org/20261014082218.2236088-1-tongweilin@linux.alibaba.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/shm.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/ipc/shm.c b/ipc/shm.c
index f70a503e61295..77ee6d9ebd9d0 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -934,26 +934,11 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
 static void shm_add_rss_swap(struct shmid_kernel *shp,
 	unsigned long *rss_add, unsigned long *swp_add)
 {
-	struct inode *inode;
+	struct inode *inode = file_inode(shp->shm_file);
 
-	inode = file_inode(shp->shm_file);
-
-	if (is_file_hugepages(shp->shm_file)) {
-		struct address_space *mapping = inode->i_mapping;
-		struct hstate *h = hstate_file(shp->shm_file);
-		*rss_add += pages_per_huge_page(h) * mapping->nrpages;
-	} else {
-#ifdef CONFIG_SHMEM
-		struct shmem_inode_info *info = SHMEM_I(inode);
-
-		spin_lock_irq(&info->lock);
-		*rss_add += inode->i_mapping->nrpages;
-		*swp_add += info->swapped;
-		spin_unlock_irq(&info->lock);
-#else
-		*rss_add += inode->i_mapping->nrpages;
-#endif
-	}
+	*rss_add += READ_ONCE(inode->i_mapping->nrpages);
+	if (IS_ENABLED(CONFIG_SHMEM) && !is_file_hugepages(shp->shm_file))
+		*swp_add += READ_ONCE(SHMEM_I(inode)->swapped);
 }
 
 /*
-- 
2.53.0



