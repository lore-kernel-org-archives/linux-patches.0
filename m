Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ACF196C8E;
	Thu,  6 Jun 2024 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682912; cv=none; b=Mj7Z1lic1XauFDtgPjioOGBYCj0AGPJRsPDgl60KoHSvTUHsMNqKCCcU6oGuz/N8XvS67XqUwTnhb/oT6uGlUkfkoRh6AMRBSTM369QovB2xggwLHkNStAeGTNd4PCmP/3rdLfMwFYf9nLjQSrUnX4fiUkxx792iRJY06ey9Wqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682912; c=relaxed/simple;
	bh=eLguRSQTBQJVYde26zTZIz+rPIJn0ytCHxHSV0y5hHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMkaok74kl6EykxjDe16Amh+OuGKRAeLrDyHHe/dDDD3En97aDQCpEasfWfNIFxhkbrVdfzbATUz8telGyHz8Wa59LrA6tU7jrrdF7N/Z9wE5IAsMLTLOMjgm5Ttfui+PIUR4podftGAvdVXIhGAUqreiAENSEkJU8RRAtk2WzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7+JGtvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7+JGtvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FE0C2BD10;
	Thu,  6 Jun 2024 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682912;
	bh=eLguRSQTBQJVYde26zTZIz+rPIJn0ytCHxHSV0y5hHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7+JGtvjZsnw+FOOUKqdoqmfkaCe9p2PCA8rCcO4jg+pZDRixGQkhcEA4qGNuvEaU
	 /tbAbUmPM4GsL/vfBTfWO8zdOTYbCLBiPct4iMrhOgAwsNllPrrVGq9310CZaJLD6/
	 F5XRAJ8rnAxc3hYuQzz0bbal6+5VLYURucE1tULc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 041/374] f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()
Date: Thu,  6 Jun 2024 16:00:20 +0200
Message-ID: <20240606131653.196502028@linuxfoundation.org>
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

[ Upstream commit bd9ae4ae9e585061acfd4a169f2321706f900246 ]

Compress flag should be checked after inode lock held to avoid
racing w/ f2fs_setflags_common() , fix it.

Fixes: 5fdb322ff2c2 ("f2fs: add F2FS_IOC_DECOMPRESS_FILE and F2FS_IOC_COMPRESS_FILE")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/CAHJ8P3LdZXLc2rqeYjvymgYHr2+YLuJ0sLG9DdsJZmwO7deuhw@mail.gmail.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index e96d05f13a336..3eed9f167fc91 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4118,9 +4118,6 @@ static int f2fs_ioc_decompress_file(struct file *filp)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4131,7 +4128,8 @@ static int f2fs_ioc_decompress_file(struct file *filp)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4196,9 +4194,6 @@ static int f2fs_ioc_compress_file(struct file *filp)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4209,7 +4204,8 @@ static int f2fs_ioc_compress_file(struct file *filp)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.43.0



