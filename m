Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84AC1D2784;
	Wed,  6 Nov 2024 12:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896015; cv=none; b=SE1oZYUcrK+cswPuTMk5k9EHD75WgPk1Mq6MDwgoP6yGk5uRm0HhJhmTx2zfiM8qIsNySbRej4CXyNG+FsJGeSExSIB0qy5I3ala2z4Ss1H4kMWvYphqpjlkW76QBIWiEH7koXB81rSEyvsbB33K7zdfY0WfKwAO9jixdssvpdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896015; c=relaxed/simple;
	bh=Yr4r69HQnoaR9z+gufNVtBUx1HKbnFFM6wVZqU010to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLVRbrE12Y54dE8P2uOrbevbi2vcq9phvm+JbLmevI8t8UI9/8wkecZPbE6G8wXEDplKumKlYup1WlW0EulYXwgjfGb6+c/VyqUA76bJxoEe725GG4SToE4e/U7b7BVeY+3MjIbTpOEZoPKsCdN9Z6PKc0jp+BntBFgJMStxubU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXEXWL+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXEXWL+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B94AC4CECD;
	Wed,  6 Nov 2024 12:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896015;
	bh=Yr4r69HQnoaR9z+gufNVtBUx1HKbnFFM6wVZqU010to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXEXWL+fwwsoRDF1WjXaeBKJd+2yp/dbGmZLwNrKbxW+P5J94Ea9zW2y6pd+Op9J6
	 y41AayqmjrxaDqksCzKB0hogSxgCh5ohKHLz9JArB5WcJTb6sxNeHkPy1XCzwc9Src
	 tX8orrHRuGYd1FxyUWVizyETFZUpo4ktP40O0iOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruansy.fnst@fujitsu.com,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 061/245] fsdax: dax_unshare_iter needs to copy entire blocks
Date: Wed,  6 Nov 2024 13:01:54 +0100
Message-ID: <20241106120320.709516859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 50793801fc7f6d08def48754fb0f0706b0cfc394 ]

The code that copies data from srcmap to iomap in dax_unshare_iter is
very very broken, which bfoster's recent fsx changes have exposed.

If the pos and len passed to dax_file_unshare are not aligned to an
fsblock boundary, the iter pos and length in the _iter function will
reflect this unalignment.

dax_iomap_direct_access always returns a pointer to the start of the
kmapped fsdax page, even if its pos argument is in the middle of that
page.  This is catastrophic for data integrity when iter->pos is not
aligned to a page, because daddr/saddr do not point to the same byte in
the file as iter->pos.  Hence we corrupt user data by copying it to the
wrong place.

If iter->pos + iomap_length() in the _iter function not aligned to a
page, then we fail to copy a full block, and only partially populate the
destination block.  This is catastrophic for data confidentiality
because we expose stale pmem contents.

Fix both of these issues by aligning copy_pos/copy_len to a page
boundary (remember, this is fsdax so 1 fsblock == 1 base page) so that
we always copy full blocks.

We're not done yet -- there's no call to invalidate_inode_pages2_range,
so programs that have the file range mmap'd will continue accessing the
old memory mapping after the file metadata updates have completed.

Be careful with the return value -- if the unshare succeeds, we still
need to return the number of bytes that the iomap iter thinks we're
operating on.

Cc: ruansy.fnst@fujitsu.com
Fixes: d984648e428b ("fsdax,xfs: port unshare to fsdax")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/172796813328.1131942.16777025316348797355.stgit@frogsfrogsfrogs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9fbbdaa784b43..21b47402b3dca 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1262,26 +1262,46 @@ static s64 dax_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
-	loff_t pos = iter->pos;
-	loff_t length = iomap_length(iter);
+	loff_t copy_pos = iter->pos;
+	u64 copy_len = iomap_length(iter);
+	u32 mod;
 	int id = 0;
 	s64 ret = 0;
 	void *daddr = NULL, *saddr = NULL;
 
 	if (!iomap_want_unshare_iter(iter))
-		return length;
+		return iomap_length(iter);
+
+	/*
+	 * Extend the file range to be aligned to fsblock/pagesize, because
+	 * we need to copy entire blocks, not just the byte range specified.
+	 * Invalidate the mapping because we're about to CoW.
+	 */
+	mod = offset_in_page(copy_pos);
+	if (mod) {
+		copy_len += mod;
+		copy_pos -= mod;
+	}
+
+	mod = offset_in_page(copy_pos + copy_len);
+	if (mod)
+		copy_len += PAGE_SIZE - mod;
+
+	invalidate_inode_pages2_range(iter->inode->i_mapping,
+				      copy_pos >> PAGE_SHIFT,
+				      (copy_pos + copy_len - 1) >> PAGE_SHIFT);
 
 	id = dax_read_lock();
-	ret = dax_iomap_direct_access(iomap, pos, length, &daddr, NULL);
+	ret = dax_iomap_direct_access(iomap, copy_pos, copy_len, &daddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	ret = dax_iomap_direct_access(srcmap, pos, length, &saddr, NULL);
+	ret = dax_iomap_direct_access(srcmap, copy_pos, copy_len, &saddr, NULL);
 	if (ret < 0)
 		goto out_unlock;
 
-	if (copy_mc_to_kernel(daddr, saddr, length) == 0)
-		ret = length;
+	if (copy_mc_to_kernel(daddr, saddr, copy_len) == 0)
+		ret = iomap_length(iter);
 	else
 		ret = -EIO;
 
-- 
2.43.0



