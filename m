Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C0D345752;
	Thu,  2 Jul 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010609; cv=none; b=jaGxQT6/QQckyGQuK669mAw5XcihnftJayKglfuA8zH5o079StvFJmeG9TpxjJDW0BHjoeZZ/XPs+ls0ahCbP+dCn7tOxOxQvT4TQ6CiqqsD7TMw3VenVlS9nynWPyUcAa5IzZ1B6IAh3xb4aewZBe2hoC/RklRqnS3YIQ5WK8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010609; c=relaxed/simple;
	bh=Z0WzoYMK5GaIDLJr95nI/LzFUi0MGwtQyXyTVxO2R8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRYzc5B0QpqYWTBxI9TY5dJGfRXjPcWd+zVJpFT0J2Xyz3ma9IDkWcH5tMwWLzT7TbzcVj+bsLviWhYEm/VmQLjuPe5dyonOT+P/qoXhFcokjmdNYdxGqqdl0OFzbbxx8TcN7lUVSshfX1kL+76Evc+PAGc14sSmvfSc2m4gupM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/WPArzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/WPArzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032D11F000E9;
	Thu,  2 Jul 2026 16:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010608;
	bh=ZEt/zOn9L/eeoKbHxPils2jrdHfbVOY7wT7N0Q4ZxXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r/WPArzWLr+WFaNyLQjl7knj5vV/CfgiTMh6e6EarRKkqpPFO8MVSU9YnySuTGsSP
	 0fiFqskcMD/7/p9eei5Usjr8D2wqkXNMmNXVinh8MEq1/0YVze5aLxDOT8mLC8YCB0
	 F/UH9Owu3oDFgqzhSkZ+MdK3/+/PmO3mNucewtvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 157/204] f2fs: fix incorrect FI_NO_EXTENT handling in __destroy_extent_node()
Date: Thu,  2 Jul 2026 18:20:14 +0200
Message-ID: <20260702155121.948130171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 1f70ddb28a3c71df124da5fa4040c808116d6bb9 upstream.

When __destroy_extent_node() sets the inode flag FI_NO_EXTENT, it does
not reset the length of the largest extent to 0 and update the inode
folio. Since modifications to the extent tree are disallowed afterward,
the cached largest extent may become stale. This can trigger the
following error in xfstests generic/388:

F2FS-fs (dm-0): sanity_check_extent_cache: inode (ino=1761) extent info [220057, 57, 6] is incorrect, run fsck to fix

In the f2fs_drop_inode path, __destroy_extent_node() does not need to
guarantee that et->node_cnt is 0, because concurrency with writeback
is expected in this path, and writeback may update the extent cache.

This patch reverts commit ed78aeebef05 ("f2fs: fix node_cnt race between
extent node destroy and writeback"), and remove the unnecessary zero
check of et->node_cnt.

Fixes: ed78aeebef05 ("f2fs: fix node_cnt race between extent node destroy and writeback")
Cc: stable@vger.kernel.org
Reported-by: Chao Yu <chao@kernel.org>
Suggested-by: Chao Yu <chao@kernel.org>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -86,10 +86,9 @@ static bool __may_extent_tree(struct ino
 	if (!__init_may_extent_tree(inode, type))
 		return false;
 
-	if (is_inode_flag_set(inode, FI_NO_EXTENT))
-		return false;
-
 	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT))
+			return false;
 		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
 				 !f2fs_sb_has_readonly(F2FS_I_SB(inode)))
 			return false;
@@ -602,14 +601,10 @@ static unsigned int __destroy_extent_nod
 
 	while (atomic_read(&et->node_cnt)) {
 		write_lock(&et->lock);
-		if (!is_inode_flag_set(inode, FI_NO_EXTENT))
-			set_inode_flag(inode, FI_NO_EXTENT);
 		node_cnt += __free_extent_tree(sbi, et, nr_shrink);
 		write_unlock(&et->lock);
 	}
 
-	f2fs_bug_on(sbi, atomic_read(&et->node_cnt));
-
 	return node_cnt;
 }
 
@@ -639,12 +634,12 @@ static void __update_extent_tree_range(s
 
 	write_lock(&et->lock);
 
-	if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
-		write_unlock(&et->lock);
-		return;
-	}
-
 	if (type == EX_READ) {
+		if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
+			write_unlock(&et->lock);
+			return;
+		}
+
 		prev = et->largest;
 		dei.len = 0;
 


