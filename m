Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9AB21B191;
	Sat, 30 May 2026 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163060; cv=none; b=n7uLJ9/GLuY+ERXJeNv9Eibd2KNpjkX5QkPLCd0pSn8wTOuTigMG4NmJy4Fqi7kLPQlTTSWKFps6BJ744qeUG8w1C6YQjfLVSp+2PYt7TXNLxq40UrUN3jA6ZEMMKOCYId/pKUlpWbPQgPdACSOU3wSx3sKkU2noikSFLKlWcRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163060; c=relaxed/simple;
	bh=Weluhycljw0VGEGhZnf7Kz5KzVr+pqexgJog9ARCHXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A93gGVkunV/wm8XjIl0ZbXKq6UkVE9RzslDB2mEFy2q+XYEH+2dnbObkeUvjZSjFdWFnMNRrQ0yW5RNpm/V39v5fLRf9wWQlrfkbbBqxWgRoct6GxWGELY/p5Fu8hyopNOUE1cvMGXuiAAuwpMgBlJtmXTOEKCFxgZlg0I4voeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFUho3iM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFUho3iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7475E1F00898;
	Sat, 30 May 2026 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163059;
	bh=qenQfVn0kGyPeSV+OwEfrxoC4cfwBt6C4HDuvBMMK8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFUho3iMk0oPf6PKYC154Mmq1GAjEa1gM366oWBQMY6VfTDUwEgwdx7h9Kpitb6Ht
	 JkXw/+/jlhLb3ow/VFKF3sRBmXesVqlVBjI6nbFCANtKlCLEexTGSntCTYeVuT7M0Z
	 sgu6T487L9SG/t6uH/eeUDUhFL0eaJ9OIQE03LZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Chao Yu" <chao@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 143/776] f2fs: fix to wait on block writeback for post_read case
Date: Sat, 30 May 2026 17:57:37 +0200
Message-ID: <20260530160244.116025093@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2537,9 +2537,6 @@ int f2fs_encrypt_one_page(struct f2fs_io
 
 	page = fio->compressed_page ? fio->compressed_page : fio->page;
 
-	/* wait for GCed page writeback via META_MAPPING */
-	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
-
 	if (fscrypt_inode_uses_inline_crypto(inode))
 		return 0;
 
@@ -2718,6 +2715,11 @@ got_it:
 		err = -EFSCORRUPTED;
 		goto out_writepage;
 	}
+
+	/* wait for GCed page writeback via META_MAPPING */
+	if (fio->post_read)
+		f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
+
 	/*
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.


