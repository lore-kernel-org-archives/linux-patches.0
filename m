Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216249;
	b=gkcjf2KgXcHcf4/gnp8PJOdItAlaDHgIlEfM+dGVp8D0z5J0omy1HUiPUNoo79H6FgvN
	 v3gjVPrH/l3Eo5DJdamYIL0Dzwgd03H/BTTIg4U8uWJmlO7hmqthPfrvxLIBpSOjzS3tF
	 voyN7QkpamKewtP77OQrUakpCwUX0OT9MA6lVpmkoi8498l0bDafQ7A0XNlDJbiZMHo4V
	 ptDXwgj5dJJJpNTbXEDh50Js9SLbt4DiulrjenoPWhQbb5D1G8EKFlp/IKro5phwJx5R7
	 7tSape7apgeReYejhEB8OZEPCWSyoRRapF9lGENtnDDj26f/j4X/+d8vw1I0wNonp6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpZN+oWxykA46H+kekkyXozwqNlbGDqWQ0bTwizReG4=;
	b=vfY7iwpGTuKaEqhiEEVjIyq8KObsRJ3sY7W8lcdYfp2HGvRmk7M0Q3+Yyje0hsXpkYPx
	 ho240CCSVW6UuJj7f6xqcvdesmM/cmxCarBTvH/6mwfL25mZaR6PngMhht4kR4DZcjtYg
	 zZ8VNMfMo0LqsdyipsXQXc3fdUDlV2lqieIQRBnZDlb4oDL6tEWMqGtUOulXdsW+CTknx
	 9qYx4DVcXufV5C6zKkeX0NSygR10LzFTsOwDhXQTqg+b6RPv0a4qYdFhIjA6uIjdNS55b
	 8M6+K7tzDYW6kxPlOBdBInKAlwguV+9I7gjfW8da33vmlpSHDrq4t++KOOGVoIdblng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b8GRU/zh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37912606A31A;
	Wed, 28 Oct 2026 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b8GRU/zh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866C41F01825;
	Wed, 28 Oct 2026 19:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216248;
	bh=SpZN+oWxykA46H+kekkyXozwqNlbGDqWQ0bTwizReG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8GRU/zhvX5ZfXrGwFHpG7BAHOybkkpmytfAWpBmT0JQ5BkYHoYNJw9cb3j1N/ele
	 GDqcNfsiOAYu6MtMthV6sFTUmAf0d/rr3uvxUu7Ps8y25E6unnVPFskRbDlbWe3f10
	 AgmiOC0V1NTSYg52OE7qXMjfQa3vlDbiReenFr3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1491/1887] f2fs: validate MOVE_RANGE destination size
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028170533.385428647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index c35b2a25a66d6..4dd995b0c472b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2932,8 +2932,9 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
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
@@ -2990,8 +2991,16 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
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
+		ret = -EINVAL;
+		dst_max_i_size = dst_end;
+	}
 
 	/* verify the end result is block aligned */
 	if (!IS_ALIGNED(pos_in, F2FS_BLKSIZE) ||
-- 
2.53.0



