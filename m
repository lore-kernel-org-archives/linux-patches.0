Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89101433E87;
	Thu,  2 Jul 2026 16:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011313; cv=none; b=L3qkh83xulpcMTAHVH1/1/XbO0AsLQ4fvL5f9NtpfFrVwyuxX1yyJwvMlvNq2D2kE/QXkpI+/S6f7TykSasQG5B/+4wgOyPgf0leclaxFDqQOtmHLriJ0E9qahiptEVPK6cQf+ydkMFkWPXlnScZjeFJulGQIa3p3j+NyAjWR/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011313; c=relaxed/simple;
	bh=/09BGaU4shWvUXAX8XCiN8FyXNZXoQDk2p87z2rezdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZA1mIKuG7ZULcyx9lGl0bF6Gfg/cGYXTroW8fNALUyTXJP5c299V1UkpA2dJJzpZejB2MOMsbsH5mpnZOr9Yu9ih2JplLKmgFp04mDKh20wQTndZZcWnHQukBMHmQPz7SVhvRS++Y1+q0KE2wX0fjja2s9Xx1ETMnZUCL0D0Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npe+RGPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npe+RGPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF64D1F000E9;
	Thu,  2 Jul 2026 16:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011312;
	bh=mDcCD3fwQrg09r/CHOEu/8U2cWWl3vqQ7jOc2o+jxFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Npe+RGPxyuzOZuGRmY+MVh4Vv2EkJx1OiGtBV6C2OANnY35QkI5dTSNSnmDry8nCg
	 +QsYL1OWfuTPtNM2tTb0C3Sjd9aImmPUg4sJ6C6kt26SYvLAR4hDIHzuHb1c8Und5T
	 pDnfeDJOcYzWAoE1qwVaCmnZxGdHVOFNl9ZZE+mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 062/108] f2fs: validate compress cache inode only when enabled
Date: Thu,  2 Jul 2026 18:20:59 +0200
Message-ID: <20260702155113.393672102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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
@@ -555,8 +555,13 @@ static int do_read_inode(struct inode *i
 
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


