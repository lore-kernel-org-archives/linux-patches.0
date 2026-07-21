Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6AF3B8412;
	Tue, 21 Jul 2026 21:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670850; cv=none; b=JQxSa65OmpNr8woyPOyBz8AvnA1gkYQWzx9ZC7h4kdL2zIVBwamW2JKaifsbp3ali7JUtNWbQT7OhN03+qEGMmLMRVTxbkkHlfPYG2tYIrXj51Sta2RZU8IM5txch6W1ViWALZQDlZ6nUmO/GYTHb1jTgufGjRinnwfzDicqIPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670850; c=relaxed/simple;
	bh=6AGYB3IjiYiCdYxJ2nOVroN6ZcLT5jjIpiNJFTDIorI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQXzRBKIA1aRHidk4M3jzmI625TO/yMi2A/inLYTU21BIju4BIHrPyKMzxfsz9qziR2Pw2aB/wnb80Nh9ZXD3yD+SeRKjZXxjNoAcvQ4rDEkQC7n0IrYw5OlhG2tW2yXhjXTdXvnk9AFCd6InMZyaNpfxMYGL51c2cEj39YMGi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8fwdssX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8fwdssX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3026F1F000E9;
	Tue, 21 Jul 2026 21:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670849;
	bh=tzlxJqf+NY/iyvqu15IyowKV5xKURDcUekn9UUvahA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8fwdssXgD8K2ACbRwcAIClbRCGthAicj9dXds8B8ngDdlE2fknoKo5K2twrrDTRo
	 hDOHP5AmqARyrDcB/CJdCwM1/r96l2ckvw9Ks+sOSpKdZ0flVOho46nY1FOMcQuey/
	 zWzMxyzZ3alCZQ1dZmO75omyS12PrHC6qfYi32EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/843] f2fs: fix to detect corrupted meta ino
Date: Tue, 21 Jul 2026 17:14:19 +0200
Message-ID: <20260721152406.507622599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit fcc2d8cc96b2f6141bbbe5b1e8953db990794b44 ]

It is possible that ino of dirent or orphan inode is corrupted in a
fuzzed image, occasionally, if corrupted ino is equal to meta ino:
meta_ino, node_ino or compress_ino, caller of f2fs_iget() from below
call paths will get meta inode directly, it's not allowed, let's
add sanity check to detect such cases.

case #1
- recover_dentry
 - __f2fs_find_entry
 - f2fs_iget_retry

case #2
- recover_orphan_inode
 - f2fs_iget_retry

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 5073c66a96a9 ("f2fs: validate compress cache inode only when enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -496,6 +496,12 @@ static int do_read_inode(struct inode *i
 	return 0;
 }
 
+static bool is_meta_ino(struct f2fs_sb_info *sbi, unsigned int ino)
+{
+	return ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
+		ino == F2FS_COMPRESS_INO(sbi);
+}
+
 struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
@@ -507,16 +513,21 @@ struct inode *f2fs_iget(struct super_blo
 		return ERR_PTR(-ENOMEM);
 
 	if (!(inode->i_state & I_NEW)) {
+		if (is_meta_ino(sbi, ino)) {
+			f2fs_err(sbi, "inaccessible inode: %lu, run fsck to repair", ino);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			ret = -EFSCORRUPTED;
+			trace_f2fs_iget_exit(inode, ret);
+			iput(inode);
+			return ERR_PTR(ret);
+		}
+
 		trace_f2fs_iget(inode);
 		return inode;
 	}
-	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
-		goto make_now;
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
-	if (ino == F2FS_COMPRESS_INO(sbi))
+	if (is_meta_ino(sbi, ino))
 		goto make_now;
-#endif
 
 	ret = do_read_inode(inode);
 	if (ret)


