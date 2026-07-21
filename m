Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9754B472531;
	Tue, 21 Jul 2026 20:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665345; cv=none; b=PgPnrcnNRJ5KRGPe4pXtJ7WYRHPy0yahcbLdaYfPV0chyheuyVc5BGpV1HffJF8hDFWN1eo/I+hPrr04Nk0oOR+yDpr15D1ij4Zdtb+pePaBBYlBCptwL3W7J4tQXUgVMHxaexKeZzjs2XJwtpkUirXbPZpssnSg1+RzyqdkxuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665345; c=relaxed/simple;
	bh=x36ls8HZcNe6GST38BwXXudk0IHxHkq4t27W+Ux25dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snu552ptD6ytJxdcZb7Zy3QIzwXflOmrTVMN82Mys4CEIlgwQIc0yUfgyALaUjkz0OqgIfktBLI9DGVyNFdkUN/B3JtD5U++UXntH6DHx9GmlyYqjZV+Up1PuAEpsNmh4rMibbjfUQe+IxkE9Y9c+A2H1uwz8R8bzFGCH1E9A3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDzahzEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDzahzEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EEE1F000E9;
	Tue, 21 Jul 2026 20:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665342;
	bh=OArl0nxHxWjjnzKwxmnoMIfvbWXs2qDwsOF+OAMUSgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDzahzEXr+lmXYEPOeKu7BXO2lQEUkybMJDxDxDmFQ0MlMIwczpJ6B4te7dvfV2Xi
	 gvuXwyIMjREiqS34ELWksODgXJffuiexSVLTp+4K0ToSrmHArsvujHDTp0wppf+GKY
	 TTDSZFs3jyQjJUMno9HL/rRiv7ghwXNBSVkMsyxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Yue <glass.su@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 0266/1266] btrfs: do not trim a device which is not writeable
Date: Tue, 21 Jul 2026 17:11:43 +0200
Message-ID: <20260721152447.773912470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 1b1937eb08f51319bf71575484cde2b8c517aedc upstream.

