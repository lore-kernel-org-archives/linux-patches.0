Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0095284B3B;
	Tue, 17 Feb 2026 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361552; cv=none; b=ZBW12SV+8Ahi7CNWAYy+hp0eLhUycvsUDCPFdIRVoJP4hbPydH2RdDfum3GiQcv9e3FpE1l29ggi0O+OfBHqOgcj64F2BHDtY8XBcVEuzwqrXmxiygTCLabuIWJaQPlfL6L5hyXbKFaa2hOSmTNGKGsM4AyGcQxHWZ8bp1VTwA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361552; c=relaxed/simple;
	bh=Hmh1wP07ABTdiUIuorwa0N7R/l2CGVyu15nMW0jc2nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an4W5+oD8l5XkD7os9WNabqXlNQ8vE8oB/bqrocPcYyr40+IpBj6vYAyWOeCAgyHe9jr7uXGAc//CFR3ckJzLAAYLYgeunqk9PEzON5CVztw4dzs5hGU3ji6VfWs5Yr+ciKEaJdL1OcHRD3QIISZeBkyEP58F6TCTRABYxERRhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faSNrhna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faSNrhna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC1EC4CEF7;
	Tue, 17 Feb 2026 20:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361552;
	bh=Hmh1wP07ABTdiUIuorwa0N7R/l2CGVyu15nMW0jc2nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faSNrhna4PNMaZEZ+ATYmKe0MdnHQ/GIL46OWbSC+thshBQbjfsypx8/D1hH/Ac4U
	 95utMlD8AEax6qVsO0yuLqaG164uhEQ0FIuvBQUPfNWc3yuz1VM5yM81ed+YuXqkC2
	 Chb/0rT8DkK+A/9YlZz2W/9rz7jklIV53TcIZJMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Sunmin Jeong <s_min.jeong@samsung.com>,
	Yeongjin Gil <youngjin.gil@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 39/43] f2fs: optimize f2fs_overwrite_io() for f2fs_iomap_begin
Date: Tue, 17 Feb 2026 21:32:19 +0100
Message-ID: <20260217200007.965789196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200006.470920131@linuxfoundation.org>
References: <20260217200006.470920131@linuxfoundation.org>
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

From: Yeongjin Gil <youngjin.gil@samsung.com>

commit d860974a7e38d35e9e2c4dc8a9f4223b38b6ad99 upstream.

When overwriting already allocated blocks, f2fs_iomap_begin() calls
f2fs_overwrite_io() to check block mappings. However,
f2fs_overwrite_io() iterates through all mapped blocks in the range,
which can be inefficient for fragmented files with large I/O requests.

This patch optimizes f2fs_overwrite_io() by adding a 'check_first'
parameter and introducing __f2fs_overwrite_io() helper. When called from
f2fs_iomap_begin(), we only check the first mapping to determine if the
range is already allocated, which is sufficient for setting
map.m_may_create.

This optimization significantly reduces the number of f2fs_map_blocks()
calls in f2fs_overwrite_io() when called from f2fs_iomap_begin(),
especially for fragmented files with large I/O requests.

Cc: stable@kernel.org
Fixes: 351bc761338d ("f2fs: optimize f2fs DIO overwrites")
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Sunmin Jeong <s_min.jeong@samsung.com>
Signed-off-by: Yeongjin Gil <youngjin.gil@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1799,7 +1799,8 @@ out:
 	return err;
 }
 
-bool f2fs_overwrite_io(struct inode *inode, loff_t pos, size_t len)
+static bool __f2fs_overwrite_io(struct inode *inode, loff_t pos, size_t len,
+				bool check_first)
 {
 	struct f2fs_map_blocks map;
 	block_t last_lblk;
@@ -1821,10 +1822,17 @@ bool f2fs_overwrite_io(struct inode *ino
 		if (err || map.m_len == 0)
 			return false;
 		map.m_lblk += map.m_len;
+		if (check_first)
+			break;
 	}
 	return true;
 }
 
+bool f2fs_overwrite_io(struct inode *inode, loff_t pos, size_t len)
+{
+	return __f2fs_overwrite_io(inode, pos, len, false);
+}
+
 static int f2fs_xattr_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo)
 {
@@ -4191,7 +4199,7 @@ static int f2fs_iomap_begin(struct inode
 	 * f2fs_map_lock and f2fs_balance_fs are not necessary.
 	 */
 	if ((flags & IOMAP_WRITE) &&
-		!f2fs_overwrite_io(inode, offset, length))
+		!__f2fs_overwrite_io(inode, offset, length, true))
 		map.m_may_create = true;
 
 	err = f2fs_map_blocks(inode, &map, F2FS_GET_BLOCK_DIO);


