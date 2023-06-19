Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A14E3C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3952C433C0;
	Mon, 19 Jun 2023 10:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170922;
	bh=YLWbKgyNNfIgGGfOOpQ0SQCUR20WpkQTguoroVdx8xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKp2OTWQGt0dG9OBqqyLrvuya4b8fLLjyPWP3o3wiUVAFS3PQe9tguwKqiU3F5k01
	 3lsYoJCl5qBagCN2pA/c+/f3c2N9H9kuIMzcziXjwZ/LCD2vjNwrrqr1WzTMsQHzH1
	 mr2i6bYOyS6p12TQjphJOD+dJP4AT3gk218zrypQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 066/187] btrfs: properly enable async discard when switching from RO->RW
Date: Mon, 19 Jun 2023 12:28:04 +0200
Message-ID: <20230619102200.867602446@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mason <clm@fb.com>

commit 981a37bab5e5f16137266d3f00cf2bd018af36ef upstream.

The async discard uses the BTRFS_FS_DISCARD_RUNNING bit in the fs_info
to force discards off when the filesystem has aborted or we're generally
not able to run discards.  This gets flipped on when we're mounted rw,
and also when we go from ro->rw.

Commit 63a7cb13071842 ("btrfs: auto enable discard=async when possible")
enabled async discard by default, and this meant
"mount -o ro /dev/xxx /yyy" had async discards turned on.

Unfortunately, this meant our check in btrfs_remount_cleanup() would see
that discards are already on:

    /* If we toggled discard async */
    if (!btrfs_raw_test_opt(old_opts, DISCARD_ASYNC) &&
	btrfs_test_opt(fs_info, DISCARD_ASYNC))
	    btrfs_discard_resume(fs_info);

So, we'd never call btrfs_discard_resume() when remounting the root
filesystem from ro->rw.

drgn shows this really nicely:

import os
import sys

from drgn.helpers.linux.fs import path_lookup
from drgn import NULL, Object, Type, cast

def btrfs_sb(sb):
    return cast("struct btrfs_fs_info *", sb.s_fs_info)

if len(sys.argv) == 1:
    path = "/"
else:
    path = sys.argv[1]

fs_info = cast("struct btrfs_fs_info *", path_lookup(prog, path).mnt.mnt_sb.s_fs_info)

BTRFS_FS_DISCARD_RUNNING = 1 << prog['BTRFS_FS_DISCARD_RUNNING']
if fs_info.flags & BTRFS_FS_DISCARD_RUNNING:
    print("discard running flag is on")
else:
    print("discard running flag is off")

[root]# mount | grep nvme
/dev/nvme0n1p3 on / type btrfs
(rw,relatime,compress-force=zstd:3,ssd,discard=async,space_cache=v2,subvolid=5,subvol=/)

[root]# ./discard_running.drgn
discard running flag is off

[root]# mount -o remount,discard=sync /
[root]# mount -o remount,discard=async /
[root]# ./discard_running.drgn
discard running flag is on

The fix is to call btrfs_discard_resume() when we're going from ro->rw.
It already checks to make sure the async discard flag is on, so it'll do
the right thing.

Fixes: 63a7cb13071842 ("btrfs: auto enable discard=async when possible")
CC: stable@vger.kernel.org # 6.3+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Chris Mason <clm@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1840,6 +1840,12 @@ static int btrfs_remount(struct super_bl
 		btrfs_clear_sb_rdonly(sb);
 
 		set_bit(BTRFS_FS_OPEN, &fs_info->flags);
+
+		/*
+		 * If we've gone from readonly -> read/write, we need to get
+		 * our sync/async discard lists in the right state.
+		 */
+		btrfs_discard_resume(fs_info);
 	}
 out:
 	/*


