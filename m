Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624596;
	b=AQ93MiZEevIYNXp2Hx2oqN+E9Ai6ynNq4uSdnwJhKtrh2VUYfeP8x9gJ+AIpZfqjES2k
	 6hJoSojHfy6MfhhzebzCSIu++0o3QdXzY9erTWxLVblKel2NxLp0yBRfQZGMJknX9vcNU
	 upRVJYPCevW8e4WtlFMbWB9UTi3pQjWw9u6q+Ct2atbwglT+IAjSXdC0pIzOwjEp5lAqJ
	 PxACLvAZlOPYX0RD+M6eT+KWNnk2MIWy2mQEosa4lOa57/fWR45okSfvt+nm9mhNcBMgm
	 GERDO/vk6Qb8Q8YbAMC2dN0zwYEw/6xKijg3go1pVgRUon3ZrJ41ucZZJ9BYCrOH0cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624596;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SlvoWF7d715y3BuLkspcy99yhwR30SXIvLR9OTs/QOk=;
	b=m9sKflAfek7Nn4UyimjjXLR2w0cygmHA+lPKCMJFlP7wfkKWoXgC756Az4VkwWfeAg4b
	 VPoY+LGMCRECiMHe5BxnSUq4VZCBGFARbEniLeguCzYdPLXkdc/yu3LEJG/OWZlVX2LI8
	 Sc1dhItELwc1FL+BujxP1dnceuYGEtCKm95zg66TYZ/xdj0unwMYM3Zh6dkKsXyVVwrZc
	 zQ0hD9FRa947AIcS/Qo7tCP8MG+6VnPum4JMaQsfv7GdyHO8xckPh8vQjeFOTr2WDPYTa
	 it1R9r7suIPhytL3+QFN4hKNWTBkPtLYf1HsWYYjxmcHUPRuREJ6Q3Rsvrdr6dUgxpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg+zHriZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FB4606A338;
	Wed, 25 Nov 2026 16:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qg+zHriZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16B21F000C6;
	Wed, 25 Nov 2026 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624595;
	bh=SlvoWF7d715y3BuLkspcy99yhwR30SXIvLR9OTs/QOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qg+zHriZht60FF4KYRkfyVCakEX6n90lPhJf76yuCYiK7VuYfEd0gA5Zl2ERkcpo7
	 LB/QTb68T7lea8RjX8D+3NnrNoQq7SNmo0eZV15umAnQXLClW8HAvBhRkAe7MiBKT3
	 7+kWV9dMcIceKpRmmXN07uTb8+z0uiBl/6pCcb9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abbott Liu <liuwenliang@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/816] initrd: flush deferred fput() before mounting root
Date: Wed, 25 Nov 2026 15:29:52 +0100
Message-ID: <20261125143854.858492881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abbott Liu <liuwenliang@huawei.com>

[ Upstream commit 807c1d7125a2b3ca5705a803aa2e19f9d53d1ea3 ]

Booting an old-style initrd, i.e. a filesystem image instead of a cpio
archive, with "root=/dev/ram rootfstype=squashfs" can fail to mount the
root filesystem:

    RAMDISK: squashfs filesystem found at block 0
    RAMDISK: Loading 68449KiB [1 disk] into ram disk... done.
    No filesystem could mount root, tried:
     squashfs
    Kernel panic - not syncing: VFS: Unable to mount root fs on
    "/dev/ram" or unknown-block(1,0)

rd_load_image() copies the image into /dev/ram with kernel_write() and
then drops the file with fput(). The data only reaches the ramdisk once
the final __fput() releases the block device and bdev_release() calls
sync_blockdev(). But that __fput() is deferred. Since commit
343f4c49f243 ("kthread: Don't allocate kthread_struct for init and
umh") init is a user mode task, so the __fput() is queued as task work
and only runs once init returns to userspace, i.e. long after
mount_root(). Before that it ran as delayed fput work at least a jiffy
later, which doesn't help either.

Whether the mount survives this depends on the block size. Squashfs
calls sb_min_blocksize() first and set_blocksize() syncs and drops the
page cache when the requested block size differs from the current one.
That hides the problem for most configurations. With
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y and 4K pages both block sizes are 4K
because set_init_blocksize() gives a page-aligned ramdisk a PAGE_SIZE
block size on the first open. So set_blocksize() does nothing and
squashfs reads the superblock with bios that bypass the page cache. brd
has no page for that range yet and returns zeroes, so the magic check
fails and the mount returns -EINVAL. With rootfstype= naming a single
filesystem there is nothing left to retry and mount_root_generic()
panics.

Fixing this in squashfs would be the wrong end. Most block-backed
filesystems read their superblock or their file data with bios that
bypass the block device page cache, so they are exposed to the same
race, just less loudly.

So flush the deferred fput() in rd_load_image() right after dropping the
ramdisk file, the same way mount_root_generic() already does before it
retries with another filesystem type. All deferred closes at this point
belong to files the boot itself created.

Verified on arm64 QEMU with an openEuler Embedded rootfs image packed as
squashfs.

Fixes: 93e72b3c612a ("squashfs: migrate from ll_rw_block usage to BIO")
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
Link: https://patch.msgid.link/20260930084632.2965573-1-liuwenliang@huawei.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/do_mounts_rd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index ac021ae6e6fa7..285afe68dbc76 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -270,6 +270,11 @@ int __init rd_load_image(char *from)
 	fput(in_file);
 noclose_input:
 	fput(out_file);
+	/*
+	 * The image only reaches the ramdisk when the deferred __fput()
+	 * syncs the block device. Flush it before mount_root() reads it.
+	 */
+	init_flush_fput();
 out:
 	kfree(buf);
 	init_unlink("/dev/ram");
-- 
2.53.0



