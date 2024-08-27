Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A317C96;
	Tue, 27 Aug 2024 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771905; cv=none; b=LI0ZlFzkNnpBjQPnjwuSulKM3RiW0tiDJ2WuUoxNFdwkocy9gBXGNcCjLHB5WNzmwfo9CvVlnYx1bCguXAfw0/6ywRUcXKImFDCHUnqURm+N82VbVH/DNa6FQuR0+hfjAMAXdIO62HfyV96Md65Li2Lx0JlDcLlFrPF1wXyEaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771905; c=relaxed/simple;
	bh=3rGxtGj/Hyvb3hsXw3NL83U95VMHHNgom53/uH2/j1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0Ima2CsULMsFe3aIehSjQTrSHFH+PrF5+kn86qhglTKt1hrXKaeUEBBgJZzpSO0NTIkySHd+AH4hKH9ImeNISdNbQkjuFlhjB0yb98mMc3PjXjcQABI1klUsY0CHOnESYoHZY25hClkLaxRCeunugjYRGHJ0hzTqHes9MShUvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXU1PNUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXU1PNUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3145C61067;
	Tue, 27 Aug 2024 15:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771905;
	bh=3rGxtGj/Hyvb3hsXw3NL83U95VMHHNgom53/uH2/j1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXU1PNUXYjAAKwbXR7NtH3zJfEBmzli9noKXtCX7kQr74c4ihoDC2AE4H5uWOxIlt
	 +MLR9M7usbbyIk3RAjPjxhUSxLCxgBt1GC2c1u0EX6NVx7crowv/vZWuuroteeNdeE
	 W1aYkcpIOyYA9t5ZuL6qT6xBg8ynczFXyQB+255g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+604424eb051c2f696163@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/321] Squashfs: fix variable overflow triggered by sysbot
Date: Tue, 27 Aug 2024 16:36:03 +0200
Message-ID: <20240827143840.330031774@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 12427de9439d68b8e96ba6f50b601ef15f437612 ]

Sysbot reports a slab out of bounds write in squashfs_readahead().

This is ultimately caused by a file reporting an (infeasibly) large file
size (1407374883553280 bytes) with the minimum block size of 4K.

This causes variable overflow.

Link: https://lkml.kernel.org/r/20231113160901.6444-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b1fda20609ede0d1@google.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/file.c        | 3 ++-
 fs/squashfs/file_direct.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 8ba8c4c507707..e8df6430444b0 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -544,7 +544,8 @@ static void squashfs_readahead(struct readahead_control *ractl)
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
 	struct page **pages;
-	int i, file_end = i_size_read(inode) >> msblk->block_log;
+	int i;
+	loff_t file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index f1ccad519e28c..763a3f7a75f6d 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -26,10 +26,10 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize,
 	struct inode *inode = target_page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 
-	int file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = target_page->index & ~mask;
-	int end_index = start_index | mask;
+	loff_t start_index = target_page->index & ~mask;
+	loff_t end_index = start_index | mask;
 	int i, n, pages, bytes, res = -ENOMEM;
 	struct page **page;
 	struct squashfs_page_actor *actor;
-- 
2.43.0



