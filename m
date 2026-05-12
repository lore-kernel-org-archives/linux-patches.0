Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B30F3EDE47;
	Tue, 12 May 2026 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608820; cv=none; b=t/kFqSLWqaGKkS0M8dxRg9IB6Ii/KF274bPu7wz4ceABhaXKiLSSY7LhESFagFhoSCh/NcYXx5trAJDpSfev0ETDCcaDMrC2l62PN/9hg5UVVwfwk5W/s1gQzqroRnrn8CAUoAH6T2DZz3Y9cUKMk7YeXWxh6VYbr7xBQLAqcj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608820; c=relaxed/simple;
	bh=t6Y3wZyy4xZr8WSXFOFarAC4w2tosVGTzdwc21etsNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXy3KAhsY4lOQTrxcxLD48GryWFz7d3wKNKKShlPuOUIZJtSZTBh7V8+m+7ZjLku5cC48qem9vEpe8xhJVKTM6cPluhwpYxAjuJCzfx+gzUTcb4nI/3o0Z6+SEl7bj2gXjeZRSnNM0sw3pWy9zNttOxgSCthqbQkxUM7DR+/Yag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtUJTjK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtUJTjK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5F0C2BCB0;
	Tue, 12 May 2026 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608820;
	bh=t6Y3wZyy4xZr8WSXFOFarAC4w2tosVGTzdwc21etsNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtUJTjK5Bx9OMem0G+4JNDfW6Tzgo4TmEVXEwXFDcSLxmc9BVoNq5eiHt8Soz9bVu
	 5i9qgNqf9yzx+nskFCmw4qYiO1DW1sBWe3Iqer9GLmILGd2KWmC315Z5QpqwX5UAWP
	 UJW4C5JtOxxJoZDJmmkz72Nf9TZp+N8Ul0Fm0K7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 228/270] f2fs: fix node_cnt race between extent node destroy and writeback
Date: Tue, 12 May 2026 19:40:29 +0200
Message-ID: <20260512173943.246192625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit ed78aeebef05212ef7dca93bd931e4eff67c113f upstream.

f2fs_destroy_extent_node() does not set FI_NO_EXTENT before clearing
extent nodes. When called from f2fs_drop_inode() with I_SYNC set,
concurrent kworker writeback can insert new extent nodes into the same
extent tree, racing with the destroy and triggering f2fs_bug_on() in
__destroy_extent_node(). The scenario is as follows:

drop inode                            writeback
 - iput
  - f2fs_drop_inode  // I_SYNC set
   - f2fs_destroy_extent_node
    - __destroy_extent_node
     - while (node_cnt) {
        write_lock(&et->lock)
        __free_extent_tree
        write_unlock(&et->lock)
                                       - __writeback_single_inode
                                        - f2fs_outplace_write_data
                                         - f2fs_update_read_extent_cache
                                          - __update_extent_tree_range
                                           // FI_NO_EXTENT not set,
                                           // insert new extent node
       } // node_cnt == 0, exit while
     - f2fs_bug_on(node_cnt)  // node_cnt > 0

Additionally, __update_extent_tree_range() only checks FI_NO_EXTENT for
EX_READ type, leaving EX_BLOCK_AGE updates completely unprotected.

This patch set FI_NO_EXTENT under et->lock in __destroy_extent_node(),
consistent with other callers (__update_extent_tree_range and
__drop_extent_tree) and check FI_NO_EXTENT for both EX_READ and
EX_BLOCK_AGE tree.

Fixes: 3fc5d5a182f6 ("f2fs: fix to shrink read extent node in batches")
Cc: stable@vger.kernel.org
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -119,9 +119,10 @@ static bool __may_extent_tree(struct ino
 	if (!__init_may_extent_tree(inode, type))
 		return false;
 
+	if (is_inode_flag_set(inode, FI_NO_EXTENT))
+		return false;
+
 	if (type == EX_READ) {
-		if (is_inode_flag_set(inode, FI_NO_EXTENT))
-			return false;
 		if (is_inode_flag_set(inode, FI_COMPRESSED_FILE) &&
 				 !f2fs_sb_has_readonly(F2FS_I_SB(inode)))
 			return false;
@@ -644,6 +645,8 @@ static unsigned int __destroy_extent_nod
 
 	while (atomic_read(&et->node_cnt)) {
 		write_lock(&et->lock);
+		if (!is_inode_flag_set(inode, FI_NO_EXTENT))
+			set_inode_flag(inode, FI_NO_EXTENT);
 		node_cnt += __free_extent_tree(sbi, et, nr_shrink);
 		write_unlock(&et->lock);
 	}
@@ -688,12 +691,12 @@ static void __update_extent_tree_range(s
 
 	write_lock(&et->lock);
 
-	if (type == EX_READ) {
-		if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
-			write_unlock(&et->lock);
-			return;
-		}
+	if (is_inode_flag_set(inode, FI_NO_EXTENT)) {
+		write_unlock(&et->lock);
+		return;
+	}
 
+	if (type == EX_READ) {
 		prev = et->largest;
 		dei.len = 0;
 


