Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0044A1A01C8;
	Tue, 27 Aug 2024 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770393; cv=none; b=lJcprlizplijVJD+7Cre1G04FpvjBQywvS/X0ZNY8hX4hlSRwn/7I6P+/JoPhVfL7Lg7uDz4+27QxRonzbq9LXK+0PE17h3rsnQZvwqcz1VVzQskQXTe525TK3QQ2ztcWzGQXp+i+Kj9BpCf+1FS2UY8N21NOxdb8dI/K6LTpKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770393; c=relaxed/simple;
	bh=8NmlGVFtyUJ7mzV/51trY5/0ai2tX/VrbWWQwvyLH7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jN+cSAcLlXE3jpzXQ7fNR3SgqGmPRjRZlJaQyi5SgE3h3DG6q2OMoiiHWP4T9O+dIE7aZ2gV0MCGdQZeYR4bX6Sh5bFP26AshXSiEyMcWQxRZY8EvTbHUcJwQ6qAM/emnJTtNrTGTZwE0XZNEhoefigIiJLSsX7qpVYK3MRQb00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CPxJX/7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPxJX/7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FFBC61042;
	Tue, 27 Aug 2024 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770392;
	bh=8NmlGVFtyUJ7mzV/51trY5/0ai2tX/VrbWWQwvyLH7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPxJX/7ZnaAW0LHwC9Vr8d8g+FGxh2UiRtFaavbh176TY7zCCQZOm5E7uOQXwqr5I
	 jUA1wh7tVPvGNFBoanARFRNBg/PzketFHfuUCpV74AUifUhEMu2ZDkJY95/utwj/34
	 DukRQ5QJKxfkZ0n2LECWAGXtcN9wkOfJYwwlPbPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/341] btrfs: push errors up from add_async_extent()
Date: Tue, 27 Aug 2024 16:36:59 +0200
Message-ID: <20240827143850.565896162@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit dbe6cda68f0e1be269e6509c8bf3d8d89089c1c4 ]

The memory allocation error in add_async_extent() is not handled
properly, return an error and push the BUG_ON to the caller. Handling it
there is not trivial so at least make it visible.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5ddee801a8303..dff47ba858a0a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -730,7 +730,8 @@ static noinline int add_async_extent(struct async_chunk *cow,
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
-	BUG_ON(!async_extent); /* -ENOMEM */
+	if (!async_extent)
+		return -ENOMEM;
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -1017,8 +1018,9 @@ static void compress_file_range(struct btrfs_work *work)
 	 * The async work queues will take care of doing actual allocation on
 	 * disk for these compressed pages, and will submit the bios.
 	 */
-	add_async_extent(async_chunk, start, total_in, total_compressed, pages,
-			 nr_pages, compress_type);
+	ret = add_async_extent(async_chunk, start, total_in, total_compressed, pages,
+			       nr_pages, compress_type);
+	BUG_ON(ret);
 	if (start + total_in < end) {
 		start += total_in;
 		cond_resched();
@@ -1030,8 +1032,9 @@ static void compress_file_range(struct btrfs_work *work)
 	if (!btrfs_test_opt(fs_info, FORCE_COMPRESS) && !inode->prop_compress)
 		inode->flags |= BTRFS_INODE_NOCOMPRESS;
 cleanup_and_bail_uncompressed:
-	add_async_extent(async_chunk, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE);
+	ret = add_async_extent(async_chunk, start, end - start + 1, 0, NULL, 0,
+			       BTRFS_COMPRESS_NONE);
+	BUG_ON(ret);
 free_pages:
 	if (pages) {
 		for (i = 0; i < nr_pages; i++) {
-- 
2.43.0



