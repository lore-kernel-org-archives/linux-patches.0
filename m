Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D91E198E90;
	Thu,  6 Jun 2024 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683490; cv=none; b=TSYx7Hc7R/MXaK+iu5shBeQ7CBh45LvAqEDqEq8liLsJlQ4MmfA6ifOSXLZ/+uVYSYrFMj2sB+1E7ojFQ+zfZ4jMVoHOnguxXKyYxiZq8p+UHSG1t0SPKqBRiliXkVhSGz5Fs6m3j6jG03rQLLoO4ysUiEP7dhDl5/AlKi8B7XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683490; c=relaxed/simple;
	bh=Su5bkrF9UegRkXugyEqM/t+IwsoCY4amjnSZPjF+Vp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLCNGLA4yqHCLVDQnlvMoA1V2MzLgR42tvVmPvVgnv5Ui1u2pAWD3Ljp6U6TwD5NF8xHxxjt4//N4utdwDh+EkLiJdy9MW1h4qjZ0zvBtm+U5UcLfyGWvkRf+Yh21mCpYOUUvkVJDNjIziZPt3+gMR4ObFsdyqBpPLGwG6Lu7Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOZnWoJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOZnWoJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3649FC32786;
	Thu,  6 Jun 2024 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683490;
	bh=Su5bkrF9UegRkXugyEqM/t+IwsoCY4amjnSZPjF+Vp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOZnWoJvUhw+6LBsnvmnl1qFSpPL4kAzHceVVviFsmEXwmyLgD85Nc6lkpaTubrDx
	 gaamOBCoA22Otki4Pzo9Zf5vUEiBGkTrlOX04RkpEkcl5e4idVqPRpj6pJygiNixnm
	 lUkKf961tjHvaoRbFVAoJ9lpzqJXrBD+prG4NNYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 433/744] f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()
Date: Thu,  6 Jun 2024 16:01:45 +0200
Message-ID: <20240606131746.362220909@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0350f36d043d6..420939ca36422 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4086,9 +4086,6 @@ static int f2fs_ioc_decompress_file(struct file *filp)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4099,7 +4096,8 @@ static int f2fs_ioc_decompress_file(struct file *filp)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4165,9 +4163,6 @@ static int f2fs_ioc_compress_file(struct file *filp)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4178,7 +4173,8 @@ static int f2fs_ioc_compress_file(struct file *filp)
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



