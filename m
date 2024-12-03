Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CF81D9341;
	Tue,  3 Dec 2024 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237835; cv=none; b=mEuluxTUthw9fL2NM6hcyT0Z3PyakRTE6VfSIVQioKPe7tz5avh+1yYtoDpG49ImlwUETRePjuwl7E3dOw2d47Ifjl8SNP3CrqeZZ0Ggd9k6cugsjQ0zZIeXYdNA660zecKCykH0zHvEA++1dClD+8ZbQ2mbH/Rq5WqSsDPxvJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237835; c=relaxed/simple;
	bh=9lItkkIlQBqTSdakFh0E8sapzoBh66Q6el1lFSYF+mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rI1eJairg9b2FPG6XPvmYda/j9kx/tXLD+ok8AHpzOZpTWLek96X4O3+zFQK+Y1arSmWW5f97+vrvdiVWS/4Y6px9uvCzmleILQ8C9n2SPZqC3GGCFeaRUDHbkGADuLv/xH3J0TJ7W+23LEYOzcRrTdZCKjhs/sBQggiJfzAQXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hqy8R+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hqy8R+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16559C4CECF;
	Tue,  3 Dec 2024 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237835;
	bh=9lItkkIlQBqTSdakFh0E8sapzoBh66Q6el1lFSYF+mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hqy8R+qpPbsmvkB9RFbZmHjD/7mCJvYosBg7z2sHY1rsN7CTgPOTiN1UsAXqKdWI
	 2HSxzZfuL/gApPD3miRcn6Q5RtvT6qS7f8qKefNaBxZIFk+ixo6Kx4BkqPWN35IN97
	 nlZll0+V2nCiMyAr987TOYdRfuFTvf1jThfq+EbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 084/817] ext4: remove array of buffer_heads from mext_page_mkuptodate()
Date: Tue,  3 Dec 2024 15:34:16 +0100
Message-ID: <20241203143958.978059527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a40759fb16ae839f8c769174fde017564ea564ff ]

Iterate the folio's list of buffer_heads twice instead of keeping
an array of pointers.  This solves a too-large-array-for-stack problem
on architectures with a ridiculoously large PAGE_SIZE and prepares
ext4 to support larger folios.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20240718223005.568869-3-willy@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 2f3d93e210b9 ("ext4: fix race in buffer_head read fault injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 7a80c32fd7326..42b52b6491a03 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -165,15 +165,14 @@ mext_folio_double_lock(struct inode *inode1, struct inode *inode2,
 	return 0;
 }
 
-/* Force page buffers uptodate w/o dropping page's lock */
-static int
-mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
+/* Force folio buffers uptodate w/o dropping folio's lock */
+static int mext_page_mkuptodate(struct folio *folio, size_t from, size_t to)
 {
 	struct inode *inode = folio->mapping->host;
 	sector_t block;
-	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
+	struct buffer_head *bh, *head;
 	unsigned int blocksize, block_start, block_end;
-	int i, nr = 0;
+	int nr = 0;
 	bool partial = false;
 
 	BUG_ON(!folio_test_locked(folio));
@@ -214,20 +213,23 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 			continue;
 		}
 		ext4_read_bh_nowait(bh, 0, NULL);
-		BUG_ON(nr >= MAX_BUF_PER_PAGE);
-		arr[nr++] = bh;
+		nr++;
 	}
 	/* No io required */
 	if (!nr)
 		goto out;
 
-	for (i = 0; i < nr; i++) {
-		bh = arr[i];
+	bh = head;
+	do {
+		if (bh_offset(bh) + blocksize <= from)
+			continue;
+		if (bh_offset(bh) > to)
+			break;
 		wait_on_buffer(bh);
 		if (buffer_uptodate(bh))
 			continue;
 		return -EIO;
-	}
+	} while ((bh = bh->b_this_page) != head);
 out:
 	if (!partial)
 		folio_mark_uptodate(folio);
-- 
2.43.0



