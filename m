Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BFC1E47A3;
	Mon, 21 Oct 2024 10:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507515; cv=none; b=R9xD9Q0z8PxktH+0B0xWz1JAwDeKHP7jSayHPZRfIF4zKhOpc3koGmdT+UMuAW5/FWxPharAYL9dMbTHXldgqOTszzpdYAApWiXbkRiaTbhl4Ck+mv5s8usu+9QhnvwbEYOTA+8YXxpw/iDL0tQPYMRRx+bpHLS9R67Z7Bqg6AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507515; c=relaxed/simple;
	bh=kBdQElYC76VAXJ0iR+h90Yq8ERJ6JOmILlOEwT8w6w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mD4510Jk7yWqSeauBOQUYe2V8llqcsHg5YoERZxTT4OJQXYoagwjCy9F0aQQqpQbLbvRFNHGNw5/v1pmPCLdVS9IDw/hWo1xDaLZcIW4Br3VICbfR8wvYixqG5+zaVs/+mYC+b0XSvl6Ff1jxM4d4ItOlHP7NRoKfvuxs2KcqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdTVx49R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdTVx49R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C0C4CEC3;
	Mon, 21 Oct 2024 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507514;
	bh=kBdQElYC76VAXJ0iR+h90Yq8ERJ6JOmILlOEwT8w6w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdTVx49RdPS0lnHVqI9g0fUa2PXUUYk4z8mvpZVPj0XFuoUqsrwccI+1leLKUlp9U
	 ny2oUZ34cqmAU4CDiKeoSBfDo99EETJd8U5MLHf2VNfeQQidffAVZ11XuEIN/tL1Mp
	 9V0gNtN4dCdTNy9ntw3WN+yA9/J4RDoNltsqjMuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 03/82] udf: Convert udf_expand_dir_adinicb() to new directory iteration
Date: Mon, 21 Oct 2024 12:24:44 +0200
Message-ID: <20241021102247.348079558@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 57bda9fb169d689bff4108265a897d324b5fb8c3 ]

Convert udf_expand_dir_adinicb() to new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   66 +++++++++++++++++++++++++--------------------------------
 1 file changed, 29 insertions(+), 37 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -330,14 +330,12 @@ struct buffer_head *udf_expand_dir_adini
 	udf_pblk_t newblock;
 	struct buffer_head *dbh = NULL;
 	struct kernel_lb_addr eloc;
-	uint8_t alloctype;
 	struct extent_position epos;
-
-	struct udf_fileident_bh sfibh, dfibh;
-	loff_t f_pos = udf_ext0_offset(inode);
-	int size = udf_ext0_offset(inode) + inode->i_size;
-	struct fileIdentDesc cfi, *sfi, *dfi;
+	uint8_t alloctype;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	struct udf_fileident_iter iter;
+	uint8_t *impuse;
+	int ret;
 
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
 		alloctype = ICBTAG_FLAG_AD_SHORT;
@@ -365,38 +363,14 @@ struct buffer_head *udf_expand_dir_adini
 	if (!dbh)
 		return NULL;
 	lock_buffer(dbh);
-	memset(dbh->b_data, 0x00, inode->i_sb->s_blocksize);
+	memcpy(dbh->b_data, iinfo->i_data, inode->i_size);
+	memset(dbh->b_data + inode->i_size, 0,
+	       inode->i_sb->s_blocksize - inode->i_size);
 	set_buffer_uptodate(dbh);
 	unlock_buffer(dbh);
-	mark_buffer_dirty_inode(dbh, inode);
-
-	sfibh.soffset = sfibh.eoffset =
-			f_pos & (inode->i_sb->s_blocksize - 1);
-	sfibh.sbh = sfibh.ebh = NULL;
-	dfibh.soffset = dfibh.eoffset = 0;
-	dfibh.sbh = dfibh.ebh = dbh;
-	while (f_pos < size) {
-		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
-		sfi = udf_fileident_read(inode, &f_pos, &sfibh, &cfi, NULL,
-					 NULL, NULL, NULL);
-		if (!sfi) {
-			brelse(dbh);
-			return NULL;
-		}
-		iinfo->i_alloc_type = alloctype;
-		sfi->descTag.tagLocation = cpu_to_le32(*block);
-		dfibh.soffset = dfibh.eoffset;
-		dfibh.eoffset += (sfibh.eoffset - sfibh.soffset);
-		dfi = (struct fileIdentDesc *)(dbh->b_data + dfibh.soffset);
-		if (udf_write_fi(inode, sfi, dfi, &dfibh, sfi->impUse,
-				 udf_get_fi_ident(sfi))) {
-			iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
-			brelse(dbh);
-			return NULL;
-		}
-	}
-	mark_buffer_dirty_inode(dbh, inode);
 
+	/* Drop inline data, add block instead */
+	iinfo->i_alloc_type = alloctype;
 	memset(iinfo->i_data + iinfo->i_lenEAttr, 0, iinfo->i_lenAlloc);
 	iinfo->i_lenAlloc = 0;
 	eloc.logicalBlockNum = *block;
@@ -407,10 +381,28 @@ struct buffer_head *udf_expand_dir_adini
 	epos.block = iinfo->i_location;
 	epos.offset = udf_file_entry_alloc_offset(inode);
 	udf_add_aext(inode, &epos, &eloc, inode->i_size, 0);
-	/* UniqueID stuff */
-
 	brelse(epos.bh);
 	mark_inode_dirty(inode);
+
+	/* Now fixup tags in moved directory entries */
+	for (ret = udf_fiiter_init(&iter, inode, 0);
+	     !ret && iter.pos < inode->i_size;
+	     ret = udf_fiiter_advance(&iter)) {
+		iter.fi.descTag.tagLocation = cpu_to_le32(*block);
+		if (iter.fi.lengthOfImpUse != cpu_to_le16(0))
+			impuse = dbh->b_data + iter.pos +
+						sizeof(struct fileIdentDesc);
+		else
+			impuse = NULL;
+		udf_fiiter_write_fi(&iter, impuse);
+	}
+	/*
+	 * We don't expect the iteration to fail as the directory has been
+	 * already verified to be correct
+	 */
+	WARN_ON_ONCE(ret);
+	udf_fiiter_release(&iter);
+
 	return dbh;
 }
 


