Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585492;
	b=FR4pFBey7uN/i1P0nBpMOjj4QXoElvVxA18yZkfiR29cMe5tfqqDxlI9FNNU5Ff3NNWo
	 kITasSERXGTQFViqC0PYg+XpAOjPzMbCpd6Oh5wo1dWYyILRna7wYidOxicyyf7Qplvxg
	 sfYTLR4qzCEq90IpSzZYxfpC0FosKMwyShye3UGFknWx3IEdCjmnzpy+PLo5Oymm29XNG
	 0CxqZNlCW5lp0BK7j3JL8Rp+fhUgDrACQrYnxBVqQIzGl+017GVwqtsprjSCrOW+iZk2U
	 oZvpRmP6QUCaddhMj4KgiEHzZI6TB5lVtNlWfKeI7ciycBjlqsRmV//qEzlfsfg06Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rbJGLYzirkj7SN1dLGRTRc5LnW/Hku0Zq4oio0X2iAI=;
	b=V02eL2vTSNu/Yi1q48MEasxbb9is/0YZAyP2g2dqKJsD7i7OD/F3fiIa39/aKISwIRGs
	 fNwLAtpttDm+lwLCTHEmCE+1f7dslYtrcOufl+53nZPvWOlMsZunwhPWaOdaSW00NnYu8
	 kDDs3bwSfHcSLOhYyvddVrEbqBNFM62kjVyl6X7QommrJv2Y2UfLuMXMlwlSSThYTzQy6
	 qeJ2v9IDKDJgnAsaClzmRWI3+HsJSu+g8OWdIvsE+Z5hFJODQlm5ZSkunu50KDob4gsI3
	 rCaDK00PFhttm/HKpqGNMSidGEzkMh9IIfUr1nTDBTtxSrYKOrjqSV+X3k0eMmWrb/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13vIRI0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D10606EBB9;
	Fri, 13 Nov 2026 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13vIRI0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F31F000C5;
	Fri, 13 Nov 2026 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585492;
	bh=rbJGLYzirkj7SN1dLGRTRc5LnW/Hku0Zq4oio0X2iAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13vIRI0Waw3z9FtlR+EFld818YivP1mGDup+os0LyJND2zmQ7QVSN1X8rBt+RGkBD
	 Cwj3+wBy53wWIpcBXn+V0gMQyzjXTtnC3bL4vn8TSvColKQ0ba+ZpISohC66zSuqUX
	 BH+aEhVjthHo+fsnD+MCACamrh9dX07/t8jKZLZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 140/507] mm/shmem: fix truncate hang in large swap entry
Date: Fri, 13 Nov 2026 10:47:24 -0500
Message-ID: <20261113153759.195187784@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit fa213b08f37f9dff78ce240a87579dc264fc7a5d ]

Truncating a tmpfs file or memfd to a page-aligned size inside a large
swap entry can loop indefinitely in shmem_undo_range(). The task holds
the inode lock and cannot be killed.

A large swap entry represents a whole swapped-out folio. For example,
truncate a file whose pages 0-7 share one swap entry to four pages:

    [ 0  1  2  3 | 4  5  6  7 ]
         keep    |   discard
                 ^
            new EOF, start = 4

i_size has already been updated when boundary handling asks
shmem_get_partial_folio() for page 4. Since it is swapped out, the helper
calls shmem_get_folio() with SGP_READ. That rejects page 4 with -EINVAL
because its starting offset equals i_size. Nothing is read back.

The final scan cannot free the entry without losing pages 0-3. It skips
it, restarts from start = 4, and finds it again indefinitely. An unaligned
truncate avoids this particular failure because the requested page starts
below i_size. Folios already in the page-cache cannot trigger it as the
direct lookup will return them beyond EOF.

Fix it by letting shmem_get_partial_folio() call shmem_swapin_folio()
directly for swap entries. This bypasses the read path's i_size check,
allowing the existing boundary handling to zero and split the folio. If
swap-in returns a smaller folio, it also splits the swap entry so the
final scan can free the entries beyond EOF. Retry the lookup if the entry
changes during swap-in.

Handling swap-in allocation failures remains broken and is unchanged by
this commit. Even when shmem_swapin_folio() correctly returns -ENOMEM
instead of -EEXIST, shmem_get_partial_folio() returns NULL and
shmem_undo_range() skips boundary handling. If the large swap entry
remains intact, truncation can still loop in the final scan, while hole
punching can return without zeroing the boundary.

This may read an entire large folio back from swap while holding
i_rwsem, only to discard part of it. Avoiding that I/O would require
splitting both the swap entry and any large folio still in the swap
cache. That, however, is much bigger work.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-11-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 90fd180c924cc..fab3f1d24550a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1089,12 +1089,10 @@ void shmem_unlock_mapping(struct address_space *mapping)
 
 static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 {
+	const gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 	struct folio *folio;
 
-	/*
-	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated folios as holes.
-	 */
+retry:
 	folio = filemap_get_entry(inode->i_mapping, index);
 	if (!folio)
 		return folio;
@@ -1105,13 +1103,14 @@ static struct folio *shmem_get_partial_folio(struct inode *inode, pgoff_t index)
 		/* The folio has been swapped out */
 		folio_unlock(folio);
 		folio_put(folio);
+		goto retry;
 	}
 	/*
-	 * But read a folio back from swap if any of it is within i_size
-	 * (although in some cases this is just a waste of time).
+	 * Truncation can look up a large swap entry at or beyond i_size.
+	 * Swap it in directly to bypass the size check in shmem_get_folio().
 	 */
-	folio = NULL;
-	shmem_get_folio(inode, index, 0, &folio, SGP_READ);
+	if (shmem_swapin_folio(inode, index, &folio, SGP_READ, gfp, NULL, NULL) == -EEXIST)
+		goto retry;
 	return folio;
 }
 
-- 
2.53.0



