Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A177015278E;
	Thu, 16 Jul 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210377; cv=none; b=qewlttrhhBsHJvUGwRmLpRQ6K7e7BxQuV3Xwn6dfhv85bkgMI4ITd4FUFrjWgsElRdKydQxTX8F2OpmpuVWWU34CpPyyin5mrw3/QLKwcDO6qVg96+2miT+QhWA+WDAnE7lTLKz5Kp1odc9M9PL6VxXcc8rR2FQoyTd1mIMSed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210377; c=relaxed/simple;
	bh=D+qUXH6uHZyJR3WY1robn5rZGBBEqQphroqLSL4NTEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8JKXD6cXqO2GkolA7lIoOSVcEsuzQH3fhzhUgkExZ/S42AIvfkuVzxuRSuv26J1PIaOnbuKaZyfRMjggMeV35PJ7YFbh/eIXYlNDhuCFVlYiAAIgGVTPaV1v2z0ZPGYrEsgK4m6Tqlrqx7IY2N3hnE3WJmYgZ+6xDWqgugkCL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ToXXsNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ToXXsNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 185321F000E9;
	Thu, 16 Jul 2026 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210376;
	bh=RyhsPNNxAWVx3bnLMPG9AiYVKrythEkPtsUqFgNXgjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ToXXsNz/pW7dJRYA5dINiHoUuMdUhM48qnIpAJQF/KP5gjb9kAph7GYT5u16BDe4
	 pdai732mvc04tizo2slB9syXYudflF8JCH27JcU55MKDJq8TYMmZgJsWX+dQggtcc5
	 TRjt8l5WiYELBX5pUGy7XX68hCj00cn1vtINyfSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Song Liu <song@kernel.org>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregg Leventhal <gleventhal@janestreet.com>,
	Lance Yang <lance.yang@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/480] mm/khugepaged: write all dirty file folios when collapsing
Date: Thu, 16 Jul 2026 15:26:11 +0200
Message-ID: <20260716133045.219157138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Pedro Falcato <pfalcato@suse.de>

[There is no upstream commit, as this code was removed by upstream
 commit 044925f9b565 ("mm: fs: remove filemap_nr_thps*() functions and their users")]

As-is, khugepaged and writable-file opening exclude each other. A file
cannot be open writeable and have THPs (because the filesystem is not aware
of them). khugepaged will never collapse file pages for files that are
opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
particular file is dropped. This is fine because nothing could've been
dirtied.

However, there is an edge-case: collapse_file() might not be able to
coexist with concurrent writers, but it can coexist with dirty folios
(from previous writers). Therefore, the following can happen:

open(file, O_RDWR)
write(file)
close(file)
madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
open(file, O_RDWR)
 nr_thps > 0
  truncate_inode_pages()
    /* THPs are cleared out, but so are the dirty folios */

When this edge-case happens, there is data loss, as the dirty folios are
fully discarded.

Fix it by fully writing back the page cache (and waiting) when collapsing
file THPs. Doing so provides the guarantee that no dirty folio will be
observed while there are active THPs. To fully ensure this is safe, the
invalidate_lock needs to be held while doing the writeout, so that
do_dentry_open()'s page cache truncation excludes this write-and-wait.

As a side effect, move the nr_thps counter bumping outside the i_pages
lock. This is correct since the counter itself is an atomic_t and the
producer <-> consumer correctness is provided by a full memory barrier:
smp_mb() in collapse_file()/memory barrier implied by full ordering in
get_write_access() -> atomic_inc_unless_negative().

Cc: stable@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <song@kernel.org>
Cc: Eric Hagberg <ehagberg@janestreet.com>
Cc: Zi Yan <ziy@nvidia.com>
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
Tested-by: Zi Yan <ziy@nvidia.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3dcd884c844e8f..01a5d443ffc586 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2077,32 +2077,43 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto xa_unlocked;
 	}
 
-	if (!is_shmem) {
+xa_locked:
+	xas_unlock_irq(&xas);
+xa_unlocked:
+
+	/*
+	 * If collapse is successful, flush must be done now before copying.
+	 * If collapse is unsuccessful, does flush actually need to be done?
+	 * Do it anyway, to clear the state.
+	 */
+	try_to_unmap_flush();
+
+	if (result == SCAN_SUCCEED && !is_shmem && !mapping_large_folio_support(mapping)) {
+		/*
+		 * invalidate_lock as shared excludes against concurrent opens
+		 * in do_dentry_open() truncating the page cache. This is
+		 * particularly important if there are dirty folios in transit.
+		 */
+		filemap_invalidate_lock_shared(mapping);
 		filemap_nr_thps_inc(mapping);
 		/*
 		 * Paired with the fence in do_dentry_open() -> get_write_access()
 		 * to ensure i_writecount is up to date and the update to nr_thps
 		 * is visible. Ensures the page cache will be truncated if the
-		 * file is opened writable.
+		 * file is opened writable. If collapse looks to be successful,
+		 * flush any dirty pages out the page cache. With the nr_thps
+		 * incremented, there won't be any new writers (nor new dirties).
 		 */
 		smp_mb();
-		if (inode_is_open_for_write(mapping->host)) {
+		if (inode_is_open_for_write(mapping->host) || filemap_write_and_wait(mapping)) {
 			result = SCAN_FAIL;
 			filemap_nr_thps_dec(mapping);
+			filemap_invalidate_unlock_shared(mapping);
+			goto rollback;
 		}
+		filemap_invalidate_unlock_shared(mapping);
 	}
 
-xa_locked:
-	xas_unlock_irq(&xas);
-xa_unlocked:
-
-	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
-	 */
-	try_to_unmap_flush();
-
 	if (result == SCAN_SUCCEED && nr_none &&
 	    !shmem_charge(mapping->host, nr_none))
 		result = SCAN_FAIL;
-- 
2.53.0



