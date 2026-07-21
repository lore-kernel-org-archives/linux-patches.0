Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E289343F4AF;
	Tue, 21 Jul 2026 21:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668011; cv=none; b=Q5EiEX1pSFQMxz9AcduNjfW1R7tFCPXbhftKyCdbdh5Hv2imyH9zR6yt7Je8Xl96rYdVasVUNRn5/2nna/eswNX1LorxdiMJdzU/iODz3BrqgkwAFS6GlJ2uwVh1dkK8z+8PB7E+I7aR1n9mYhbLposTelpuF4OqvAt0p3lN2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668011; c=relaxed/simple;
	bh=tp+suwTJjxXY3q7OZdYtFf0rCmsV4COKaxK+HpwG4SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2TQ7IWYP6o1jSUnHaCUb9a8kAVm1A9QtaMUP8dNyUQmWilrtT9RegQtHQOs5Ul277m4hBI0BpZ9L0PEJPXS0Boudej/hmWkvu4DX4IV+TFYmX3+TC+gHwWUKN4gp2E3JyTU2d5UT63B59yp5/P2dRh+F1XIca91n+HGLDzEG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alWqaWJ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alWqaWJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525F41F000E9;
	Tue, 21 Jul 2026 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668009;
	bh=mwcAOCGVa4LTbEaP1Fm87hY7vw5Gr4BBH2zr0n8CnFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alWqaWJ+8r0lkeaTJGnAuoENciAX7WEZ1hj9m+XaUiX7EWhkTcSzki6iCN9sxutJ5
	 PAwXnmn487CRUVHNJgSWOsaUiSf/mzr6UeLPHbxjKDpzDB+ejxxrSerV17xdaAD2Qg
	 BOctiIVSn7reBWUccn/GhCGuH0tCaOJgaxQ6wjKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0015/1067] f2fs: keep atomic write retry from zeroing original data
Date: Tue, 21 Jul 2026 17:10:16 +0200
Message-ID: <20260721152424.872744913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit 6d874b65aadce56ac78f76129dbcfc2599b638f8 ]

A partial atomic write reserves a block in the COW inode before reading the
original data page for the untouched bytes in that page.

If that read fails, write_begin returns an error but leaves the COW inode
entry as NEW_ADDR. A retry of the same partial write then finds the COW
entry, treats it as existing COW data, and f2fs_write_begin() zeroes the
whole folio because blkaddr is NEW_ADDR.

If the retry is committed, the bytes outside the retried write range are
committed as zeroes instead of preserving the original file contents.

Only use the COW inode as the read source when it already has a real data
block. If the COW entry is still NEW_ADDR, treat it as a reservation to
reuse: keep reading the old data from the original inode and avoid
reserving or accounting the same atomic block again.

Cc: stable@kernel.org
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3561,6 +3561,7 @@ static int prepare_atomic_write_begin(st
 	pgoff_t index = page->index;
 	int err = 0;
 	block_t ori_blk_addr = NULL_ADDR;
+	bool cow_has_reserved_block = false;
 
 	/* If pos is beyond the end of file, reserve a new block in COW inode */
 	if ((pos & PAGE_MASK) >= i_size_read(inode))
@@ -3570,8 +3571,10 @@ static int prepare_atomic_write_begin(st
 	err = __find_data_block(cow_inode, index, blk_addr);
 	if (err)
 		return err;
-	else if (*blk_addr != NULL_ADDR)
+	else if (__is_valid_data_blkaddr(*blk_addr))
 		return 0;
+	else if (*blk_addr == NEW_ADDR)
+		cow_has_reserved_block = true;
 
 	/* Look for the block in the original inode */
 	err = __find_data_block(inode, index, &ori_blk_addr);
@@ -3580,10 +3583,13 @@ static int prepare_atomic_write_begin(st
 
 reserve_block:
 	/* Finally, we should reserve a new block in COW inode for the update */
-	err = __reserve_data_block(cow_inode, index, blk_addr, node_changed);
-	if (err)
-		return err;
-	inc_atomic_write_cnt(inode);
+	if (!cow_has_reserved_block) {
+		err = __reserve_data_block(cow_inode, index, blk_addr,
+					   node_changed);
+		if (err)
+			return err;
+		inc_atomic_write_cnt(inode);
+	}
 
 	if (ori_blk_addr != NULL_ADDR)
 		*blk_addr = ori_blk_addr;


