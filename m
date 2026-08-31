Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2F0427FB6;
	Mon, 31 Aug 2026 13:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183208; cv=none; b=USP2bgwYAi53Y6jG1pgnkjO7lGMrpG0cO1xt+eDGRP6zN49IZV9fxtmxq5ka0IQgldbgRfB09i8OdqBxfzn88OdI9osC6xFzD3qyWar7LkQ8l3z++IcPnA80dN8IbG0QvK2xYgyg1LfADM7AXZa4ALgcyG/j4l8VDdSJqQoMJfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183208; c=relaxed/simple;
	bh=U1i+nzvbSVxrXS7qjECK50b/bT9u6n4qnfAkz9GxbnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaQL7N6KTYjLFeFGFEDKGzLL28YNJOEopZzBdemh1IhvaCRhM7YiCXQqW/IjN/6dvovDPynpiXx3dmH1cf6CBcF9FvUie/WHjqp1Q6+/T1LLrwf4BfA+iG5nFdYOz607rKcJxx5Lq4Nbg/9hGAmkpqAGXjkZN2Fkn2HNKMXA76c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9kwOYdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9kwOYdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D51A1F00A3D;
	Mon, 31 Aug 2026 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183206;
	bh=6TXEw8YB6Mq5YV1Q5/GSKHGwKOC11P2l3Yr0tDfy340=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9kwOYdUhSUQa/BAAcXu+pvQmxtKGWzkErx5Nu+mPIP1fUoiC8OvomFZC5Bv5SvVy
	 dA9HxcrHEwj9okWEpju5B6D5lH9m5Taf5rzlHEfphsaLCEfi1qbSd1kQnyyW++Gf9c
	 yReDixHlMsz0+wVRVhM3FqbE0Dy2hQ2L8gagiu7kyTVzgtet2i7czwBvxobnoQbBDG
	 sQ/nhqnzz9Dy1EPbBl0jEUAyQoeYFcw/S8dvqCQ7yvPlf5TS/ymysvGzjhAwBNrAnd
	 ZFqsI4WhI24SdJZR9ZY1I7+rVoQYKbixhygWltguwIDaz85Un8wYeN0DULjt7qSwDw
	 xGDT98dgNURFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	almaz.alexandrovich@paragon-software.com,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] ntfs3: handle set_blocksize failures
Date: Mon, 31 Aug 2026 09:20:35 -0400
Message-ID: <20260831133314.4125787-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 24f7d1824b7581ae3daf9d443c5dfeabd89df6d8 ]

ntfs3 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting we will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-10-hch@lst.de
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished and match the earlier analysis:

- **Related commits in 6.18.44:** `b3c151` (dummy `sb_min_blocksize`
  before boot read) and `28861e3` (moved blocksize init into
  `ntfs_init_from_boot`). Neither covers the unchecked
  `sb_set_blocksize()` calls this patch fixes.
- **This commit is not in the tree:** `git log --grep="handle
  set_blocksize"` returned nothing here, so the fix is still a candidate
  for backport.

The **YES** verdict stands: the vulnerable code is at
`fs/ntfs3/super.c:1137` and `:1188`, and the patch should apply cleanly.

 fs/ntfs3/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 9a2e3d0efd998..81fcc8c2114b6 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1134,7 +1134,10 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 	rec->total = cpu_to_le32(sbi->record_size);
 	((struct ATTRIB *)Add2Ptr(rec, ao))->type = ATTR_END;
 
-	sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE));
+	if (!sb_set_blocksize(sb, min_t(u32, sbi->cluster_size, PAGE_SIZE))) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	sbi->block_mask = sb->s_blocksize - 1;
 	sbi->blocks_per_cluster = sbi->cluster_size >> sb->s_blocksize_bits;
@@ -1185,7 +1188,8 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 			/*
 			 * Try alternative boot (last sector)
 			 */
-			sb_set_blocksize(sb, block_size);
+			if (!sb_set_blocksize(sb, block_size))
+				return -EINVAL;
 			hint = "Alternative boot";
 			dev_size = dev_size0; /* restore original size. */
 			goto read_boot;
-- 
2.53.0

