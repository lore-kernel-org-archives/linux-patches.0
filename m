Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F1D1474AF;
	Fri,  6 Dec 2024 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496706; cv=none; b=CeHyoQPGOl5x9G+nFbnwO5YkV14QlzYYfdeyh4Q7LtIXESGP5LRausk2artYPA3vnInKIx1QKT7Jgkm6DBP48hOY/yPR9teEyGEaLtrdNDyPKgD1fHK+SS5aPnZEs3C7V5p29oHfzxk/kCDfEWQIXnAy2rj1JkpHglmncglh9pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496706; c=relaxed/simple;
	bh=61AGTmzSRPa11sE5FuNQj2wb7AR1y+lpraJ7i2uyqvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfdS8KSgnMCeELYb0R6+WSlFu/a5/aleWTZAV1BLCyGdcXwvc/KsY9Da9S4HgcOSzJf0E+TyL0xubYE3l0VavM/LFdq6GTd6//zc0dunCdhSkfwdnePyZej5dZ2STzg0LhnkYdSPV0js+gogzOhM+yof8aB6UUtjC8HMMXEETxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYBmUGO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYBmUGO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B4FC4CED1;
	Fri,  6 Dec 2024 14:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496705;
	bh=61AGTmzSRPa11sE5FuNQj2wb7AR1y+lpraJ7i2uyqvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYBmUGO7lI5zsrZDm9ZppDyMY3d6y86MWZq12+UhxSr9NFm1IcdeSRIJIZpYPQ74G
	 r8kXIl7nbz3gNQ5J29nhOG8jXkrJGwYfSdiMXbA7ougZcg04MJM1VI25u7v1bltvQI
	 qqFs0smLNRS9H92kvH778OsSBJG093YC5w+4U5wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/676] ext4: remove array of buffer_heads from mext_page_mkuptodate()
Date: Fri,  6 Dec 2024 15:28:12 +0100
Message-ID: <20241206143656.217396388@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 28d59548770d7..f082bccdb01ad 100644
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
@@ -216,20 +215,23 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
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



