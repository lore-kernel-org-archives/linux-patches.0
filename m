Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705189;
	b=L2V6T7NCsqQq4Rg05f4TgQ6t2itUWDsgrvm2D3dcZTZgHmKbvRPs6WgFd2hpBqWeLspl
	 SI2pPpuGDFkp7S/jEV+q84TIbdehF+YpAIxaaoCapNlsz1nNerBKFBBExgRrj9Rr9ReJc
	 V4idjqOHOYOeDl3gtut21RLO89Tn8wzRIX6YoSzvwNv896E7WbS5qzAOd1+H2OFKf4dqG
	 0JnYeTLY0U9cLLiZ6WzAOlpzrugpl2SiVVKJkSn9Zik8EEfYri5JOJOj3bKxPZTpUGY4L
	 bgZVRHeBeYTYVDNAEqhC/Z7zGeyQjBXKlsz3Xa3BDm4noK2xEhuUI8ebYgG+yQ45o6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/P1OZ4/BR8Pw3kVRuLBj5wUS6iIs9Wv342bLZrLg21Y=;
	b=G7tjrSU5FLvZJdFTff3s6ADMPvAUbKrjZI9xvyHnxgFiX4IwtO8B152G2W61a33FJrKD
	 0BiW+qDyi+foN20ZE+FcKhh1JKdW4OnOBbsDBKHE+D2NGPv31Sf++J4FFSQvzNfJM254f
	 qn1R40bl1PfHwo/Q3EwY0xd0+DVt69lLLhNpNydF5/moeHR/kVsFmZQ/XQGS3HMuBvrUo
	 Da5umRZI6lBDZLnd+jY4fDB5hhI+0Uow+9mXMiNHeTJ9jfZOiVA7qpMXmz2a522Lus1+C
	 viiQLraNM7G3gJDmbCSO6t9Pm4Hga4g/53WcbTc0z++nwYlFPWsvAxLVAfi42NNGtvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tjao1z6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F0A606A321;
	Thu, 26 Nov 2026 14:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tjao1z6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4EB1F000C4;
	Thu, 26 Nov 2026 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705189;
	bh=/P1OZ4/BR8Pw3kVRuLBj5wUS6iIs9Wv342bLZrLg21Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjao1z6q+aNaODm6+yn6OeeM6CJZPqnbIdmohxygAJo6oIasH/uUfVIlsHQJvkgpq
	 SXduOuWuvOm97vVDWrwO5vBK9ZG9Yg3etwdgSIGNB9bs8KwzezxNqCa/gALPe1Wyx2
	 PdxRhGiRJica8gb6ZLOAO2g9MYvHzHGihUsJsdtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abbott Liu <liuwenliang@huawei.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/319] initrd: flush deferred fput() before mounting root
Date: Thu, 26 Nov 2026 15:38:01 +0100
Message-ID: <20261126144009.295056577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



