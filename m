Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E4F13B5B6;
	Tue,  3 Dec 2024 14:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237832; cv=none; b=ul3bBtrKMU8ZkpjTJGqgb2e49jFr6Tv+DSqVfWsWUSfRDCR4kXKxLsky7OP7QwboqtoQWBbCFSpTzKz1xKjzWA0HdW816GvwB+3X9hViID5d3ADCjbCfTSIq5MH7G9alNAK5bPVZKnecSkiAySypsmBJswVekx0bncjXoLClu1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237832; c=relaxed/simple;
	bh=Rh+kh0TqBExBNUXZoNPISDT5iFCYBBw7x6ObhWTWHEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8WgMwYjaekKRYhRzlbmE4VvOvS8IDIj2DKfLjyqk5RzzffC0RcJmPpLiiVsRZABAjsFkeopQHfe+ZlBPAOP+n6sX4wR7t8sqmTFHle25mOloyqdm1hsCv5CGSR33pB+5fqwsk8UXj0/sqXFs1bt3LwZal8BdepDHhGyYvFt5kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnZIpJkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnZIpJkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D1EC4CECF;
	Tue,  3 Dec 2024 14:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237832;
	bh=Rh+kh0TqBExBNUXZoNPISDT5iFCYBBw7x6ObhWTWHEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnZIpJkhT77iLO8KiLZUDAWaW3StXzQvAxr2zKMO1sgy+IYNN92hJrEh8EibrVC+l
	 abRdOV1q88hz+/1ylOikvKIbhG5OubfR+2BELWJWCA620WLVQuRiWfLRyDjemiSPys
	 W4hpK9/X4OuCvyZkVyaM/XaUgsitDxx6BTEWUFwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 083/817] ext4: pipeline buffer reads in mext_page_mkuptodate()
Date: Tue,  3 Dec 2024 15:34:15 +0100
Message-ID: <20241203143958.939183408@linuxfoundation.org>
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

[ Upstream commit 368a83cebbb949adbcc20877c35367178497d9cc ]

Instead of synchronously reading one buffer at a time, submit reads
as we walk the buffers in the first loop, then wait for them in the
second loop.  This should be significantly more efficient, particularly
on HDDs, but I have not measured.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20240718223005.568869-2-willy@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 2f3d93e210b9 ("ext4: fix race in buffer_head read fault injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c95e3e526390d..7a80c32fd7326 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -173,7 +173,9 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 	sector_t block;
 	struct buffer_head *bh, *head, *arr[MAX_BUF_PER_PAGE];
 	unsigned int blocksize, block_start, block_end;
-	int i, err,  nr = 0, partial = 0;
+	int i, nr = 0;
+	bool partial = false;
+
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(folio_test_writeback(folio));
 
@@ -191,13 +193,13 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 		block_end = block_start + blocksize;
 		if (block_end <= from || block_start >= to) {
 			if (!buffer_uptodate(bh))
-				partial = 1;
+				partial = true;
 			continue;
 		}
 		if (buffer_uptodate(bh))
 			continue;
 		if (!buffer_mapped(bh)) {
-			err = ext4_get_block(inode, block, bh, 0);
+			int err = ext4_get_block(inode, block, bh, 0);
 			if (err)
 				return err;
 			if (!buffer_mapped(bh)) {
@@ -206,6 +208,12 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 				continue;
 			}
 		}
+		lock_buffer(bh);
+		if (buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			continue;
+		}
+		ext4_read_bh_nowait(bh, 0, NULL);
 		BUG_ON(nr >= MAX_BUF_PER_PAGE);
 		arr[nr++] = bh;
 	}
@@ -215,11 +223,10 @@ mext_page_mkuptodate(struct folio *folio, unsigned from, unsigned to)
 
 	for (i = 0; i < nr; i++) {
 		bh = arr[i];
-		if (!bh_uptodate_or_lock(bh)) {
-			err = ext4_read_bh(bh, 0, NULL);
-			if (err)
-				return err;
-		}
+		wait_on_buffer(bh);
+		if (buffer_uptodate(bh))
+			continue;
+		return -EIO;
 	}
 out:
 	if (!partial)
-- 
2.43.0



