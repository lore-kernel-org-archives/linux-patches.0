Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916B24BD02;
	Tue, 20 May 2025 14:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750215; cv=none; b=Mo3Oo5GL9p/HtvUK1IjqZi3RkdxORYiFTr27p4St/miFsVe9CCXGjIc9gu7uQ/2XGFXmUXbFEvcIjooYctgAv8m7wTmXdCbhTdUqfM8TawvHzHQcoJY0siuIc+zcYS05RVctpwTkpGv+jjQDgcBlAQVpqGOhFQ/3SbXQB58DzmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750215; c=relaxed/simple;
	bh=psgV00cFV9VVWvtohu0yk7YrABqCGN3HvtLvmv0KgX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0y4fdydr+55sNsEi7cpH5L2O77CySDl7TSmelgug7G8KT6reUG0x+bo5qxbazcrTIW7bASBy9PzfQiMhvH26WliFgnnhZ9KRRN3X2b6tig9Vn8phmv68aChm2aSv/u5SmISF+pgRYwqzrlQv7byUPkEGpJMIzoNju4YHvBqkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMH4JKyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMH4JKyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42032C4CEE9;
	Tue, 20 May 2025 14:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750215;
	bh=psgV00cFV9VVWvtohu0yk7YrABqCGN3HvtLvmv0KgX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMH4JKyfwg31FoAxuqGg/1grXWzPYCDToGbNBW/P06NumKh1eds36G2xu3prETVHq
	 8iOpnuMfPG7qw4fSyOeSe+KM5CAVc8ZmHWUa+tycTs5BCokOWKIoXFDnS/L35z1Q6P
	 3K3VZneiDNtks9Ivgmymw2h8k8veIflACfFWpLGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.12 080/143] btrfs: fix folio leak in submit_one_async_extent()
Date: Tue, 20 May 2025 15:50:35 +0200
Message-ID: <20250520125813.215429215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Boris Burkov <boris@bur.io>

commit a0fd1c6098633f9a95fc2f636383546c82b704c3 upstream.

If btrfs_reserve_extent() fails while submitting an async_extent for a
compressed write, then we fail to call free_async_extent_pages() on the
async_extent and leak its folios. A likely cause for such a failure
would be btrfs_reserve_extent() failing to find a large enough
contiguous free extent for the compressed extent.

I was able to reproduce this by:

1. mount with compress-force=zstd:3
2. fallocating most of a filesystem to a big file
3. fragmenting the remaining free space
4. trying to copy in a file which zstd would generate large compressed
   extents for (vmlinux worked well for this)

Step 4. hits the memory leak and can be repeated ad nauseam to
eventually exhaust the system memory.

Fix this by detecting the case where we fallback to uncompressed
submission for a compressed async_extent and ensuring that we call
free_async_extent_pages().

Fixes: 131a821a243f ("btrfs: fallback if compressed IO fails for ENOSPC")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Co-developed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1187,6 +1187,7 @@ static void submit_one_async_extent(stru
 	struct extent_state *cached = NULL;
 	struct extent_map *em;
 	int ret = 0;
+	bool free_pages = false;
 	u64 start = async_extent->start;
 	u64 end = async_extent->start + async_extent->ram_size - 1;
 
@@ -1207,7 +1208,10 @@ static void submit_one_async_extent(stru
 	}
 
 	if (async_extent->compress_type == BTRFS_COMPRESS_NONE) {
+		ASSERT(!async_extent->folios);
+		ASSERT(async_extent->nr_folios == 0);
 		submit_uncompressed_range(inode, async_extent, locked_folio);
+		free_pages = true;
 		goto done;
 	}
 
@@ -1223,6 +1227,7 @@ static void submit_one_async_extent(stru
 		 * fall back to uncompressed.
 		 */
 		submit_uncompressed_range(inode, async_extent, locked_folio);
+		free_pages = true;
 		goto done;
 	}
 
@@ -1264,6 +1269,8 @@ static void submit_one_async_extent(stru
 done:
 	if (async_chunk->blkcg_css)
 		kthread_associate_blkcg(NULL);
+	if (free_pages)
+		free_async_extent_pages(async_extent);
 	kfree(async_extent);
 	return;
 


