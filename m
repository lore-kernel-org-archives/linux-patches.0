Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621686;
	b=tIwA3SdbIKMTdf9hdR4Y9z1nVNWi5stLo4GbVKENuAbVKqEAwiO2NwQExHzhPQpaRPdq
	 /DbEHBMWK3HXHPDn6PwoUWbkHFhjh6J1GcW4PiPca3vT6viI+lPUh+p0xwTzD8oeq5xNy
	 DafTl2ZA63ZxajULWO8k9FXzdoyTXXNbLDDEDqI3yjAv003aOIreXo3eLeqfcjF/JzuBG
	 +GajhDJtNvPJ/Yjup3CsYCah+3o+QrCdpgtEIGzMmsH+7cBKEcBxmiGlc6xZy2rdY+ps9
	 0xWVvqOu9WqUk2+xDOo30T3BRcAsAgM9awZ/k/bqKdUi0SW+M+8cHVu9Vbw27LSGVYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ZtXbR233Sk7z6SbrIQu17rU5rF4nBcM07XDfDHtCsM=;
	b=FrWSTHggg5dGValQurhPZ1dyZq412+zynb4L+4qFE9S0ojZD0s9/hEm3I+J7iAwPJc80
	 cEIS3uvz3U3poAOUUPQwnyFSEhmwz5KNkeTprBEMo+rEOuZ4Rpg6neGD3LS5g3rRRKDGR
	 ctbzdY2BUpPW+l8FpPPKDTEUbzi18n3RB2IeBacepBV5aYDJrtmKanxPU4ccHHXYykUce
	 M4/0KSYc8MRtVskxQJbOM9pDokLeF6w8tNVk7zKToAlKZz+996mpUfytEkKLO2hgg9b20
	 QEmBBrv5/fho9jX+QRImTkBfwK9V/ZUtyPukdMJH628l64Ser5ro4iGOIEiZiVjYy3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOXEYu6I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92E3606A339;
	Wed, 25 Nov 2026 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOXEYu6I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F8C1F000C0;
	Wed, 25 Nov 2026 15:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621686;
	bh=+ZtXbR233Sk7z6SbrIQu17rU5rF4nBcM07XDfDHtCsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOXEYu6IfoeoW/0XifaaACequMIZybS9cahEd/tuEImy5rqSJ2UHg/ekh3i5bWlMr
	 ohfUWFtartx+YWvEBuEKNp0cPD81F+CBYLqMsAmMQKchRqeHkkmCLzmm2ADv+sPRcs
	 SimYMu8kI1rND+IPIw59AqKepg+YaHPIKNuhY0bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abbott Liu <liuwenliang@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 302/990] initrd: flush deferred fput() before mounting root
Date: Wed, 25 Nov 2026 15:27:49 +0100
Message-ID: <20261125143829.165987198@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 19d9f33dcacf8..fb7897d879b06 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -268,6 +268,11 @@ int __init rd_load_image(char *from)
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



