Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6B32033A;
	Sun, 10 Aug 2025 16:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844741; cv=none; b=K19DKLrDHeSUQ/wkMoJqbZ6AzvpFodyN4KFZ3zofyYXs5LWzeFx3J8x3uJ+4oi9qvdS5mAVIfsj+a0iRzhmRq5/rfZM2DfPjaURsi5RM3YpU0YrhGaxO0ITlb7+7z2wsImhZJgThkczmpjNkBpWMD8Ep2HhcVQIU8ftWHB6yOH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844741; c=relaxed/simple;
	bh=njWxkI9r7TNsQM+AFinPsE4n0m/ueCecA9hoaC+99c4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IRhFWfiXvulSj8zNCsor9hCGEYLgj0X27iyriyXDKiGvgYju+6hv45If+r17q8wKflcdBeTW9HC2uuYAL2yBETi+Hze9wm6deIs84CI1P/I+7G2qeV3uXzkCxQ21wkCynR+EcYVc+EBN3Tg9d7RISc6/wuUWJ4YRflxiKhgZZh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/sC1oEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/sC1oEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A029C4CEF0;
	Sun, 10 Aug 2025 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844740;
	bh=njWxkI9r7TNsQM+AFinPsE4n0m/ueCecA9hoaC+99c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/sC1oEpbLAakIVM91OWQoBTU8eGtiCclJvJUkVc8LENdAgr+mcmY5tfdejSXotum
	 HkUJ31Yze47q+SqF3kMvNyen9HAHtjt8QiPB1a/VhqnVx+laaoQbY98em10GEBIyFM
	 LPhv3gTIIRGx+GF4TRHRxGt7Efy3qXVVWESHus/no0V3OAm4m6HJbiAqUhmiGHRy2H
	 OG8O+s3JzwLDE+toC0RXQdxxtQZdYz9fp4utSvQZxomXSRNADULdT5N3MdKCZS1z4t
	 908F3B6NwRBYuU12Yq+Y442wo/oFsy+MzE03e7wOwobAGOvdPO2Kgwup/G+p1vS7Ca
	 JlDqNVl8CJj2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	chuck.lever@oracle.com,
	bcodding@redhat.com
Subject: [PATCH AUTOSEL 6.16-5.4] pNFS: Fix stripe mapping in block/scsi layout
Date: Sun, 10 Aug 2025 12:51:49 -0400
Message-Id: <20250810165158.1888206-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 81438498a285759f31e843ac4800f82a5ce6521f ]

Because of integer division, we need to carefully calculate the
disk offset. Consider the example below for a stripe of 6 volumes,
a chunk size of 4096, and an offset of 70000.

chunk = div_u64(offset, dev->chunk_size) = 70000 / 4096 = 17
offset = chunk * dev->chunk_size = 17 * 4096 = 69632
disk_offset_wrong = div_u64(offset, dev->nr_children) = 69632 / 6 = 11605
disk_chunk = div_u64(chunk, dev->nr_children) = 17 / 6 = 2
disk_offset = disk_chunk * dev->chunk_size = 2 * 4096 = 8192

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250701122341.199112-1-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a critical mathematical calculation error in the pNFS
block/SCSI layout stripe mapping function. The bug causes incorrect disk
offset calculations due to improper integer division, which could lead
to data corruption or incorrect data access in striped pNFS block
layouts.

## Specific Code Analysis

The bug is in the `bl_map_stripe()` function at line 276 of the original
code:
```c
disk_offset = div_u64(offset, dev->nr_children);
```

This calculation is fundamentally wrong. The commit message provides a
clear example showing how the bug manifests:
- With 6 volumes, chunk size 4096, and offset 70000
- The wrong calculation yields disk_offset = 11605
- The correct calculation yields disk_offset = 8192

The fix changes the calculation to:
```c
disk_chunk = div_u64_rem(chunk, dev->nr_children, &chunk_idx);
disk_offset = disk_chunk * dev->chunk_size;
```

This properly calculates which chunk on the specific disk should be
accessed by:
1. First determining the disk_chunk number (which chunk on the target
   disk)
2. Then multiplying by chunk_size to get the actual byte offset

## Stable Backport Criteria Met

1. **Fixes a real bug**: Yes - incorrect stripe offset calculation
   leading to wrong data access
2. **Small and contained**: Yes - only 3 lines changed, localized to one
   function
3. **No major architectural changes**: Correct - simple math fix
4. **Low regression risk**: Yes - the new calculation is mathematically
   correct and doesn't change any interfaces
5. **Important for users**: Yes - data corruption/access issues in pNFS
   deployments are serious

## Historical Context
Looking at the git history, this area has had previous stable-worthy
fixes:
- Commit 0914bb965e38 fixed an off-by-one error and was explicitly
  marked for stable (Cc: stable@vger.kernel.org # 3.17+)
- Commit 5466112f0935 fixed 64-bit division issues in the same function

This indicates that `bl_map_stripe()` is a critical function that has
needed careful attention for correctness, and fixes to it have
historically been considered stable-worthy.

## Impact Assessment
Without this fix, any system using pNFS block layout with striping could
experience:
- Data written to wrong disk locations
- Data read from wrong disk locations
- Potential data corruption or loss

The fix is essential for correct operation of pNFS block layouts with
striping configurations.

 fs/nfs/blocklayout/dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index cab8809f0e0f..44306ac22353 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -257,10 +257,11 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
 	struct pnfs_block_dev *child;
 	u64 chunk;
 	u32 chunk_idx;
+	u64 disk_chunk;
 	u64 disk_offset;
 
 	chunk = div_u64(offset, dev->chunk_size);
-	div_u64_rem(chunk, dev->nr_children, &chunk_idx);
+	disk_chunk = div_u64_rem(chunk, dev->nr_children, &chunk_idx);
 
 	if (chunk_idx >= dev->nr_children) {
 		dprintk("%s: invalid chunk idx %d (%lld/%lld)\n",
@@ -273,7 +274,7 @@ static bool bl_map_stripe(struct pnfs_block_dev *dev, u64 offset,
 	offset = chunk * dev->chunk_size;
 
 	/* disk offset of the stripe */
-	disk_offset = div_u64(offset, dev->nr_children);
+	disk_offset = disk_chunk * dev->chunk_size;
 
 	child = &dev->children[chunk_idx];
 	child->map(child, disk_offset, map);
-- 
2.39.5

