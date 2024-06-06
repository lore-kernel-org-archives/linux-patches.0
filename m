Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82B1974FC;
	Thu,  6 Jun 2024 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682947; cv=none; b=r9tuJwnPYkQGkWfcDKvPQhk18vPfRFeud92VN5RJyMQVdyHNhsjiTizwjjIX/tG+T+sZfYNSHh2e+zP6rviEh/wJvBYCLprAiS63D8ZBt4G+pFyTuRI+8hq0eifJEVHIaYMiO5jRk+eLHM9tfRTEVOZkRA5koUaZ91cc0D8jGXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682947; c=relaxed/simple;
	bh=+Axoq8aGPp8zhB1xgLietfIH7AzIZCWNiAOg/Hgtxes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXMheIFbrq1x5mivEXwSRKdHxkiyD4V5IjNzX/Q9R7BtYzTOsywTYAcnQpa601KWui+i1K3ByAvqHVZn8ZIu1rDV7ZIP0JkLbT8x+ye/bkFN96Y3WoWJMasF7ElNhKsympd/zizK181gysQFN8Aovp8/NPv1++paX+SoDy31ctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+Q6+I8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+Q6+I8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDBFC32781;
	Thu,  6 Jun 2024 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682947;
	bh=+Axoq8aGPp8zhB1xgLietfIH7AzIZCWNiAOg/Hgtxes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+Q6+I8Hq4nGxNWpKKtayboJHtq7C1tmQ/8DkMMBOVchD/6Jli7Dn7Ni1utGBaqZ5
	 8kEF841Io+X2DvVNCXsVdvyqZPUNIjcNp2Wy3j8yehzEpKDG2C9+sN7B7pyKKIckgb
	 oak6xli+30zkAgb2E9jlgTYRI9N+BHKgIvAUOUuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 109/374] f2fs: compress: fix to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock
Date: Thu,  6 Jun 2024 16:01:28 +0200
Message-ID: <20240606131655.571308533@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0a4ed2d97cb6d044196cc3e726b6699222b41019 ]

It needs to cover {reserve,release}_compress_blocks() w/ cp_rwsem lock
to avoid racing with checkpoint, otherwise, filesystem metadata including
blkaddr in dnode, inode fields and .total_valid_block_count may be
corrupted after SPO case.

Fixes: ef8d563f184e ("f2fs: introduce F2FS_IOC_RELEASE_COMPRESS_BLOCKS")
Fixes: c75488fb4d82 ("f2fs: introduce F2FS_IOC_RESERVE_COMPRESS_BLOCKS")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 34becfc142d80..30d438bd30ab4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3574,9 +3574,12 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 		struct dnode_of_data dn;
 		pgoff_t end_offset, count;
 
+		f2fs_lock_op(sbi);
+
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_get_dnode_of_data(&dn, page_idx, LOOKUP_NODE);
 		if (ret) {
+			f2fs_unlock_op(sbi);
 			if (ret == -ENOENT) {
 				page_idx = f2fs_get_next_page_offset(&dn,
 								page_idx);
@@ -3594,6 +3597,8 @@ static int f2fs_release_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
@@ -3744,9 +3749,12 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 		struct dnode_of_data dn;
 		pgoff_t end_offset, count;
 
+		f2fs_lock_op(sbi);
+
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_get_dnode_of_data(&dn, page_idx, LOOKUP_NODE);
 		if (ret) {
+			f2fs_unlock_op(sbi);
 			if (ret == -ENOENT) {
 				page_idx = f2fs_get_next_page_offset(&dn,
 								page_idx);
@@ -3764,6 +3772,8 @@ static int f2fs_reserve_compress_blocks(struct file *filp, unsigned long arg)
 
 		f2fs_put_dnode(&dn);
 
+		f2fs_unlock_op(sbi);
+
 		if (ret < 0)
 			break;
 
-- 
2.43.0



