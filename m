Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177B196C8E;
	Thu,  6 Jun 2024 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682912; cv=none; b=SQ8e/ukvkefdPIEGWeLjtr665qEv93fUi4tYRr6V81nP4foecVZQcOk9WCfK6gicCN81TZklZnP7FVgQfV9ymBU8c+fuX2NZ7f/L5qu3zBia4xh8VTNWCvP6ydqoSZ22K/o5waeQx7X27pxKDiD0zPURf6jPNGV1R//1FMYGIZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682912; c=relaxed/simple;
	bh=vRSIQlaSpWhIqbxsFO5ZtElEnBmHB7CpRZ0GP6FkuDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIcE9MN3BRx5qV99MUS6mM3Xxmn+RO+D3mjvLkDIc/7OejyM2Tzz6mUTOuxdW+CCdISxSlg0UEd+33IgD1/F7zR9GtmFgRe+mz/K5ekdJslFd8Dl70Z36tzw3GxrbNU6Hkww52SR7Hf2vy9xHrpoP+hbpfYXX/gkAVDDNQ1brFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMxGcTU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMxGcTU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BA2C4AF08;
	Thu,  6 Jun 2024 14:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682911;
	bh=vRSIQlaSpWhIqbxsFO5ZtElEnBmHB7CpRZ0GP6FkuDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMxGcTU4bOlRVK//Ktl2hgibBald7mAQxfpNVVXFwRDj+HDNJSH/yiPzZCfBiCIPY
	 6saj5z16pKLYhX+VGrHHr1mNDeiqnSfQ0KhgecSDNlGaLr+8zXEDPfOhOra4jQ1Yaa
	 vhIqUdRjw2xiBA+fNIAjJL08+yaFj+X8x3yQIydw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 040/374] f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()
Date: Thu,  6 Jun 2024 16:00:19 +0200
Message-ID: <20240606131653.164934291@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7c5dffb3d90c5921b91981cc663e02757d90526e ]

Compress flag should be checked after inode lock held to avoid
racing w/ f2fs_setflags_common(), fix it.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/CAHJ8P3LdZXLc2rqeYjvymgYHr2+YLuJ0sLG9DdsJZmwO7deuhw@mail.gmail.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 06e3a69b45dc7..e96d05f13a336 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3525,9 +3525,6 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3546,7 +3543,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -3707,9 +3705,6 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 	if (!f2fs_sb_has_compression(sbi))
 		return -EOPNOTSUPP;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	if (f2fs_readonly(sbi->sb))
 		return -EROFS;
 
@@ -3721,7 +3716,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 	inode_lock(inode);
 
-	if (!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		!is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto unlock_inode;
 	}
-- 
2.43.0



