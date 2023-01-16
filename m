Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A916FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74265C433EF;
	Mon, 16 Jan 2023 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888152;
	bh=mushRrHwKvH8DJJVvJ14e1foLV58aaATPvYifLMZ6jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYwM9IstCHlR/+lH5Tb1e3byR1qwC7sH3SIkYQ32d/7i4CzQx4BDhvArz+5n9mHmE
	 AfiGpmkwVJCcX8/k40Vb9muc4MEeIpfX7WQOnpabUHzRsM/Uu1TCgpj4Mdb6RHtw4S
	 OL1gz0+rftjN+39j0FuNW003ZNBljHu3MUQJ0dHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 419/521] btrfs: send: avoid unnecessary backref lookups when finding clone source
Date: Mon, 16 Jan 2023 16:51:21 +0100
Message-Id: <20230116154905.869390084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 22a3c0ac8ed0043af209a15928ae4c4855b0a4c4 ]

At find_extent_clone(), unless we are given an inline extent, a file
extent item that represents hole or an extent that starts beyond the
i_size, we always do backref walking to look for clone sources, unless
if we have more than SEND_MAX_EXTENT_REFS (64) known references on the
extent.

However if we know we only have one reference in the extent item and only
one clone source (the send root), then it's pointless to do the backref
walking to search for clone sources, as we can't clone from any other
root. So skip the backref walking in that case.

The following test was run on a non-debug kernel (Debian's default kernel
config):

   $ cat test.sh
   #!/bin/bash

   DEV=/dev/sdi
   MNT=/mnt/sdi

   mkfs.btrfs -f $DEV
   mount $DEV $MNT

   # Create an extent tree that's not too small and none of the
   # extents is shared.
   for ((i = 1; i <= 50000; i++)); do
      xfs_io -f -c "pwrite 0 4K" $MNT/file_$i > /dev/null
      echo -ne "\r$i files created..."
   done
   echo

   btrfs subvolume snapshot -r $MNT $MNT/snap

   start=$(date +%s%N)
   btrfs send $MNT/snap > /dev/null
   end=$(date +%s%N)

   dur=$(( (end - start) / 1000000 ))
   echo -e "\nsend took $dur milliseconds"

   umount $MNT

Before this change:

   send took 5389 milliseconds

After this change:

   send took 4519 milliseconds  (-16.1%)

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 63d5429f68a3 ("btrfs: replace strncpy() with strscpy()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index eb2f8e84ffc9..80d248e88761 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1306,6 +1306,7 @@ static int find_extent_clone(struct send_ctx *sctx,
 	u64 disk_byte;
 	u64 num_bytes;
 	u64 extent_item_pos;
+	u64 extent_refs;
 	u64 flags = 0;
 	struct btrfs_file_extent_item *fi;
 	struct extent_buffer *eb = path->nodes[0];
@@ -1373,14 +1374,22 @@ static int find_extent_clone(struct send_ctx *sctx,
 
 	ei = btrfs_item_ptr(tmp_path->nodes[0], tmp_path->slots[0],
 			    struct btrfs_extent_item);
+	extent_refs = btrfs_extent_refs(tmp_path->nodes[0], ei);
 	/*
 	 * Backreference walking (iterate_extent_inodes() below) is currently
 	 * too expensive when an extent has a large number of references, both
 	 * in time spent and used memory. So for now just fallback to write
 	 * operations instead of clone operations when an extent has more than
 	 * a certain amount of references.
+	 *
+	 * Also, if we have only one reference and only the send root as a clone
+	 * source - meaning no clone roots were given in the struct
+	 * btrfs_ioctl_send_args passed to the send ioctl - then it's our
+	 * reference and there's no point in doing backref walking which is
+	 * expensive, so exit early.
 	 */
-	if (btrfs_extent_refs(tmp_path->nodes[0], ei) > SEND_MAX_EXTENT_REFS) {
+	if ((extent_refs == 1 && sctx->clone_roots_cnt == 1) ||
+	    extent_refs > SEND_MAX_EXTENT_REFS) {
 		ret = -ENOENT;
 		goto out;
 	}
-- 
2.35.1



