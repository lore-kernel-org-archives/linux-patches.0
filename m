Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549BC21A424;
	Mon, 24 Feb 2025 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408325; cv=none; b=PFFmDoAR5Eaz+W+y16hj4uk5GRUzFSE2KsM9QQhoheOj5b1X5g6U2XXu+GgrUBLjnnCaTy35lKG1E5rVGfr8EMql+t30RTEqOuVnJHjxzkcw3+CE+AqiGcoWaL6BXYhNlnITDjiy1vdu77Ju8CHXdpVDpurbE7sbZyWWACk/NaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408325; c=relaxed/simple;
	bh=g9ZOz9S7JsaX1tpsLuVaqbg4/K6DsLy+sGObkYQoYSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9M+KMOVUO0fyLtsSjCWMDk0zA8kde8tdJncZMYjnwyjPtc+vIg0jAOyoODMW3FqcEQxJT9h5+mInbijqRBqM02f4i2XYIXt8s0RzFvVMsx9vcdVvKmKRZKzhPcdA8NlHAppmWAY7GpISMeCYTyLwf02MoXy6xX/4UXhDL12dVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00nY0NTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00nY0NTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A64C4CEE6;
	Mon, 24 Feb 2025 14:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408325;
	bh=g9ZOz9S7JsaX1tpsLuVaqbg4/K6DsLy+sGObkYQoYSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00nY0NTFIh4V7vydVHZ0aLJNkDeHma1mzbYEdp4t2xvQzsN0bY1qD9BtawK2SqccP
	 RJ6wZyu7DDiOEsVt2CjXl2fIrspLjSLwR+ut07w3gGVwNgHUPd+BHpgLv1UtgxEsSp
	 24xFCQ46exdjxJlTzKGVxC+F1HbL0nehA1DCpxXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/154] btrfs: mark all dirty sectors as locked inside writepage_delalloc()
Date: Mon, 24 Feb 2025 15:33:27 +0100
Message-ID: <20250224142607.397246213@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit c96d0e3921419bd3e5d8a1f355970c8ae3047ef4 ]

Currently we only mark sectors as locked if there is a *NEW* delalloc
range for it.

But NEW delalloc range is not the same as dirty sectors we want to
submit, e.g:

        0       32K      64K      96K       128K
        |       |////////||///////|    |////|
                                       120K

For above 64K page size case, writepage_delalloc() for page 0 will find
and lock the delalloc range [32K, 96K), which is beyond the page
boundary.

Then when writepage_delalloc() is called for the page 64K, since [64K,
96K) is already locked, only [120K, 128K) will be locked.

This means, although range [64K, 96K) is dirty and will be submitted
later by extent_writepage_io(), it will not be marked as locked.

This is fine for now, as we call btrfs_folio_end_writer_lock_bitmap() to
free every non-compressed sector, and compression is only allowed for
full page range.

But this is not safe for future sector perfect compression support, as
this can lead to double folio unlock:

              Thread A                 |           Thread B
---------------------------------------+--------------------------------
                                       | submit_one_async_extent()
				       | |- extent_clear_unlock_delalloc()
extent_writepage()                     |    |- btrfs_folio_end_writer_lock()
|- btrfs_folio_end_writer_lock_bitmap()|       |- btrfs_subpage_end_and_test_writer()
   |                                   |       |  |- atomic_sub_and_test()
   |                                   |       |     /* Now the atomic value is 0 */
   |- if (atomic_read() == 0)          |       |
   |- folio_unlock()                   |       |- folio_unlock()

The root cause is the above range [64K, 96K) is dirtied and should also
be locked but it isn't.

So to make everything more consistent and prepare for the incoming
sector perfect compression, mark all dirty sectors as locked.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bf334beb349 ("btrfs: fix double accounting race when extent_writepage_io() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ba34b92d48c2f..8222ae6f29af5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1174,6 +1174,7 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 	u64 delalloc_end = page_end;
 	u64 delalloc_to_write = 0;
 	int ret = 0;
+	int bit;
 
 	/* Save the dirty bitmap as our submission bitmap will be a subset of it. */
 	if (btrfs_is_subpage(fs_info, inode->vfs_inode.i_mapping)) {
@@ -1183,6 +1184,12 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		bio_ctrl->submit_bitmap = 1;
 	}
 
+	for_each_set_bit(bit, &bio_ctrl->submit_bitmap, fs_info->sectors_per_page) {
+		u64 start = page_start + (bit << fs_info->sectorsize_bits);
+
+		btrfs_folio_set_writer_lock(fs_info, folio, start, fs_info->sectorsize);
+	}
+
 	/* Lock all (subpage) delalloc ranges inside the folio first. */
 	while (delalloc_start < page_end) {
 		delalloc_end = page_end;
@@ -1193,9 +1200,6 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
 		}
 		set_delalloc_bitmap(folio, &delalloc_bitmap, delalloc_start,
 				    min(delalloc_end, page_end) + 1 - delalloc_start);
-		btrfs_folio_set_writer_lock(fs_info, folio, delalloc_start,
-					    min(delalloc_end, page_end) + 1 -
-					    delalloc_start);
 		last_delalloc_end = delalloc_end;
 		delalloc_start = delalloc_end + 1;
 	}
-- 
2.39.5



