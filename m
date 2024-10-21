Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D9F1EABAE;
	Mon, 21 Oct 2024 10:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507249; cv=none; b=YRgj3IVCRU89gp2+6IYLsHpDxIhEQ9F0vagr4jyOlabW2B1q1I+9wszzChkJae2N0EPNUVlzjYbuV2jjPEh1s1I01k0FaiPe8pJknXN4EwJUF+HYFRqZBDo0TwmvnmIfV+3SvbOza6oBji83JHO2MZJYUAk5MeBfkdGZO1AE5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507249; c=relaxed/simple;
	bh=zL0yRcE/JOkd7dKFYEfQO2/CTMFt3oz6xpLnCsdnbEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ6x4v19b2J+5f0nU+hzLu/ZpbUFVrccugw103443kuE/AN/oDaABXP9l5r6mGW1Sasv2z6c0YqyXhrKMmjVxMDpqx/jUPP/RWfix2ySlHo4yRTu6jb0NdLdqNPzprSG6hVMhVH7oGf+oDdO1NUSKWSA2WAQa8gWR0uXIirQ1f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JU0Hu42X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JU0Hu42X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C592C4AF09;
	Mon, 21 Oct 2024 10:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507249;
	bh=zL0yRcE/JOkd7dKFYEfQO2/CTMFt3oz6xpLnCsdnbEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU0Hu42XVc577ED5N4cMQoJrmyBIyW3oVa/8yKyfpQiVB6ZO1uo5TBxhxtIRcRGBt
	 6BQmgmez+h3O/oMQIl7COvSDopbpjxNQSNe/Ve7FMVozbzoLf4F6FyVetsrzbVwgH2
	 ufAj0sVaz0iTGd5V42ShK+7W71ZYnW+OYSJNSUDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 15/91] udf: Convert empty_dir() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:29 +0200
Message-ID: <20241021102250.405610644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit afb525f466f9fdc140b975221cb43fbb5c59314e ]

Convert empty_dir() to new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   68 +++++++--------------------------------------------------
 1 file changed, 9 insertions(+), 59 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -879,69 +879,19 @@ out:
 
 static int empty_dir(struct inode *dir)
 {
-	struct fileIdentDesc *fi, cfi;
-	struct udf_fileident_bh fibh;
-	loff_t f_pos;
-	loff_t size = udf_ext0_offset(dir) + dir->i_size;
-	udf_pblk_t block;
-	struct kernel_lb_addr eloc;
-	uint32_t elen;
-	sector_t offset;
-	struct extent_position epos = {};
-	struct udf_inode_info *dinfo = UDF_I(dir);
+	struct udf_fileident_iter iter;
+	int ret;
 
-	f_pos = udf_ext0_offset(dir);
-	fibh.soffset = fibh.eoffset = f_pos & (dir->i_sb->s_blocksize - 1);
-
-	if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		fibh.sbh = fibh.ebh = NULL;
-	else if (inode_bmap(dir, f_pos >> dir->i_sb->s_blocksize_bits,
-			      &epos, &eloc, &elen, &offset) ==
-					(EXT_RECORDED_ALLOCATED >> 30)) {
-		block = udf_get_lb_pblock(dir->i_sb, &eloc, offset);
-		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
-			if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
-				epos.offset -= sizeof(struct short_ad);
-			else if (dinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
-				epos.offset -= sizeof(struct long_ad);
-		} else
-			offset = 0;
-
-		fibh.sbh = fibh.ebh = udf_tread(dir->i_sb, block);
-		if (!fibh.sbh) {
-			brelse(epos.bh);
-			return 0;
-		}
-	} else {
-		brelse(epos.bh);
-		return 0;
-	}
-
-	while (f_pos < size) {
-		fi = udf_fileident_read(dir, &f_pos, &fibh, &cfi, &epos, &eloc,
-					&elen, &offset);
-		if (!fi) {
-			if (fibh.sbh != fibh.ebh)
-				brelse(fibh.ebh);
-			brelse(fibh.sbh);
-			brelse(epos.bh);
-			return 0;
-		}
-
-		if (cfi.lengthFileIdent &&
-		    (cfi.fileCharacteristics & FID_FILE_CHAR_DELETED) == 0) {
-			if (fibh.sbh != fibh.ebh)
-				brelse(fibh.ebh);
-			brelse(fibh.sbh);
-			brelse(epos.bh);
+	for (ret = udf_fiiter_init(&iter, dir, 0);
+	     !ret && iter.pos < dir->i_size;
+	     ret = udf_fiiter_advance(&iter)) {
+		if (iter.fi.lengthFileIdent &&
+		    !(iter.fi.fileCharacteristics & FID_FILE_CHAR_DELETED)) {
+			udf_fiiter_release(&iter);
 			return 0;
 		}
 	}
-
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-	brelse(epos.bh);
+	udf_fiiter_release(&iter);
 
 	return 1;
 }


