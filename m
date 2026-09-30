Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD247124F;
	Wed, 30 Sep 2026 15:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782625; cv=none; b=iB96LAbStrZxx3S21WtTkjsQAfg02fmVN4ljQKiwrxV1F1QnJoN+txDwIzvCz0vRnWKGgAAZBXclq0gQl5pGMW/QzPX3eWTvjXna0FilwsKAw8bOuiUy2pk04Lm+oFxbM9Yu1Xy1jIKwDAU6qtl7ByJORlNQSG58P1Tay/MfiH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782625; c=relaxed/simple;
	bh=FKBMH8gyPD3+smku/vwhG50WfY9NlztVmr76wg8V7t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2gVEgcYghcbuCXeXv+XFvni7uqhvTXdKE0a3sgNfntjiSzk/UGA1u8AwLDVxTANVkoXB8DD2gZHRRJy72bP8hUknmFwcZ0WWgBlOtATi0kzIdIyc4Awd8fd7HvWmPdeZmL562aDSjXhOP0tfBt2WGq34GA+PJmv48b0M6lXnHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mE+VWiSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mE+VWiSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64821F00893;
	Wed, 30 Sep 2026 15:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782618;
	bh=wtMxhUtfJ/LOKfKM3TRGlayHgkIdPnakS1Rzk3WcyiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mE+VWiSk8eSGOypIuQ1T0uWF6vwWbj7xmRjbd3ZTF47+zNhRLrt/kD/AQE6BxeoCE
	 8+sfJ8WvZImNniX80f8pdzClDgvRv3P1DNvrA1DSNLoyRmOVeHA0bbumtqKTOtK0BD
	 7K3+7rvP1Ewlp1bBFIp+1SwKSc6rnKEcWFTwvObI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/595] btrfs: balance: fix potential bg lookup failure in btrfs_may_alloc_data_chunk()
Date: Wed, 30 Sep 2026 17:20:01 +0200
Message-ID: <20260930152350.060728826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index da77493f4c17d..f08b6310e0d67 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3296,7 +3296,11 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
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



