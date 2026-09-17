Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8B54F5DF0;
	Thu, 17 Sep 2026 16:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664367; cv=none; b=muM6DcUzjmF80LrEiCtZF6DTvBbxd64u1Vn72Dy8WkPxzsLvUE3JAgILfbKaa32RPEQeVg5DcF0K1bQek38qFb4IsFRHi0r1Qzze3s0jq2aM2isyTVw3aR6E2zzygC3ktcwt/QHsF+dh5Uh4inMl2PzkvKeG5dmeAb8v5zGeJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664367; c=relaxed/simple;
	bh=xaijL55iDNeVEu8qUjgX1q55OESgTNVgeuvyUKSJ3oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0oa3k+zMV6fKcihGAV67goxq6PXrguiKCTlYTd1PU9pfb9OKvwvING65zE+VmNUUmT+YB0iH6SaX9eurp02m1EcOGIc1e6DKsX/SRLg7138qbgaaEvVbhdoRXZnMqXLrFfBpoZvCydyILinkSh19kpiIZylWoJIwimWiAcxfFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uUZoMGx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uUZoMGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393491F000FF;
	Thu, 17 Sep 2026 16:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664365;
	bh=4nvygmSoEm+9AXyzpWqOG/2jT+hGPf6BuoDfTXDhZsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uUZoMGxbX719B7qFvpEcJOItZdIK0pn0ZGVULnzZ39Tn30j7eE1hI50DrYb/nVSZ
	 bBnp+KajUCWgPmcrdD8HjxqDowM3PJrJc5eXLuGucrMMORUT0iCM7o1Ulqz/CnrhHN
	 abvajY3+UnGWHBmnooA1Ds7ZW9/o9zAPHhlzZWeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0349/1250] btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()
Date: Thu, 17 Sep 2026 16:02:24 +0100
Message-ID: <20260917151601.530553608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit 18d32b0013efba19f7ad3e5b08d7aee813d604a6 ]

[BUG]
Running btrfs balance can trigger a null-ptr-deref before relocating a
data chunk when metadata corruption leaves a chunk in the chunk tree
without a corresponding block group in the in-memory cache:

  KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
  RIP: 0010:btrfs_may_alloc_data_chunk+0x40/0x1c0 fs/btrfs/volumes.c:3601
  Call Trace:
    __btrfs_balance fs/btrfs/volumes.c:4217 [inline]
    btrfs_balance+0x2516/0x42b0 fs/btrfs/volumes.c:4604
    btrfs_ioctl_balance fs/btrfs/ioctl.c:3577 [inline]
    btrfs_ioctl+0x25cf/0x5b90 fs/btrfs/ioctl.c:5313
    ...

[CAUSE]
__btrfs_balance() iterates the on-disk chunk tree and passes the chunk
logical bytenr to btrfs_may_alloc_data_chunk() before relocating a data
chunk. That helper then queries the in-memory block group cache:

  cache = btrfs_lookup_block_group(fs_info, chunk_offset);
  chunk_type = cache->flags;   /* cache may be NULL */

A corrupt image can contain a chunk item whose matching block group
item is missing, so no block group is ever inserted into the cache. In
that case btrfs_lookup_block_group() returns NULL.

The code only guards this with ASSERT(cache), which becomes a no-op when
CONFIG_BTRFS_ASSERT is disabled. The subsequent dereference of
cache->flags therefore crashes the kernel.

[FIX]
Add a NULL check after btrfs_lookup_block_group() in
btrfs_may_alloc_data_chunk() and print and error message for clarity.

Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 51c3eab54bde6..fe81ff417c0d8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3719,7 +3719,11 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 	u64 chunk_type;
 
 	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
-	ASSERT(cache);
+	if (unlikely(!cache)) {
+		btrfs_err(fs_info, "balance: chunk at bytenr %llu has no corresponding block group",
+			  chunk_offset);
+		return -EUCLEAN;
+	}
 	chunk_type = cache->flags;
 	btrfs_put_block_group(cache);
 
-- 
2.53.0



