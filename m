Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046285;
	b=awDKT4LfN2+KO8nFZlHvKtiJaOpRXm3+uIiPvod7dbnyOZqp58COOlZ9pvNmN/67fTMt
	 vZuCR+Mhu11Bgu31BaBcNvd0X7LyyL/SPiXpHQZhki9oWxapKjKsSwTsQAT4BcXpWCMEV
	 LO5b/7eBk6N7JOc3PMR1Fv/TlHTKVNU4vfuvtynkJ26krYMDxGGcrrneLrGlEEC8xsSsF
	 0bmLy4wszXSnHH4n7cmCpbXv8snC40/Fj5Xa0/+3+eR+ok0yJi9PeNnD8iF0KiPQfFfZE
	 WLXUS7ymVJRIe6D/mkP1DwM/TT6Mvm/7yEEb/KTIb25r+Sp0nQxgaAffmCtFh/4ewIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GrCLk3mNITQS2jwoHpLTaBLC2LTPr+E70acH9ZZmuBk=;
	b=UlSem99os+XP5UiJCzS1RELCVxfKoUzHXX9kxJWawZJhbMAiElv5Hjzei2zL7b4u9j8o
	 Wufo4ATY65YlAMkvmeQLYyQCJyH4oBwUenwQuxFhV0ha5jDCcHKNOHb/vXtGHwZVEU94U
	 sILJKhIiRpPJJBN9hTINT/Ow3voHmRXtGgacUCQJ8Hcb6SlxwNllsr2JHEu5ZJHwkXMsn
	 br1gI6WMus7QHUwuDthTS1m/eVZVrs+ObsWr2KsRFP1+JigKmm8k2+APZHLcJHKguwb6q
	 fVUvIKO3/GTMexULEGc1ZQrQQhqaDMbh8/Kt4mzFJ8BaNydlJDGg9Av1cJBnc/rYgUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf+hx4Ow;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6625606A325;
	Wed, 18 Nov 2026 23:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qf+hx4Ow
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF9C1F000C5;
	Wed, 18 Nov 2026 23:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046284;
	bh=GrCLk3mNITQS2jwoHpLTaBLC2LTPr+E70acH9ZZmuBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qf+hx4OwhZz9LwwKOvplWr9nUk9lvNy9yU04dKzPJ+ykzsK35xy26x5rhW7leobT3
	 MmEf3mHH91rrEZ5kVBrKyBUMcZg1iHBsPEtVbQREDgw2VwQ4UqW/XZfKR/8QZnqGYL
	 ZZxmdjU9pB0uYbbNWWYQXiqObbPhGQtxwbc57apU=
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
Subject: [PATCH 6.1 1226/2857] mm/shmem: preserve data in clean folios when splitting fails
Date: Wed, 18 Nov 2026 15:37:40 +0100
Message-ID: <20261118150245.708477271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c7939dde94f2d..d277144d15e13 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1034,6 +1034,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
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



