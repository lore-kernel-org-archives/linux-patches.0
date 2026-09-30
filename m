Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017BC53B32F;
	Wed, 30 Sep 2026 17:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790052; cv=none; b=PRfCZ1efAlteYUjNc8IhCXhpnbNIZLAngSR2d1TYB7rH02gZ7eKRrL4ET0GoAi0gTEmrq9T8Mc3kh5LlfMeKYAIqL4Y+1I5D5DHJXqtnz/PvwXMaph3iZciMYtFdVnzuh/b+HZkLEOMhyiJ4I46QbzMWut5xpsZkklH46bVe14Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790052; c=relaxed/simple;
	bh=vHDyRW2+T6abov5btP6v0GQ4iuNb0800lYxGvPna6w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUeb8yyd1cvQPOEsAqCI9sTBe0x4g26xtfzg85VIsPM4jVynkbK4p/Je96x+xExCoyHG724eUgLdLO2XPLn0fHGlWjzmQu8dvmKV7SHQbOLGK3VxTiYf7qWui1xTlaj2f+n3peLJlbNqbtzj66XUbkWAGC9cMtby+ItYquilBow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypPyZaGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypPyZaGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FED1F000FF;
	Wed, 30 Sep 2026 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790050;
	bh=MdgFNscMCVfYDuxLv0l9d28sNIGd5kG11YM/nNhAVJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypPyZaGZKHPGe+kTHK2q3m2kfawnpvA2JOuDEndJGC3vJXY4DkIkqjd8uX9klWuyo
	 zDj6p/6r8dyAB7TAC7VG7+tqfhBG994o+vq8wKiQpCrhAyYxTBWmZ/MLq9ZoJ37xg1
	 CbkLVcoO6Ee9KZ9vvF9zO9lWHsqeaROzeQzmRy/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 686/877] f2fs: validate MOVE_RANGE destination size
Date: Wed, 30 Sep 2026 17:26:37 +0200
Message-ID: <20260930152429.478673926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit e533889fc26aea0cd83c90327063f272061dd820 ]

F2FS_IOC_MOVE_RANGE checks the source range, but not the destination end
before updating i_size. A source hole can expose this: __clone_blkaddrs()
skips NULL_ADDR entries and returns success, so the caller can still extend
the destination inode with unchecked pos_out + len.

Reject destination overflow and use inode_newsize_ok() before extending
the destination inode.

Fixes: 4dd6f977fc77 ("f2fs: support an ioctl to move a range of data blocks")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Adjusted declaration context for the missing `struct f2fs_lock_context lc`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3100,8 +3100,9 @@ static int f2fs_move_file_range(struct f
 	struct inode *src = file_inode(file_in);
 	struct inode *dst = file_inode(file_out);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(src);
-	size_t olen = len, dst_max_i_size = 0;
-	size_t dst_osize;
+	size_t olen = len;
+	loff_t dst_max_i_size = 0;
+	loff_t dst_osize, dst_end;
 	int ret;
 
 	if (file_in->f_path.mnt != file_out->f_path.mnt ||
@@ -3158,8 +3159,15 @@ static int f2fs_move_file_range(struct f
 	}
 
 	dst_osize = dst->i_size;
-	if (pos_out + olen > dst->i_size)
-		dst_max_i_size = pos_out + olen;
+	if (olen > LLONG_MAX - pos_out)
+		goto out_unlock;
+	dst_end = pos_out + olen;
+	if (dst_end > dst->i_size) {
+		ret = inode_newsize_ok(dst, dst_end);
+		if (ret)
+			goto out_unlock;
+		dst_max_i_size = dst_end;
+	}
 
 	/* verify the end result is block aligned */
 	if (!IS_ALIGNED(pos_in, F2FS_BLKSIZE) ||


