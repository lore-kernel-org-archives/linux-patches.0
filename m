Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0056C433E87;
	Thu,  2 Jul 2026 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011056; cv=none; b=dbje2YZat0MXOrhYdeswMHDV1V1yR2xCkUZZk9pBBGHMKD0+FF1XWRLiNUE1R/l5RujPtjjbhYhNBydOdLv6pJrm1OI+V9R4/0EmmDmy36SoAQNqtVodS+SpzwJr2WOZ9FOMBa4s3JI/hAMfhyQE0FdaAw0MSzudofIzivA627A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011056; c=relaxed/simple;
	bh=cQtassdKM0UxLa5WooRp5yedShsqgPLkrLKPA3fmu98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOFnuXYdZo2SM5+DFvM1M22c8oq7DYKe01R9Z5Jh6wAtr6a+LXIP+0jdLV4x9f9cw+15tUX70qILnzj/NMWQ7eJLdlRhmCiNcbINH2Q56Uj3taN2A8iYq76/gZvwC3WuA9sTsj5gzEGvaT51eclLAAKV9ObQahrsm9XwrTD1oGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAKgixfu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAKgixfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6473D1F000E9;
	Thu,  2 Jul 2026 16:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011054;
	bh=QSZNuKtAQcaKAljN+mHINzfKgbjCypficA0VLBKezKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAKgixfulwvKK8A7pKIylDM45bF7zY2fFNoFSXikalRzyeFk0wDTbWXidyPYrCg7p
	 Iu1wBS3Li/lTacQuEgagSmW2tHXGQOj4n1DYLVTFrkKRyCMkYyfa3bmdOwP6qZtxAd
	 GtDjCZiRc7T3lutv/iVoWZ+t+cttOjdvtKkXhqFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 137/175] f2fs: validate compress cache inode only when enabled
Date: Thu,  2 Jul 2026 18:20:38 +0200
Message-ID: <20260702155118.695982687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

commit 5073c66a96a9c23c0c2533ed4ed06e42f9021208 upstream.

F2FS_COMPRESS_INO() uses NM_I(sbi)->max_nid as the synthetic inode
number for the compressed page cache inode. That inode only exists when
the compress_cache mount option is enabled.

When compress_cache is disabled, max_nid is outside the valid inode
range. A corrupted directory entry that points to ino == max_nid should
therefore be rejected by f2fs_check_nid_range(). However, is_meta_ino()
currently treats F2FS_COMPRESS_INO() as a meta inode unconditionally,
so f2fs_iget() bypasses do_read_inode() and its nid range check, and
instantiates a fake internal inode instead.

Gate the compressed cache inode case on COMPRESS_CACHE, matching
f2fs_init_compress_inode(). With compress_cache disabled, ino ==
max_nid now follows the normal inode path and is rejected as an
out-of-range nid.

Cc: stable@kernel.org
Fixes: 6ce19aff0b8c ("f2fs: compress: add compress_inode to cache compressed blocks")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -544,8 +544,13 @@ static int do_read_inode(struct inode *i
 
 static bool is_meta_ino(struct f2fs_sb_info *sbi, unsigned int ino)
 {
-	return ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi) ||
-		ino == F2FS_COMPRESS_INO(sbi);
+	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
+		return true;
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (test_opt(sbi, COMPRESS_CACHE) && ino == F2FS_COMPRESS_INO(sbi))
+		return true;
+#endif
+	return false;
 }
 
 struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)


