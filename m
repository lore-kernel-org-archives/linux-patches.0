Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014986;
	b=MuzXZF122xiqoIZ2DqQsdibKDuNkXslARv2iv7tZKCPU6ra7nuAdJWKge+9OPOBN1JCo
	 Z/V1aysb//C6RxNUMmQPNkaFeJkD5D+6CAv2NrDpeKkk2ZMB6gwxwp2th/qxE50U1N6//
	 SnGo8+r7TeiQJ6CKbUOXHs/K5+nOuw+CTDWdghPdsPUP/DIp6RQB/rpK+/AmkNnv9G9JJ
	 +AJwK3nG619/8rxbX7gIam24zZelc6B9URhaLSdlN2veHsLegLHBx7dBV2h5u2s/Rmw/R
	 u3710W43I+/nDC83TyeOlByDj/Ljn16jMS6eT3CUWsSUBNFvVRfBR9GS38vS+1VE8yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gOqFByboSCa4sob8kTmW6xiav0hMXwkp8xh3eigPJu0=;
	b=AbiJJ8UrHuNoqGVwe8Ysgxc4wbw12FYY38hJ433r+98rEJyP5ostoU/3WyfkMbQeFCVT
	 Mv73ZAcYLVYrS+EoZwYSDrapeaPNwzZFuqYUvQe31coqCkTlxLE2SuGb99gIcmT1OFp35
	 DhpE7AhISFKQEE01CsPGd1ZrJJ8gPcjw86R/SXByaMzpKAtdLvSGcuWoyvUdg7C58ZXTN
	 LIQ1HNxaq09tDB7ob57gCAYBncaV53NpRZiMW+MMeG6hOamWXwotNwDt0nKK2rcfkuOrF
	 NfNAABEpZsG4a9Twy6Wg/ppfsnpz76Rd+vdv6Aq+w8frqFZQMcs9HlEd2L30Nc0hxbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjlQFcuR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7B606A320;
	Wed, 18 Nov 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wjlQFcuR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700E01F000C4;
	Wed, 18 Nov 2026 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795014985;
	bh=gOqFByboSCa4sob8kTmW6xiav0hMXwkp8xh3eigPJu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wjlQFcuR+AFLaAuRCdHF2USQjx4ORxKxdZruwdnCVKU2jdL686QY2NUeIebqfIIbI
	 BfYs34EdZKDjKs+NtzhRngAElrPsqpcVYImc4C8qrj44/BP/J2ZY5R5awXBz2zbpKj
	 wCvoqExHwk2fpn6u46wc8rLJpNc+PjDiVoKRviOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0004/2651] mm/shmem: hold off eviction in shmem_writeout()
Date: Wed, 18 Nov 2026 15:20:44 +0100
Message-ID: <20261118150248.162622215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 8f59173b5ca358bf4d1017b44da3cbe6faa80daf ]

Once shmem_writeout() has moved the folio from the page cache to the
swap cache, the folio lock no longer keeps the inode alive: truncation
and eviction find a swap entry, free it and do not wait for anybody.
That did not matter as long as swap_writeout() was the last thing the
function did.  But since it puts the folio back when swap_writeout()
returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
afterwards:

  reclaim                               last close of an unlinked file
  shmem_writeout()
    shmem_delete_from_page_cache()
    swap_writeout()
      zswap_store() fails               shmem_evict_inode()
      writeback is disabled               shmem_truncate_range()
      return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
                                        destroy_inode()
                                        ... RCU grace period, freed
    shmem_add_to_page_cache(mapping)
      xas_lock_irq()            <- use after free

swap_writeout() behaves that way if zswap is enabled, cannot take the
folio and the memcg or one of its ancestors has memory.zswap.writeback
set to 0.

shmem_unuse() already added infrastructure to deal with that.
Reuse info->stop_eviction to protect the inode during writeout. Increment
it before removing the folio from the page cache, and decrement it after
swap_writeout() and any attempted reinsertion and inode accounting.
In shmem_evict_inode(), wait for the counter to reach zero even if
swapoff has already removed the inode from the swap list. Add some helpers
to make the code easier to digest.

There is a known remaining issue with two swapoffs racing, and the empty
list check not being able to detect that race. That will be addressed
separately later.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
[ david: code cleanups; improve description ]
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-6-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: expanded upstream eviction helpers inline at their call sites to avoid adding new functions ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 597bbc2e7321a..eac9017cfb8d2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1447,16 +1447,21 @@ static void shmem_evict_inode(struct inode *inode)
 			}
 			spin_unlock(&sbinfo->shrinklist_lock);
 		}
-		while (!list_empty(&info->swaplist)) {
-			/* Wait while shmem_unuse() is scanning this inode... */
+		/*
+		 * Writeout may still use the inode after swapoff has removed it
+		 * from the swaplist, so always wait at least once.
+		 */
+		do {
 			wait_var_event(&info->stop_eviction,
 				       !atomic_read(&info->stop_eviction));
+			if (list_empty(&info->swaplist))
+				break;
 			spin_lock(&shmem_swaplist_lock);
 			/* ...but beware of the race if we peeked too early */
 			if (!atomic_read(&info->stop_eviction))
 				list_del_init(&info->swaplist);
 			spin_unlock(&shmem_swaplist_lock);
-		}
+		} while (!list_empty(&info->swaplist));
 	}
 
 	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
@@ -1737,6 +1742,13 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
+		/*
+		 * Once the folio has left the page cache, its lock no longer
+		 * keeps the inode from being evicted and freed: hold eviction
+		 * off, in case the folio has to be put back below.
+		 */
+		atomic_inc(&info->stop_eviction);
+
 		folio_dup_swap(folio, NULL);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
@@ -1744,6 +1756,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		error = swap_writeout(ctx, folio);
 		if (error != AOP_WRITEPAGE_ACTIVATE) {
 			/* folio has been unlocked */
+			if (atomic_dec_and_test(&info->stop_eviction))
+				wake_up_var(&info->stop_eviction);
 			return error;
 		}
 
@@ -1760,6 +1774,8 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 			shmem_recalc_inode(inode, 0, -nr_pages);
 			folio_put_swap(folio, NULL);
 		}
+		if (atomic_dec_and_test(&info->stop_eviction))
+			wake_up_var(&info->stop_eviction);
 
 		/*
 		 * The swap_cache_del_folio() below could be left for
-- 
2.53.0



