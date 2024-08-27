Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DA1C6F64;
	Tue, 27 Aug 2024 14:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770449; cv=none; b=LgSUe8VtTB2WrSuCcvIj2DebLf5B6mI39dIAul1+kGz0lhxRCfnLHDjb2Jz4xcEB0COtUGESDS/c2yzdcPjPPY4ojWL2z9aWEqYGBsduu/xxQp064ZD7AfvYhFu4xrFZo41y+k/PC8NPhPL4FKj4dBwrODwBF2oY4Md8JIDqF1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770449; c=relaxed/simple;
	bh=1nKCylYUdBA3Pj1HIb/ZaotxzOKrwZIwkz04LHzyq1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shJkLZo7WA6xpabL92vz4N9f8TcTkhciqaArz+b6wBLhF2nbXqiZBkW6mn94sl3ocp4q4INthaygg82Lb8Y94FjRbvjG6cpHyvC3olnlt9kLgIDLhoMn+c/KUgStH16qp+YJNdh+5Yz9VfcalT/bVIl88oNN7MjzTQqRvYt896Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkMyw5qB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkMyw5qB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD3EC4E66E;
	Tue, 27 Aug 2024 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770449;
	bh=1nKCylYUdBA3Pj1HIb/ZaotxzOKrwZIwkz04LHzyq1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkMyw5qBIBezdV8Kqj/sUVOR373uSSD7ZuKdL9SnEXnHkUzYqDYKbzUNZSEZ/bm/E
	 BAw7AM1zEsJ7d6BvbIUjvAVbQSrx7F4rPEeZEi9t5/tCsika2oEt+FGvSzCUrwiPcg
	 J9nJQZtjMAnJTSRF4keS5xEmJM95d2cBOFP90n0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/341] btrfs: send: allow cloning non-aligned extent if it ends at i_size
Date: Tue, 27 Aug 2024 16:37:44 +0200
Message-ID: <20240827143852.275617663@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 46a6e10a1ab16cc71d4a3cab73e79aabadd6b8ea ]

If we a find that an extent is shared but its end offset is not sector
size aligned, then we don't clone it and issue write operations instead.
This is because the reflink (remap_file_range) operation does not allow
to clone unaligned ranges, except if the end offset of the range matches
the i_size of the source and destination files (and the start offset is
sector size aligned).

While this is not incorrect because send can only guarantee that a file
has the same data in the source and destination snapshots, it's not
optimal and generates confusion and surprising behaviour for users.

For example, running this test:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  # Use a file size not aligned to any possible sector size.
  file_size=$((1 * 1024 * 1024 + 5)) # 1MB + 5 bytes
  dd if=/dev/random of=$MNT/foo bs=$file_size count=1
  cp --reflink=always $MNT/foo $MNT/bar

  btrfs subvolume snapshot -r $MNT/ $MNT/snap
  rm -f /tmp/send-test
  btrfs send -f /tmp/send-test $MNT/snap

  umount $MNT
  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  btrfs receive -vv -f /tmp/send-test $MNT

  xfs_io -r -c "fiemap -v" $MNT/snap/bar

  umount $MNT

Gives the following result:

  (...)
  mkfile o258-7-0
  rename o258-7-0 -> bar
  write bar - offset=0 length=49152
  write bar - offset=49152 length=49152
  write bar - offset=98304 length=49152
  write bar - offset=147456 length=49152
  write bar - offset=196608 length=49152
  write bar - offset=245760 length=49152
  write bar - offset=294912 length=49152
  write bar - offset=344064 length=49152
  write bar - offset=393216 length=49152
  write bar - offset=442368 length=49152
  write bar - offset=491520 length=49152
  write bar - offset=540672 length=49152
  write bar - offset=589824 length=49152
  write bar - offset=638976 length=49152
  write bar - offset=688128 length=49152
  write bar - offset=737280 length=49152
  write bar - offset=786432 length=49152
  write bar - offset=835584 length=49152
  write bar - offset=884736 length=49152
  write bar - offset=933888 length=49152
  write bar - offset=983040 length=49152
  write bar - offset=1032192 length=16389
  chown bar - uid=0, gid=0
  chmod bar - mode=0644
  utimes bar
  utimes
  BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=06d640da-9ca1-604c-b87c-3375175a8eb3, stransid=7
  /mnt/sdi/snap/bar:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..2055]:       26624..28679      2056   0x1

