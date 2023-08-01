Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CD11F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303A5C433C7;
	Tue,  1 Aug 2023 09:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882829;
	bh=YlXPdq0/gnn+e+PpeOS7ou8G1R9CDfXYYKkci43QBtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKCFiwik4pOTet/m9/vRQpuKgj2bNQ1QXKdJg9f00Y456U+H3Tfjfwl2IXp/chDOQ
	 ZBUoLqIepatcHGtfEl0pRHdrfdy09I1GiK+c3X9/WK29tzB2350yClnePUhQgwdi2v
	 kcKMQGCIPUGXQBlI8wLQUpNzuKEAqUr0qtkj3bFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 018/239] btrfs: factor out a btrfs_verify_page helper
Date: Tue,  1 Aug 2023 11:18:02 +0200
Message-ID: <20230801091926.301499300@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ed9ee98ecb4fdbdfe043ee3eec0a65c0745d8669 ]

Split all the conditionals for the fsverity calls in end_page_read into
a btrfs_verify_page helper to keep the code readable and make additional
refactoring easier.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 2c14f0ffdd30 ("btrfs: fix fsverify read error handling in end_page_read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a37a6587efaf0..496c2c9920fc6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -478,6 +478,15 @@ void extent_clear_unlock_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			       start, end, page_ops, NULL);
 }
 
+static bool btrfs_verify_page(struct page *page, u64 start)
+{
+	if (!fsverity_active(page->mapping->host) ||
+	    PageError(page) || PageUptodate(page) ||
+	    start >= i_size_read(page->mapping->host))
+		return true;
+	return fsverity_verify_page(page);
+}
+
 static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
@@ -486,11 +495,7 @@ static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 	       start + len <= page_offset(page) + PAGE_SIZE);
 
 	if (uptodate) {
-		if (fsverity_active(page->mapping->host) &&
-		    !PageError(page) &&
-		    !PageUptodate(page) &&
-		    start < i_size_read(page->mapping->host) &&
-		    !fsverity_verify_page(page)) {
+		if (!btrfs_verify_page(page, start)) {
 			btrfs_page_set_error(fs_info, page, start, len);
 		} else {
 			btrfs_page_set_uptodate(fs_info, page, start, len);
-- 
2.39.2



