Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5418121B42A;
	Tue, 12 Nov 2024 10:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408458; cv=none; b=uNGUtXKZ0ay5Bh1VSbIqFI2nRayww7XsYjdnhi32HLjSvmuKvdlmWUxrmdIxi1XUG/GbseEjdmMxA4/1JsJlE+5vCbRBzf3LCnfw1GxUzOS5Oe0Ow0UEnIlZiApRp4I2/ldY5Qhu0Pk7ZFeA2C4WTSxj6twYy2L2QKUwv/Me/GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408458; c=relaxed/simple;
	bh=KyWRJ+xoBBxjoS0iJpVpF4KF/o2a1C8Pz8PFItadu1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eajpxtSZu2wcxFdFI/4NBj1yPgdmAR9OTVc/Fc99q+5rUdyFnc0kMPT+pWj0cP/SVggVgIl2Jk0hFNOvfKN1P9ygvzF6BOY7G2qMfnJKQZy5PxRcAovDCdxSCWY9X+3eAIGet2IWbUbOhHbcAAJvpbE7kgzwhCoX4phf9WqYVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=we2N/nlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="we2N/nlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9ABC4CECD;
	Tue, 12 Nov 2024 10:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408457;
	bh=KyWRJ+xoBBxjoS0iJpVpF4KF/o2a1C8Pz8PFItadu1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=we2N/nlB++FxhlPnaSdmxb+4cy6PxRar+FheVpY0DjiLPwpm+CIHXzSCGBS04Lbvv
	 MMUEqui6VtI8sBq98dj3ykmbpIeCYN6dL6ZY3RzFJnQ3qlEMGJByXxXahXqTadxl4+
	 /vdnV8Xo3FQAQWwHCYBIDxnPDwMkxjbPdhudcTYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 137/184] btrfs: fix per-subvolume RO/RW flags with new mount API
Date: Tue, 12 Nov 2024 11:21:35 +0100
Message-ID: <20241112101906.129488553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit cda7163d4e3d99db93aa38f0e825b8433c7a8452 upstream.

[BUG]
With util-linux 2.40.2, the 'mount' utility is already utilizing the new
mount API. e.g:

  # strace  mount -o subvol=subv1,ro /dev/test/scratch1 /mnt/test/
  ...
  fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/mapper/test-scratch1", 0) = 0
  fsconfig(3, FSCONFIG_SET_STRING, "subvol", "subv1", 0) = 0
  fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
  fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = 0
  fsmount(3, FSMOUNT_CLOEXEC, 0)          = 4
  mount_setattr(4, "", AT_EMPTY_PATH, {attr_set=MOUNT_ATTR_RDONLY, attr_clr=0, propagation=0 /* MS_??? */, userns_fd=0}, 32) = 0
  move_mount(4, "", AT_FDCWD, "/mnt/test", MOVE_MOUNT_F_EMPTY_PATH) = 0

But this leads to a new problem, that per-subvolume RO/RW mount no
longer works, if the initial mount is RO:

  # mount -o subvol=subv1,ro /dev/test/scratch1 /mnt/test
  # mount -o rw,subvol=subv2 /dev/test/scratch1  /mnt/scratch
  # mount | grep mnt
  /dev/mapper/test-scratch1 on /mnt/test type btrfs (ro,relatime,discard=async,space_cache=v2,subvolid=256,subvol=/subv1)
  /dev/mapper/test-scratch1 on /mnt/scratch type btrfs (ro,relatime,discard=async,space_cache=v2,subvolid=257,subvol=/subv2)
  # touch /mnt/scratch/foobar
  touch: cannot touch '/mnt/scratch/foobar': Read-only file system

This is a common use cases on distros.

[CAUSE]
We have a workaround for remount to handle the RO->RW change, but if the
mount is using the new mount API, we do not do that, and rely on the
mount tool NOT to set the ro flag.

But that's not how the mount tool is doing for the new API:

  fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/mapper/test-scratch1", 0) = 0
  fsconfig(3, FSCONFIG_SET_STRING, "subvol", "subv1", 0) = 0
  fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0       <<<< Setting RO flag for super block
  fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = 0
  fsmount(3, FSMOUNT_CLOEXEC, 0)          = 4
  mount_setattr(4, "", AT_EMPTY_PATH, {attr_set=MOUNT_ATTR_RDONLY, attr_clr=0, propagation=0 /* MS_??? */, userns_fd=0}, 32) = 0
  move_mount(4, "", AT_FDCWD, "/mnt/test", MOVE_MOUNT_F_EMPTY_PATH) = 0

This means we will set the super block RO at the first mount.

Later RW mount will not try to reconfigure the fs to RW because the
mount tool is already using the new API.

This totally breaks the per-subvolume RO/RW mount behavior.

[FIX]
Do not skip the reconfiguration even if using the new API.  The old
comments are just expecting any mount tool to properly skip the RO flag
set even if we specify "ro", which is not the reality.

Update the comments regarding the backward compatibility on the kernel
level so it works with old and new mount utilities.

CC: stable@vger.kernel.org # 6.8+
Fixes: f044b318675f ("btrfs: handle the ro->rw transition for mounting different subvolumes")
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/super.c |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1979,25 +1979,10 @@ error:
  *     fsconfig(FSCONFIG_SET_FLAG, "ro"). This option is seen by the filesystem
  *     in fc->sb_flags.
  *
- * This disambiguation has rather positive consequences.  Mounting a subvolume
- * ro will not also turn the superblock ro. Only the mount for the subvolume
- * will become ro.
- *
- * So, if the superblock creation request comes from the new mount API the
- * caller must have explicitly done:
- *
- *      fsconfig(FSCONFIG_SET_FLAG, "ro")
- *      fsmount/mount_setattr(MOUNT_ATTR_RDONLY)
- *
- * IOW, at some point the caller must have explicitly turned the whole
- * superblock ro and we shouldn't just undo it like we did for the old mount
- * API. In any case, it lets us avoid the hack in the new mount API.
- *
- * Consequently, the remounting hack must only be used for requests originating
- * from the old mount API and should be marked for full deprecation so it can be
- * turned off in a couple of years.
- *
- * The new mount API has no reason to support this hack.
+ * But, currently the util-linux mount command already utilizes the new mount
+ * API and is still setting fsconfig(FSCONFIG_SET_FLAG, "ro") no matter if it's
+ * btrfs or not, setting the whole super block RO.  To make per-subvolume mounting
+ * work with different options work we need to keep backward compatibility.
  */
 static struct vfsmount *btrfs_reconfigure_for_mount(struct fs_context *fc)
 {
@@ -2019,7 +2004,7 @@ static struct vfsmount *btrfs_reconfigur
 	if (IS_ERR(mnt))
 		return mnt;
 
-	if (!fc->oldapi || !ro2rw)
+	if (!ro2rw)
 		return mnt;
 
 	/* We need to convert to rw, call reconfigure. */


