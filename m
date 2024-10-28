Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DFB18EFF9;
	Mon, 28 Oct 2024 06:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097316; cv=none; b=VIWR9I6ToQLlgKhJPqBkcY+RnlNBx6wqSTmrWlcZaYktw4WyW17V93bkeNRRmhbxLndsQqD7+CecVCDU73Dg/6vTuapPlBjlRCUT+gdmZBftWKJlS1O99pzZQZv5xNgLi+KSywu7s9+SRnDWMrsruKDbfFsUCM2Ni6SqvRpmxJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097316; c=relaxed/simple;
	bh=94bVQFD41BAwdb4KSkYZq4SDExo+n1UmHdcYZUZujhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmMwiS2+qJ/6kru1DVLa7GkOgxuEP88wFOQqUpMLiEAPDtzrlfzgRZ0qS70gy2uqZOUtQQVGV0FZAfMuDNnfN73KbZAdxqJtRU0vD0vaDy3j8CjANz/vBZDyJb+SOp16ifs0R/wDIjrJC5kMlYZ79XyPBZ60Lh/wx2xSIhCkihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT3wysFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT3wysFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA7C4CEC3;
	Mon, 28 Oct 2024 06:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097316;
	bh=94bVQFD41BAwdb4KSkYZq4SDExo+n1UmHdcYZUZujhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT3wysFQutZ+DDz6/TE/gY22LO3FyIgynLph+TjUHvVOYLNoil46O14R5O6w2QM5x
	 2t+G4daXYF8EPlTR73vnnY2OzCFMPID9OjuEQaBgO3kNNO6Fwf65tbSDJ4W5cCwUh/
	 +2El8pnxcFabvZB4j12/1UuDGRNHqvxZcQUwDSeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Mengmeng <zhaomengmeng@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/137] udf: refactor udf_current_aext() to handle error
Date: Mon, 28 Oct 2024 07:25:15 +0100
Message-ID: <20241028062300.915856329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

[ Upstream commit ee703a7068f95764cfb62b57db1d36e465cb9b26 ]

As Jan suggested in links below, refactor udf_current_aext() to
differentiate between error, hit EOF and success, it now takes pointer to
etype to store the extent type, return 1 when getting etype success,
return 0 when hitting EOF and return -errno when err.

