Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9B51F76DB;
	Tue,  3 Dec 2024 16:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242149; cv=none; b=my0UzxVS6c18oG2mEuKwxCso7LE1EGtlWjDDaaDmhJ6dlQf2TN+Tr9+kH1+M/9pP6zC/ZG9ZN5DrVv9vz+0bGJ0Gx4w9oa3nb6Q+HNiXjPPNyaJETSKpRty3Wc4HppaxfhJc+/4B4v1N0SoMse8lP0nEdoe/Pchhuk+9fuuGedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242149; c=relaxed/simple;
	bh=aycgpjbKgoHQ5qLrlQR3M4/0lGkJGKEFk8UkXZv04JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/F3VFB6lCpffuQMBTTgLU5kSY8ChYHXS8c9gcB+UxIvb2MJt2CuPMzuc2X7SKhowPjonZmpyhtFnDtTPoXGnni1IoEsm0HIIu3DLm3IVcyVm32QE07x/cI2/LRz+413S0SiOUx0jhS1k6fFXZvb5rjBLY3pCLgGC5as8V23YXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2lC0hdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2lC0hdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB0CC4CED6;
	Tue,  3 Dec 2024 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242149;
	bh=aycgpjbKgoHQ5qLrlQR3M4/0lGkJGKEFk8UkXZv04JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2lC0hdJug5PvmuUPlgNOsyvD54K9gMLbfbwvJGPS4qWMGr3QyJCAgylqxgYw2arc
	 usFC5mpoJmesa8tzHQfkgUgrCRYfCCpgnCJLqWrPQXWhsK+JGi5Jd4+qzJKEnsMwyF
	 xI7FxH2EUagAYov+vv6xWRCCMwnmx84FU1eRN//A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiuhong Wang <xiuhong.wang@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 6.12 622/826] f2fs: fix fiemap failure issue when page size is 16KB
Date: Tue,  3 Dec 2024 15:45:49 +0100
Message-ID: <20241203144808.016638627@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiuhong Wang <xiuhong.wang@unisoc.com>

commit a7a7c1d423a6351a6541e95c797da5358e5ad1ea upstream.

After enable 16K page size, an infinite loop may occur in
fiemap (fm_length=UINT64_MAX) on a file, such as the 16KB
scratch.img during the remount operation in Android.

The condition for whether fiemap continues to map is to check
whether the number of bytes corresponding to the next map.m_lblk
exceeds blks_to_bytes(inode,max_inode_blocks(inode)) if there are HOLE.
The latter does not take into account the maximum size of a file with 16KB
page size, so the loop cannot be jumped out.

The following is the fail trace:
When f2fs_map_blocks reaches map.m_lblk=3936, it needs to go to the
first direct node block, so the map is 3936 + 4090 = 8026,
The next map is the second direct node block, that is,
8026 + 4090 = 12116,
The next map is the first indirect node block, that is,
12116 + 4090 * 4090 = 16740216,
The next map is the second indirect node block, that is,
16740216 + 4090 * 4090 = 33468316,
The next map is the first double indirect node block, that is,
33468316 + 4090 * 4090 * 4090 = 68451397316
Since map.m_lblk represents the address of a block, which is 32
bits, truncation will occur, that is, 68451397316 becomes
4026887876, and the number of bytes corresponding to the block
number does not exceed blks_to_bytes(inode,max_inode_blocks(inode)),
so the loop will not be jumped out.
The next time, it will be considered that it should still be a
double indirect node block, that is,
4026887876 + 4090 * 4090 * 4090 = 72444816876, which will be
truncated to 3725340140, and the loop will not be jumped out.

156.374871: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 0, start blkaddr = 0x8e00, len = 0x200, flags = 2,seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.374916: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 512, start blkaddr = 0x0, len = 0x0, flags = 0 , seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.374920: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 513, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
......
156.385747: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 3935, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385752: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 3936, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385755: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 8026, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385758: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 12116, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385761: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 16740216, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385764: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 33468316, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385767: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 4026887876, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385770: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 3725340140, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385772: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 4026887876, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0
156.385775: f2fs_map_blocks: dev = (254,57), ino = 7449, file offset = 3725340140, start blkaddr = 0x0, len = 0x0, flags = 0, seg_type = 8, may_create = 0, multidevice = 0, flag = 1, err = 0

Commit a6a010f5def5 ("f2fs: Restrict max filesize for 16K f2fs")
has set the maximum allowed file size to (U32_MAX + 1) * F2FS_BLKSIZE,
so max_file_blocks should be used here to limit it, that is,
maxbytes defined above. And the max_inode_blocks function is not
called by other functions except here, so cleanup it.

Signed-off-by: Xiuhong Wang <xiuhong.wang@unisoc.com>
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1902,25 +1902,6 @@ static int f2fs_xattr_fiemap(struct inod
 	return (err < 0 ? err : 0);
 }
 
-static loff_t max_inode_blocks(struct inode *inode)
-{
-	loff_t result = ADDRS_PER_INODE(inode);
-	loff_t leaf_count = ADDRS_PER_BLOCK(inode);
-
-	/* two direct node blocks */
-	result += (leaf_count * 2);
-
-	/* two indirect node blocks */
-	leaf_count *= NIDS_PER_BLOCK;
-	result += (leaf_count * 2);
-
-	/* one double indirect node block */
-	leaf_count *= NIDS_PER_BLOCK;
-	result += leaf_count;
-
-	return result;
-}
-
 int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
 {
@@ -1993,8 +1974,7 @@ next:
 	if (!compr_cluster && !(map.m_flags & F2FS_MAP_FLAGS)) {
 		start_blk = next_pgofs;
 
-		if (blks_to_bytes(inode, start_blk) < blks_to_bytes(inode,
-						max_inode_blocks(inode)))
+		if (blks_to_bytes(inode, start_blk) < maxbytes)
 			goto prep_next;
 
 		flags |= FIEMAP_EXTENT_LAST;


