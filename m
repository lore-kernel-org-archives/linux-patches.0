Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16B335F619;
	Wed, 20 May 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297406; cv=none; b=QfL7qq+PcFBmNwCze4AgKx6FTUHb6G00IBd8qwSyoZSQPwqvx1+W3VeJxxs6shdw1nUVqaKl9mwUqBR97FdFeW5USbL8MAC088m8z2TO6WMOxrATt4Q2moxjxze1jmBDwnyhVWqkTCUlOgDrBOd46m65fy+l/JEawxJwnnNSvTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297406; c=relaxed/simple;
	bh=5fyaSUIMzmM57b3l6W9iLWBmN9dZONvZZp1WtVu9YHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG8o2+X58KzrbyAZQF4UWaYEW3Or/+ZExoWp8Z1Yryc5eWCkTmucFrgfjpExvrga72tFsH+1ifOBxYbcygZOO0bMQBIiMwq0rUlIuFzWn3+tlZEmnRJjLq0NSUWONkQbZiGp1R1VqxE9ZQTzywEL5sc1ibLs14wjA93638FalBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kupyufnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kupyufnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CD21F000E9;
	Wed, 20 May 2026 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297404;
	bh=D9zqkVdWRamgseCAMzFGPRlwAEJn1ruFXYYOQ+auI1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kupyufnTarBfudMJKBJfto23DPtRKsqZJE0+aQ+lai6cTZKPvSwcQEYud8ygxOUQU
	 UrVil/N892/KUyMERvtYFhLDYYI0IMWlXbEFbkwNIWp+TcLRiDRyxM4fuTm1u9bNe4
	 UP9jLoUY8TnsDFIWGTk3kDIFt3iuLoxdfY7IJNQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/957] fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START
Date: Wed, 20 May 2026 18:08:05 +0200
Message-ID: <20260520162134.613714756@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyungJung Joo <jhj140711@gmail.com>

[ Upstream commit 0621c385fda1376e967f37ccd534c26c3e511d14 ]

omfs_fill_super() rejects oversized s_sys_blocksize values (> PAGE_SIZE),
but it does not reject values smaller than OMFS_DIR_START (0x1b8 = 440).

Later, omfs_make_empty() uses

    sbi->s_sys_blocksize - OMFS_DIR_START

as the length argument to memset().  Since s_sys_blocksize is u32,
a crafted filesystem image with s_sys_blocksize < OMFS_DIR_START causes
an unsigned underflow there, wrapping to a value near 2^32.  That drives
a ~4 GiB memset() from bh->b_data + OMFS_DIR_START and overwrites kernel
memory far beyond the backing block buffer.

Add the corresponding lower-bound check alongside the existing upper-bound
check in omfs_fill_super(), so that malformed images are rejected during
superblock validation before any filesystem data is processed.

Fixes: a3ab7155ea21 ("omfs: add directory routines")
Signed-off-by: Hyungjung Joo <jhj140711@gmail.com>
Link: https://patch.msgid.link/20260317054827.1822061-1-jhj140711@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/omfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 135c49c5d848c..31218d89b7580 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -512,6 +512,12 @@ static int omfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_brelse_bh;
 	}
 
+	if (sbi->s_sys_blocksize < OMFS_DIR_START) {
+		printk(KERN_ERR "omfs: sysblock size (%d) is too small\n",
+			sbi->s_sys_blocksize);
+		goto out_brelse_bh;
+	}
+
 	if (sbi->s_blocksize < sbi->s_sys_blocksize ||
 	    sbi->s_blocksize > OMFS_MAX_BLOCK_SIZE) {
 		printk(KERN_ERR "omfs: block size (%d) is out of range\n",
-- 
2.53.0



