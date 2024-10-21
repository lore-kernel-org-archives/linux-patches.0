Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C276D1E47C9;
	Mon, 21 Oct 2024 10:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507261; cv=none; b=AmEE5p8I6Y6fbpPzw+yXLlIcY4nLkVC5l63AkDWUFucYVGqW+1H1qzHRvLoX8YYE3SpAk9jiXPeax35746lGti9FMhfcn//ULrrnzIbJTAXrehyRi+JLSbfE5AYW9z0YgEy1Dpsksf2Tc9wP9ZeIo7aUpoDaySfTyoO34fmpFLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507261; c=relaxed/simple;
	bh=8OQO+ffJJ98mvuCy/F3bo5xvAKVSeJBonoZNh6TFEJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwAon01h5Wdd4htfkKpNIJ+qoYsM4aLUO/Omk8CrYEBhP0iocsGfiAKKZszQWVFpa2JJiT9F93xjEBpzyTIePITi5ykOxNzL8Y0BGhmFj1WAUOa7B9FNojC363i78AwLHT1yRYQxMggSVHxdKpGVjqBi/Finhb+/NGsTJdlpcKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mU1NYpRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mU1NYpRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC1FC4CEC3;
	Mon, 21 Oct 2024 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507261;
	bh=8OQO+ffJJ98mvuCy/F3bo5xvAKVSeJBonoZNh6TFEJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mU1NYpRRqIt4nOO6/aMiB0qVvIOw/ytu9GIcBA+boXIPVHJCvwKaeldnaX8DbEyGq
	 NB3Sgzd27ohjKkB29wS3mgVIAyStxJjjZQCOzRevRF/meb9ibTvWbVs+DHa+MsJjlo
	 f+KycisO75uYso1kvyoN5bWZGahXw7Mo8JjyVLnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 19/91] udf: Convert udf_add_nondir() to new directory iteration
Date: Mon, 21 Oct 2024 12:24:33 +0200
Message-ID: <20241021102250.565257790@linuxfoundation.org>
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

[ Upstream commit ef91f9998bece00cf7f82ad26177f910a7124b25 ]

Convert udf_add_nondir() to new directory iteration code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -847,26 +847,23 @@ static int udf_add_nondir(struct dentry
 {
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct inode *dir = d_inode(dentry->d_parent);
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc cfi, *fi;
+	struct udf_fileident_iter iter;
 	int err;
 
-	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
-	if (unlikely(!fi)) {
+	err = udf_fiiter_add_entry(dir, dentry, &iter);
+	if (err) {
 		inode_dec_link_count(inode);
 		discard_new_inode(inode);
 		return err;
 	}
-	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
-	*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+	iter.fi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
+	iter.fi.icb.extLocation = cpu_to_lelb(iinfo->i_location);
+	*(__le32 *)((struct allocDescImpUse *)iter.fi.icb.impUse)->impUse =
 		cpu_to_le32(iinfo->i_unique & 0x00000000FFFFFFFFUL);
-	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
+	udf_fiiter_write_fi(&iter, NULL);
 	dir->i_ctime = dir->i_mtime = current_time(dir);
 	mark_inode_dirty(dir);
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
+	udf_fiiter_release(&iter);
 	d_instantiate_new(dentry, inode);
 
 	return 0;


