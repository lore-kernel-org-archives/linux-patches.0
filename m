Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585489;
	b=ino6ZPsx9WyneOA6F5jXv3w3YXYp4U+B6IrYUzttWYAKwuIqspQ8LBeMZXOehAIdhU33
	 uR+uDY/w2f0gO/O7CiTC9ESZ1oPEozjFULTIBK+4t9D8XmHKNXvPOgTZhmHAe2NT5xGx7
	 GqPdcLDz/vwUKaVDFtTctvm6u9vH1h6xbIoo4iNZeGPph5oe/0KLBxg4zaVumDHpAB4Nm
	 Pqn429Wydhh8N6o4iIg7pSa0qVArRZlK6CyQHo2YHMLV0WdUPy4aIfHvyuYpSVw40x1xc
	 ttldWIMHrieqNK8gJ+nz7U4ufOS2rpjWMjYj0nUUfn+1gDHvdA7rITi+oWsEJcqIMqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mhGEP/dWlGJXBHgqqDn+Rwx0eM/7ewBf6JgycTOA4PQ=;
	b=VPXO4rWXJajSk3wtFaQfj+CuTvQ+uITOTuAEZBAr66l8iKGyUiYXu7AM2ScORRT5BG66
	 /OAFT1E14lEGhLnoYfOaq0v/akSR1BtMZiSG5Perri9p0AijDaPi3oO/ejodotucnaPVG
	 3GdQn+UYcVixcHKnxhA/TpFcR3ehclMspz/NvxIdH0Q85e3uMVlUm7n649vpSIZJzz4Qx
	 G+FaMiV8cSXUAkmpv/dmnv3H4s68UzXmhib/3K2n6xfCgyIEBDEqjPveg97+GwyhzoW5H
	 il8fbtaWPeyskg4uqBZTqbAXsiBzmAOUTfVvPFEpKj72sFdHoCSs1ZogR4IUauvGRPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F67VLrLI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2D0606EBAC;
	Fri, 13 Nov 2026 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F67VLrLI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4991F000C4;
	Fri, 13 Nov 2026 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585488;
	bh=mhGEP/dWlGJXBHgqqDn+Rwx0eM/7ewBf6JgycTOA4PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F67VLrLIIMqUP+gyDFILKb+92F6cM5ainhX7U6Nfzzg3L0SEkppuMo98TS3wbXHkX
	 uBs3N3cH/VGRV1J/nX1SHSUHzvC2Sk9KZISX/UWigv3rc5k+y8fdPol85If6tLJhs6
	 2sOj3PEpfItlEXqzkrXA1jF5JuH1ikfnJ+pl6GaM=
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
Subject: [PATCH 7.3 137/507] mm/shmem: preserve data in clean folios when splitting fails
Date: Fri, 13 Nov 2026 10:47:21 -0500
Message-ID: <20261113153759.095367951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 249914d48f2ca..de4d9424f0596 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1259,6 +1259,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
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



