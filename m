Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0ED17E90E;
	Mon, 27 May 2024 19:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837015; cv=none; b=IE8GybkOrfsCIjdWo70qUguRzysLPRLSg0lS27RWbbjtxnk1Y+LM39SGd7DrDteqh85ChZk+DwDiQ0OnN/lycpLywCObvn2Zn0Jk/GHRXHKZmStX7e1KRNUkV5bfO9MVWo08d83hH5e0a8BFPSZ4bQMDxavt+hCWbVcT9Rn2HBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837015; c=relaxed/simple;
	bh=YN9fOO8mlo15uzcRUFEOgNrfaTRtu/0eIAqr7LALWgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEv0feH2eSO0YiFzDlbb6U4hn8rCVt7jJanoY0Dcs2EAWfc933hfxisgCNcKX9vdv5IMXRPlaaIgEp/o/+syOoEgS3i6ZSdyCZFwK0UJCQaqRwNplPseCjO8YsFer+gY93mB3No9hZ694artW7fj3gI+fIQ3+vCXG5d6xQIMWoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZgb1woF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZgb1woF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859F7C2BBFC;
	Mon, 27 May 2024 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837014;
	bh=YN9fOO8mlo15uzcRUFEOgNrfaTRtu/0eIAqr7LALWgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZgb1woFqT5Q45gAQxVHCY4svOyZK3BgIcQrzPTfA3LscEIkq9pYV+xMUsfFx2B10
	 SIHaHpU460wb9CIi2Y6cdZyR0XulQGrWhgl6LY+o3BWm+7d7NopC1bL8hBtdRwdrkJ
	 N8sn4bRc+/PzQeuWFtxQXskvTPFU0PO7HPwhXjwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 225/427] btrfs: set start on clone before calling copy_extent_buffer_full
Date: Mon, 27 May 2024 20:54:32 +0200
Message-ID: <20240527185623.506013789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 53e24158684b527d013b5b2204ccb34d1f94c248 ]

Our subpage testing started hanging on generic/560 and I bisected it
down to 1cab1375ba6d ("btrfs: reuse cloned extent buffer during
fiemap to avoid re-allocations").  This is subtle because we use
eb->start to figure out where in the folio we're copying to when we're
subpage, as our ->start may refer to an area inside of the folio.

For example, assume a 16K page size machine with a 4K node size, and
assume that we already have a cloned extent buffer when we cloned the
previous search.

copy_extent_buffer_full() will do the following when copying the extent
buffer path->nodes[0] (src) into cloned (dest):

  src->start = 8k; // this is the new leaf we're cloning
  cloned->start = 4k; // this is left over from the previous clone

  src_addr = folio_address(src->folios[0]);
  dest_addr = folio_address(dest->folios[0]);

  memcpy(dest_addr + get_eb_offset_in_folio(dst, 0),
	 src_addr + get_eb_offset_in_folio(src, 0), src->len);

Now get_eb_offset_in_folio() is where the problems occur, because for
sub-pagesize blocksize we can have multiple eb's per folio, the code for
this is as follows

  size_t get_eb_offset_in_folio(eb, offset) {
	  return (eb->start + offset & (folio_size(eb->folio[0]) - 1));
  }

So in the above example we are copying into offset 4K inside the folio.
However once we update cloned->start to 8K to match the src the math for
get_eb_offset_in_folio() changes, and any subsequent reads (i.e.
btrfs_item_key_to_cpu()) will start reading from the offset 8K instead
of 4K where we copied to, giving us garbage.

Fix this by setting start before we co copy_extent_buffer_full() to make
sure that we're copying into the same offset inside of the folio that we
will read from later.

All other sites of copy_extent_buffer_full() are correct because we
either set ->start beforehand or we simply don't change it in the case
of the tree-log usage.

With this fix we now pass generic/560 on our subpage tests.

Fixes: 1cab1375ba6d ("btrfs: reuse cloned extent buffer during fiemap to avoid re-allocations")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2776112dbdf8d..87f487b116577 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2773,13 +2773,19 @@ static int fiemap_next_leaf_item(struct btrfs_inode *inode, struct btrfs_path *p
 		goto out;
 	}
 
-	/* See the comment at fiemap_search_slot() about why we clone. */
-	copy_extent_buffer_full(clone, path->nodes[0]);
 	/*
 	 * Important to preserve the start field, for the optimizations when
 	 * checking if extents are shared (see extent_fiemap()).
+	 *
+	 * We must set ->start before calling copy_extent_buffer_full().  If we
+	 * are on sub-pagesize blocksize, we use ->start to determine the offset
+	 * into the folio where our eb exists, and if we update ->start after
+	 * the fact then any subsequent reads of the eb may read from a
+	 * different offset in the folio than where we originally copied into.
 	 */
 	clone->start = path->nodes[0]->start;
+	/* See the comment at fiemap_search_slot() about why we clone. */
+	copy_extent_buffer_full(clone, path->nodes[0]);
 
 	slot = path->slots[0];
 	btrfs_release_path(path);
-- 
2.43.0



