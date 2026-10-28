Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217221;
	b=gJn5dAWAoboIECnodIesEdXBz/LyxwmCqYHejT2CNOCYEJ1PKc9BSbVrdBH/sovYk47X
	 0T7mBgrdzrFgEELF7ZC5Sn0rbDUx/56zI++cQeQx83G3gtyD6BQmgHugPs/01wsERyM1Y
	 FMFvnF0oI0x9omsmfs4MJJrv0KVbxi/yBGWjyDnzL4uzdsKKngZjElN0KyLwbWEWl4zHK
	 zKdk8+8ukRuFc5r5d2h5wbizBY1vXkVcq343XfxkAF7iWpuZPPrX7sVCfE22BjwG3uNXG
	 zk5XYUBnbnOY16b9y6YP2B+K7p9hi6XYMSJJObXAUYz/hUMKhNclzz+DNg/CeOuhZFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ysYu5yYTjEhNPZry+mb3JVMURHIz4Yg7tSDeYgWUX6o=;
	b=IJsfmlZ0/TVNpcS49eGtBKQBHNM0NCmHcRT+u6coIxquXbkybY7bHyMWJ/dmd3f05UuB
	 dw1A2xj+0X2MxrjwRYJvWbg/oYVG5YxcwvPULfjDEHN3OubCvvl7gYy49YGDmCImGuJM6
	 nSvItzPPt1RqGbgqU9wnkNK0i/QDLd7pBmvgVPstb0EE4w4/U+g+BXvCgn4tC0YMkpOg2
	 ocqGeUlbejdjpC28ySiIUYngx2PFvSGrazR1zc56KP05L6RKDeDN9rHjuf8hJx1VhbAf2
	 N3vLqCzLwESRU+95D95vjE/DwfQy+Ej9DGDDxw/DebKuGzT4u0IXwzBSQQkMqYF1+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNR7IH89;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7B2606A31A;
	Wed, 28 Oct 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNR7IH89
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FB71F01825;
	Wed, 28 Oct 2026 19:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217221;
	bh=ysYu5yYTjEhNPZry+mb3JVMURHIz4Yg7tSDeYgWUX6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNR7IH89rPeiTtgFOKoAgqtgMCmtAi7vm57Q56YfMDhwhXjSZCiTqZ4miulJS8bG2
	 pulcqd/0qcxHqkTQLUF8Nsjr3vk2RlpX69eYthMOvjZRXEWuDthw0XIn2tlK+2X0ae
	 q4rlgfGaCyDHJGfhBvM0OjINGiRlXQp0HFAXh0lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1827/1887] f2fs: fix node_cnt race between extent node destroy and writeback
Date: Wed, 28 Oct 2026 18:05:23 +0100
Message-ID: <20261028170541.017998053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit ed78aeebef05212ef7dca93bd931e4eff67c113f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index f84493c7b072c..b4c14efc83cd8 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -76,9 +76,10 @@ static bool __may_extent_tree(struct inode *inode, enum extent_type type)
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
@@ -623,6 +624,8 @@ static unsigned int __destroy_extent_node(struct inode *inode,
 
 	while (atomic_read(&et->node_cnt)) {
 		write_lock(&et->lock);
+		if (!is_inode_flag_set(inode, FI_NO_EXTENT))
+			set_inode_flag(inode, FI_NO_EXTENT);
 		node_cnt += __free_extent_tree(sbi, et, nr_shrink);
 		write_unlock(&et->lock);
 	}
@@ -654,12 +657,12 @@ static void __update_extent_tree_range(struct inode *inode,
 						tei->blk, 0);
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
 
-- 
2.53.0



