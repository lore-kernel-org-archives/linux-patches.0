Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8717724DFF3;
	Mon, 23 Jun 2025 13:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685664; cv=none; b=D+JA/J0vvDX8JUaSqkLmzNRahHoiDvaOmUGEsKCWILY1BvErXFk7vA7btSG4VkqBEuQFJPBRQHnjMVtgfJUJWigrS1kDLsH7EhVs0JzmeH8QeE1GxpI+lIYSiCoac7V/vD9ZfCUmsJfgzf/n8nsLCunN1g2moxMW9JkJBD847IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685664; c=relaxed/simple;
	bh=0MOQUBjHLVq3aE8nVrZ5lVnNIOII3sU/LSWLN72gNtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJ9PzW9ievRfaKOicXtBGwmt9ebtzkuOpBltGy/bD0BM5ZzReK8NxQqmhAFiYjdiOROBTKjk+fOpVHEu3lgC33b/MZ2Vm4cxgeH5RhGx6LgXpnlrM2+D/aMwuHK1JHHvOsOf/tlBXljf6EpUM771pJSYorB48sEXyIQ/EOFYM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf0OGEMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf0OGEMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C3C4CEEA;
	Mon, 23 Jun 2025 13:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685664;
	bh=0MOQUBjHLVq3aE8nVrZ5lVnNIOII3sU/LSWLN72gNtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf0OGEMr4ZorQ7i/ef87E2NA3npfB/QGNVyzoQYs2cD4JDBlp3Sakzt4PRtdWr3Q9
	 uiLWZDxI9xAgn8ZIEZigoSpKWK82nxUrNwwcSVRWtNipxMfJxMllwtNSGaVpSl5FcV
	 s2gp2oywINrXlVAnDIakn2hHmOLh2timjP7NY7Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 251/592] exfat: do not clear volume dirty flag during sync
Date: Mon, 23 Jun 2025 15:03:29 +0200
Message-ID: <20250623130706.266755563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 46a557694b464881b3c2c4a0ba389a6436419a37 ]

xfstests generic/482 tests the file system consistency after each
FUA operation. It fails when run on exfat.

exFAT clears the volume dirty flag with a FUA operation during sync.
Since s_lock is not held when data is being written to a file, sync
can be executed at the same time. When data is being written to a
file, the FAT chain is updated first, and then the file size is
updated. If sync is executed between updating them, the length of the
FAT chain may be inconsistent with the file size.

To avoid the situation where the file system is inconsistent but the
volume dirty flag is cleared, this commit moves the clearing of the
volume dirty flag from exfat_fs_sync() to exfat_put_super(), so that
the volume dirty flag is not cleared until unmounting. After the
move, there is no additional action during sync, so exfat_fs_sync()
can be deleted.

Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/super.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 8465033a6cf0c..7ed858937d45d 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -36,31 +36,12 @@ static void exfat_put_super(struct super_block *sb)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 
 	mutex_lock(&sbi->s_lock);
+	exfat_clear_volume_dirty(sb);
 	exfat_free_bitmap(sbi);
 	brelse(sbi->boot_bh);
 	mutex_unlock(&sbi->s_lock);
 }
 
-static int exfat_sync_fs(struct super_block *sb, int wait)
-{
-	struct exfat_sb_info *sbi = EXFAT_SB(sb);
-	int err = 0;
-
-	if (unlikely(exfat_forced_shutdown(sb)))
-		return 0;
-
-	if (!wait)
-		return 0;
-
-	/* If there are some dirty buffers in the bdev inode */
-	mutex_lock(&sbi->s_lock);
-	sync_blockdev(sb->s_bdev);
-	if (exfat_clear_volume_dirty(sb))
-		err = -EIO;
-	mutex_unlock(&sbi->s_lock);
-	return err;
-}
-
 static int exfat_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
@@ -219,7 +200,6 @@ static const struct super_operations exfat_sops = {
 	.write_inode	= exfat_write_inode,
 	.evict_inode	= exfat_evict_inode,
 	.put_super	= exfat_put_super,
-	.sync_fs	= exfat_sync_fs,
 	.statfs		= exfat_statfs,
 	.show_options	= exfat_show_options,
 	.shutdown	= exfat_shutdown,
@@ -751,10 +731,14 @@ static void exfat_free(struct fs_context *fc)
 
 static int exfat_reconfigure(struct fs_context *fc)
 {
+	struct super_block *sb = fc->root->d_sb;
 	fc->sb_flags |= SB_NODIRATIME;
 
-	/* volume flag will be updated in exfat_sync_fs */
-	sync_filesystem(fc->root->d_sb);
+	sync_filesystem(sb);
+	mutex_lock(&EXFAT_SB(sb)->s_lock);
+	exfat_clear_volume_dirty(sb);
+	mutex_unlock(&EXFAT_SB(sb)->s_lock);
+
 	return 0;
 }
 
-- 
2.39.5



