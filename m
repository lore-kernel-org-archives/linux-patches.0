Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A48A34F278;
	Tue,  6 Jan 2026 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720480; cv=none; b=mZNa6+HuRlJqj6x5nZIfoGSri/Uz6dUuWkOJT44Jx5Fhq5ceFr3Wfm4P0a0KlSPorNpP6XtLwMT79bIbB12fTwUpgnsiRLviTmT5Xkz0DUijcLTxx+WEOs3TpVetAgD3DpJuIR+J/zF322ZLNHXAQXqnlo0ZcxVB9sFO3JLkiwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720480; c=relaxed/simple;
	bh=FEVUhAy4PiGlHwX1GFU1SMzUYZzx3WIkNJNL4izjqRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8n1Nh9kAkc3gMuyqbNpK2OwNO7TGRCtlVo6PzqUa2p269GUdZlFOu9NqFxt9CnAvpUvWL7D3JLCffM+99nhnShpc8lR87DnwWuPcAO2T3R9kSNbPqy+qbFMn4E1gqW37b1Z7YBdlrGpnple8/ePhEZ1TgsOpRXl11urf65TI8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnYjeRKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnYjeRKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B4EC19423;
	Tue,  6 Jan 2026 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720480;
	bh=FEVUhAy4PiGlHwX1GFU1SMzUYZzx3WIkNJNL4izjqRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnYjeRKoFlmwHmiQC0ULmhR5lWeW6Nezwd7gYt73zaPJo2zIuqrssE0AHHYrqxXSn
	 PmALRtlJp7e3FWAqdr15xQnpGofNGDfZb3bkVJ6HWxvHptNhBQTkAO4U2yQi++ZMok
	 o9JSSGouSATHs2P7Q5WgBtzgrBhX5+L9yJhNiYgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xiaole He <hexiaole1994@126.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 207/567] f2fs: fix age extent cache insertion skip on counter overflow
Date: Tue,  6 Jan 2026 17:59:49 +0100
Message-ID: <20260106170458.981682967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaole He <hexiaole1994@126.com>

commit 27bf6a637b7613fc85fa6af468b7d612d78cd5c0 upstream.

The age extent cache uses last_blocks (derived from
allocated_data_blocks) to determine data age. However, there's a
conflict between the deletion
marker (last_blocks=0) and legitimate last_blocks=0 cases when
allocated_data_blocks overflows to 0 after reaching ULLONG_MAX.

In this case, valid extents are incorrectly skipped due to the
"if (!tei->last_blocks)" check in __update_extent_tree_range().

This patch fixes the issue by:
1. Reserving ULLONG_MAX as an invalid/deletion marker
2. Limiting allocated_data_blocks to range [0, ULLONG_MAX-1]
3. Using F2FS_EXTENT_AGE_INVALID for deletion scenarios
4. Adjusting overflow age calculation from ULLONG_MAX to (ULLONG_MAX-1)

Reproducer (using a patched kernel with allocated_data_blocks
initialized to ULLONG_MAX - 3 for quick testing):

Step 1: Mount and check initial state
  # dd if=/dev/zero of=/tmp/test.img bs=1M count=100
  # mkfs.f2fs -f /tmp/test.img
  # mkdir -p /mnt/f2fs_test
  # mount -t f2fs -o loop,age_extent_cache /tmp/test.img /mnt/f2fs_test
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 18446744073709551612 # ULLONG_MAX - 3
  Inner Struct Count: tree: 1(0), node: 0

