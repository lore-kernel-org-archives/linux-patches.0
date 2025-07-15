Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A79A2E62C9;
	Tue, 15 Jul 2025 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587031; cv=none; b=Rf0QgrlhnIrT/X2lPHWZSXr1c+vuIy8MTQdduFdgvR3591t1ns7WnrnIbMf0Chlu7C3lFqzNPiblOvNfthPOTdIXUwPrwi6t229zpKalYWmadM2ncLwy55g7cg//faZz32pYe7zP0TWpEv5Lm4uCdHIhtY/FjMB0Ifeet/kwrhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587031; c=relaxed/simple;
	bh=b9ItFOQbr7LAyezWkBoHgzKpHGljag5zvpv9hPxybNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEQB+52WTuOPvf1DHMzu5uyY+5eqAbNwK/g17H7xGMkwXukG3BR1+lMdFM2UuRPlO12oK8yZaeefjtWtslxsG5hWVNxwWSKZweeSW0Eq68DbOLl0gk+vAeaLfZi/4B6SaYDrcJt6I8qS67hyICzTIrByKbOIz6wtnaDPFY52Amk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3mf7Kb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3mf7Kb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDE6C4CEE3;
	Tue, 15 Jul 2025 13:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587031;
	bh=b9ItFOQbr7LAyezWkBoHgzKpHGljag5zvpv9hPxybNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3mf7Kb4neTYIgiQn5oRcqLYsJmgiqvnsyY941qHyx9precnTNelWslFcYvvOVJzO
	 LPNt/2EFVKQ3uFcGIJhMlAfM7Z12AE9Grx0wyaCtqHFHxExmtfb0CVqPkILOQNCDqJ
	 Df/JOEtEshTrGQKQqW+Jm5nPtRocT1EU/yqCeGpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Fontaine <axel@axelfontaine.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.15 123/192] erofs: fix large fragment handling
Date: Tue, 15 Jul 2025 15:13:38 +0200
Message-ID: <20250715130819.829144037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit b44686c8391b427fb1c85a31c35077e6947c6d90 upstream.

Fragments aren't limited by Z_EROFS_PCLUSTER_MAX_DSIZE. However, if
a fragment's logical length is larger than Z_EROFS_PCLUSTER_MAX_DSIZE
but the fragment is not the whole inode, it currently returns
-EOPNOTSUPP because m_flags has the wrong EROFS_MAP_ENCODED flag set.
It is not intended by design but should be rare, as it can only be
reproduced by mkfs with `-Eall-fragments` in a specific case.

Let's normalize fragment m_flags using the new EROFS_MAP_FRAGMENT.

Reported-by: Axel Fontaine <axel@axelfontaine.com>
Closes: https://github.com/erofs/erofs-utils/issues/23
Fixes: 7c3ca1838a78 ("erofs: restrict pcluster size limitations")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250711195826.3601157-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/internal.h |    4 +++-
 fs/erofs/zdata.c    |    2 +-
 fs/erofs/zmap.c     |    9 ++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -314,10 +314,12 @@ static inline struct folio *erofs_grab_f
 /* The length of extent is full */
 #define EROFS_MAP_FULL_MAPPED	0x0008
 /* Located in the special packed inode */
-#define EROFS_MAP_FRAGMENT	0x0010
+#define __EROFS_MAP_FRAGMENT	0x0010
 /* The extent refers to partial decompressed data */
 #define EROFS_MAP_PARTIAL_REF	0x0020
 
+#define EROFS_MAP_FRAGMENT	(EROFS_MAP_MAPPED | __EROFS_MAP_FRAGMENT)
+
 struct erofs_map_blocks {
 	struct erofs_buf buf;
 
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1003,7 +1003,7 @@ static int z_erofs_scan_folio(struct z_e
 		if (!(map->m_flags & EROFS_MAP_MAPPED)) {
 			folio_zero_segment(folio, cur, end);
 			tight = false;
-		} else if (map->m_flags & EROFS_MAP_FRAGMENT) {
+		} else if (map->m_flags & __EROFS_MAP_FRAGMENT) {
 			erofs_off_t fpos = offset + cur - map->m_la;
 
 			err = z_erofs_read_fragment(inode->i_sb, folio, cur,
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -413,8 +413,7 @@ static int z_erofs_map_blocks_fo(struct
 	    !vi->z_tailextent_headlcn) {
 		map->m_la = 0;
 		map->m_llen = inode->i_size;
-		map->m_flags = EROFS_MAP_MAPPED |
-			EROFS_MAP_FULL_MAPPED | EROFS_MAP_FRAGMENT;
+		map->m_flags = EROFS_MAP_FRAGMENT;
 		return 0;
 	}
 	initial_lcn = ofs >> lclusterbits;
@@ -489,7 +488,7 @@ static int z_erofs_map_blocks_fo(struct
 			goto unmap_out;
 		}
 	} else if (fragment && m.lcn == vi->z_tailextent_headlcn) {
-		map->m_flags |= EROFS_MAP_FRAGMENT;
+		map->m_flags = EROFS_MAP_FRAGMENT;
 	} else {
 		map->m_pa = erofs_pos(sb, m.pblk);
 		err = z_erofs_get_extent_compressedlen(&m, initial_lcn);
@@ -617,7 +616,7 @@ static int z_erofs_map_blocks_ext(struct
 	if (lstart < lend) {
 		map->m_la = lstart;
 		if (last && (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER)) {
-			map->m_flags |= EROFS_MAP_MAPPED | EROFS_MAP_FRAGMENT;
+			map->m_flags = EROFS_MAP_FRAGMENT;
 			vi->z_fragmentoff = map->m_plen;
 			if (recsz > offsetof(struct z_erofs_extent, pstart_lo))
 				vi->z_fragmentoff |= map->m_pa << 32;
@@ -797,7 +796,7 @@ static int z_erofs_iomap_begin_report(st
 	iomap->length = map.m_llen;
 	if (map.m_flags & EROFS_MAP_MAPPED) {
 		iomap->type = IOMAP_MAPPED;
-		iomap->addr = map.m_flags & EROFS_MAP_FRAGMENT ?
+		iomap->addr = map.m_flags & __EROFS_MAP_FRAGMENT ?
 			      IOMAP_NULL_ADDR : map.m_pa;
 	} else {
 		iomap->type = IOMAP_HOLE;


