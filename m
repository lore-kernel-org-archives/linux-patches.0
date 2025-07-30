Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B701E25E1;
	Wed, 30 Jul 2025 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868821; cv=none; b=G5aI8TlvlZbG31WWf56DKRR1Pvd6jL8aZ8/QvL5WnVmcj7ug7QvcE+ckySyt4uJWCxNBxV7p4SRN6L+3h7dpgCGbAw3frWDFnueY1eYdk+d095mBkp8ixJorNLajts3G9BE+gOp4g0yMyctS0vdq66yYuyN/I80s/p9hIp8SVo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868821; c=relaxed/simple;
	bh=c/4meQAkmQHxFPkZNQXcMih3R1rWC9QolGWqSPeP77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhpjSVjnrvh60V/UUOQjf1KuY196Bxz5M0ACvH+xAs7Ev1K1k0sbGoS5J6m8/ntrc4l03oLlZK6OCqhBwvjRa6/RhTn4tEjjr85upp3DS7YteXNWRIv/ACn/En98PcIQ9dQN/DNfSJYry3VT2pY4Irf+7n6ysUp70uRqNShrpbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxXRr+6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxXRr+6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE145C4CEF5;
	Wed, 30 Jul 2025 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868821;
	bh=c/4meQAkmQHxFPkZNQXcMih3R1rWC9QolGWqSPeP77Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxXRr+6TqLQoEwe5RVIc2VplhHyxctj6UhjhW2L7OeDGVmKw9fY8M2KdOWKpOL3ZH
	 sbZfpCXTlec1BaJrDrYIT2FdRKoQRzRxN4qKizFZeXxJ63ESMBaTNWh6HDjM5tWGgR
	 VbNgprt85A+LtlCSZ6YpR2bPmoDXF9DOJSRsyZmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Axel Fontaine <axel@axelfontaine.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/117] erofs: fix large fragment handling
Date: Wed, 30 Jul 2025 11:35:53 +0200
Message-ID: <20250730093237.042258210@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit b44686c8391b427fb1c85a31c35077e6947c6d90 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/internal.h |    4 +++-
 fs/erofs/zdata.c    |    2 +-
 fs/erofs/zmap.c     |    7 +++----
 3 files changed, 7 insertions(+), 6 deletions(-)

--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -324,10 +324,12 @@ static inline struct folio *erofs_grab_f
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
@@ -1016,7 +1016,7 @@ static int z_erofs_scan_folio(struct z_e
 		if (!(map->m_flags & EROFS_MAP_MAPPED)) {
 			folio_zero_segment(folio, cur, end);
 			tight = false;
-		} else if (map->m_flags & EROFS_MAP_FRAGMENT) {
+		} else if (map->m_flags & __EROFS_MAP_FRAGMENT) {
 			erofs_off_t fpos = offset + cur - map->m_la;
 
 			err = z_erofs_read_fragment(inode->i_sb, folio, cur,
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -481,7 +481,7 @@ static int z_erofs_do_map_blocks(struct
 			goto unmap_out;
 		}
 	} else if (fragment && m.lcn == vi->z_tailextent_headlcn) {
-		map->m_flags |= EROFS_MAP_FRAGMENT;
+		map->m_flags = EROFS_MAP_FRAGMENT;
 	} else {
 		map->m_pa = erofs_pos(sb, m.pblk);
 		err = z_erofs_get_extent_compressedlen(&m, initial_lcn);
@@ -644,8 +644,7 @@ int z_erofs_map_blocks_iter(struct inode
 			    !vi->z_tailextent_headlcn) {
 				map->m_la = 0;
 				map->m_llen = inode->i_size;
-				map->m_flags = EROFS_MAP_MAPPED |
-					EROFS_MAP_FULL_MAPPED | EROFS_MAP_FRAGMENT;
+				map->m_flags = EROFS_MAP_FRAGMENT;
 			} else {
 				err = z_erofs_do_map_blocks(inode, map, flags);
 			}
@@ -678,7 +677,7 @@ static int z_erofs_iomap_begin_report(st
 	iomap->length = map.m_llen;
 	if (map.m_flags & EROFS_MAP_MAPPED) {
 		iomap->type = IOMAP_MAPPED;
-		iomap->addr = map.m_flags & EROFS_MAP_FRAGMENT ?
+		iomap->addr = map.m_flags & __EROFS_MAP_FRAGMENT ?
 			      IOMAP_NULL_ADDR : map.m_pa;
 	} else {
 		iomap->type = IOMAP_HOLE;


