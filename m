Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054139;
	b=Mr33sI4bycpQhdJga5CEAiSoOLJzMw8tY7aDFWfRfQtvm/soF9xXLnpLV+kyzKGMH7KQ
	 n228pfxczYTHYg4fMBhtokPGq/Tjo1VtiPNDwSSZRo9xcvXjp5Fz9spYmN0EVvUjr08x2
	 3I9gNVC4I10Bnp5dwbzU6XCxgPsEj52+WwUb+V90O4chg9ek9ARyhRoZZ1oMGZhbmlV0X
	 m85WvZyb346R5F2AQexiqDhydtLWcXiyvr7s3Y83b4lxk25qGDGzzltixh7ox8mmYHLL+
	 clouODlCHIawXFFqbu9qcq2/0/fJGtT1tFJyvdgG4ezEVKzxxkZjGOgMC2gKZHk+01A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IP8ZsZqTZB2XALUgML3QrPfquQ77pRF/aAQ0+HkUAME=;
	b=IAC/VqzTH2fpGe0VSlyhUOWToaeOdHuZQNaXGZBMe3JlLtFnCkvbsLlawV0o3GEOw7b5
	 XACXHMRClNQsM/ooQdpc4JoL1dswTZXv9XTCRyBYnMkFx8abAHUnF0t0YgA5hRSYDgqQ0
	 XWX0Ujd2T5MVpYGLGK32VZJbpTz6PtEXHEHDJ3+mL4wok2DtmzFE0M8KWVSyRJxviqlCt
	 3lGU7i5VpPLiG3ZY+Ac2eLejvZ8johigh7yjWrD+XKZm5EnUqgAYUqZP3zs3fITTxYXDB
	 7vF3+8ifHOGl08yGhPGt7x1eoiYK2vuaELzBoOZd6xcUL1qpHf+63DAKDRv0SV5Mitw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IbJ4nrm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4321606A31C;
	Thu, 19 Nov 2026 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1IbJ4nrm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F791F000C4;
	Thu, 19 Nov 2026 02:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054138;
	bh=IP8ZsZqTZB2XALUgML3QrPfquQ77pRF/aAQ0+HkUAME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1IbJ4nrmSnxKT48abdc+MXZ4gu4ngK1TniTekIhj9cRIerQzXD0P3qiyd5C3faB2F
	 Svuh7XNPjzLLVILQrJ+npQW8sPE/J4+9FUERtT85/tBsk56hsYPN2LWt6XgbjKFik5
	 X8ncEaLJR/q99xBY607A65mGf6lWd9BVoMBrUWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1169/2214] f2fs: release a removed xattr node in roll-forward recovery
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118150058.772581297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted newer F2FS helpers to existing page-based APIs and legacy error handling ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 65f3501b939e0..cd2ffc8e1e94e 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2725,6 +2725,44 @@ int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
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
+				F2FS_BLK_TO_BYTES((loff_t)ni.nid + 1) - 1);
+		f2fs_i_xnid_write(inode, 0);
+	}
+
 	f2fs_update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
 	return 0;
-- 
2.53.0



