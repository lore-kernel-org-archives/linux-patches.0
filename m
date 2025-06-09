Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5E52459E6;
	Mon,  9 Jun 2025 13:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476642; cv=none; b=IkkRLfHD87/5PLjTq5/LoaJ+MCNwNj9VKlGl/i4HK/3DqfDLrjIluID+E/xbGgNx/8HSqKTryQW3IvSi2Q8uJce5vmq5S5no02YDehYWPq+ESj5/qewq+wAV5WQODiR0GCriaTGWr+AHZgKDFjikuMkqSPZjEBvr4sFEWKjpjmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476642; c=relaxed/simple;
	bh=+NLbCTM1HvxphxMUmY5TbB34v7C0iU2XQ9XXCSz6HHU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VjrbatRCBkxjnY00y8DPMjpNgjrChy2Rym6zvGyUrD0x4xFXhQT5f66SvVjuW94SNHncIOnCOLtu+SuflASuM/dbQxuolmrz9fCVddm4zGDF5tLnClFs7eKRWbDT44YJoTAX6X/K6+v7mAyzReC59VwZnsyCKjPUvFs99s/5y+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+CpdKIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+CpdKIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20901C4CEF3;
	Mon,  9 Jun 2025 13:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476642;
	bh=+NLbCTM1HvxphxMUmY5TbB34v7C0iU2XQ9XXCSz6HHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+CpdKIPITd4+/R0BnOaBP6yVF2nLRUmRa43bZDcWrBRc0CxTItDzJB6KQXdumoXC
	 3e13HD4bKYaPv4MdctOhjcp9RE6NmR5Lkcz6w224gu9pTHnvORBgNm3zqWHk1kxMh9
	 HbN+bo6UtjcQERvVWPe5LHxle5Zdeq2vj1hZKaFPk2Wsrpd7F8KtWkbWkn6foMGGU5
	 jpQXV5JGxEI/Tqcy6RmxMWHexU0YwuZiGj7TmQouvP5BdNA4kKVxwto/ZsPzAnAMYL
	 4PFFpiJZ/X1H4tU6QhOSxl4L++e5PW9SXezKy1uTNPFwL7H3NiIFF5cdJutLDlhdnS
	 WeL+ZVQYqcmpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 04/35] md/md-bitmap: fix dm-raid max_write_behind setting
Date: Mon,  9 Jun 2025 09:43:20 -0400
Message-Id: <20250609134355.1341953-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 2afe17794cfed5f80295b1b9facd66e6f65e5002 ]

It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.

Link: https://lore.kernel.org/linux-raid/20250524061320.370630-14-yukuai1@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now I have a clear understanding. Let me analyze the specific code
change in the commit:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Bug Fix

### 1. The Bug
The code in `md_bitmap_new_disk_sb()` incorrectly validates
`write_behind` against `COUNTER_MAX` instead of `COUNTER_MAX / 2`:

```c
- if (write_behind > COUNTER_MAX)
+       if (write_behind > COUNTER_MAX / 2)
                write_behind = COUNTER_MAX / 2;
```

### 2. Why This is a Real Bug

The comment immediately above this code explicitly states:
```c
/*
 - FIXME: write_behind for RAID1.  If not specified, what
 - is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
 */
```

The intent is clearly to limit write_behind to `COUNTER_MAX / 2`, but
the validation check was incorrectly comparing against `COUNTER_MAX`.
This creates an inconsistency where:
- Values between `COUNTER_MAX / 2` and `COUNTER_MAX` would pass the
  check
- But then get clamped to `COUNTER_MAX / 2` anyway
- This means the validation isn't serving its intended purpose

### 3. Impact on Users

This bug affects:
- **dm-raid users**: When creating new bitmap superblocks for RAID
  arrays with write-behind configured
- **Data consistency**: While not causing data corruption, it creates
  confusion about the actual limits
- **Configuration validation**: Users might set values that appear to be
  accepted but are silently reduced

### 4. Consistency with Other Code

The fix aligns with the pattern used elsewhere:
- In `dm-raid.c`: The validation correctly checks `value / 2 >
  COUNTER_MAX` (equivalent check for sector-based values)
- The clamping value of `COUNTER_MAX / 2` is consistently used as the
  default throughout the codebase

### 5. Backport Criteria

This commit meets the stable kernel backport criteria:
- **It fixes a bug**: Incorrect validation logic that doesn't match the
  intended behavior
- **Simple and contained**: One-line change with minimal risk
- **Clear fix**: The correct value is obvious from the surrounding code
  and comment
- **User-visible impact**: Affects configuration validation for dm-raid
  users

### 6. Similar Historical Commits

Looking at the similar commits provided:
- Commit #1 (backported): Added validation to prevent setting
  max_write_behind without write-mostly devices
- Commit #4 (backported): Fixed missing bitmap updates with write-mostly
  devices

Both of these were backported and dealt with correctness issues in the
write-behind functionality, establishing a pattern that such fixes are
considered stable-worthy.

### 7. Risk Assessment

- **Low risk**: Single character change ('/' to '/ 2')
- **Well-understood**: The correct limit is documented in the comment
- **No ABI changes**: Just tightens an existing validation check
- **Fail-safe**: Makes the validation more restrictive, not less

## Conclusion

This is a clear bug fix that corrects an incorrect validation check to
match the documented and intended behavior. The fix is trivial, safe,
and addresses a real issue that affects dm-raid users. It should be
backported to ensure consistent behavior across stable kernel versions.

 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 37b08f26c62f5..45dd3d9f01a8e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -789,7 +789,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
 	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
 	 */
 	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
-	if (write_behind > COUNTER_MAX)
+	if (write_behind > COUNTER_MAX / 2)
 		write_behind = COUNTER_MAX / 2;
 	sb->write_behind = cpu_to_le32(write_behind);
 	bitmap->mddev->bitmap_info.max_write_behind = write_behind;
-- 
2.39.5