There's no clone operation to clone extents from the file foo into file
bar and fiemap confirms there's no shared flag (0x2000).

So update send_write_or_clone() so that it proceeds with cloning if the
source and destination ranges end at the i_size of the respective files.

After this changes the result of the test is:

  (...)
  mkfile o258-7-0
  rename o258-7-0 -> bar
  clone bar - source=foo source offset=0 offset=0 length=1048581
  chown bar - uid=0, gid=0
  chmod bar - mode=0644
  utimes bar
  utimes
  BTRFS_IOC_SET_RECEIVED_SUBVOL uuid=582420f3-ea7d-564e-bbe5-ce440d622190, stransid=7
  /mnt/sdi/snap/bar:
   EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
     0: [0..2055]:       26624..28679      2056 0x2001

A test case for fstests will also follow up soon.

Link: https://github.com/kdave/btrfs-progs/issues/572#issuecomment-2282841416
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 52 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 633d306933f3f..e912d8e411cc4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6160,25 +6160,51 @@ static int send_write_or_clone(struct send_ctx *sctx,
 	u64 offset = key->offset;
 	u64 end;
 	u64 bs = sctx->send_root->fs_info->sectorsize;
+	struct btrfs_file_extent_item *ei;
+	u64 disk_byte;
+	u64 data_offset;
+	u64 num_bytes;
+	struct btrfs_inode_info info = { 0 };
 
 	end = min_t(u64, btrfs_file_extent_end(path), sctx->cur_inode_size);
 	if (offset >= end)
 		return 0;
 
-	if (clone_root && IS_ALIGNED(end, bs)) {
-		struct btrfs_file_extent_item *ei;
-		u64 disk_byte;
-		u64 data_offset;
+	num_bytes = end - offset;
 
-		ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				    struct btrfs_file_extent_item);
-		disk_byte = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
-		data_offset = btrfs_file_extent_offset(path->nodes[0], ei);
-		ret = clone_range(sctx, path, clone_root, disk_byte,
-				  data_offset, offset, end - offset);
-	} else {
-		ret = send_extent_data(sctx, path, offset, end - offset);
-	}
+	if (!clone_root)
+		goto write_data;
+
+	if (IS_ALIGNED(end, bs))
+		goto clone_data;
+
+	/*
+	 * If the extent end is not aligned, we can clone if the extent ends at
+	 * the i_size of the inode and the clone range ends at the i_size of the
+	 * source inode, otherwise the clone operation fails with -EINVAL.
+	 */
+	if (end != sctx->cur_inode_size)
+		goto write_data;
+
+	ret = get_inode_info(clone_root->root, clone_root->ino, &info);
+	if (ret < 0)
+		return ret;
+
+	if (clone_root->offset + num_bytes == info.size)
+		goto clone_data;
+
+write_data:
+	ret = send_extent_data(sctx, path, offset, num_bytes);
+	sctx->cur_inode_next_write_offset = end;
+	return ret;
+
+clone_data:
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	disk_byte = btrfs_file_extent_disk_bytenr(path->nodes[0], ei);
+	data_offset = btrfs_file_extent_offset(path->nodes[0], ei);
+	ret = clone_range(sctx, path, clone_root, disk_byte, data_offset, offset,
+			  num_bytes);
 	sctx->cur_inode_next_write_offset = end;
 	return ret;
 }
-- 
2.43.0



