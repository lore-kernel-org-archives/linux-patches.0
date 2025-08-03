Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061D11D5CC6;
	Sun,  3 Aug 2025 21:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256021; cv=none; b=H335FjsWPb+X4P3a5RTjLZFmjZwytdrWsSmkKnfVCKGGWZa+49HNNfqxj6lx7wIeYrRdAz6xlXyEJpuGV0XcR65PxK4X7JiDwLGOEA4F2xaLhaNRbpAoF9iseBb2zG2pkuNJoag4914YxqL/B73nssu31m+PPoRQu2lUs3IromU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256021; c=relaxed/simple;
	bh=3dTYzuGnZd3LM/DJnChQci1PIZnNPwjGX4pMVqkY1fo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j3eS2Vy8m1l6O+tDV0Iwlrqtux3O6PCkXfQ9sZMxTvQWHs1ovIglHz1FnLLZP32YAYnMWHMeKQf12rfOchfs5bmoTYv8C4BJDzv34MkcKHCSEFcj2P1BagvoRmlEwTekqzoPxGs0ivjSpqBF82qDQ0AQkTuSOVWCNsqg11FgOJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GVUd54f4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GVUd54f4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1478C4CEFB;
	Sun,  3 Aug 2025 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256019;
	bh=3dTYzuGnZd3LM/DJnChQci1PIZnNPwjGX4pMVqkY1fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVUd54f4QLyw4IHC0ZcNKrCWPuSpgLTOPP+s5LA4rTxqQIGgzl9FkO3mHXWXAf1Yi
	 ruLPHrZMj76+w9qI4+sUeKn9wmHeges+PwIQTP+Z5uLEFQvJ03M7+ctrRhwxPDvUH1
	 43Up+cmqT8JCSssHw+IzpS4yh35uRzPIvjQF8k5kwnccecuJZYJyog9v8/FYV38AOh
	 0hcAGKV5oOJQzvJMZ6mPlrm63hQRpjjHdTS0DKqDJPuUg/YdzupVce6jFDQlzjX7H0
	 neaK00iJIWYv6E+Snp3TcAqvSVj667qOfuVIihCL9Lss/V8qBpZi37VHsBjfC7aIUq
	 Cn6lqjZgNwgAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com
Subject: [PATCH AUTOSEL 6.12 17/31] udf: Verify partition map count
Date: Sun,  3 Aug 2025 17:19:20 -0400
Message-Id: <20250803211935.3547048-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803211935.3547048-1-sashal@kernel.org>
References: <20250803211935.3547048-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.41
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

[ Upstream commit 1a11201668e8635602577dcf06f2e96c591d8819 ]

Verify that number of partition maps isn't insanely high which can lead
to large allocation in udf_sb_alloc_partition_maps(). All partition maps
have to fit in the LVD which is in a single block.

Reported-by: syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees based on the
following analysis:

1. **Security Fix**: The commit addresses a security vulnerability
   reported by syzbot
   (syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com), indicating
   this is fixing a real bug discovered through fuzzing. The issue could
   lead to excessive memory allocation in
   `udf_sb_alloc_partition_maps()`.

2. **Integer Overflow/Memory Exhaustion Prevention**: The code adds a
   crucial bounds check that prevents potentially huge allocations.
   Without this check, a malformed UDF filesystem could specify an
   arbitrarily large `numPartitionMaps` value, causing `kcalloc()` in
   `udf_sb_alloc_partition_maps()` to allocate excessive memory or fail.

3. **Small, Contained Fix**: The change is minimal - only 11 lines added
   and 2 modified. It adds a simple validation check:
  ```c
  if (part_map_count > table_len / sizeof(struct genericPartitionMap1))
  ```
  This ensures the partition map count doesn't exceed what can
  physically fit in the table.

4. **Clear Bug Fix Pattern**: The fix follows a standard pattern of
   input validation before allocation, which is a well-understood
   security best practice. The logic is straightforward: all partition
   maps must fit within the Logical Volume Descriptor (LVD) block.

5. **No Feature Changes**: This is purely a defensive check that
   prevents invalid input from causing problems. It doesn't change any
   functionality for valid UDF filesystems.

6. **Affects User-Facing Code**: UDF filesystem mounting is user-facing
   functionality that could be triggered by inserting malicious media or
   mounting crafted filesystem images, making this an important security
   boundary.

7. **Low Risk of Regression**: The added check only rejects invalid
   filesystems that would likely cause problems anyway. Valid UDF
   filesystems will pass this check without issue.

The commit follows stable kernel rules by fixing an important bug
(potential DoS through memory exhaustion) with minimal, low-risk changes
to a filesystem that handles untrusted input.

 fs/udf/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 1c8a736b3309..b2f168b0a0d1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1440,7 +1440,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1461,7 +1461,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					   "logical volume");
 	if (ret)
 		goto out_bh;
-	ret = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+
+	part_map_count = le32_to_cpu(lvd->numPartitionMaps);
+	if (part_map_count > table_len / sizeof(struct genericPartitionMap1)) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too many partition maps (%u > %u)\n", part_map_count,
+			table_len / (unsigned)sizeof(struct genericPartitionMap1));
+		ret = -EIO;
+		goto out_bh;
+	}
+	ret = udf_sb_alloc_partition_maps(sb, part_map_count);
 	if (ret)
 		goto out_bh;
 
-- 
2.39.5

