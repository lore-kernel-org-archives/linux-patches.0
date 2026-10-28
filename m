Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215150;
	b=383ynxv4KAowQRBaJo/z99/Qd4gN3cISWrP2KC9iRiPnlwLyzZp3xH2IQ5gBP7zAYCti
	 dh21F/4nGNy5XiMCBtY/rkWX8tZydixBPjlIyMTT90DXwkY1sPG2/Sk3MH0gbU+PbxjVH
	 eZGnoQYN2NY7BAnoO2amSX/49yU+WValFJszWXd+yNxMxldjVQA4yZPZFH9n9jsMsSLQM
	 Br1q97oyvd3CEo2lojJETFTenujZGhnNYTKscbPA5CFCN/Z1e6elIt3Fjj689jHJ45d7j
	 BunajVOpUocVzYib1pBTekPVgEjYUThloiUQi1XfIBMwxWBiJM2scAPDCelfSqYKUQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o7HF4vCoJFPxGL197qsoEjafUlRuBbOqJuLsYigksts=;
	b=zP4tM2niugN0rwIcHluvwuMEE2de7wFC8dvxrc91gQtg7M/Czk9RJsa7S8Ivl2X1acFi
	 NGR6I2Zo7sDerdi7u1JrrUrlNUyGWEmnHr2gyKqm8ZDPvO8bXfCpNuY2gTdQboOqx7slT
	 LeYahSSMuuzS4Az/YcMI8eH92rWtoEJ/idOC6tD8+3xQ7hYOvPZMcg+Kw2NefRZjTqyHa
	 7CFed5P2hfu+ygKaUht+bhKQCDG5I73ScM4tZmDAEq6e9e4cWKmgBc8iuYSIPGeqf3H0J
	 v43QPpniuKkxY7FDoNV6LCuUxSg3HuT1B31wNem0rONsP5rvzcBJRGMutkwlrgmpBfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgZvNgr6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457A606A32C;
	Wed, 28 Oct 2026 19:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgZvNgr6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A101F01825;
	Wed, 28 Oct 2026 19:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215150;
	bh=o7HF4vCoJFPxGL197qsoEjafUlRuBbOqJuLsYigksts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgZvNgr6rFbKE3lib6I3ZK/iYF17RFm1mqBZME+f0Cr90w7s03q3TZAcoQo8nwKb1
	 V/Kdir1acro2famHGPBWW2d3rR/EMrB4hLbnLLbX8yZ0kFGtvaEcVWqMT8XZntnNYs
	 BeFkb2q3JujEJjsmKNWmmEPy5zgsauu8h3Pj0vjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1110/1887] f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage
Date: Wed, 28 Oct 2026 17:53:26 +0100
Message-ID: <20261028170524.663199794@linuxfoundation.org>
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

[ Upstream commit 019f9dda7f66e55eb94cd32e1d3fff5835f73fbc ]

f2fs_need_dentry_mark() reads nat_entry flags without mutual exclusion
with the checkpoint path, which can result in an incorrect inode block
marking state. The scenario is as follows:

create & write & fsync 'file A'                 write checkpoint
- f2fs_do_sync_file // inline inode
 - f2fs_write_inode // inode folio is dirty
                                                - f2fs_write_checkpoint
                                                 - f2fs_flush_merged_writes
                                                 - f2fs_sync_node_pages
 - f2fs_fsync_node_pages // no dirty node
 - f2fs_need_inode_block_update // return true
 - f2fs_fsync_node_pages // inode dirtied
  - f2fs_need_dentry_mark //return true
                                                 - f2fs_flush_nat_entries
                                                - f2fs_write_checkpoint end
  - __write_node_folio // inode with DENT_BIT_SHIFT set
  SPO, "fsck --dry-run" find inode has already checkpointed but still
  with DENT_BIT_SHIFT set

The state observed by f2fs_need_dentry_mark() can differ from the state
observed in __write_node_folio() after acquiring sbi->node_write. The
root cause is that the semantics of IS_CHECKPOINTED and
HAS_FSYNCED_INODE are only guaranteed after the checkpoint write has
fully completed.

This patch moves set_dentry_mark() into __write_node_folio() and
protects it with the sbi->node_write lock.

Cc: stable@kernel.org
Fixes: 88bd02c9472a ("f2fs: fix conditions to remain recovery information in f2fs_sync_file")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d384c56c72b3e..2cfe99772b3fa 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1692,13 +1692,12 @@ static int __write_node_page(struct page *page, bool atomic, bool *submitted,
 		goto redirty_out;
 	}
 
-	if (atomic) {
-		if (!test_opt(sbi, NOBARRIER) && !f2fs_sb_has_blkzoned(sbi))
-			fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
-		if (IS_INODE(page))
-			set_dentry_mark(page,
+	if (atomic && !test_opt(sbi, NOBARRIER) && !f2fs_sb_has_blkzoned(sbi))
+		fio.op_flags |= REQ_PREFLUSH | REQ_FUA;
+
+	if (IS_INODE(page) && (atomic || is_fsync_dnode(page)))
+		set_dentry_mark(page,
 				f2fs_need_dentry_mark(sbi, ino_of_node(page)));
-	}
 
 	/* should add to global list before clearing PAGECACHE status */
 	if (f2fs_in_warm_node_list(sbi, page)) {
@@ -1853,9 +1852,6 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 					if (is_inode_flag_set(inode,
 								FI_DIRTY_INODE))
 						f2fs_update_inode(inode, page);
-					if (!atomic)
-						set_dentry_mark(page,
-							f2fs_need_dentry_mark(sbi, ino));
 				}
 				/* may be written by other thread */
 				if (!PageDirty(page))
-- 
2.53.0



