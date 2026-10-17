Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C678E3BB67F;
	Sat, 17 Oct 2026 16:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255942; cv=none; b=TIfWnIAoPawfvPAdAUpJtatnpfnSuIg1GG2m87vGwMQnkR2AQrLkYETdTEUqyx/JEy2pqJrnyzHO7giELkQAZxJum23XyOdw7x87JDp8AKmBBcejKYJLm9Amb4xQqoJUtNeLyF5v5gj9JRHLFtwBhkjbyflpcaaINtpff0lQiTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255942; c=relaxed/simple;
	bh=YWRZzblvj5hQMAz7XjmZZskfEQUdaa3EMso58ioHB/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W14HdItugGmmZVqCMh+qp1xCpQoc2q+lD2NsyqjdM/PVForGIGGAbNMx8C0pXzoPO//MyXZ2YTu9v8C7FYMUFA2DZvD4/WahsZ34rljjLcZpU94weJZW7f5Bec5/YYOlUJZW1NL3p8m3K9Cp160rUIYYtvxvkxSn4deyf/XIRIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9SLafNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9SLafNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC4C1F000C4;
	Sat, 17 Oct 2026 16:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255941;
	bh=lW/6L1eQRbvKSM8+dJlPUfCQQcAS1dfrs10BmY/ICy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c9SLafNCR5EoFYLpee5FqVDY7tCxVdK//S4GRoQUTVNIPhaNbGvLkUvY+HDLPJqy1
	 IzDmefCQJjQ9nyPuNelK0lx8fs9jxMs+QbdOtN+zWzWvfO54OMsH3c1Vtl+c/rtdVR
	 CfHTCg0zTjZGwzAs8luzo+R+5zKnjAGEM3K+YWGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0030/1674] f2fs: validate MOVE_RANGE destination size
Date: Sat, 17 Oct 2026 17:38:22 +0200
Message-ID: <20261017160431.914939280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
---
 fs/f2fs/file.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7125117b63225..038de37ce8c2f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3065,8 +3065,9 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
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
@@ -3123,8 +3124,15 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
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
-- 
2.53.0



