Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039178;
	b=QIOS6Q2K3wcK4yRzJ7i2Y2AO2Pn97pnsz4w6ZGzlreWWbw8BtLGDvSdeqt8RqQE2BALX
	 TR+HuxuebeP2Z8NCUKsubbfQ7PW1/lApHSoBVmQ0XKN8KCYPyLOzWWR8LRlOqPbN9adDY
	 +G/nc6YQd6F+I+kO0QCL6fyjlYExFtnPU69ZBE1uAUvTmo1ZDJkySDuXEPa8kdXBMFROs
	 iqk+8qJyi9jyZeSKdH66pM2wxZWgV9wM14djYB8czKKpH8VeN5kAYcKwtsoalKZ2crNUG
	 ZHVYZZZYpvyDyOje2MkC9V+KcnSfKyJEzFHsAFncujct9CCV5qpsPJfCyjaIpa6pBYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=857dF8gboFCzMSQNoi92XSizMXnCvbeqohTrBDB0A50=;
	b=GfDwlObZ6LT9XP72G3oAfp9E77gzqNxOtKPiqC75PDMoy3B+HCYiRhPs3IKLAeo1kxrc
	 70aLQq+bUmRdCB0evozIgTu4WE3cp28yTfnvu6unaqdOfuwJBTMQleZ3J2ZEMNOJRMz86
	 mAqAfaujgloqWsRr2t6nZyDJcctidE4ibp3cq5deNsqcnAir3c5JdEykSQlXIUhBZdfZy
	 yZBuGl3AuBz2NvP7CY+XsLlKv+PcljZJnPsHBXBGMpsdOsBFEYedDAvXJGOnU1tEKf39U
	 xFDz/237OdXgPgp8tTKNVC89mmFSpExSTs+gErox0edy+H5CjwtZ6O7Pu3971mospDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgnKwGSo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A921606A320;
	Wed, 18 Nov 2026 21:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IgnKwGSo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CCF1F000C5;
	Wed, 18 Nov 2026 21:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039178;
	bh=857dF8gboFCzMSQNoi92XSizMXnCvbeqohTrBDB0A50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IgnKwGSoS5lmxpIQikAhAMtSXcWbyl8JfqiacFrv4bByNj+0wMXDZ7arU6xfBy8tu
	 OTmzh3EqIIMbYHU5Qlrra1fBFXqBCowbzVK1vI+RN5jBjU/5CMSI0VHYA76uaDGa1l
	 Bcml3B3m3OfSrFG6QuQpDS0lro19j2Rvq6pkqNKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1965/3318] mm/shmem: fix accounting of swapin-error markers
Date: Wed, 18 Nov 2026 15:43:07 +0100
Message-ID: <20261118150421.039557897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 66ce68a249f4ac56cd6968aa6d8ded20fb4b7d09 ]

A failed swap read replaces the swap entry with a swapin-error marker in
the page-cache and subtracts its pages from "alloced" and "swapped";
however, it leaves their block charge in place.

Removing the marker during truncate then subtracts from "swapped" again.
This can underflow the counters or make swapped reach zero while other
pages remain swapped out, causing swapoff to loop without finding them.

When installing the marker, subtract only from "swapped" and let
shmem_recalc_inode() reduce "alloced" and release the block charge.

Make shmem_free_swap() report successful removal separately from the
number of swap pages freed, so removing a swapin-error marker does not
subtract from "swapped" again.

It's a bit confusing, but replacing a swapped out page by a swapin-error
marker in shmem_set_folio_swapin_error() behaves as follows:

Initially:
	alloced=1, swapped=1, nrpages=0
Calling shmem_recalc_inode(inode, 0, -1)
	-> swapped = 0
	-> freed =  1 - 0 - 0 = 1
	-> alloced -= freed
	-> alloced=0, swapped=0, block charge released

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-14-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adapted multi-page softleaf_t swap handling to older swp_entry_t APIs for single-page entries. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 74517e446f63f..adb0215ba0b41 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -855,18 +855,24 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
 }
 
 /*
- * Remove swap entry from page cache, free the swap and its page cache.
+ * Remove a swap entry or swapin-error marker at index.
+ * Return whether it was removed, counting freed swap pages in nr_swaps_freed.
  */
-static int shmem_free_swap(struct address_space *mapping,
-			   pgoff_t index, void *radswap)
+static bool shmem_free_swap(struct address_space *mapping,
+		pgoff_t index, void *radswap, long *nr_swaps_freed)
 {
+	const swp_entry_t swp = radix_to_swp_entry(radswap);
 	void *old;
 
 	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
 	if (old != radswap)
-		return -ENOENT;
-	free_swap_and_cache(radix_to_swp_entry(radswap));
-	return 0;
+		return false;
+	/* A swapin-error marker holds no swap slot, so just drop it. */
+	if (!non_swap_entry(swp)) {
+		free_swap_and_cache(swp);
+		(*nr_swaps_freed)++;
+	}
+	return true;
 }
 
 /*
@@ -1019,8 +1025,8 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
-							indices[i], folio);
+				shmem_free_swap(mapping, indices[i], folio,
+						&nr_swaps_freed);
 				continue;
 			}
 
@@ -1088,12 +1094,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (xa_is_value(folio)) {
 				if (unfalloc)
 					continue;
-				if (shmem_free_swap(mapping, indices[i], folio)) {
+				if (!shmem_free_swap(mapping, indices[i], folio,
+						     &nr_swaps_freed)) {
 					/* Swap was replaced by page: retry */
 					index = indices[i];
 					break;
 				}
-				nr_swaps_freed++;
 				continue;
 			}
 
@@ -1847,11 +1853,10 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 	folio_wait_writeback(folio);
 	delete_from_swap_cache(folio);
 	/*
-	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
-	 * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
-	 * in shmem_evict_inode().
+	 * Let shmem_recalc_inode() reduce alloced and release the block charge
+	 * for the freed swap pages.
 	 */
-	shmem_recalc_inode(inode, -1, -1);
+	shmem_recalc_inode(inode, 0, -1);
 	swap_free(swap);
 }
 
-- 
2.53.0



