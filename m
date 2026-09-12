Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6C7377ABA;
	Sat, 12 Sep 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242170; cv=none; b=Yi21JzVcDM/oPEeWcfdSx9aLXsZMLUvo3+oTG8hSDbG492W/4GeSmvw4JDMlmSkN98vY2Oln4lfS4MROA/f3DEGUiEUwMWg+BK+A1BWFW/4zrpR3yaQ5O+B5JaP0lBoK4K35XaLKZQfkifoScJgxQmJK02xRO7xoNo5kKH7r+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242170; c=relaxed/simple;
	bh=VMarV80USPTVBBhy2mqG+iCrBKU0UAbGAlZYmjzH8u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCymF2cBSLw+ft4xubJXWLKjjlW2wxPu2VvBsAuBi+WGhnHFX/Udv9QLh4DPs81MTLKcJImmOlL5kJGyaACX3uGpmTFfkTpPIBAaQoY4+6+xnW3QMPZakapAKyg17ew64vvrXn3HCnLvVb0lEfF+GuB83Hed2SwsF9aCdZHeFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0WoLGQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0WoLGQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31211F000FF;
	Sat, 12 Sep 2026 19:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242169;
	bh=lQuKZ/PTJ2x75aqIevA/5cdGeIhfHGbmiZwO7dP+Quk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0WoLGQ068Gct77LBfpq+0UPF3ZaGH9FdRryP3SjPanE0XbBjonkzaakCHsxmHHmR
	 3k52PUvZ/t0hw5EY6rbanSqzHqAXrBhsndz422q0jin2L56QC7LIPd6a+UInwFxVX5
	 V/uV70FDZNANYptVC0OSkW0bSfrFD3YNG6iaLyaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 310/798] f2fs: return symlink writeback errors
Date: Sat, 12 Sep 2026 08:58:58 +0200
Message-ID: <20260912065524.262102786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

commit a2c73a7a677afdaa8b16d775188f9ef5cfbfd8b2 upstream.

F2FS writes long symlink data with page_symlink() and then flushes the
symlink mapping to reduce the chance of exposing a broken symlink.

That flush result is currently ignored. If the writeback fails, symlink()
still returns success even though the symlink is not durable and the same
operation can already surface -EIO through syncfs().

Return the writeback error to userspace and skip the dirsync flush once the
symlink data flush has failed.

Fixes: d0cae97cb600 ("f2fs: flush symlink path to avoid broken symlink after POR")
Cc: stable@kernel.org
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -718,15 +718,16 @@ err_out:
 	 * performance regression.
 	 */
 	if (!err) {
-		filemap_write_and_wait_range(inode->i_mapping, 0,
-							disk_link.len - 1);
+		err = filemap_write_and_wait_range(inode->i_mapping, 0,
+						   disk_link.len - 1);
 
-		if (IS_DIRSYNC(dir))
+		if (!err && IS_DIRSYNC(dir))
 			f2fs_sync_fs(sbi->sb, 1);
-	} else {
-		f2fs_unlink(dir, dentry);
 	}
 
+	if (err)
+		f2fs_unlink(dir, dentry);
+
 	f2fs_balance_fs(sbi, true);
 	goto out_free_encrypted_link;
 


