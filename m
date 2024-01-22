Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FB24A27;
	Tue, 23 Jan 2024 00:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969597; cv=none; b=efIzwrKAqCsFRqy1+A6RX25UST/5Ic7et2lYxy+9KweI7j47SQQby7i55AaZzL9DySubrCmoxY1fBDCBqALWfvBkCu3NqiME3iiM2jmlgJEGQnaO3N0cIAQ8H2WGcy5bFmRXLR+oCFohKihD5kZzgsrHcnuk2JWnufFCel5aXr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969597; c=relaxed/simple;
	bh=m5S36eezk8hnJlXABOJ2rgXJ9PkjG70gmrltTjme9r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJDX2NNNyEji2/NnOcojy6EndRUfCSl/MWOhjGexSHHP6bOFW//nkZklUz2fr9LbNIJ/cp3/bxdbE7H5vFcGVLUuebVbzKp1WxI3MMmWKNlqIMLvik+fJnd93cv6iRyLMzqgXsMxLsu3ac3JJX3rWPHojpj+MpXNWgAtJ+T7OGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXHSWRkw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXHSWRkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C25DC43399;
	Tue, 23 Jan 2024 00:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969597;
	bh=m5S36eezk8hnJlXABOJ2rgXJ9PkjG70gmrltTjme9r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXHSWRkwH7OYeOitI89hATD1sa/irl9EqlHob4MAcFANfiDM7fu2LE3MtkCuVpEms
	 z6hfc57IV3l4K75QTgEluOQ4G5ga3iLFgWynAvXJIK1BjilIPOMAKxIemBGNleFvI/
	 ZSPz/F9qLIABGZeTKkBPEGOVr5i4q0NxIoFcxZAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 314/641] f2fs: fix to wait on block writeback for post_read case
Date: Mon, 22 Jan 2024 15:53:38 -0800
Message-ID: <20240122235827.721363030@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 55fdc1c24a1d6229fe0ecf31335fb9a2eceaaa00 ]

If inode is compressed, but not encrypted, it missed to call
f2fs_wait_on_block_writeback() to wait for GCed page writeback
in IPU write path.

Thread A				GC-Thread
					- f2fs_gc
					 - do_garbage_collect
					  - gc_data_segment
					   - move_data_block
					    - f2fs_submit_page_write
					     migrate normal cluster's block via
					     meta_inode's page cache
- f2fs_write_single_data_page
 - f2fs_do_write_data_page
  - f2fs_inplace_write_data
   - f2fs_submit_page_bio

IRQ
- f2fs_read_end_io
					IRQ
					old data overrides new data due to
					out-of-order GC and common IO.
					- f2fs_read_end_io

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4e42b5f24deb..bc3f05d43b62 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2566,9 +2566,6 @@ int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
 
 	page = fio->compressed_page ? fio->compressed_page : fio->page;
 
-	/* wait for GCed page writeback via META_MAPPING */
-	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
-
 	if (fscrypt_inode_uses_inline_crypto(inode))
 		return 0;
 
@@ -2755,6 +2752,10 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 		goto out_writepage;
 	}
 
+	/* wait for GCed page writeback via META_MAPPING */
+	if (fio->post_read)
+		f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
+
 	/*
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
-- 
2.43.0



