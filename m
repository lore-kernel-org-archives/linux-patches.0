Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4486C215795;
	Thu, 12 Dec 2024 15:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015898; cv=none; b=AYaYU+XfV8UV0BNZx8Mc3e8J7jVmv9IbmI3I4ahik7E2qNOd8WdKQ2BV/wYxVS8bkBfyFTmj25Z1S24AIvxq1QMBR/QoYjMKiCgTK9JyaYv4ugZ9fcthKhUMtt9QFCpW5h4ZD5+tUCbaZFrcn68YU8zgVL03ucEPsIDtBoqMZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015898; c=relaxed/simple;
	bh=s1aJDrksTe2lVpTpVR9u69ax7KBkHhJOxijPZ7zZcTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2KZfYWMXxq7dlPkQyVAPsqQ5zhc59vZeuDGyx3ZQ3B8TSXEWxXCwuqCfiyXLvprNVr5s4x9dG9PArf93nNFdtbUQKsVgem9QxZsQb1cie+CZ53CR+4K2Vji2yqjYFXCotxp7ShFlZ/QLrXR+gGwwWeT6WWgKQEz+YmbWHqjPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW7Sh311; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW7Sh311"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4188C4CECE;
	Thu, 12 Dec 2024 15:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015898;
	bh=s1aJDrksTe2lVpTpVR9u69ax7KBkHhJOxijPZ7zZcTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW7Sh311JVsAowdM/ICs+tlDXFbAcOyUUPwHNWENWx5fNSRcYYIMkSj3wmaRGsg6S
	 8kFM6yZhwVpUpc9yUY3Ro4M7gDvhTtrBcb6YjM6P+8s7LYLYe1zjAZeuj6LenVRteG
	 CZzeL7u6fIs8ERF9uJnVwaapd0JONYWcopKUFDpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/466] f2fs: fix to requery extent which cross boundary of inquiry
Date: Thu, 12 Dec 2024 15:54:04 +0100
Message-ID: <20241212144309.781943925@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 6787a82245857271133b63ae7f72f1dc9f29e985 ]

dd if=/dev/zero of=file bs=4k count=5
xfs_io file -c "fiemap -v 2 16384"
file:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..31]:         139272..139303      32 0x1000
     1: [32..39]:        139304..139311       8 0x1001
xfs_io file -c "fiemap -v 0 16384"
file:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..31]:         139272..139303      32 0x1000
xfs_io file -c "fiemap -v 0 16385"
file:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..39]:         139272..139311      40 0x1001

There are two problems:
- continuous extent is split to two
- FIEMAP_EXTENT_LAST is missing in last extent

The root cause is: if upper boundary of inquiry crosses extent,
f2fs_map_blocks() will truncate length of returned extent to
F2FS_BYTES_TO_BLK(len), and also, it will stop to query latter
extent or hole to make sure current extent is last or not.

In order to fix this issue, once we found an extent locates
in the end of inquiry range by f2fs_map_blocks(), we need to
expand inquiry range to requiry.

Cc: stable@vger.kernel.org
Fixes: 7f63eb77af7b ("f2fs: report unwritten area in f2fs_fiemap")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a126fecc808c4..da0960d496ae0 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1896,7 +1896,7 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		u64 start, u64 len)
 {
 	struct f2fs_map_blocks map;
-	sector_t start_blk, last_blk;
+	sector_t start_blk, last_blk, blk_len, max_len;
 	pgoff_t next_pgofs;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = 0;
@@ -1940,14 +1940,13 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 	start_blk = F2FS_BYTES_TO_BLK(start);
 	last_blk = F2FS_BYTES_TO_BLK(start + len - 1);
-
-	if (len & F2FS_BLKSIZE_MASK)
-		len = round_up(len, F2FS_BLKSIZE);
+	blk_len = last_blk - start_blk + 1;
+	max_len = F2FS_BYTES_TO_BLK(maxbytes) - start_blk;
 
 next:
 	memset(&map, 0, sizeof(map));
 	map.m_lblk = start_blk;
-	map.m_len = F2FS_BYTES_TO_BLK(len);
+	map.m_len = blk_len;
 	map.m_next_pgofs = &next_pgofs;
 	map.m_seg_type = NO_CHECK_TYPE;
 
@@ -1970,6 +1969,17 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		flags |= FIEMAP_EXTENT_LAST;
 	}
 
+	/*
+	 * current extent may cross boundary of inquiry, increase len to
+	 * requery.
+	 */
+	if (!compr_cluster && (map.m_flags & F2FS_MAP_MAPPED) &&
+				map.m_lblk + map.m_len - 1 == last_blk &&
+				blk_len != max_len) {
+		blk_len = max_len;
+		goto next;
+	}
+
 	compr_appended = false;
 	/* In a case of compressed cluster, append this to the last extent */
 	if (compr_cluster && ((map.m_flags & F2FS_MAP_DELALLOC) ||
-- 
2.43.0



