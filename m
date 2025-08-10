Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E318C933;
	Sun, 10 Aug 2025 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844722; cv=none; b=YT6jpJtbJY+p8ay63QwlVRo2/cGQofXaqNVAAad+ph4D/lDwFyChhkbuEiD09T00d1/aaqxM1N1ENMqs/93XnJrFDAqU791aqityLhRaeqVmHuvkLUATm0+lwJPcZkVKVShv6Ft+jGcZN+PLARamA3hJqWgVn6yJgUkGQJRB7t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844722; c=relaxed/simple;
	bh=5+1OgXBWikGfNfHsB4wmJv6tgGDqZu9/PnzXxMeunkQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=unuq+xR3BhdpZiitIeZZoEbVfBtfjF9xc/7vAr/aCO2+WrgvTQj35t9OTcsTLFCqL+nZMVilh3yn5f2Mk+JvMmix30ZwaIVavWRSb91PjpbdfnIqYNRhCGRhVxtMRisiuTKb7hzJbacDtuiOFR/eDFb7OFwrVnln/UCh6a5CIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlQYaWMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlQYaWMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9445C4CEEB;
	Sun, 10 Aug 2025 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844722;
	bh=5+1OgXBWikGfNfHsB4wmJv6tgGDqZu9/PnzXxMeunkQ=;
	h=From:To:Cc:Subject:Date:From;
	b=NlQYaWMlmFpolWHrnZ1R2FFoqoRoIb6qh7OqItMjD5vlwKa1B6FFdZXRsueEULYT5
	 VOHHs3+8zKeW6dsigo7A3T1l3Mj5bz2D8hooI6qKMFq9d3P5f8W5pgTYzHwBL/Nssh
	 HaSU7Pr1F28ARpsTaoisjDKCtiSpGo3SlpLDFkT+gd2+o5N9qEwurZ/9hF8qCw8/Wl
	 WFkwpY9kEUCUl/QGapnJC2AWyPqXzF9GToBdu6aMW8YiHroxctIg9bnm3jtSAaD+ge
	 DeUMrioaw/MLMDTKP9l/zDLK2NWWE6zuw1R5TBWsELJCoq2h33OuF+l8pVQbVO+DHk
	 A2PoAGpnEDjNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-5.10] block: avoid possible overflow for chunk_sectors check in blk_stack_limits()
Date: Sun, 10 Aug 2025 12:51:43 -0400
Message-Id: <20250810165158.1888206-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 448dfecc7ff807822ecd47a5c052acedca7d09e8 ]

In blk_stack_limits(), we check that the t->chunk_sectors value is a
multiple of the t->physical_block_size value.

However, by finding the chunk_sectors value in bytes, we may overflow
the unsigned int which holds chunk_sectors, so change the check to be
based on sectors.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250729091448.1691334-2-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

## Extensive Analysis

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **It fixes a real integer overflow bug**
The original code performs `(t->chunk_sectors << 9)` which can cause an
integer overflow. Since both `chunk_sectors` and `physical_block_size`
are `unsigned int` (32-bit), when `chunk_sectors` is larger than
8,388,607 (2^23 - 1), shifting it left by 9 bits (multiplying by 512)
will overflow the 32-bit unsigned integer. This overflow can lead to
incorrect alignment checks.

### 2. **The fix is minimal and contained**
The change is a single-line modification that replaces:
```c
if ((t->chunk_sectors << 9) & (t->physical_block_size - 1))
```
with:
```c
if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT))
```

This mathematically equivalent check avoids the overflow by dividing
`physical_block_size` by the sector size (512 bytes) instead of
multiplying `chunk_sectors` by 512.

### 3. **It's a correctness issue in critical block layer code**
The `blk_stack_limits()` function is fundamental to the block layer's
device stacking functionality, used by MD, DM, and other stacked block
devices. An overflow here could lead to:
- Incorrect alignment detection
- Improper chunk_sectors being cleared when it shouldn't be
- Potential data corruption or I/O errors in stacked block devices

### 4. **The fix has low regression risk**
- The new calculation is mathematically equivalent to the intended check
- It only changes how the comparison is performed, not the logic
- The fix has been reviewed by multiple maintainers (Hannes Reinecke,
  Martin K. Petersen, Damien Le Moal)
- No new features or architectural changes are introduced

### 5. **Real-world impact potential**
Modern storage devices can have large chunk sizes. For example:
- NVMe devices with large zones could have chunk_sectors approaching or
  exceeding the overflow threshold
- RAID configurations with large stripe sizes
- This becomes more likely as storage devices grow in capacity and
  complexity

### 6. **Follows stable kernel criteria**
According to stable kernel rules, this qualifies because it:
- Fixes a bug that users can potentially hit
- Is obviously correct and tested
- Is small (single line change)
- Fixes only one thing
- Has no dependencies on other patches

The commit message clearly describes the problem (overflow in unsigned
int) and the solution (changing the check to avoid overflow). The fix
maintains the same semantic meaning while being overflow-safe, making it
an ideal candidate for stable backporting.

 block/blk-settings.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a000daafbfb4..88890e904320 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -779,7 +779,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	}
 
 	/* chunk_sectors a multiple of the physical block size? */
-	if ((t->chunk_sectors << 9) & (t->physical_block_size - 1)) {
+	if (t->chunk_sectors % (t->physical_block_size >> SECTOR_SHIFT)) {
 		t->chunk_sectors = 0;
 		t->flags |= BLK_FLAG_MISALIGNED;
 		ret = -1;
-- 
2.39.5

