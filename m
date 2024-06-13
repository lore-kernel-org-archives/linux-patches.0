Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0280D20ED;
	Thu, 13 Jun 2024 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282197; cv=none; b=AQjvcyvzOmZFGyMAJje/rMa9otF+f92dcxUPM0EaLfUgowpjw6NOL3HvnVl2RVBTyRWe+I6HHjn+C73AvAxNaUbCP05IUpSL8vZLMcckRyoPpBAiVl0zZgbqvQyou6QT2AMGcPSkn8gAW2z1ydvP5p9r3vM4brPPOwgLDdUIqYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282197; c=relaxed/simple;
	bh=Gg9vOvCiGD40PfmkhSsw8ft3SSAx57/FlXMEeaaNgV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1aqCf/+ej3SXqDKEh58dpo7nlF3MsB2a0nyE/J97HB/aQx6nwdGzfAows8c6RmoTezWbwJtOKWk9H5YwUqlqomuHpnCkYOu2YXNXu/m366zG/jcMi0/xFMwNijAHrb9+VR1McF6E5owHLRqt/l+0KfnLv4nDkhTvqdZXWAO0Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O+qhdpUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O+qhdpUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C4EC2BBFC;
	Thu, 13 Jun 2024 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282196;
	bh=Gg9vOvCiGD40PfmkhSsw8ft3SSAx57/FlXMEeaaNgV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+qhdpUvP3ouWwVP3fWd4ZpoOKanaVywFXMp6p/xqOX5ArRVSaRcbo4pWa1oVLCcL
	 CSuPP/u6wCNe8pBWVs6eW1liqOR/XDba0vlnL/6n6Y448PfHn2nj5Rife6llJmUxqE
	 /s2+OdEYj42pIkyrQcPNJ2TCIdNWUYWi6oVuOE1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/402] f2fs: compress: fix to relocate check condition in f2fs_ioc_{,de}compress_file()
Date: Thu, 13 Jun 2024 13:32:33 +0200
Message-ID: <20240613113309.786134522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5c0c7b95259f3..da071ed11a3f6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4016,9 +4016,6 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4029,7 +4026,8 @@ static int f2fs_ioc_decompress_file(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
+	if (!f2fs_compressed_file(inode) ||
+		is_inode_flag_set(inode, FI_COMPRESS_RELEASED)) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -4088,9 +4086,6 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
 	if (!(filp->f_mode & FMODE_WRITE))
 		return -EBADF;
 
-	if (!f2fs_compressed_file(inode))
-		return -EINVAL;
-
 	f2fs_balance_fs(sbi, true);
 
 	file_start_write(filp);
@@ -4101,7 +4096,8 @@ static int f2fs_ioc_compress_file(struct file *filp, unsigned long arg)
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



