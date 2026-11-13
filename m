Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591600;
	b=yj3em5Dt1dcJ29Q54ai+s2rn6vcDQ2yw4KXp0WcLWCmCGLLRbPpoJMYX8IcRtTDnKssl
	 XsvmRd+vk/oHajYoPq/hxh7n78LvQ9KCWmV3hCNkTSSk4+sCcucc/fJAl/BzpodbWDHhl
	 y8ASiFqBCkGbxUB2xIfsaPCAK7vjtoF5dHZDyvFFy17hzOFZuX16MWgkXUKuoHzRA1yC9
	 RzrrJ7j0LjQVTB1+h7agMhTPMxZELanSUaZGcu/fhoiwetnbrvJNntOHX0dPhdNejOdRp
	 a6xY/rksTw2CiLb4BGAfd1Hasguc9tGGjrNbineldljbNtIWGrx+fewJjLZ9HP1ZcXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hKuxo9SSvb2O6VR53Im5kQExOK+KmFPxz9HU4IdWO74=;
	b=eQtstx0sPul6ZIKvzopYYR5RXgip50rgBZMuYVXwirJRKgXgloT0c2WV6VYJvyz6mYKL
	 HzWRdV9GBfI5vVyk0sAKWYbm/zbk9tcYbE58ED/nZbjtpvnZxuOPmovJKgd/L7LybF6fG
	 leN4/sVXxXs62oN2quKxcCBMfZZqgfmY1ZuCFsXtRkHLmuIiaxt+TIbqAOSXnCwBHd6Ft
	 uQk6DPDMDgYlrKv8TDIoR91ScFBPpMBLAWv9pfWhTZisvf2MotQw+RJUYz1WQupymQAck
	 +scU1UTDU68tsFFGewRkgl2XoaHPzkFr6/5zYx6jMjQWdK8W+dVwJH6EYoKC2trACOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tY2iIRKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FC5606A8A1;
	Fri, 13 Nov 2026 17:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tY2iIRKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F92B1F000C4;
	Fri, 13 Nov 2026 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591600;
	bh=hKuxo9SSvb2O6VR53Im5kQExOK+KmFPxz9HU4IdWO74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tY2iIRKjth3gvSFF+xl+0eRNbooBlJpS2dk8cwEO62aRQc8bgfC7LRK+EQwowfbpO
	 YShWUm2BVfMpXK2DHpK8dv4KCXDeUAFMm3dCZKCgeOQO/zvbY2K4Or/rkVFA1hYle9
	 7OYoqN902YC/j92P7f0HTkFO2JRWonamDOi97JbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 643/670] f2fs: release a removed xattr node in roll-forward recovery
Date: Fri, 13 Nov 2026 10:53:27 -0500
Message-ID: <20261113153833.581330337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted upstream API calls to the existing page-based cache and single-block invalidation interfaces ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 963adcf00e910..231a9281968e4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2779,6 +2779,45 @@ int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
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
+			f2fs_err_ratelimited(sbi,
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



