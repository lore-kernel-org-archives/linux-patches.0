Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588EC51B190;
	Wed, 30 Sep 2026 17:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789807; cv=none; b=ti+pUEwYmiZ459IG2Q/NmI1Pxh26ds2EiHmZU8UoWxapVHv84YKFjmtt3Qqep4R6PAWW/un3qz2WMzFg+2o6gmdx7jpQUdbNH+i8FV7SsrnJI7bcorjY+ozWbHwggXNTOK+OeccUoIJZ0bl9yMUKZHjSdZwGEixzfDeaZZ0i984=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789807; c=relaxed/simple;
	bh=XNGXDk1UPZt11IsJg7FP70sRhPjc0O5ZKWz1UNZ6PQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSdtSxo1OjwgMJvVQ3H13qsbZn9ulpLiaJNZh1yrqQGwv2FzAQZGHfDan2hlRaku0GwiGiFFvHXufno4vuCC3joZ4LFYF1xxRqmaQPbLo/6zymdabNSzkmRkJqhpiCyJKUXTS5BsWRF2ZLqmD8cCcpelt9s7+vVGS2sKidbLAQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTqs9qn2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTqs9qn2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35F11F000FF;
	Wed, 30 Sep 2026 17:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789806;
	bh=FRk1OV4bsFec6cRooyoxD16fCgjrRnzDTLSYk32Resg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTqs9qn2YOHbHAeZKfpnnkWwEGFvGJEhBsOdYOBhEC4oFC2d4gDRo5FIwXzjvKRO/
	 ni5U519DhDzet+0QidsGLKdh0D5tTLJ2nHfhaIF929z0M6Ylh+2+TMluIoi/0JWymm
	 U6pb6V2+BX/PorRhs2ONBoGGapx5ZcKt32u8bSmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 608/877] udf: Move udf_map_block() up
Date: Wed, 30 Sep 2026 17:25:19 +0200
Message-ID: <20260930152427.776379456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 97e9d759a4193eabe4d8b6ecac093aac664c16e3 ]

Move udf_map_block() in the file to avoid forward declarations.

Link: https://patch.msgid.link/20260730104232.4086759-3-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Stable-dep-of: 62333e480d12 ("udf: Fix data loss when converting inline inodes to out of line")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |  118 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -330,65 +330,6 @@ const struct address_space_operations ud
 	.migrate_folio	= buffer_migrate_folio,
 };
 
-/*
- * Expand file stored in ICB to a normal one-block-file
- *
- * This function requires i_mutex held
- */
-int udf_expand_file_adinicb(struct inode *inode)
-{
-	struct folio *folio;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-	int err;
-
-	WARN_ON_ONCE(!inode_is_locked(inode));
-	if (!iinfo->i_lenAlloc) {
-		down_write(&iinfo->i_data_sem);
-		if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-			iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
-		else
-			iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
-		up_write(&iinfo->i_data_sem);
-		mark_inode_dirty(inode);
-		return 0;
-	}
-
-	folio = __filemap_get_folio(inode->i_mapping, 0,
-			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
-	if (IS_ERR(folio))
-		return PTR_ERR(folio);
-
-	if (!folio_test_uptodate(folio))
-		udf_adinicb_read_folio(folio);
-	down_write(&iinfo->i_data_sem);
-	memset(iinfo->i_data + iinfo->i_lenEAttr, 0x00,
-	       iinfo->i_lenAlloc);
-	iinfo->i_lenAlloc = 0;
-	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
-	else
-		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
-	folio_mark_dirty(folio);
-	folio_unlock(folio);
-	up_write(&iinfo->i_data_sem);
-	err = filemap_fdatawrite(inode->i_mapping);
-	if (err) {
-		/* Restore everything back so that we don't lose data... */
-		folio_lock(folio);
-		down_write(&iinfo->i_data_sem);
-		memcpy_from_folio(iinfo->i_data + iinfo->i_lenEAttr,
-				folio, 0, inode->i_size);
-		folio_unlock(folio);
-		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
-		iinfo->i_lenAlloc = inode->i_size;
-		up_write(&iinfo->i_data_sem);
-	}
-	folio_put(folio);
-	mark_inode_dirty(inode);
-
-	return err;
-}
-
 #define UDF_MAP_CREATE		0x01	/* Mapping can allocate new blocks */
 #define UDF_MAP_NOPREALLOC	0x02	/* Do not preallocate blocks */
 
@@ -449,6 +390,65 @@ out_read:
 	return ret;
 }
 
+/*
+ * Expand file stored in ICB to a normal one-block-file
+ *
+ * This function requires i_mutex held
+ */
+int udf_expand_file_adinicb(struct inode *inode)
+{
+	struct folio *folio;
+	struct udf_inode_info *iinfo = UDF_I(inode);
+	int err;
+
+	WARN_ON_ONCE(!inode_is_locked(inode));
+	if (!iinfo->i_lenAlloc) {
+		down_write(&iinfo->i_data_sem);
+		if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
+			iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
+		else
+			iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+		up_write(&iinfo->i_data_sem);
+		mark_inode_dirty(inode);
+		return 0;
+	}
+
+	folio = __filemap_get_folio(inode->i_mapping, 0,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+
+	if (!folio_test_uptodate(folio))
+		udf_adinicb_read_folio(folio);
+	down_write(&iinfo->i_data_sem);
+	memset(iinfo->i_data + iinfo->i_lenEAttr, 0x00,
+	       iinfo->i_lenAlloc);
+	iinfo->i_lenAlloc = 0;
+	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
+	else
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+	folio_mark_dirty(folio);
+	folio_unlock(folio);
+	up_write(&iinfo->i_data_sem);
+	err = filemap_fdatawrite(inode->i_mapping);
+	if (err) {
+		/* Restore everything back so that we don't lose data... */
+		folio_lock(folio);
+		down_write(&iinfo->i_data_sem);
+		memcpy_from_folio(iinfo->i_data + iinfo->i_lenEAttr,
+				folio, 0, inode->i_size);
+		folio_unlock(folio);
+		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
+		iinfo->i_lenAlloc = inode->i_size;
+		up_write(&iinfo->i_data_sem);
+	}
+	folio_put(folio);
+	mark_inode_dirty(inode);
+
+	return err;
+}
+
 static int __udf_get_block(struct inode *inode, sector_t block,
 			   struct buffer_head *bh_result, int flags)
 {


