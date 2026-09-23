Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26554EC64E;
	Wed, 23 Sep 2026 14:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173555; cv=none; b=ok5M+m7GS83ZQolCHyWfMUngV+DUtE875CYqlwsrZD9mdRj3+Y+XGl7oBwx5LpczG45rxwW9WXulOvIFe0OZOvScPPHJNBouqEwspJyvbfRNgq1wnP6RvPP07sXvp/EQAq1kRlsqXvdHYRX3oIu95UIwxgTXhtZ2UVQ9xqAV3Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173555; c=relaxed/simple;
	bh=sD3diYbVB9Jxg07G/3pyFqkmb621YNuOBnXr1WwsURs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMuKhLxtFDNCnmBXj/wrbHokGfwiACOzEsn8gliUzp4EpykjNWv9w+DnPK0W6nLQPgtggZ5AosbZUKXjS5iIwuXq+tEwtZjeSLJc55KRqvBIwttenHSelmdKqbebuzGjIcnsb8g5rDNQdWpPGGnOfIEr7iCQu30bYJdFS2Q59D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NggspDBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NggspDBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8EA1F000FF;
	Wed, 23 Sep 2026 14:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173554;
	bh=ByC4wMzOETLgux9WwrcLm25BIPLB9cTvFs8iSBcDr64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NggspDBKPtA1UyLgGeAQ8FkG2EZrvGlddf3EQAaUymMom+CjtLanksToKXNDemt58
	 SIRfq6P3PzzCWGZv7/Lx8FxFZLIASuOnkM1uElPsdWmmI3HB6kAgwwsQghdr3laizy
	 vt+wBNRv/erECZO436t3Zn9TvjWTb8uEXvJIgV7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.2 283/438] btrfs: fix creation of compressed inline extents that dont save space
Date: Wed, 23 Sep 2026 16:05:04 +0200
Message-ID: <20260923140652.108595671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit cc337324cc6be1ce0ae7e5a068dcb7e99ae1b59c upstream.

If the compressed data of an inline extent is larger than or equals to the
size of the uncompressed data, we are still allowing the creation of the
compressed inline extent, which does not result in any benefits, quite the
contrary as we waste metadata space and have to decompress when reading.

This is a recent regression introduced in commit 3eaf5f082c4c ("btrfs:
extract inlined creation into a dedicated delalloc helper").

It happens because we are passing the block size to btrfs_compress_bio(),
so we don't get -E2BIG from the compression code anymore, but we can not
pass i_size either, because if i_size is smaller than sector size, we
end up never creating lzo compressed inline extent for such small i_size
values. So refuse the compressed result at run_delalloc_inline() if
its size is not smaller than the uncompressed size (i_size).

Reported-by: Hanabishi <i.r.e.c.c.a.k.u.n+kernel.org@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/c97652a5-ac6b-4de6-aa23-3cdebc01d00b@gmail.com/
Fixes: 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated delalloc helper")
CC: stable@vger.kernel.org # 7.1+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2338,12 +2338,27 @@ static int run_delalloc_inline(struct bt
 		} else if (inode->prop_compress) {
 			compress_type = inode->prop_compress;
 		}
+		/*
+		 * We need to pass blocksize and not i_size, otherwise we can't
+		 * create compressed inline extents for data smaller than sector
+		 * size with lzo.
+		 */
 		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
 		if (IS_ERR(cb)) {
 			cb = NULL;
 			/* Just fall back to non-compressed case. */
 		} else {
 			compressed_size = cb->bbio.bio.bi_iter.bi_size;
+			/*
+			 * If we did not save space, it's pointless and wasteful
+			 * to have an inline compressed extent, so fallback to
+			 * an uncompressed inline extent.
+			 */
+			if (compressed_size >= i_size) {
+				cleanup_compressed_bio(cb);
+				cb = NULL;
+				compressed_size = 0;
+			}
 		}
 	}
 	if (!can_cow_file_range_inline(inode, 0, i_size, compressed_size)) {


