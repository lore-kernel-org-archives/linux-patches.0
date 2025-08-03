Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91F204090;
	Sun,  3 Aug 2025 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256061; cv=none; b=MQuvulF9eQocKT9UAP81e8fGYxw/zVphgmoEoRM3rQDj1d5KfjyVlQ7YYyPK5qqJB4mllufbt2ThWLNPlRThT0eGTum5P7gOcyQKoFiq7RnKWbQGWWpNiU7eKXxD0QJZoILO6fVacmw/4Y+ow0BlLshnEXjq3z4Bu61kRlfXlUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256061; c=relaxed/simple;
	bh=aa+Ru3EneJaN6+jRe0PpJ4r3pnXnlu0b8LfZS8UNv24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mJAPg/+EMwODqJC8qDsGop08Unw49074KM3/gBXShvNwIKDBoQOf4fboIyUaT5ymDGA0BPE/74hrd2caJk7rGuQqU4tIF7YpaDGED1mM/sFm6l1foMi+sljBXxbaL5AMyEAzWbsyOdr3VkqbI0REMgkQaIU/4djr4cJWIgle08M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p82nbdWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p82nbdWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F013C4CEFC;
	Sun,  3 Aug 2025 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256060;
	bh=aa+Ru3EneJaN6+jRe0PpJ4r3pnXnlu0b8LfZS8UNv24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p82nbdWT/Y6fMi3C0lCSnT3f4335g2WeHD7Cpx4DYF2E5SJmqMcTD0B8xOfa64427
	 m/+Q/1UU3D9qC+SA1i+v/Nw4sVeSUzaRLnDsPOpxsa1KtsXne1Lffc1eomazbEKAKn
	 G23rJsGb+ErUgw2AgvHLTBJ3t2wOC4wMEgmWw2ApIl+TvxbkzPkKhpfiCWtrDiallu
	 y5Zsdh+fVmzlLlSNrx3bLTGNjtQOLsPMv5WdoI6g3srcNVIy6aDsNh4Q4JGTZDhTFe
	 RCeBqPo7KBPRRPRjlwvPYZNIJubr7cWOSmZjPeLuJIIWP5sSBT2s2898PvVGrOdIue
	 uSN3RJIH/It7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>,
	jack@suse.com
Subject: [PATCH AUTOSEL 6.6 12/23] udf: Verify partition map count
Date: Sun,  3 Aug 2025 17:20:19 -0400
Message-Id: <20250803212031.3547641-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
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
index 20dff9ed2471..cb13a07a4aa8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1409,7 +1409,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1430,7 +1430,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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

