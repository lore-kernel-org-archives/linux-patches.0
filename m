Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063633;
	b=OixxMPEMAGXqauVg7BqsP9dGTh8XICMOhlQDLGxGOzZBFxtSDdRKYvJbYmQUEfCK4ADP
	 N93HJEdp2X5D/JesMGmjRgOzfrLurklebBF9WFSInrPA4Zb5QVHhcyMp9bPz11VYmeJzb
	 7JPO7lYL3rL+atmSLXZyO1srNhPI1lazWPNiBnMyQMDbIs1WSnxkUpCHz/hFvuU99uGnN
	 3DvErh8NYDBFXnjLk4dbSlfSdRQlDJ9+oSgks8JcSJMaeYeXdzx/nsiZXHyA/3EHbJ2I3
	 BSnuBBBnEPqVoc5DqYf/RwBrVT/jrh/BkEod9M1dPVmNN9K209Ix6prd69mAy+dd00Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQ1RvVNyJ/kqbCyYKiNsZETtvOhVEt3Azssztc2sb64=;
	b=dAbN58Dv3x9x71DT4g6YqRYpq11twM95n7vvwqzkBCFnr1qDbw0EaJSDTLXgnqSBrv6G
	 Oc9PzyjvgGeWfiJA9VIYErAZ5VxPJvLM6SQChAymZaIQYLKunQvsGI/wwXIGYyeZZUo+c
	 K7Xpffk1uw8l14Pb4eiZ0cCtAh0Dxf72TgOlsrrAdEYJ7qYCNWIz4FSWT/u06YaxHrgk5
	 sjouNGVpyGntqjC4rgJnH60dheUYhLjKjEGo7JBz92gooa2I8GM2IEA8DiAI0xJh0q3aS
	 v0Bwc/140mBqA7jw3adTtYOnrvg0W1yIL0B4LWwbwwOizCSPKJpkslaOp2VhjiHOLFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yay6X7M0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D7B606EEAB;
	Sat,  7 Nov 2026 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yay6X7M0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA411F0089F;
	Sat,  7 Nov 2026 15:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063633;
	bh=FQ1RvVNyJ/kqbCyYKiNsZETtvOhVEt3Azssztc2sb64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yay6X7M02xq22m2tw7Qd9ys7rYZDgNlcCtCnqQ102lozEEF62i6K/cBqxJ8TnvWPM
	 2gSY8+KHXeRGdpl9OuPRQwpoLICq452xv6VtxJ/wi+ydWfafzRVxv04qmpYvEoXwxD
	 doiByN9srP2pCaaCj61LMiwHxnXcjOw8TNWeba28=
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
Subject: [PATCH 6.18 750/869] ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Sat,  7 Nov 2026 08:57:12 -0500
Message-ID: <20261107134918.187301187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c77a6c8683ce9..2f5cee0c78c7d 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -936,26 +936,11 @@ static inline unsigned long copy_shminfo_to_user(void __user *buf, struct shminf
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



