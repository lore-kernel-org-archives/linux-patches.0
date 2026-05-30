Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6A352027;
	Sat, 30 May 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163866; cv=none; b=mE8RT6vnCXD/mdCOCpvl1aG7SmAGBZDy8duqpAXEpzPxTDGWmxiq+ZzO07/yBHnTedZo8SwcnJWH0hZzCzzeDs7HPLhYxa7NFjSErw6gnHBJNlaAZZ+9OsKZEr4lMt9WbFxcv9sZ7OqcTNVahhw4z7mRJvVIgLMXYRHT0El89yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163866; c=relaxed/simple;
	bh=FyxGDZ8Rc9LZrq2vLmxS4JQ/5QOygSVjz5BVUvkBb70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=preur1ez0YpwxSXc7+MyydmahjU/uGdFnj8XXhfz5sLP720+92e+OYVmVX9AExv7cjMYpD6ZeLX4SwayMTs3qFrISETNJQtrfRWAvi46yqnppve8UAATcSp4ywJ4LcLH9ZBEupgsuycJhYGxrvQlnhiYhsZQRvMFvwLiaenA+lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CwydmZDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwydmZDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B03A1F00893;
	Sat, 30 May 2026 17:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163865;
	bh=nALtJp+MFsfwtGd4K4Gz8v5URs2FC72knv/Q1D5jaYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CwydmZDj5bOht1fx8JQDxu08DW5/ZEQqkrBcdJoSclqlJYIPsPO+wfDp/X5flKlRo
	 aNUBHRyNyGRKL0H+1mwLABhQSd6EF0p7T+cxZWtHIkrUzu3/dcZMPHmE590JVx29QT
	 pVXQCe+v07UnOw7/1MMqIBKTIC2jo2Y4LXBhG4Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 385/776] fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START
Date: Sat, 30 May 2026 18:01:39 +0200
Message-ID: <20260530160250.460095922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2a0e83236c011..9773846daa4bc 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -515,6 +515,12 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
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



