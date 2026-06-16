Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA93F3ACA5A;
	Tue, 16 Jun 2026 19:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636630; cv=none; b=iYsjnPgmrfsXYlV3ECrEzCAuAuJ9ksj6XQty2B17YwNDbwvWr0OGffbWp8xLQ1+a9Ipb+6iavlrICSZFtiq4Bp6L2O4BnJroW7VNB9cF53cQCTDAPTwu1/8OMPmyrC4JD5IoCNxy53NNlgxm6ohGs5IUjMmkxpt2dmwLQbBfI08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636630; c=relaxed/simple;
	bh=3wBseRu2ayxH6m2RDqAGObWfYxiH5HeMxApS337o0oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLFNjsGctlARFv5bxbZ5N3CfYK0/sf9UclEtSUHEUUU/8KpD/9dMpAmrTfwceLMSdpa5wFVGPFLOWZcRLGeJUqRhb08ryrLAWZ6jCoaYVS/I1bC4MQ2W+b+KAqPYZYr8gVSLfz89MPayk2I9FQAda3RZOYoK1+kPXLx4IMsnNjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgRsCbz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgRsCbz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2861F000E9;
	Tue, 16 Jun 2026 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636629;
	bh=N5u9//6vff88tpi+BbmMGn/IIrZTrSunnllSclr/vnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgRsCbz6ACJTdllWBzHaU6mCClUHMCYBm+OMCTqxrB6NOqxiyIiXhlSf7WDRMFGZD
	 SBL4b+OzWnvBbfoQipVIDS7fCqtDbTB3MZOGwubWIixGkIA4lrvMN4eo4rwmIPdx27
	 0uu7xCnNinXiTsqwFi2WkpEZS7kmFKNHJ5vLLmSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/342] f2fs: fix incorrect file address mapping when inline inode is unwritten
Date: Tue, 16 Jun 2026 20:29:31 +0530
Message-ID: <20260616145101.171458650@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 68a0178981a0f493295afa29f8880246e561494c ]

When `fileinfo->fi_flags` does not have the `FIEMAP_FLAG_SYNC` bit set
and inline data has not been persisted yet, the physical address of the
extent is calculated incorrectly for unwritten inline inodes.

root@vm:/mnt/f2fs# dd if=/dev/zero of=data.3k bs=3k count=1
root@vm:/mnt/f2fs# f2fs_io fiemap 0 100 data.3k
Fiemap: offset = 0 len = 100
	logical addr.    physical addr.   length           flags
0	0000000000000000 00000ffffffff16c 0000000000000c00 00000301

This patch fixes the issue by checking if the inode's address is valid.
If the inline inode is unwritten, set the physical address to 0 and
mark the extent with `FIEMAP_EXTENT_UNKNOWN | FIEMAP_EXTENT_DELALLOC`
flags.

Cc: stable@kernel.org
Fixes: 67f8cf3cee6f ("f2fs: support fiemap for inline_data")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ renamed `ifolio` to `ipage` in `inline_data_addr()` and `F2FS_INODE()` calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inline.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -761,7 +761,7 @@ int f2fs_read_inline_dir(struct file *fi
 int f2fs_inline_data_fiemap(struct inode *inode,
 		struct fiemap_extent_info *fieinfo, __u64 start, __u64 len)
 {
-	__u64 byteaddr, ilen;
+	__u64 byteaddr = 0, ilen;
 	__u32 flags = FIEMAP_EXTENT_DATA_INLINE | FIEMAP_EXTENT_NOT_ALIGNED |
 		FIEMAP_EXTENT_LAST;
 	struct node_info ni;
@@ -794,9 +794,14 @@ int f2fs_inline_data_fiemap(struct inode
 	if (err)
 		goto out;
 
-	byteaddr = (__u64)ni.blk_addr << inode->i_sb->s_blocksize_bits;
-	byteaddr += (char *)inline_data_addr(inode, ipage) -
-					(char *)F2FS_INODE(ipage);
+	if (__is_valid_data_blkaddr(ni.blk_addr)) {
+		byteaddr = (__u64)ni.blk_addr << inode->i_sb->s_blocksize_bits;
+		byteaddr += (char *)inline_data_addr(inode, ipage) -
+						(char *)F2FS_INODE(ipage);
+	} else {
+		f2fs_bug_on(F2FS_I_SB(inode), ni.blk_addr != NEW_ADDR);
+		flags |= FIEMAP_EXTENT_DELALLOC | FIEMAP_EXTENT_UNKNOWN;
+	}
 	err = fiemap_fill_next_extent(fieinfo, start, byteaddr, ilen, flags);
 	trace_f2fs_fiemap(inode, start, byteaddr, ilen, flags, err);
 out:


