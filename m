Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FF8330B34;
	Mon, 29 Dec 2025 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025735; cv=none; b=gcs7ZyFl38QvPw0CI4Ny7dbVSlYHFrvkk0F60G25wV+GL1OMsExyqKb8/LS5DMa+C7dfFeX/0BHBK+2XW9LhToKVQakoZ2FOJ6UL0ltqAXc/fs365zEapmGNlSXU5p9U9gatfLOEFFz9gjVgC2NOEiAkjW6m2MpBZ3+U82+051s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025735; c=relaxed/simple;
	bh=HWQYqU87XP5y2iS0Ch+6Jn+WFhCuSXyCJg7hlqJOjJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/KtSeaDhr2PU1RmHoEq/B8y2OiP7lrvP/yVUdP3pIhWLiHSuaTZr1VTJOZqaCZdIqS91y/L7EASRa17zAcJvewxJi3Ekp90NnOXDgrII7HseEfxq1ikSBHLaSf695DbNffyzTeNavoy4Pb/y/6b7h66gMiorR4FIjh4xHCf9Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYzcI4p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYzcI4p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC66BC4CEF7;
	Mon, 29 Dec 2025 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025735;
	bh=HWQYqU87XP5y2iS0Ch+6Jn+WFhCuSXyCJg7hlqJOjJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYzcI4p4JuiOx2kARkyrwZ7q0n6yQCkP4zGShqcZauUHqL4QS1MgWsusPV4nxLj78
	 IgD2MiStu3mqu1Wd6ywC4XhIVAQm6ZICoHZo2y9SwRFUAN4meJmStHxatHJaxQQnQL
	 UZEgGmbkLUszFuseWZaK0D9ByNsSlOTGLIzy/LrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Xiaole He <hexiaole1994@126.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 319/430] f2fs: fix age extent cache insertion skip on counter overflow
Date: Mon, 29 Dec 2025 17:12:01 +0100
Message-ID: <20251229160736.069460777@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -808,7 +808,7 @@ static void __update_extent_tree_range(s
 	}
 	goto out_read_extent_cache;
 update_age_extent_cache:
-	if (!tei->last_blocks)
+	if (tei->last_blocks == F2FS_EXTENT_AGE_INVALID)
 		goto out_read_extent_cache;
 
 	__set_extent_info(&ei, fofs, len, 0, false,
@@ -912,7 +912,7 @@ static int __get_new_block_age(struct in
 			cur_age = cur_blocks - tei.last_blocks;
 		else
 			/* allocated_data_blocks overflow */
-			cur_age = ULLONG_MAX - tei.last_blocks + cur_blocks;
+			cur_age = (ULLONG_MAX - 1) - tei.last_blocks + cur_blocks;
 
 		if (tei.age)
 			ei->age = __calculate_block_age(sbi, cur_age, tei.age);
@@ -1114,6 +1114,7 @@ void f2fs_update_age_extent_cache_range(
 	struct extent_info ei = {
 		.fofs = fofs,
 		.len = len,
+		.last_blocks = F2FS_EXTENT_AGE_INVALID,
 	};
 
 	if (!__may_extent_tree(dn->inode, EX_BLOCK_AGE))
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -708,6 +708,12 @@ enum extent_type {
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
@@ -3881,8 +3881,13 @@ skip_new_segment:
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
 


