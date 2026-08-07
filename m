Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EEF2DC765;
	Fri,  7 Aug 2026 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115663; cv=none; b=kQudsk4dLPIwOODTZpouEQuF+0RI2/eD4qplT6e0ElHTOHpEsfFpXtArBLIyRf0ftoodEj04uHf/jYJTh5NGlJYjEUCVWvfJi4QUpWfvVhfbIogjNiqAZGc/tN4WHiU8P5pqoh1ZmLe3KvmD96lBE6AduEUctOMVQ4DM5dG7spI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115663; c=relaxed/simple;
	bh=Chi+oXO2fri+jzJFgugxh3cKPE5N9JgBmF35fHyZDME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcydThyTJtL3mPiWaW8TBAaSSsbB2ID6ajnx8sGKTMQ/hMLs7JonkOA4b+dYBSj9ZkBHyYxvHVB9HB6n1EoWpmr96FFI9QzyjC/bGf1w5BfhNQNtxHeFpPjwVTGobNVMgnpKAx6iG0Otr4uSguVdWfTAaqjjtKmUjzI6I/eDetQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7iI5+V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7iI5+V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3151F000E9;
	Fri,  7 Aug 2026 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115661;
	bh=u8c3QqKUU3DmvQ+OjER9ElDQyLJ1dszm79W6P7wyyA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7iI5+V+HzXN/7PRofivaUStbrtfVbRUOlvpqgN4powlNnVitazutPJ5/xzzL/khX
	 b/uiHMethrjgLd4oLLg79R2sC7fhnRLCisL6HiLZUAbsCicRMtuBpHdIHKjA4nDVUR
	 0StB183Zu/AVGAMkD/vGyjnaMCvImIqOa18Is3zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 355/396] mm/huge_memory: unlock i_mmap_rwsem before releasing after-split folios
Date: Fri,  7 Aug 2026 16:38:35 +0200
Message-ID: <20260807143431.942123397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiryl Shutsemau (Meta) <kas@kernel.org>

[ Upstream commit e923bd21058ea02fd0dcd3549d151d143fd036e5 ]

__folio_split() keeps dereferencing the mapping after the split:
shmem_uncharge(mapping->host) and remap_page() while the folios are still
frozen/locked, and i_mmap_unlock_read(mapping) at the very end, after the
after-split folios have been unlocked and freed.

Nothing holds an inode reference across that.  The split relies on @folio
-- which the beyond-EOF drop loop never removes, as it starts at
folio_next(folio) -- staying locked and in the page cache to hold off
eviction.  But the unlock loop unlocks @folio before i_mmap_unlock_read()
runs.  If the caller's @lock_at is a tail beyond EOF, as memory_failure()
passes when splitting a poisoned tail of a shmem THP that reaches past
i_size during truncation, it too is gone from the page cache; so once
@folio is unlocked no locked, in-cache folio pins the inode, and a
concurrent final iput() can evict and RCU-free it before
i_mmap_unlock_read() touches i_mmap_rwsem:

  BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
   i_mmap_unlock_read include/linux/fs.h:537 [inline]
   __folio_split+0x732/0x1640 mm/huge_memory.c:4100
   try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
   memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

  Freed by task 4601:
   shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
   evict+0x57f/0xac0 fs/inode.c:870

Do every mapping dereference while @folio still pins the inode: drop
i_mmap_rwsem right after remap_page(), before the loop that unlocks and
frees the after-split folios, and clear @mapping so the exit path does not
unlock it again.  shmem_uncharge() and remap_page() already run before
that point, so after this nothing past the unlock loop touches the inode
or the mapping.

This is now a rule the split depends on, alongside keeping @folio frozen
until the page cache is updated: no inode or mapping dereference once the
after-split folios start being unlocked.

Link: https://lore.kernel.org/20260716095424.471052-1-kirill@shutemov.name
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
Co-developed-by: Hao Zhang <zhanghao1@kylinos.cn>
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit e923bd21058ea02fd0dcd3549d151d143fd036e5)

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c08aa3db96431..bd3093a6cc628 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3871,6 +3871,18 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 	remap_page(folio, 1 << order, remap_flags);
 
+	/*
+	 * Drop the mapping while the inode is still pinned. @folio stays
+	 * locked and present in the page cache until the loop below, so
+	 * eviction cannot free the inode yet; @lock_at is not enough, it may
+	 * be a tail beyond EOF that the split already dropped from the page
+	 * cache. Nothing past this point may touch the inode or the mapping.
+	 */
+	if (mapping) {
+		i_mmap_unlock_read(mapping);
+		mapping = NULL;
+	}
+
 	/*
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.
-- 
2.53.0



