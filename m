Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DA526ADD;
	Mon, 24 Feb 2025 14:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408283; cv=none; b=YxBBWyy1V75nZZtHqcC4CX1IxfUgd8tc+MXvDde+Y6NyoLLQ/2Qfk3qP4x7taHgfCSz/tKxGgo4iCu5siiJshowQDUDj5E9YoAMczgTdR4uGXsS0LKukbKmJ3vG9tom/0ROC0xW5snectSSrXo0v/P4LaNfwM4+fb6dZ6SEzni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408283; c=relaxed/simple;
	bh=FuMd4rrMMjB3JzRdwXoRztS2KNPNgu2SyaYduYnBPtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoNL5BXMR66GhxyQUThg2D3IMPmZm44NqUefRiA/YieTR8Bmx8h8mwQ9RjYL/6ND31nojuACCuwOaIBNWXUE9YKPbgSQFyVdI9ooQag05Oo+FFoOOuUsWIq9dFdqzel1KFKRNC8w2NaLeMXXOPY9pIFZQFIPu/L+e7qLo3SVr5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmfchwGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmfchwGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4504C4CED6;
	Mon, 24 Feb 2025 14:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408281;
	bh=FuMd4rrMMjB3JzRdwXoRztS2KNPNgu2SyaYduYnBPtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmfchwGX0x7kJNil6uYE8+mXJ1Pyg7Nv6Q2OmqPHtHg8dVDnFfSYyLkDlTMAhsfzt
	 ma/HS/vQaxuxJWvBLO5DhAg1tzMdYUWHmuQBnEeuhag1GXSvQ+JzqTnR4pwsLBabmg
	 f17EW4hEwWpRDbL9phVbhlf1PCeafm2BVwIrgsMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/154] btrfs: use btrfs_inode in extent_writepage()
Date: Mon, 24 Feb 2025 15:33:31 +0100
Message-ID: <20250224142607.555312252@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 011a9a1f244656cc3cbde47edba2b250f794d440 ]

As extent_writepage() is internal helper we should use our inode type,
so change it from struct inode.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5a1bde8cc8b64..e8f882f949051 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1467,15 +1467,15 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
  */
 static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl)
 {
-	struct inode *inode = folio->mapping->host;
-	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
+	struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	const u64 page_start = folio_pos(folio);
 	int ret;
 	size_t pg_offset;
-	loff_t i_size = i_size_read(inode);
+	loff_t i_size = i_size_read(&inode->vfs_inode);
 	unsigned long end_index = i_size >> PAGE_SHIFT;
 
-	trace_extent_writepage(folio, inode, bio_ctrl->wbc);
+	trace_extent_writepage(folio, &inode->vfs_inode, bio_ctrl->wbc);
 
 	WARN_ON(!folio_test_locked(folio));
 
@@ -1499,13 +1499,13 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	if (ret < 0)
 		goto done;
 
-	ret = writepage_delalloc(BTRFS_I(inode), folio, bio_ctrl);
+	ret = writepage_delalloc(inode, folio, bio_ctrl);
 	if (ret == 1)
 		return 0;
 	if (ret)
 		goto done;
 
-	ret = extent_writepage_io(BTRFS_I(inode), folio, folio_pos(folio),
+	ret = extent_writepage_io(inode, folio, folio_pos(folio),
 				  PAGE_SIZE, bio_ctrl, i_size);
 	if (ret == 1)
 		return 0;
@@ -1514,7 +1514,7 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 
 done:
 	if (ret) {
-		btrfs_mark_ordered_io_finished(BTRFS_I(inode), folio,
+		btrfs_mark_ordered_io_finished(inode, folio,
 					       page_start, PAGE_SIZE, !ret);
 		mapping_set_error(folio->mapping, ret);
 	}
-- 
2.39.5