Link: https://lore.kernel.org/all/20240912111235.6nr3wuqvktecy3vh@quack3/
Signed-off-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20241001115425.266556-2-zhaomzhao@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c    | 40 ++++++++++++++++++++++++++--------------
 fs/udf/truncate.c | 10 ++++++++--
 fs/udf/udfdecl.h  |  5 +++--
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 77471e33ccf75..fac28caca356a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1838,6 +1838,7 @@ int udf_setup_indirect_aext(struct inode *inode, udf_pblk_t block,
 	struct extent_position nepos;
 	struct kernel_lb_addr neloc;
 	int ver, adsize;
+	int err = 0;
 
 	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -1882,10 +1883,12 @@ int udf_setup_indirect_aext(struct inode *inode, udf_pblk_t block,
 	if (epos->offset + adsize > sb->s_blocksize) {
 		struct kernel_lb_addr cp_loc;
 		uint32_t cp_len;
-		int cp_type;
+		int8_t cp_type;
 
 		epos->offset -= adsize;
-		cp_type = udf_current_aext(inode, epos, &cp_loc, &cp_len, 0);
+		err = udf_current_aext(inode, epos, &cp_loc, &cp_len, &cp_type, 0);
+		if (err <= 0)
+			goto err_out;
 		cp_len |= ((uint32_t)cp_type) << 30;
 
 		__udf_add_aext(inode, &nepos, &cp_loc, cp_len, 1);
@@ -1900,6 +1903,9 @@ int udf_setup_indirect_aext(struct inode *inode, udf_pblk_t block,
 	*epos = nepos;
 
 	return 0;
+err_out:
+	brelse(bh);
+	return err;
 }
 
 /*
@@ -2050,9 +2056,12 @@ int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
 {
 	int8_t etype;
 	unsigned int indirections = 0;
+	int ret = 0;
 
-	while ((etype = udf_current_aext(inode, epos, eloc, elen, inc)) ==
-	       (EXT_NEXT_EXTENT_ALLOCDESCS >> 30)) {
+	while ((ret = udf_current_aext(inode, epos, eloc, elen,
+				       &etype, inc)) > 0) {
+		if (etype != (EXT_NEXT_EXTENT_ALLOCDESCS >> 30))
+			break;
 		udf_pblk_t block;
 
 		if (++indirections > UDF_MAX_INDIR_EXTS) {
@@ -2073,14 +2082,17 @@ int8_t udf_next_aext(struct inode *inode, struct extent_position *epos,
 		}
 	}
 
-	return etype;
+	return ret > 0 ? etype : -1;
 }
 
-int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
-			struct kernel_lb_addr *eloc, uint32_t *elen, int inc)
+/*
+ * Returns 1 on success, -errno on error, 0 on hit EOF.
+ */
+int udf_current_aext(struct inode *inode, struct extent_position *epos,
+		     struct kernel_lb_addr *eloc, uint32_t *elen, int8_t *etype,
+		     int inc)
 {
 	int alen;
-	int8_t etype;
 	uint8_t *ptr;
 	struct short_ad *sad;
 	struct long_ad *lad;
@@ -2107,8 +2119,8 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 	case ICBTAG_FLAG_AD_SHORT:
 		sad = udf_get_fileshortad(ptr, alen, &epos->offset, inc);
 		if (!sad)
-			return -1;
-		etype = le32_to_cpu(sad->extLength) >> 30;
+			return 0;
+		*etype = le32_to_cpu(sad->extLength) >> 30;
 		eloc->logicalBlockNum = le32_to_cpu(sad->extPosition);
 		eloc->partitionReferenceNum =
 				iinfo->i_location.partitionReferenceNum;
@@ -2117,17 +2129,17 @@ int8_t udf_current_aext(struct inode *inode, struct extent_position *epos,
 	case ICBTAG_FLAG_AD_LONG:
 		lad = udf_get_filelongad(ptr, alen, &epos->offset, inc);
 		if (!lad)
-			return -1;
-		etype = le32_to_cpu(lad->extLength) >> 30;
+			return 0;
+		*etype = le32_to_cpu(lad->extLength) >> 30;
 		*eloc = lelb_to_cpu(lad->extLocation);
 		*elen = le32_to_cpu(lad->extLength) & UDF_EXTENT_LENGTH_MASK;
 		break;
 	default:
 		udf_debug("alloc_type = %u unsupported\n", iinfo->i_alloc_type);
-		return -1;
+		return -EINVAL;
 	}
 
-	return etype;
+	return 1;
 }
 
 static int udf_insert_aext(struct inode *inode, struct extent_position epos,
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 036ebd892b852..f0de6e106ce65 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -192,6 +192,7 @@ int udf_truncate_extents(struct inode *inode)
 	loff_t byte_offset;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	int ret = 0;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -221,8 +222,8 @@ int udf_truncate_extents(struct inode *inode)
 	else
 		lenalloc -= sizeof(struct allocExtDesc);
 
-	while ((etype = udf_current_aext(inode, &epos, &eloc,
-					 &elen, 0)) != -1) {
+	while ((ret = udf_current_aext(inode, &epos, &eloc,
+				       &elen, &etype, 0)) > 0) {
 		if (etype == (EXT_NEXT_EXTENT_ALLOCDESCS >> 30)) {
 			udf_write_aext(inode, &epos, &neloc, nelen, 0);
 			if (indirect_ext_len) {
@@ -257,6 +258,11 @@ int udf_truncate_extents(struct inode *inode)
 		}
 	}
 
+	if (ret < 0) {
+		brelse(epos.bh);
+		return ret;
+	}
+
 	if (indirect_ext_len) {
 		BUG_ON(!epos.bh);
 		udf_free_blocks(sb, NULL, &epos.block, 0, indirect_ext_len);
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index d35aa42bb5777..1d19434d4a47c 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -174,8 +174,9 @@ extern void udf_write_aext(struct inode *, struct extent_position *,
 extern int8_t udf_delete_aext(struct inode *, struct extent_position);
 extern int8_t udf_next_aext(struct inode *, struct extent_position *,
 			    struct kernel_lb_addr *, uint32_t *, int);
-extern int8_t udf_current_aext(struct inode *, struct extent_position *,
-			       struct kernel_lb_addr *, uint32_t *, int);
+extern int udf_current_aext(struct inode *inode, struct extent_position *epos,
+			    struct kernel_lb_addr *eloc, uint32_t *elen,
+			    int8_t *etype, int inc);
 extern void udf_update_extra_perms(struct inode *inode, umode_t mode);
 
 /* misc.c */
-- 
2.43.0



