Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709D212D215;
	Tue, 30 Apr 2024 11:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475550; cv=none; b=prICRYyb3rT5E0pnXvNYKEmNIy1EBhNP7SZj99jsFQzC8bgX3NT7Qs62V/t+2HLNA5tP0i+0vGGpN8Wc09JrpE+A5tpuD/spRm1d2OWTXd4mGTd9EWf0U9MO1xQqI7h+MdUxml3aXG5y91PTl7+bkokoVyXJjHvvHgTJyBXr6Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475550; c=relaxed/simple;
	bh=ZViiC/SNHBkhr//K7NdbhC+eMGvfxwatAHeE7VPdKHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXbcgkSv4mZkk/LO1Hn7pjzeRM7Ki9+/gLUOSGkJ5vP3QCtD4PgFGB4m2OujcimIMmO5InAFiPPlV11+997RTD4NELCA+B9k8C/XL/oRXmGQUjScb30+wZjWJIa5syHZ98xVfPTPCs0vkA+d2sizXTiffupYBHBlRAGobCwTkE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BwGtHIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BwGtHIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C12C2BBFC;
	Tue, 30 Apr 2024 11:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475550;
	bh=ZViiC/SNHBkhr//K7NdbhC+eMGvfxwatAHeE7VPdKHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BwGtHIbgYgGJJyp2ZB/US5hR1/x/zMwLH2+be5oX6Pd94esZoEYMw+be0Tdk6jcB
	 kaJK+GGZzDBFn8a3narEWEKMtCrKtkY/cSETnc0FYZ2rUMawdHoxyPSqaxCYddlb1v
	 O0dmiAoqqJGgNdop8E1/dbdNw0k6DTeI7fFL4qQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Neal Gompa <neal@gompa.dev>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 131/186] btrfs: fallback if compressed IO fails for ENOSPC
Date: Tue, 30 Apr 2024 12:39:43 +0200
Message-ID: <20240430103101.833765587@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

commit 131a821a243f89be312ced9e62ccc37b2cf3846c upstream.

In commit b4ccace878f4 ("btrfs: refactor submit_compressed_extents()"), if
an async extent compressed but failed to find enough space, we changed
from falling back to an uncompressed write to just failing the write
altogether. The principle was that if there's not enough space to write
the compressed version of the data, there can't possibly be enough space
to write the larger, uncompressed version of the data.

However, this isn't necessarily true: due to fragmentation, there could
be enough discontiguous free blocks to write the uncompressed version,
but not enough contiguous free blocks to write the smaller but
unsplittable compressed version.

This has occurred to an internal workload which relied on write()'s
return value indicating there was space. While rare, it has happened a
few times.

Thus, in order to prevent early ENOSPC, re-add a fallback to
uncompressed writing.

Fixes: b4ccace878f4 ("btrfs: refactor submit_compressed_extents()")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Co-developed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1134,13 +1134,13 @@ static void submit_one_async_extent(stru
 				   0, *alloc_hint, &ins, 1, 1);
 	if (ret) {
 		/*
-		 * Here we used to try again by going back to non-compressed
-		 * path for ENOSPC.  But we can't reserve space even for
-		 * compressed size, how could it work for uncompressed size
-		 * which requires larger size?  So here we directly go error
-		 * path.
+		 * We can't reserve contiguous space for the compressed size.
+		 * Unlikely, but it's possible that we could have enough
+		 * non-contiguous space for the uncompressed size instead.  So
+		 * fall back to uncompressed.
 		 */
-		goto out_free;
+		submit_uncompressed_range(inode, async_extent, locked_page);
+		goto done;
 	}
 
 	/* Here we're doing allocation and writeback of the compressed pages */
@@ -1192,7 +1192,6 @@ done:
 out_free_reserve:
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
-out_free:
 	mapping_set_error(inode->vfs_inode.i_mapping, -EIO);
 	extent_clear_unlock_delalloc(inode, start, end,
 				     NULL, EXTENT_LOCKED | EXTENT_DELALLOC |


