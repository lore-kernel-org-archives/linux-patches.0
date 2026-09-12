Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A9B22A7F6;
	Sat, 12 Sep 2026 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222013; cv=none; b=Ac9rhQmu2tAu6/5YmQICgAC9OlIcqYYAxrjgP26A8BRrzc1pMt/IGjBZyVCeD5adYQAPDZ5bwTEvQ8/JkhBTALMgwQWOtnx+9J8WRu0RN06h2eyiwymH4c14EICoUGVRKj2JneCQ0yOT757AKR9Q5p5FvcQ+ONZve6U8DfWPYkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222013; c=relaxed/simple;
	bh=lQBU4JQl6kNpYfIC2yUtFhQIH+HcigTT9wdoWlSifD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1taReYJMLl5KBzkaSWHZLNvheZ5JVRUeiOSyfK5epqjpSInjw3kGX6E/Rqix2SCx4iaeNSpwkAN57Jg134MMib/JFuZRT5oonrkSEiRs76BOUBq4ASvR1Cg1olz4iXtuxd2n4PUDgvOWqvJInI2gHpeWNeFH+g8E0A/2zkg78E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p5S9hJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p5S9hJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637F91F000FF;
	Sat, 12 Sep 2026 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222012;
	bh=t49EPzwPp8t/ohCegX9Yn2DLlyrrgXO/vxR4yrbI8HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1p5S9hJ9h3zC6t+BJuf96Hvy+8vD4lTVV/okEWqENlcZVYRpYGVuYiKJRJ8MhnSjd
	 UFaAgqsOLIo8M154VP1c6BLrvoUYSaJyyFlVnCci4gsvXA+XKgcqqxPU9+zF6Zzda0
	 ARUx083R1Q5+cL6T+OiB9LlETJNXk7UDwxonZvfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.6 0501/1424] f2fs: return symlink writeback errors
Date: Sat, 12 Sep 2026 08:48:53 +0200
Message-ID: <20260912065618.511090251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -673,15 +673,16 @@ err_out:
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
 


