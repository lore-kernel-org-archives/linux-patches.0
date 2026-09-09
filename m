Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1593566C42;
	Wed,  9 Sep 2026 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962950; cv=none; b=NsTj6C+ZlLNN3sPiO5U0DvNodG+AcbbBQsBavo8RLfYgnQ9/CqxivSPqGyMYKfjUJ2ydUqX7YcCE83UnljSviDph88Ej6iE2vvj9/7YdhLctqrBDWXXPiPwuQv8bjNkBESLJFR4445zrr0crAXC9Lvln3pGkZ3dMHNuE15lZfrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962950; c=relaxed/simple;
	bh=acXMjoBLsXtjrA1nDU8er7R48yie9Fq2QIDpHsUeQv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3g7xHBEFDSYnF8U0ULGh964I3HmVdurgE2s5VcrE4Rwhnm3a42WDDbg9uFrNJuepj2zK000TIf+miz4yYqHPkBiRxXOBztCbObRdhS+ZVXVwNuUKh6txhg6OdqU7eLde0oDYZJ8tOsmLnYaHs95sC/I3NFTw6UhRHYUH8+khgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1UisgL4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1UisgL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D391F00A3A;
	Wed,  9 Sep 2026 14:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962948;
	bh=nXC+v6RKSUGSpoddOfRkIKapBeBJXXMOc+VrbVhMipc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1UisgL4Kqw/pQlqEDcA9hYyvAHy801ADe9v8zLIaGAuFUCkz8W/wq9ZxOtIiWUa8
	 QmlRVGddTMj3FSYvoiJDylLbj/zYzTp91dQkAVjGldRv8qfGOMOweyJsghB3I6olMD
	 1xnxnI4pcJFKhlutvbGMnqXGsATenWyU2pLJz1ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 468/556] f2fs: fix valid block count leak on data block allocation failure
Date: Wed,  9 Sep 2026 15:42:28 +0200
Message-ID: <20260909134247.021690767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0f9af07ecc1ab486038373db6ae0436c5d674b19 upstream.

In __allocate_data_block(), when allocating a new data block
(dn->data_blkaddr == NULL_ADDR), inc_valid_block_count() is
called first to increment total_valid_block_count and i_blocks.
If the subsequent f2fs_allocate_data_block() fails, the function
returns the error directly without rolling back the
already-incremented block counts, causing a permanent leak.

Fix this by calling dec_valid_block_count() to undo the
increment before returning the error. The condition
old_blkaddr == NULL_ADDR precisely identifies the case where
inc_valid_block_count() was called.

Fixes: 7d009e048d7c ("f2fs: fix to handle segment allocation failure correctly")
Cc: <stable@vger.kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1533,8 +1533,11 @@ static int __allocate_data_block(struct
 	old_blkaddr = dn->data_blkaddr;
 	err = f2fs_allocate_data_block(sbi, NULL, old_blkaddr,
 				&dn->data_blkaddr, &sum, seg_type, NULL);
-	if (err)
+	if (err) {
+		if (old_blkaddr == NULL_ADDR)
+			dec_valid_block_count(sbi, dn->inode, count);
 		return err;
+	}
 
 	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
 		f2fs_invalidate_internal_cache(sbi, old_blkaddr, 1);


