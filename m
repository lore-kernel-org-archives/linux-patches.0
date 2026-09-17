Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8775038E4;
	Thu, 17 Sep 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666337; cv=none; b=PZNJaOqQlx3uzIxz1xXfbIuaSHlF7yGqE4uPD2uOg5b2Nxc+uKwgPDrFexHp2RgmkWYsC9N4bYLyUT8HZR75+/BX3RaS/JOcOTTeI92Uve2POdOjHHziVF/BXpwWpdE40PWe9uyfImHzHnslqRNg+2PVkmQcQ9SfJtwvMfw258o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666337; c=relaxed/simple;
	bh=8d2DQOHS+QaqN+gvRnLKcmq5V9fTtl6ceHeBvAPo+/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDtEg438t1azY2a14OdGoX8Uk2ABFQeNYl962BROldR4D7g2GYb97GUiWSr3caELm7ueQQa9sp8+6mX9nv7WpNB1JXilYkbsjOO8tY3pUf0jljF9mJKDTMw8GnppLidl1WoyTrmb9Go4hr41+YCvEStHFP7rO5EkBrP2GEMpTjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrbDtKSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrbDtKSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4E51F000FF;
	Thu, 17 Sep 2026 17:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666336;
	bh=7opT5lxseD8PjqZCb1y56XID8s7ePa+mPonGoAvSO+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrbDtKSs62UuMhCSxmtPwfVfA/RonrRjvZR+s+duZcxFp41hpalY5ngYarIOnfIpG
	 QOT/VQLrmktAjMTMXWYHYuoIKEahzQQUa2gIzOzKM3qlZjqGj6fyz7nRUgKQkqmIwR
	 DJHJdlfaJQXdU/xcFNBg8K5Bk8Mj65sfwbKg5G78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moritz Tanner <moritz.tanner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 1003/1250] fs: dont return -EINVAL for successful nested thaw
Date: Thu, 17 Sep 2026 16:13:18 +0100
Message-ID: <20260917151619.226910219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Moritz Tanner <moritz.tanner@linbit.com>

commit fe967191e5851ea79818c5fe4e781c3882139218 upstream.

Commit 7366f8b6fc6a ("fs: handle freezing from multiple devices")
replaced the freeze_holders bitmask with per-holder counters to allow
nested freezes. In the bitmask version, a thaw that released a shared
hold while another holder remained returned 0. Since the rework,
thaw_super_locked() drops the freeze reference via freeze_dec() but
then returns -EINVAL when other freezers remain, misinforming the
caller: the thaw did succeed, the superblock just stays frozen for the
remaining holders.

This breaks bdev-initiated freezing. When a filesystem is frozen with
FIFREEZE and additionally frozen via bdev_freeze() -- which nests by
design, see fs_bdev_freeze() -- the subsequent bdev_thaw() receives
-EINVAL from the holder op although its freeze reference was dropped,
and therefore keeps bd_fsfreeze_count elevated. Then device-mapper's
unlock_fs() ignores bdev_thaw()'s return value, so nothing rebalances
the count. After the user's FITHAW and umount, the block device can
never be mounted again:

    dm-1: Can't mount, blockdev is frozen

There is no way for userspace to drop the leaked count; only
destroying the block device (or a reboot) recovers the device.

Reproducer (any kernel since v6.8):

    dmsetup create dut --table "0 $(blockdev --getsz "$DEV") linear $DEV 0"
    mkfs.ext4 /dev/mapper/dut
    mount /dev/mapper/dut /mnt
    fsfreeze --freeze /mnt      # freeze_ucount == 1
    dmsetup suspend dut         # bd_fsfreeze_count == 1, ucount == 2
    dmsetup resume dut          # ucount 2 -> 1, but thaw_super()
                                # returns -EINVAL, so bdev_thaw()
                                # keeps bd_fsfreeze_count at 1
    fsfreeze --unfreeze /mnt    # filesystem thaws fine
    umount /mnt
    mount /dev/mapper/dut /mnt  # EBUSY, forever

The same happens with fsfreeze held across an LVM snapshot of the
origin volume.

fs_bdev_thaw()'s documentation already describes the intended
semantics: "If this function returns zero it doesn't mean that the
filesystem is unfrozen as it may have been frozen multiple times".
Restore them by returning 0 when a nested thaw drops its hold while
other freezers remain. Thawing without holding a freeze still fails
with -EINVAL as may_unfreeze() rejects that case before the reference
count is touched.

Fixes: 7366f8b6fc6a ("fs: handle freezing from multiple devices")
Cc: stable@vger.kernel.org # needs adjustments for < 6.17 (no may_unfreeze())
Signed-off-by: Moritz Tanner <moritz.tanner@linbit.com>
Link: https://patch.msgid.link/20260821085451.65206-1-moritz.tanner@linbit.com
Tested-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Reviewed-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -2187,11 +2187,14 @@ static int thaw_super_locked(struct supe
 		goto out_unlock;
 
 	/*
-	 * All freezers share a single active reference.
-	 * So just unlock in case there are any left.
+	 * All freezers share a single active reference. If other freezers
+	 * remain, drop our hold and report success; the superblock stays
+	 * frozen until the last holder thaws it.
 	 */
-	if (freeze_dec(sb, who))
+	if (freeze_dec(sb, who)) {
+		error = 0;
 		goto out_unlock;
+	}
 
 	if (sb_rdonly(sb)) {
 		sb->s_writers.frozen = SB_UNFROZEN;


