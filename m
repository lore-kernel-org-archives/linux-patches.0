Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065406;
	b=CxpUlJog1ZMzdSwDAItVu1YeCDJn1jT7usMMEyYxW9OUF2yeWu/lcaQyisVERuy62ri1
	 4xeMcU3Au9ROQ2QNmHCvrXF34t3KSkVSI5b1kOFbWwpQYmoop5cTWV56q1Wy1oSI0WYps
	 R/7P6eezpPFvHmMfJY4wcMFQg9rDuqVn9Szv+9mPvRvUBTSynyXjw34VBKEsLCKTQFGmu
	 oBTbtGJEv5o6twTYYXvurdWTFMaHEwkcxbfivl5njemU4Y+Aw4hA1J5UNBTu4ljdczr3V
	 xhQ9uo9ybbfHiTMZV1o++HbX0K4Dkxjsu9qnlx8FaW26HgNuchgZFrgnK83E3ebbCYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9oOHgj9rESHfSJumdyGod7ah3O0TuaaP0z7PB7wGhMw=;
	b=qRiQMwfTBOyW2oCHPjLYCk52ApZ82WiuCs4ORDMgbweUENMtBFGF5qrxutGfk0w/XS3X
	 QXRjuv39knp8ONdJ5nMrYJzStsfXQ1JQ3bhJ7w5Bf+P8rAHhnnmUAyt1ABhFxD6zuRNPB
	 /fCM+FURAFhd6g+nul4aJTpfSef9PtCuXArRXOXooBabTJYxItqVgHnbc4N4PASFzGrer
	 H9MyeYZwIdaMosTEgKiz16+MOj+2dNH7OG3UDuqc8NkdPN4A8fIUPkK8g82DBMnenFRBa
	 wMU7klnwdjEVlVVYWB2YF+yVuAWczbcwF92XQcPgtiE3pcRIBJMcEPXZgtjuo/qI9iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkz+LWFA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2C606A338;
	Sat,  7 Nov 2026 15:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkz+LWFA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9231F008A1;
	Sat,  7 Nov 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065406;
	bh=9oOHgj9rESHfSJumdyGod7ah3O0TuaaP0z7PB7wGhMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkz+LWFA4127lhJtdEpd4qzHdvZYoru/OeyyhTNL2nUKGrB/kscH6bW2w9fDdC7nI
	 6Qs7bjw/5aX9wTHfRM/HpShqXbNHIXXz/BDYkvWT5aRQAgD+AJI8CS7NLrX7l8IgSF
	 qgIG07gHpNLO4N2cgqscvZprbeQJtBZaE+DI2lEE=
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
Subject: [PATCH 7.3 1087/1257] ipc/shm: fix RSS accounting for hugetlb shared memory
Date: Sat,  7 Nov 2026 08:56:23 -0500
Message-ID: <20261107135009.289581126@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bb1a721a3e746..6862f681373f1 100644
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



