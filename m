Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA977343D9D;
	Tue, 12 May 2026 18:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609638; cv=none; b=q9d+QZGfnYjLc095IBfLMtdtvIStWlQ8aldjCNgh0uhlpTuV3KiUJ80JBtxmU26Bq2Ceisr8Ynpw044y/1VSOOp/3STAhywLvU5WQ7LARLnOaabTmVLIT6WrpNgqswki7/EKAv3g85Rvym8Ta6v8Nq1a1Agt+EdGIP3dnpWp4Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609638; c=relaxed/simple;
	bh=TQaTBELHloQ+MRjeW5Z+0IdXmFBrXw55nl1iTGNSVVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0GjFP0Iq+GcXsF3RRYPwt370qKVttNzvBmh7av5n9w+wgNutjkqHD/zmUsywKkyZ6ED8MKYNseFG2Nw5CawXH9mEWn9Zn6FvtZ5DMTCUORCMqloWbQwB1rcWAdMm3DbIMfPQrkgkF1LulIxrwjRCcMbXjdqDugGJoan0w2xOZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQLAiwjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQLAiwjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A9AC2BCB0;
	Tue, 12 May 2026 18:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609638;
	bh=TQaTBELHloQ+MRjeW5Z+0IdXmFBrXw55nl1iTGNSVVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQLAiwjO+GrekjJQm++jkBSfeULPlufbWG/v1To0RpFa/E+xlbYQhgBOHohxiX7ou
	 Eb2E82x6H4v5MlzJCgjFnY/IDEPo7wHttnZVR8rsJABV5rWIwLEt5Uqkadr3KENGma
	 Gwt+154AKDwfArWE0E7cKgH8p5vrtTlEIPsMq010=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 273/307] f2fs: fix node_cnt race between extent node destroy and writeback
Date: Tue, 12 May 2026 19:41:08 +0200
Message-ID: <20260512173945.887070052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 


