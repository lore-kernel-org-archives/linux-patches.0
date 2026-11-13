Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585940;
	b=zrYoFnslCzYiK59boNk0xRSIeyzzqI7ieHTSOuAsXgjVK6JTk+fHiBISELZia0c9QDqz
	 VLQxo+UuHNzVhAoPidMkRI/gPBAuMKbGMsVNUO0W7RkYDs6z6lVar7bSFl37SnkxalH5P
	 qM6rf8YZTziBrNNEuut8gi/hC5CsLk1LHDy2LYudTb0CKN35lV/uMBd7GnBva3DAfP0xc
	 c2wyMFbEJzKPmq6gXpMjMowazV0HRDmkNjlVB2mcnJP4gXN4iKP9f2TpJ/Vo0l4ERw12z
	 Xr8EohmS/RAH4V65qTBD9+1WGreBn40NOOuJpJHm6yxxNIL+ymChAFVuYVwSMMkWDRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oavkn1aoBqf1hPDxLpPnug8fYdwQ/iYp1d9wJtQkYeY=;
	b=m2dIM2+/5zd1M7UqmaJv2aDLF6lV+z0Bh0ogysSQs0qbHHDymQbOpQ7KDdBclwz6+lzi
	 oQNo8xhWlySDfvKHssZxgkgCgXvdVUllfknUluHRj8yMC3AHgzWpg4V/seZlOvjQvIElr
	 4MYWlR5l4/bMpq4USbYbD4U0tXzJEIXhgBA9m7rMrx4lZgEk7Wjyhl05+JZ+KR63K18e+
	 McGW7UvpCLnj1+RLOW2vBAgsnkMLfabxvqT9iss6nJRtA89NhCtyME0XY2riXe5QPqlzK
	 sMjDHxc8Ew37MD8SVJIjz7KYGDX7VKJFkXO3mk46ERUy68haSeUjFpBL3QVQOCxJefw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+DXq2RL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F4F6070FC6;
	Fri, 13 Nov 2026 16:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V+DXq2RL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC251F000C4;
	Fri, 13 Nov 2026 16:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585940;
	bh=oavkn1aoBqf1hPDxLpPnug8fYdwQ/iYp1d9wJtQkYeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+DXq2RL6bwIBFIM6eFySbPfv4do+GkLE79POAdlKScQAS8m/Nm/kDpiSP1bqXrt9
	 kFagUlWrPyZj05we0OpFFAika+mowXtA1Fvz6e0U0kafd/twANRFBuRcZEUyZ66CmU
	 Rd/VERPkrTDCsnRwGMae6BT2wgq7esSt/5KH0IKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 496/507] f2fs: release a removed xattr node in roll-forward recovery
Date: Fri, 13 Nov 2026 10:53:20 -0500
Message-ID: <20261113153813.908866244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced newer node-cache helpers with f2fs_folio_put() and truncate_inode_pages_range(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 70593f95abfb5..e166c5a5d1703 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2883,6 +2883,45 @@ int f2fs_recover_inline_xattr(struct inode *inode, struct folio *folio)
 	f2fs_folio_wait_writeback(ifolio, NODE, true, true);
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
+			f2fs_folio_put(ifolio, true);
+			return err;
+		}
+
+		if (ni.blk_addr != NEW_ADDR &&
+		    !f2fs_is_valid_blkaddr(sbi, ni.blk_addr,
+					   DATA_GENERIC_ENHANCE)) {
+			f2fs_err_ratelimited(sbi,
+				"nat entry is corrupted, run fsck to fix it, ino:%u, nid:%u, blkaddr:%u",
+				ni.ino, ni.nid, ni.blk_addr);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			f2fs_handle_error(sbi, ERROR_INCONSISTENT_NAT);
+			f2fs_folio_put(ifolio, true);
+			return -EFSCORRUPTED;
+		}
+
+		f2fs_invalidate_blocks(sbi, ni.blk_addr, 1);
+		dec_valid_node_count(sbi, inode, false);
+		set_node_addr(sbi, &ni, NULL_ADDR, false);
+		/* drop the cached xattr node, which may be dirty */
+		truncate_inode_pages_range(NODE_MAPPING(sbi),
+				F2FS_BLK_TO_BYTES((loff_t)ni.nid),
+				F2FS_BLK_END_BYTES((loff_t)ni.nid));
+		f2fs_i_xnid_write(inode, 0);
+	}
+
 	f2fs_update_inode(inode, ifolio);
 	f2fs_folio_put(ifolio, true);
 	return 0;
-- 
2.53.0



