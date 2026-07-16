Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D73009E2;
	Thu, 16 Jul 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210866; cv=none; b=keG9N1qR753RPNyEYJ2jqPJVDzzO2kar+ihG0judU14998oh0qyOJ7gbz4VJ4RXrMOGPoBGy+h6mqaeTvdWZsu3h5woqm7UHVdmExf9SfaauAJtA3zP0/NRF6SaQ2qtlMgYMNoJeCFMY0jEDmsrX7kY9L7KuHiKorYkzG572vpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210866; c=relaxed/simple;
	bh=SVhh6V4h92jaH6+geNLKW17a/XbIeHQ3NXZd0lmzYDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsQddsX1c8QEhMCZh3J/wMlUKw1t4HkUazgSPpcyPan4/FVOoKI13INsQy7va/IL/wHFxoh8xmg/iWzZR2GoFHoYbSya0+XwpF2joj/WAqbgw6G08ehBw+xIwov6hmOBv7Z409meAFKNQdSLmGsSKWbdlBXyF1LIU24eWnmyAlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLqiWrum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLqiWrum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA66D1F000E9;
	Thu, 16 Jul 2026 14:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210865;
	bh=Lnq2tVdsU8uklMx0C8XBNMA3JG137636WcQsmN3I3Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLqiWrumlajfsVl6HYUhVJmqOwfd0XChi1n9XGb2K7vUUpgh3QzbGLi1Rra044jRs
	 nF98vjIjGdORzPB4lm/ehcdrJxP9WWwvYdWWnuAzrkh+pyjFB6o/z1/xRvQIQriaRl
	 KpBeANxZmIS8p0avlmw78U2WcI1jRuM4XNZ/L0x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/480] fs/ntfs3: rename ni_readpage_cmpr into ni_read_folio_cmpr
Date: Thu, 16 Jul 2026 15:29:17 +0200
Message-ID: <20260716133049.273194611@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 4248f563f0b76f3fb74b2a28ee068bf66fcbbedf ]

The old "readpage" naming is still used in ni_readpage_cmpr(), even though
the vfs has transitioned to the folio-based read_folio() API.

This patch performs a straightforward renaming of the helper:
ni_readpage_cmpr() -> ni_read_folio_cmpr().

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 8 ++++----
 fs/ntfs3/inode.c   | 2 +-
 fs/ntfs3/ntfs_fs.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 295f6936a3e588..480f2ed518a783 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2046,18 +2046,18 @@ static struct page *ntfs_lock_new_page(struct address_space *mapping,
 }
 
 /*
- * ni_readpage_cmpr
+ * ni_read_folio_cmpr
  *
  * When decompressing, we typically obtain more than one page per reference.
  * We inject the additional pages into the page cache.
  */
-int ni_readpage_cmpr(struct ntfs_inode *ni, struct folio *folio)
+int ni_read_folio_cmpr(struct ntfs_inode *ni, struct folio *folio)
 {
 	int err;
 	struct ntfs_sb_info *sbi = ni->mi.sbi;
 	struct address_space *mapping = folio->mapping;
-	pgoff_t index = folio->index;
-	u64 frame_vbo, vbo = (u64)index << PAGE_SHIFT;
+	pgoff_t index;
+	u64 frame_vbo, vbo = folio_pos(folio);
 	struct page **pages = NULL; /* Array of at most 16 pages. stack? */
 	u8 frame_bits;
 	CLST frame;
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 205baa791f998e..0cf2898334f33b 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -736,7 +736,7 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 
 	if (is_compressed(ni)) {
 		ni_lock(ni);
-		err = ni_readpage_cmpr(ni, folio);
+		err = ni_read_folio_cmpr(ni, folio);
 		ni_unlock(ni);
 		return err;
 	}
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 2649fbe16669de..a4466e9641f65d 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -567,7 +567,7 @@ int ni_write_inode(struct inode *inode, int sync, const char *hint);
 #define _ni_write_inode(i, w) ni_write_inode(i, w, __func__)
 int ni_fiemap(struct ntfs_inode *ni, struct fiemap_extent_info *fieinfo,
 	      __u64 vbo, __u64 len);
-int ni_readpage_cmpr(struct ntfs_inode *ni, struct folio *folio);
+int ni_read_folio_cmpr(struct ntfs_inode *ni, struct folio *folio);
 int ni_decompress_file(struct ntfs_inode *ni);
 int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 		  u32 pages_per_frame);
-- 
2.53.0



