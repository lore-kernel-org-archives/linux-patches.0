Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585553;
	b=xGnFdNGHIrMfCB72Vvr/sHQ23LGdWe0UMUUo0YSUtziDPAkxjXi3XpMbHaoVX75PnN8t
	 tbQjDocCejKXaXhYM9QRDiaXkbAB+Dt5W7rP/5Qq5m6Han7LFC8eevEC1vG0Cq5b5/nfU
	 j4p2nyDqNoZl7RQ+V/fsAuN+AgPbQZv6CBRvxk2a5kuXyyYbpBL/k8tRgurOeL1/aamc/
	 F8K7NkVCe205OQvaT9DLnnPA7gt3tVQRSP9uAdzk9Yo+WmcNGGhBWHFmarJLzDtWbvdBi
	 wdkVJZCmIxtz6vmXAf7wjHvYPY6IwtsqcobC3ID1Yi4APnclrmmtwPp2m6XPxD5tebQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jrfg3epoNe9Td/CGn9e3hVbz/ccPYuE/a1DrdyNU740=;
	b=hv2dYm3OvS5beuHnevVY6MtbwTD8m1PBArZwtFPIdNEOQsNgrs/XpD6U369clhrP+Lmi
	 FzC4DRDbIet+iJW+Nb0I5XYo5MeI9/YWw4jbxE5pIunNd+lFJM0EiIoBYAG1dcPKOY+Kc
	 dehTZDOVfrbhwItI6LYbVZXfvYD5Oobj733aWld55CwKAwd1CH/Waa19wK4yvLLs3NxxL
	 RZERTR0l8LGZ+9FLjHw3EOW3cAUuNT1M4O2dFkFLLTUycZChArFLUnQDzSo9ZBWXTHwn4
	 5nunlHjVUN/kBqzuly3iGpkldT1flnWHD5Dj4/Gr8YQEsuCfHo9lIJBXOmrdn87aOIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ng1UR7m+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5959C606BA8F;
	Fri, 13 Nov 2026 15:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ng1UR7m+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B01F000C9;
	Fri, 13 Nov 2026 15:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585553;
	bh=jrfg3epoNe9Td/CGn9e3hVbz/ccPYuE/a1DrdyNU740=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng1UR7m+STmHh2OLHUMCEV9cyoJJGSK0ZVGQAjqL9V6dB8q3kK9nyt7A9LYmwMnO9
	 CiTGWQVSUxO1B6Tm4uzfUQMIkBcbF7chI2goQ2FraS2Ohk+ztAoANRublMT8qwDDc9
	 6qjoGrsOqTElIZMxHB5ajlDkDxfou04konLtyxWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Rik van Riel <riel@surriel.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 149/507] mm/truncate: look again if a folio left the mapping
Date: Fri, 13 Nov 2026 10:47:33 -0500
Message-ID: <20261113153759.483075383@linuxfoundation.org>
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

[ Upstream commit 9cf632e139737314afa889ca18122bc3fddb9120 ]

invalidate_inode_pages2_range() skips a folio which no longer belongs to
the mapping by the time it has got the folio lock, on the assumption
that somebody else has removed it from the page cache. But the folio may
have been replaced, and then there is a new folio with the same data at
that index.

For most cases, like folio migration, that is impossible. However,
collapse_file() only checks the refcount of the old folios, under the
i_pages lock, and relies on their folio locks from there on. That works for
users which repeat the lookup when they find folio->mapping changed.
The following scenario is, however, possible:

  CPU0 pwrite(O_DIRECT)               CPU1 collapse_file()
  kiocb_invalidate_pages()
                                      read the folio (old data), lock it
                                      refcount check
  the write completes                 copy to new_folio
  kiocb_invalidate_post_direct_write()
    find_get_entries() -> old folio
                                      xas_store(new_folio)
                                      folio->mapping = NULL
                                      folio_unlock(folio)
    folio_lock()
    folio->mapping != mapping
      -> continue

In that scenario, the collapsed folio with the data from before the write
stays in the page cache after the write has returned.

This used to be impossible, as khugepaged only collapsed files that nobody
had open for writing.

Restart the lookup at that index, like shmem_undo_range() does. The same
problem seems to exist in truncate_inode_pages_range() as well when
truncate_inode_folio() fails, so handle it there as well, but slightly
differently: simply check once more through find_get_entries().

Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-5-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/truncate.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 29782aced8bad..b7c5d3384748c 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -436,8 +436,11 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		}
 	}
 
+	if (start >= end)
+		return;
+
 	index = start;
-	while (index < end) {
+	while (true) {
 		cond_resched();
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
@@ -460,6 +463,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			folio_lock(folio);
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
+			/* Do not handle errors, we'll do another lookup */
 			truncate_inode_folio(mapping, folio);
 			folio_unlock(folio);
 		}
@@ -721,7 +725,12 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 			folio_lock(folio);
 			if (unlikely(folio->mapping != mapping)) {
 				folio_unlock(folio);
-				continue;
+				/*
+				 * Folio might have been replaced: look up
+				 * again.
+				 */
+				index = indices[i];
+				break;
 			}
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
-- 
2.53.0



