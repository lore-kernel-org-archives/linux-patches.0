Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5781F481DD;
	Sat, 30 May 2026 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160787; cv=none; b=GewAy0kMyTvqB8v9+2xYB4677M+B2iAQFSO38IMcT6hkuvSd69nY+7Ume5KIimuyhmau+6b5XonkFobjedgd0Y29/f4iBufvSnvmUzhm7eBebxTLejhD3E46rEaiVrjgpJoyTito6Eqg93wr2VDtdYbk9tDtawdrUKnqZs6yjWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160787; c=relaxed/simple;
	bh=xS5sbRN4yxp7EooOKrr16k74ISaZtSVU0wRf14WFoxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBTu2iy+oqU40rpSw3vZKp+f3YuqyO9foBZi4NO9p6WMeN/ziSz/P9RtoSsNzrkvywfOiol7hbQtwgholOuNswX0CF3YPBraKoLREbsY+sQt01yq4cY9YSyyDKVt8/j9Tf7cMHf+QB94CcHecmqlnyLEbGYSTj49auJPaS8tijw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhiC7+zT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhiC7+zT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997301F00893;
	Sat, 30 May 2026 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160786;
	bh=YAD3HR8Ta8fuWF8DymqG4W59tNDfO2e5vV8J+M7+bb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhiC7+zTsqmD11yXq+eGr0x7MmvSYJyrrKSDk6yY3qri8cA6o8FEEPowGbQpZG3/w
	 ey1dBgrG1O4jUC8n6bD5yO7myJpiZa0O7gE/GyL3Oy74ibd5c2LBE6SE1rF8VxGypW
	 J0ZnORxhkR8trmsBhRMrS9EyfKm09gTxvl5R8cL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/969] fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START
Date: Sat, 30 May 2026 17:59:17 +0200
Message-ID: <20260530160312.216548776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



