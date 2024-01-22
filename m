Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D66A03B;
	Tue, 23 Jan 2024 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975330; cv=none; b=AEvB6Se6M/JeDdVi6Sf5h3B0gLr9f9F5mMS/sf08Oy0vjFikCv//Ya+jfpUr6YBnsEm864SnUxZEdmdBR19SNnaA1b+DMepdnZ7GkcgNuYOokiQ4e5St9Lz4daQoLzKojcfhknFyL/N4Mrdr36iL88r6aT8mIkHsk7ctiwRrXwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975330; c=relaxed/simple;
	bh=aLUQAG31w2kJKmaxpHrfDue6/eVH9L8uPXnUgaq13cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvsNuJrAOX9ZZgCETQDN+cvcJ9714zGjQy9EZ1e+rpq3O6pufX8MHQdaoE4FGFTpXthLdNzYcitUmL6XSh5a6BGZKjKjVkmvxFoYUKXWEKbfRQ/yy8f2mWBBuG3afp94zuu+7g5/OjsoCn4eMV5LxFWqf5vO2BUKz4UCvmGFuwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIGUmezT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIGUmezT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBE0C433C7;
	Tue, 23 Jan 2024 02:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975330;
	bh=aLUQAG31w2kJKmaxpHrfDue6/eVH9L8uPXnUgaq13cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIGUmezTK2/Cmo12AIBXCwzyJjm3RS3Oux0fWKipGulnyMbE7BrqqaGdWE5dSXfbH
	 BTFIu+661pe5uaf1NXeAbBbYrlUnHwuQ3QAshxzdxtDXd85DebVSBH4VNqx5t7Zw4Z
	 C+SrVQg92/5nClvwgbXKJ7MKRHqKspRNhwFQTikg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/583] f2fs: fix to wait on block writeback for post_read case
Date: Mon, 22 Jan 2024 15:55:27 -0800
Message-ID: <20240122235820.443379431@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ac34eb49a0e..f5f33926acf8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2568,9 +2568,6 @@ int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
 
 	page = fio->compressed_page ? fio->compressed_page : fio->page;
 
-	/* wait for GCed page writeback via META_MAPPING */
-	f2fs_wait_on_block_writeback(inode, fio->old_blkaddr);
-
 	if (fscrypt_inode_uses_inline_crypto(inode))
 		return 0;
 
@@ -2752,6 +2749,10 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
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