Step 2: Create files and write data to trigger overflow
  # touch /mnt/f2fs_test/{1,2,3,4}.txt; sync
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 18446744073709551613 # ULLONG_MAX - 2
  Inner Struct Count: tree: 5(0), node: 1

  # dd if=/dev/urandom of=/mnt/f2fs_test/1.txt bs=4K count=1; sync
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 18446744073709551614 # ULLONG_MAX - 1
  Inner Struct Count: tree: 5(0), node: 2

  # dd if=/dev/urandom of=/mnt/f2fs_test/2.txt bs=4K count=1; sync
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 18446744073709551615 # ULLONG_MAX
  Inner Struct Count: tree: 5(0), node: 3

  # dd if=/dev/urandom of=/mnt/f2fs_test/3.txt bs=4K count=1; sync
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 0 # Counter overflowed!
  Inner Struct Count: tree: 5(0), node: 4

Step 3: Trigger the bug - next write should create node but gets skipped
  # dd if=/dev/urandom of=/mnt/f2fs_test/4.txt bs=4K count=1; sync
  # cat /sys/kernel/debug/f2fs/status | grep -A 4 "Block Age"
  Allocated Data Blocks: 1
  Inner Struct Count: tree: 5(0), node: 4

  Expected: node: 5 (new extent node for 4.txt)
  Actual: node: 4 (extent insertion was incorrectly skipped due to
  last_blocks = allocated_data_blocks = 0 in __get_new_block_age)

After this fix, the extent node is correctly inserted and node count
becomes 5 as expected.

Fixes: 71644dff4811 ("f2fs: add block_age-based extent cache")
Cc: stable@kernel.org
Signed-off-by: Xiaole He <hexiaole1994@126.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/extent_cache.c |    5 +++--
 fs/f2fs/f2fs.h         |    6 ++++++
 fs/f2fs/segment.c      |    9 +++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -756,7 +756,7 @@ static void __update_extent_tree_range(s
 	}
 	goto out_read_extent_cache;
 update_age_extent_cache:
-	if (!tei->last_blocks)
+	if (tei->last_blocks == F2FS_EXTENT_AGE_INVALID)
 		goto out_read_extent_cache;
 
 	__set_extent_info(&ei, fofs, len, 0, false,
@@ -860,7 +860,7 @@ static int __get_new_block_age(struct in
 			cur_age = cur_blocks - tei.last_blocks;
 		else
 			/* allocated_data_blocks overflow */
-			cur_age = ULLONG_MAX - tei.last_blocks + cur_blocks;
+			cur_age = (ULLONG_MAX - 1) - tei.last_blocks + cur_blocks;
 
 		if (tei.age)
 			ei->age = __calculate_block_age(sbi, cur_age, tei.age);
@@ -1062,6 +1062,7 @@ void f2fs_update_age_extent_cache_range(
 	struct extent_info ei = {
 		.fofs = fofs,
 		.len = len,
+		.last_blocks = F2FS_EXTENT_AGE_INVALID,
 	};
 
 	if (!__may_extent_tree(dn->inode, EX_BLOCK_AGE))
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -644,6 +644,12 @@ enum extent_type {
 	NR_EXTENT_CACHES,
 };
 
+/*
+ * Reserved value to mark invalid age extents, hence valid block range
+ * from 0 to ULLONG_MAX-1
+ */
+#define F2FS_EXTENT_AGE_INVALID	ULLONG_MAX
+
 struct extent_info {
 	unsigned int fofs;		/* start offset in a file */
 	unsigned int len;		/* length of the extent */
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3746,8 +3746,13 @@ skip_new_segment:
 	locate_dirty_segment(sbi, GET_SEGNO(sbi, old_blkaddr));
 	locate_dirty_segment(sbi, GET_SEGNO(sbi, *new_blkaddr));
 
-	if (IS_DATASEG(curseg->seg_type))
-		atomic64_inc(&sbi->allocated_data_blocks);
+	if (IS_DATASEG(curseg->seg_type)) {
+		unsigned long long new_val;
+
+		new_val = atomic64_inc_return(&sbi->allocated_data_blocks);
+		if (unlikely(new_val == ULLONG_MAX))
+			atomic64_set(&sbi->allocated_data_blocks, 0);
+	}
 
 	up_write(&sit_i->sentry_lock);
 


