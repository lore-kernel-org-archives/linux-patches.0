Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591068;
	b=LMD5C1Vc1JhS1O32Xo/uVNO9S5pMUeQNRQM/W8lUflRyDNydTegNmT6H3RGMPWFrj2Bp
	 0+llN8bjRarwQHQtFs0fDIQgD44Yo+ZVxJXdLUgM2BLxvmunIwOEjbDU6K76PzqHSNyyW
	 XJ7rLjrDwt8X5uNvcTNzwBpo2fXTe+PoY62eQYqGBhfp2JMiulCgRvq8dFGw+/4O/g3DI
	 nR6+p/+IrstfCUKHyeJCC0gynaGC//h2qPAUM6Ufoq46IdeNgbeWnsNSe8fjDsnzhqNgm
	 C5JrxCSB7nCmV1cWWlcpe2W/N7SPevIcVwlq1Ag7xB/zj6TKgCAV3zkLyj8baddYLNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xTbXpk+xzidUyQH8lYwhkCuDxEokoPHO6ydfwx3DMpo=;
	b=NfDWsG8pk60RQ17qu++35uQoqtc71WJdyRyTYjOPH9DLi7ndvEaKyROqh9eRwotToEcR
	 xKeZtggljo1zs8Il43dSRNWLmCl3O4iGu8TxJQ7lkMOFUhGBXxs4CGjEheKU2NnV3t+/v
	 7DE2w4EfAWtYBlKC9UXRv9/vZ3x+9wYt1iBZSZ6/vXhcv3X1bwsdeCIQoqZ9ADmQA21gU
	 8ZyPBFmqba4HBVkHiPorSZB83d38cB5xwgiIKDmXy5Q8bThWr/YhA+sIqbHCnuBj9t2bj
	 DvDp93+TR3D1oOAe2UEQ9VJwjHy6PODkqvK2eh7cb5nksE8tSxBWfkbjaApvVkgO6lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbM7wDra;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF35606B83B;
	Fri, 13 Nov 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QbM7wDra
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B21F000C4;
	Fri, 13 Nov 2026 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591068;
	bh=xTbXpk+xzidUyQH8lYwhkCuDxEokoPHO6ydfwx3DMpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QbM7wDraAPEcOuSUGbijOYJffw60guYfZujAifFoH2AWYgios1/ano5GxhCc/YLRZ
	 hZwYfEtjRWVaJYNG+OF54jzqCIC0FuzwndTTWNQSlqPp3P6c/9m9NS7SgsZTHhuTyY
	 Mdl0jsE0n/B71iwMkj8+mbFEtVLUCC1t//Vp6DGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/670] mm/shmem: preserve data in clean folios when splitting fails
Date: Fri, 13 Nov 2026 10:46:30 -0500
Message-ID: <20261113153819.532866344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 0c800435394a172f33bf4df4a5a04e187546cc9b ]

A shared writable mapping can have dirty PTEs while its shmem folio is
still clean. A read fault can install a writable PTE, and a later store
sets the PTE's dirty bit without marking the folio dirty.

After shmem_undo_range() has handled the boundary folios, a concurrent
read fault into a hole below the new EOF can allocate a large folio.
For example, on a tmpfs mount with huge=always, the fault's offset must
be within the file, but the allocated folio can extend beyond i_size.
The final scan then finds this folio and calls
truncate_inode_partial_folio() without marking it dirty.

Splitting normally collects the PTE dirty bits when unmapping the
folio. An extra reference, for example from vmsplice(), can make it
fail before that step. The fallback unmapping on split failure excludes
shmem, so the helper still sees a clean folio and drops it, losing data
outside the range.

CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
─────────────────────────────────────  ──────────────────────────────────
i_size = 3M
shmem_undo_range(3M, -1)
  first pass: hole, nothing to do
  boundary folio at 3M: hole, none
                                       read fault at 2M+x (below EOF)
                                         PMD folio [2M,4M), crosses EOF
                                         writable PTE, folio clean
                                       store to 2M+x
                                         PTE dirty, folio still clean
                                       vmsplice(2M+x)
                                         extra folio reference
  whole_folios: finds [2M,4M) folio
  truncate_inode_partial_folio()
    zero [3M,4M)
    folio_split()
      unmap_folio(): extra ref
        → -EAGAIN, PTE dirty bit
          never reaches the folio
    folio clean
      → truncate_inode_folio(whole)
        [2M,3M) dropped
                                       read 2M+x → refault → zeroes

Mark large folios dirty before partial truncation in the final scan,
as the boundary handling already does. Exclude failed-fallocate
rollback, which must discard the folios it added.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: simplify descriptions, adjust comments ]
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-8-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 7061d2217306b..b058e20bf018a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1155,6 +1155,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
 
+				/*
+				 * A shared mapping can have dirty PTEs while
+				 * the folio is still clean. Mark the folio
+				 * dirty so a failed split cannot discard data
+				 * outside the range.
+				 */
+				if (!unfalloc && folio_test_large(folio))
+					folio_mark_dirty(folio);
+
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio, lstart, lend)) {
-- 
2.53.0



