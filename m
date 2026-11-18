Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047228;
	b=sbTvduSDWlopfV2oN9GmxZRlOHEYUV2t6FyOyT7w8DhYXdi3KWF5ktkqnobURYXYuufe
	 vQEyxo3N8X7IyR7EYJxp4Q7tHybYlJNgx/F+qXQqH0YTfJrHU2ZiHkb2f1gXjjNFow226
	 DvcSdidjiERaePoYQCIAO02qVPGdJZThEOi74+QxXwdwt6uY6Kz9LiZJpJJQmN8irv+hH
	 audDRFnRB/ArZO5ZgLJ9XK7sTLmPSNQlpVdRPF3wZe8JKEWo49u1CFltrld61m+H/1wjp
	 GKvjTaxoRUgBitbUhLpYAZ/xB32uhyBWM7QWASfbnL5nZ1hr96krj8jZiygS+79z8wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xolkowR7qlUQG1M7cgVK4m0GFNLor2fe7bNZrwoh6qQ=;
	b=b8kAx4GI4hCxAbDTipy5nqfoQxVLpXluDM3uqYRJvcqxZ3i58T7Q/h+gF8H1d2tnqBl9
	 /EVT9TYFT9+/wir0He+MIIzzB44CDbGudUiRzg7klV+HUOUkYjDLq2cuKYB61ARRdZSmp
	 5R/FGiDzw5XGazgcgWLwalTZe9ybW7CXWVub+iGed6+MdC9b56i1OPOaS+r1+zeCeM3PD
	 L9MPPdZeKVKaheeiCwa/us/PsBhSDOO4jBi1Xeba/QUnwdUMpOv5IV8AtzaIcl8ilk4OB
	 tuTpGCH21D/R4Kily6lQO8bzUym32KC9BkKPiLdqnwI+5RliGeVqDfdlTGjjiMHBa9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcmPs8+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3C6606A320;
	Thu, 19 Nov 2026 00:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KcmPs8+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D831F000C4;
	Thu, 19 Nov 2026 00:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047228;
	bh=xolkowR7qlUQG1M7cgVK4m0GFNLor2fe7bNZrwoh6qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcmPs8+eDYC1zqTLjFE5uLZVGAxwNWecbsLdjNL9QWf4KjewGat5CGKWDn6KF3D4P
	 6fUkkDgWo7FEVn9LikbnKX0KxXJRy74FsXoh7QGZMDH4EN1rFrt+UqLchbYq4wWi/W
	 04Kkd4PhuJPl8eY6vp1SkcR9rOsz2aie4wbtl9rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1565/2857] f2fs: release a removed xattr node in roll-forward recovery
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150257.734894086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit f5924de8867c09206ba631b9faed63862ec00a10 ]

When xattrs shrink enough to fit in the inline xattr area,
write_all_xattrs() truncates the xattr node and clears i_xattr_nid. If
the file is then fsynced without a checkpoint, only the inode block is
written, with i_xattr_nid of 0.

Roll-forward recovery starts from the checkpointed inode, whose
i_xattr_nid still points to the old xattr node.
f2fs_recover_inline_xattr() copies only the inline xattr area, and
f2fs_update_inode() writes the old i_xattr_nid back. So the inode keeps
the stale xattr node:

 - The node block is never released, and fsck reports "nonzero bytes in
   xattr space after end of list".
 - If the inline xattr list ends exactly at the end of the inline area,
   its terminator is read from the stale node, and the removed xattrs
   come back after recovery.

When the fsynced inode has no xattr node but the checkpointed one has,
release the old xattr node as truncate_node() does: check its block
address, invalidate the block and drop its node cache, which may still
be dirty.

Fixes: 28cdce0459cc ("f2fs: recover inline xattr data in roll-forward process")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted F2FS helper calls to the existing page-based APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c85ec028baef7..4ef20021d4dc6 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2775,6 +2775,45 @@ int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 	f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 	memcpy(dst_addr, src_addr, inline_size);
 update_inode:
+	/*
+	 * The xattr node of the checkpoint was removed before fsync, e.g. the
+	 * xattrs became small enough to fit inline. Release it as well, or
+	 * the inode keeps pointing to the stale xattrs.
+	 */
+	if (!ri->i_xattr_nid && F2FS_I(inode)->i_xattr_nid) {
+		struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+		struct node_info ni;
+		int err;
+
+		err = f2fs_get_node_info(sbi, F2FS_I(inode)->i_xattr_nid,
+								&ni, false);
+		if (err) {
+			f2fs_put_page(ipage, 1);
+			return err;
+		}
+
+		if (ni.blk_addr != NEW_ADDR &&
+		    !f2fs_is_valid_blkaddr(sbi, ni.blk_addr,
+					   DATA_GENERIC_ENHANCE)) {
+			f2fs_err(sbi,
+				"nat entry is corrupted, run fsck to fix it, ino:%u, nid:%u, blkaddr:%u",
+				ni.ino, ni.nid, ni.blk_addr);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+			f2fs_put_page(ipage, 1);
+			return -EFSCORRUPTED;
+		}
+
+		f2fs_invalidate_blocks(sbi, ni.blk_addr);
+		dec_valid_node_count(sbi, inode, false);
+		set_node_addr(sbi, &ni, NULL_ADDR, false);
+		/* drop the cached xattr node, which may be dirty */
+		truncate_inode_pages_range(NODE_MAPPING(sbi),
+				F2FS_BLK_TO_BYTES((loff_t)ni.nid),
+				F2FS_BLK_END_BYTES((loff_t)ni.nid));
+		f2fs_i_xnid_write(inode, 0);
+	}
+
 	f2fs_update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
 	return 0;
-- 
2.53.0



