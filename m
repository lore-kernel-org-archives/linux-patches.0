Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C413AF666;
	Sat, 17 Oct 2026 16:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255779; cv=none; b=V+p53GFbXs1/gRSu6L9MjiZ0MM9b9P5t/kAmeQaPOpgsak9WVfZORO6XIE3Nr5odR4JPdYKChOAPnUhv93v8Zn3ANnkA1WUG5erIuBHi8wNWwnqUsfL77FHa5bwqMcH2xLOowevU6aBZnqR5ojpfQN6wkCbVkcgvEP5XAlloT+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255779; c=relaxed/simple;
	bh=AmbM5Z5dcfv0eV1yMDRxaxZ5e2IKSiUtHUmzbHbO2ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SE9VoQRIZ7BaJiZMUznOBGJJqjjlK4pVWiFZhdLkh7vqMRku2DFxoba4vp2qK5h1TAX1sKEEESkyXpxrHMfsn3T59PRI1M3ail9L8ZtYYMvGnUTTzLfndbuV1ppuo0V3vHjHzb70WNytMLlpFzI3tJ3kUvV7SbJ7J0qhYseCw+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCZtT8zj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCZtT8zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2331F000C4;
	Sat, 17 Oct 2026 16:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255777;
	bh=z2XTZ69HTyf0cUyB8+bTCfKp6egsz9abjbVyy0xPZnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCZtT8zjI2E2pG035bzMhriJ+PDGn/5xb6zHcSrYZbsvSHUEkN8w8FflfeFgECc9f
	 HyAXgiu2f5fsT96YuVT/IfSSW8zco35LRnIL0LbPW3XBTPMuMhcBRAJSTmKrSdwJhH
	 j/vABEAmnF0v5N/Scdk89I/ibWiHSBEtyedyZwXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0019/1674] udf: Fix data loss when converting inline inodes to out of line
Date: Sat, 17 Oct 2026 17:38:11 +0200
Message-ID: <20261017160431.634716678@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 62333e480d12ab186f89fe2725b372d12f72d5eb ]

When udf_expand_file_adinicb() converts file from inline format to out
of line, we use filemap_fdatawrite() to writeout the data to the new
blocks. However since 36580ed08776 ("udf: Do not allocate blocks on page
writeback") the writeback actually doesn't allocate the new block and
the folio dirty bit is just silently cleared. Thus unless the file is
written to after the conversion (as it can easily happen in case of
truncate up), the data is just lost. Fix the problem by explicitely
allocating the block underlying the data before starting writeback.

Fixes: 36580ed08776 ("udf: Do not allocate blocks on page writeback")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20260730104232.4086759-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
[ adjusted mapping declarations to accommodate the branch’s older udf_map_block() function order. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6e40689845bc3..d1bed7927c2f9 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -48,13 +48,25 @@
 #define FE_DELETE_PERMS	(FE_PERM_U_DELETE | FE_PERM_G_DELETE | \
 			 FE_PERM_O_DELETE)
 
-struct udf_map_rq;
+#define UDF_MAP_CREATE		0x01	/* Mapping can allocate new blocks */
+#define UDF_MAP_NOPREALLOC	0x02	/* Do not preallocate blocks */
+
+#define UDF_BLK_MAPPED	0x01	/* Block was successfully mapped */
+#define UDF_BLK_NEW	0x02	/* Block was freshly allocated */
+
+struct udf_map_rq {
+	sector_t lblk;
+	udf_pblk_t pblk;
+	int iflags;		/* UDF_MAP_ flags determining behavior */
+	int oflags;		/* UDF_BLK_ flags reporting results */
+};
 
 static umode_t udf_convert_permissions(struct fileEntry *);
 static int udf_update_inode(struct inode *, int);
 static int udf_sync_inode(struct inode *inode);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static int inode_getblk(struct inode *inode, struct udf_map_rq *map);
+static int udf_map_block(struct inode *inode, struct udf_map_rq *map);
 static int udf_insert_aext(struct inode *, struct extent_position,
 			   struct kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, udf_pblk_t,
@@ -343,6 +355,10 @@ int udf_expand_file_adinicb(struct inode *inode)
 {
 	struct folio *folio;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	struct udf_map_rq map = {
+		.lblk = 0,
+		.iflags = UDF_MAP_CREATE,
+	};
 	int err;
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
@@ -372,20 +388,27 @@ int udf_expand_file_adinicb(struct inode *inode)
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+	up_write(&iinfo->i_data_sem);
+
+	/* Allocate the block underlying the data */
+	err = udf_map_block(inode, &map);
+	if (err < 0)
+		goto restore;
+
 	folio_mark_dirty(folio);
 	folio_unlock(folio);
-	up_write(&iinfo->i_data_sem);
 	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		folio_lock(folio);
+restore:
 		down_write(&iinfo->i_data_sem);
 		memcpy_from_folio(iinfo->i_data + iinfo->i_lenEAttr,
 				folio, 0, inode->i_size);
-		folio_unlock(folio);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
+		folio_unlock(folio);
 	}
 	folio_put(folio);
 	mark_inode_dirty(inode);
@@ -393,19 +416,6 @@ int udf_expand_file_adinicb(struct inode *inode)
 	return err;
 }
 
-#define UDF_MAP_CREATE		0x01	/* Mapping can allocate new blocks */
-#define UDF_MAP_NOPREALLOC	0x02	/* Do not preallocate blocks */
-
-#define UDF_BLK_MAPPED	0x01	/* Block was successfully mapped */
-#define UDF_BLK_NEW	0x02	/* Block was freshly allocated */
-
-struct udf_map_rq {
-	sector_t lblk;
-	udf_pblk_t pblk;
-	int iflags;		/* UDF_MAP_ flags determining behavior */
-	int oflags;		/* UDF_BLK_ flags reporting results */
-};
-
 static int udf_map_block(struct inode *inode, struct udf_map_rq *map)
 {
 	int ret;
-- 
2.53.0



