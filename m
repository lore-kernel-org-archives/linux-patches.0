Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3285349CCF;
	Sat, 30 May 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166156; cv=none; b=uXvUjyheRyluJ7InGtzgebNM4OOKr7b34ffR0YjCqA5ZaE1WJX5x9fRsjTtoe9P7JgpWjHyPNg2+yJbmGfSyFOVGlGyV/uLmL/ynA4UZbTFiBa0QuwgYo53QWUNBa6aIAKOEKRnT1IUNwWjdNmdQQP8iWbtMKf3K+IiHyLrVdeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166156; c=relaxed/simple;
	bh=1Rm4UFaNGUaMDISz7XyDaucwH918Mh6gcCVBquO7M5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GjCqgNkrD9tDSAjk8NULQfnuTrbQ4pNqSKtUjHgg6TI3MI3l36PadPrHy69AV8Co1/nSygonSKNSJNlBxvYzPN/thW7qLts8a+/20P72bs9aGFyTh2I9NoPAD08ytXjvM4yWeUCJeqWglTkpmEy/PQ9JU9CCFAGrCrOF/53Heog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLvLsGKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLvLsGKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E691F00893;
	Sat, 30 May 2026 18:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166155;
	bh=mMTxWcV94l7A8hCjvk+VELXoykdn6wejWNK3EJ8n5Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLvLsGKZQ6VsR9B73VhYek/PDh9G0G3Zs5YB0iFIvlBEpUY6klbivyZpJj/ThdvGS
	 UZuOSCc/ui8nSIj1aoRy3AiaifyUbQRmeJiHezIWkMM0gqc7iegydwq2hQhg5JGbbc
	 PuhUsIhbTDdPh6/hIkcOHtB0B9XBX0Zep2l97090=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/589] fs/omfs: reject s_sys_blocksize smaller than OMFS_DIR_START
Date: Sat, 30 May 2026 18:02:52 +0200
Message-ID: <20260530160232.588998160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ce93ccca86392..5abd152406f51 100644
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



