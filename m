Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D420318EC1;
	Thu,  2 Jul 2026 17:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011605; cv=none; b=KE7fRnOh8sKDVPDZS8+aL88oUzxzVxHsdEWr1QNn5qAKsys4WNy2TfOApVF4ejVdkkvfX9WtBbZq6LGMXY6ELp63AaN1Lmj7K+WfEigQkGXiIR2hB6bTONNCwVe3uknQyHXOuyMYNNzh8TqZ40tCygAcY3NMtariolhQZIYoa0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011605; c=relaxed/simple;
	bh=yu7rm1YdNq1Gi+Azn8XEpeH3tkPontKGTTZmmF9eYF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8sCSqHtnCGBn9yLeGR7969PynH3ArBh7LITJLPVrC1A3FqfiSY0vrXFu0jqkyw7G9DS/tzPKmC5pG1V4lhJwBuiU2U4IB9w3CZQRJAif9YbGfw+sh0Xvjf4CbVsekZuPJF+MAT/SDgHb0twCr/MeiQmv6lvMOmtetOqcU56I+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYMqJb8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYMqJb8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1FF1F00A3D;
	Thu,  2 Jul 2026 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011604;
	bh=yTb486xm4bCE1QMfQw36Mc6kklArWceUUm3xSje5th4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYMqJb8DamouENMIjSDqbERae0J7bR0amsXihMYn5l7TVezCIXeEbAJ3kVs6lzRDJ
	 5J8T7nj7FQaGHq7ibqaDzFQuPFYG3ZWsKR6ATZ/Ds5NqZL+LXqdYhq/9eOOwNbFWNY
	 OmkLHHcVKLo4afQEV9BAD6cPmMLySIFb/o1ngwHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.1 064/120] f2fs: validate compress cache inode only when enabled
Date: Thu,  2 Jul 2026 18:21:00 +0200
Message-ID: <20260702155114.283971276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -561,8 +561,13 @@ static int do_read_inode(struct inode *i
 
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