[BUG]
There is a bug report that btrfs/242 can randomly fail with the
following NULL pointer dereference:

  run fstests btrfs/242 at 2026-06-01 10:25:08
  BTRFS: device fsid d4d7f234-487c-4787-88e4-47a8b68c9874 devid 1 transid 9 /dev/sdc (8:32) scanned by mount (122609)
  BTRFS info (device sdc): first mount of filesystem d4d7f234-487c-4787-88e4-47a8b68c9874
  BTRFS info (device sdc): using crc32c checksum algorithm
  BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
  BTRFS warning (device sdc): devid 2 uuid fbe72d72-3272-482d-80fb-ab88ed398192 is missing
  BTRFS info (device sdc): allowing degraded mounts
  BTRFS info (device sdc): turning on async discard
  BTRFS info (device sdc): enabling free space tree
  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000018
  user pgtable: 4k pages, 48-bit VAs, pgdp=000000013fd6b000
  CPU: 4 UID: 0 PID: 122625 Comm: fstrim Not tainted 7.0.10-2-default #1 PREEMPT(full) openSUSE Tumbleweed e9a5f6b24978fba3bf015a992f865837fdfff3dd
  Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250812-19.fc42 08/12/2025
  pstate: 01400005 (nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
  pc : btrfs_trim_fs+0x34c/0xa00 [btrfs]
  lr : btrfs_trim_fs+0x1f0/0xa00 [btrfs]
  Call trace:
   btrfs_trim_fs+0x34c/0xa00 [btrfs f02c1d570ceea621c69d302ba75dd61868083840] (P)
   btrfs_ioctl_fitrim+0xe8/0x178 [btrfs f02c1d570ceea621c69d302ba75dd61868083840]
   btrfs_ioctl+0xdd4/0x2bd8 [btrfs f02c1d570ceea621c69d302ba75dd61868083840]
   __arm64_sys_ioctl+0xac/0x108
   invoke_syscall.constprop.0+0x5c/0xd0
   el0_svc_common.constprop.0+0x40/0xf0
   do_el0_svc+0x24/0x40
   el0_svc+0x40/0x1d0
   el0t_64_sync_handler+0xa0/0xe8
   el0t_64_sync+0x1b0/0x1b8
  Code: 17ffff83 f94017e0 f9002be0 f9402ea0 (f9400c00)
  ---[ end trace 0000000000000000  ]---

Also the reporter is very kind to test the following ASSERT() added to
btrfs_trim_free_extents_throttle():

	ASSERT(device->bdev,
	       "devid=%llu path=%s dev_state=0x%lx\n",
	       device->devid, btrfs_dev_name(device), device->dev_state);

And it shows the following output:

  assertion failed: device->bdev, in extent-tree.c:6630 (devid=2 path=/dev/sdd dev_state=0x82)

Which means the device->bdev is NULL, and the dev_state is
BTRFS_DEV_STATE_IN_FS_METADATA | BTRFS_DEV_STATE_ITEM_FOUND, without
BTRFS_DEV_STATE_WRITEABLE flag set.

[CAUSE]
The pc points to the following call chain:

  btrfs_trim_fs()
  |- btrfs_trim_free_extents()
     |- btrfs_trim_free_extents_throttle()
        |- bdev_max_discard_sectors(device->bdev)

So the NULL pointer dereference is caused by device->bdev being NULL.

This looks impossible by a quick glance, as just before calling
btrfs_trim_free_extents_throttle(), we have skipped any device that has
BTRFS_DEV_STATE_MISSING flag set.

However in this particular case, there is a window where the missing
device is later re-scanned, causing btrfs to remove the
BTRFS_DEV_STATE_MISSING flag:

  btrfs_control_ioctl()
  |- btrfs_scan_one_device()
     |- device_list_add()
        |- rcu_assign_pointer(device->name, name);
        |  This updates the missing device's path to the new good path.
        |
        |- clear_bit(BTRFS_DEV_STATE_MISSING, &device->dev_state)
           This removes the BTRFS_DEV_STATE_MISSING flag.

This allows the missing device to re-appear and clear the
BTRFS_DEV_STATE_MISSING flag.  However the device still does not have
the BTRFS_DEV_STATE_WRITEABLE flag set, nor is its bdev pointer updated.

The bdev pointer remains NULL, triggering the crash later.

[FIX]
This is a big de-synchronization between BTRFS_DEV_STATE_MISSING and
device->bdev pointer, and shows a gap in btrfs's re-appearing-device
handling.

The proper handling of re-appearing device will need quite some extra
work, which is out of the context of this small fix.

Thankfully the regular bbio submission path has already handled it well
by checking if the device->bdev is NULL before submitting.

So here we just fix the crash by checking if the device is writeable and
has a bdev pointer before calling bdev_max_discard_sectors().

Reported-by: Su Yue <glass.su@suse.com>
Link: https://lore.kernel.org/linux-btrfs/wlwir19t.fsf@damenly.org/
Fixes: 499f377f49f0 ("btrfs: iterate over unused chunk space in FITRIM")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6053,12 +6053,16 @@ static int btrfs_trim_free_extents(struc
 
 	*trimmed = 0;
 
-	/* Discard not supported = nothing to do. */
-	if (!bdev_max_discard_sectors(device->bdev))
+	/*
+	 * The caller only filters out MISSING devices, but a device that was
+	 * missing at mount and later rescanned has MISSING cleared while bdev
+	 * is still NULL and WRITEABLE is still unset. Skip those here.
+	 */
+	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state) || !device->bdev)
 		return 0;
 
-	/* Not writable = nothing to do. */
-	if (!test_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state))
+	/* Discard not supported = nothing to do. */
+	if (!bdev_max_discard_sectors(device->bdev))
 		return 0;
 
 	/* No free space = nothing to do. */


