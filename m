Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037569;
	b=xd7PwgYB6Gb+kJhePr3FiBdoxcGIAAtPNYK0FHybvQxkq6MhmRxCHFV+KEQ5f3F3GVTk
	 IcJlVCPv95JdXDfifmXHgLFJsUUZctRb9Zf97LfuHfsGTsrhyI6Xye7Rr+GPjhNS0FN2+
	 k6XkYhcSDf5r4wkCHwfn0urjBb/PHqbbOkcui1UnjndNZmPambzBgKmLE0+1eQ4F8CChL
	 hV2BfGpTFNUCjmsrUmhZIr4dswPk2tSQOWjtOXhgNLSU0A5t8/V2OhXdEkMlMcYroL+Bj
	 Rq7avzoiAyLLEFpUMjky5TD0EEw9KLrxjPej9iAI5ZACMBTtAyo3MOGSYEXQ0GRfYQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=iKWjNa7/K3TYKf5QjaI8Qql55p/gs1Z1Rb0WqdM8DMM=;
	b=m6j/vuDGPG3jF/HRy45YX+8edIX+QfV0zHxiDh63qeDMPbhb4j5MbDCyngavtGpyxRgt
	 Gxzs/lnLlJI18/57WN7K7sCjI6N1LTibh1HLAYRllBf9SMSwGMTQJ6sFpNR7ksCSqLlQV
	 cu875kjqtmzcNuYuWt9X/4rUmi7xMcMimXebvcV38D3KShOmh4OnlEjWO9P4FFUNUvft3
	 S3yszYjab/T3q7JdD42PA+0BLjAqjbVT3akNDel2EmxxZHkDuFmlwj7rq667A5n0S0eGg
	 XkKO9oeXXLFlTek+R1msy4pMM4QZZYtPew7yfIRVIMuOyZs8QH1dbBdX5TrHF1lmu4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qG/NZnM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B3B606A31C;
	Wed, 18 Nov 2026 21:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qG/NZnM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EFA1F000C4;
	Wed, 18 Nov 2026 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037568;
	bh=iKWjNa7/K3TYKf5QjaI8Qql55p/gs1Z1Rb0WqdM8DMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qG/NZnM/GKr9njlonvUwL62ztZxj2SvbSS+m5eANYIQ4RV28fr9Nuo48XLhyVRJbG
	 C9owjLbC5Q0TrsKD6GrDvImIaLH+SVXonraKbuS5n/qdbz8unaISoH4Cc6HvVIM6lQ
	 iPDQH3wzTW2JxCFPY12/WoK9hYExKj0JozEQ6O3s=
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
Subject: [PATCH 6.6 1443/3318] mm/shmem: preserve data in clean folios when splitting fails
Date: Wed, 18 Nov 2026 15:34:25 +0100
Message-ID: <20261118150404.115740951@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2968248bf8c20..b81d9c789d11f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1103,6 +1103,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
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



