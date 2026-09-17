Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF514DA9A9;
	Thu, 17 Sep 2026 15:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660244; cv=none; b=FmQae5EfWsAlizD2hjARciY8d/p8JJcADNnGFOBYOyviaE4Y4tDiwjvibPcB6Klr1VTjeHnKQhh9J9l1tk+bjM0KdnVu2kLUU3JFf/JIv1vIpDgUZn17IpRsERn3rh92sEX5cloJCKeGb1hxR+e3baj3EQdznn0YUZoZn+31fTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660244; c=relaxed/simple;
	bh=YukoIh3H93hzzFJtyz7HvyoEeRTcVpu/zAcuxk28+dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT38r+7JEXjyuCfV489stBEFjEQbjTVfEO5KJo6uBMVHAIkgTVShGE2gTb6WxxW/Ca0E//XVY6RQLlF6uTVHtdiTip36PhW5l8JjUOgerJuZOmsTZQszVdf+qK1xjPkLkI4mrJIwEMBlkPpmui2tMt7L7S7Jh9BOI3mzPshDLlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTgAnmhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTgAnmhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394001F000FF;
	Thu, 17 Sep 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660235;
	bh=K0R2O8u6dEx7RdMZFX5XaCs4N8ABsRoVq24yRhHaU48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTgAnmhmEBtvQRaKkpnDk/4bmn5VK54HkBjKReYOAAEYogc6k0YEAbkEyDBCS7LRs
	 1qQy+29J733LH4r0TDf2Kuhnf5Fj1+C/LLtfsjUKcBG/+h+Xalw4jQu2q4xT0ypVLX
	 T/KBiiO9rdfcgTx7mqdWTmTc1gX0r81psbVhbVAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moritz Tanner <moritz.tanner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 523/733] fs: dont return -EINVAL for successful nested thaw
Date: Thu, 17 Sep 2026 16:13:51 +0100
Message-ID: <20260917151405.202069445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2122,11 +2122,14 @@ static int thaw_super_locked(struct supe
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


