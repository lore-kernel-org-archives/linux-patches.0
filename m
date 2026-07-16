Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649EE426429;
	Thu, 16 Jul 2026 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209425; cv=none; b=UK61y2I4pF+s1UScCe1BynKM+yoHPo6nvODfH0YziY84u/mEsJuRtGcTu6iaAUD6tqgYJZpf0obodt9GDyhzea8GlbmRyzEr5O3sUhGdltZnJ8QeFXDvRHN1DR6eKIcf7QrkOxS+c/CRr5M7ZZ8CbLjQq3uypFbY+ZHPxox30tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209425; c=relaxed/simple;
	bh=yulUo+3I8MUGAV+36FsuMQNUnvWos2xB92hM1y3+Xf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kqp1X6FsgrJnL+z+zHvCXpAiXRw+Xqkw4aTFpIPQ7eIxnzZdfFsbMlOjCCn6njxRxO25F3KtbdJ3ASs10I23hyvQ6oawdghaNlquhxun2YMudkkvKN5+8PPDmkAB2eQHdfHhRnBngKVPtYTBPLzeSABExMbp7H90zueBiX7Z0Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5BWnkb4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5BWnkb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2231F01558;
	Thu, 16 Jul 2026 13:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209418;
	bh=RV29dvZ7CsF+U9S2nOPbpPbRTulyYwLapTEnr4VPY+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5BWnkb4vaJomTqbaXYVNza4EeMZ18L2yx7oXOxlp6azkK/MshkfaUfnk6UkZ/HiT
	 eM+7YESKPczYmdNLywJRMUfk20PwaKOjOlmZviNTZNDGKVD784sCXCBCfVCqQIG+NF
	 mfYuePj9lpw7pniCcOm9Qu3RIjGKHLIEYhTJQrig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valeriy Yashnikov <yashnikov.valeriy@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 179/518] ntfs: avoid calling post_write_mst_fixup() for invalid index_block
Date: Thu, 16 Jul 2026 15:27:27 +0200
Message-ID: <20260716133051.754092805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valeriy Yashnikov <yashnikov.valeriy@gmail.com>

commit 5b6eedd7cc2936f9238e852b553a1b326105bde8 upstream.

ntfs_icx_ib_sync_write() calls post_write_mst_fixup() when ntfs_ib_write()
returns an error, intending to restore the buffer after a failed write.

However, ntfs_ib_write() returns an error immediately if
pre_write_mst_fixup() validation fails. The caller,
ntfs_icx_ib_sync_write(), interprets any error as a write failure
requiring rollback. It does not differentiate between I/O errors and
validation failures, and calls post_write_mst_fixup() anyway.

Since post_write_mst_fixup() assumes that the index_block contents is
correct, it doesn't perform the boundary checks, which results in
out-of-bounds memory access.

An attacker can craft a malicious NTFS image with:
  - large index_block.usa_ofs offset, pointing outside the ntfs_record
  - index_block.usa_count = 0, causing integer underflow
  - or index_block.usa_count larger than actual number of sectors in the
    ntfs_record, causing out-of-bounds access

KASAN reports describing the memory corruption:
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in post_write_mst_fixup+0x19c/0x1d0
  Read of size 2 at addr ffff8881586c9018 by task p/9428
  Call Trace:
   <TASK>
   dump_stack_lvl+0x100/0x190
   print_report+0x139/0x4ad
   ? post_write_mst_fixup+0x19c/0x1d0
   ? __virt_addr_valid+0x262/0x500
   ? post_write_mst_fixup+0x19c/0x1d0
   kasan_report+0xe4/0x1d0
   ? post_write_mst_fixup+0x19c/0x1d0
   post_write_mst_fixup+0x19c/0x1d0
   ntfs_icx_ib_sync_write+0x179/0x220
   ntfs_inode_sync_filename+0x83d/0x1080
   __ntfs_write_inode+0x1049/0x1480
   ntfs_file_fsync+0x131/0x9b0
  ==================================================================
  BUG: KASAN: slab-out-of-bounds in post_write_mst_fixup+0x1aa/0x1d0
  Write of size 2 at addr ffff8881586c91fe by task p/9428
  Call Trace:
   <TASK>
   dump_stack_lvl+0x100/0x190
   print_report+0x139/0x4ad
   ? post_write_mst_fixup+0x1aa/0x1d0
   ? __virt_addr_valid+0x262/0x500
   ? post_write_mst_fixup+0x1aa/0x1d0
   kasan_report+0xe4/0x1d0
   ? post_write_mst_fixup+0x1aa/0x1d0
   post_write_mst_fixup+0x1aa/0x1d0
   ntfs_icx_ib_sync_write+0x179/0x220
   ntfs_inode_sync_filename+0x83d/0x1080
   __ntfs_write_inode+0x1049/0x1480
   ntfs_file_fsync+0x131/0x9b0
  ==================================================================

Let's move the post_write_mst_fixup() call to ntfs_ib_write().
The ntfs_ib_write() function calls pre_write_mst_fixup() at the beginning.
If the index_block contents is invalid, pre_write_mst_fixup() fails and
ntfs_ib_write() returns early without calling post_write_mst_fixup() on
bad index_block.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Cc: stable@vger.kernel.org
Signed-off-by: Valeriy Yashnikov <yashnikov.valeriy@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/index.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ntfs/index.c
+++ b/fs/ntfs/index.c
@@ -141,6 +141,10 @@ static int ntfs_ib_write(struct ntfs_ind
 	ret = ntfs_inode_attr_pwrite(VFS_I(icx->ia_ni),
 			ntfs_ib_vcn_to_pos(icx, vcn), icx->block_size,
 			(u8 *)ib, icx->sync_write);
+
+	/* Perform data restoration before returning */
+	post_write_mst_fixup((struct ntfs_record *)ib);
+
 	if (ret != icx->block_size) {
 		ntfs_debug("Failed to write index block %lld, inode %llu",
 				vcn, (unsigned long long)icx->idx_ni->mft_no);
@@ -178,7 +182,6 @@ int ntfs_icx_ib_sync_write(struct ntfs_i
 		icx->ib = NULL;
 		icx->ib_dirty = false;
 	} else {
-		post_write_mst_fixup((struct ntfs_record *)icx->ib);
 		icx->sync_write = false;
 	}
 


