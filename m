Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D51BDA95;
	Thu, 30 Jan 2025 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246978; cv=none; b=QwRZ0dHtf2yGA2uTPIWBm0z+PDMCq6xB4MDTZj7yJXUPBEEQrQmni3UGgzro4iftPWtVn7/0ifAs2WZWQOx/wWSObTyrCj9d2YfaTI5nB9oTapjVs4488NKVEfvLGa0qLxvwWN18fvmV41z3G9l03KMInwJdaUzrOi0okJXrJrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246978; c=relaxed/simple;
	bh=FT5RzeYv7+4ZJmu9k5nSwekv6c6D5P0eThMKBrHnFHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpU0pz3057Ks5vLDKpg0x1J4n5k1X2R50UK7wZXHxuJyup9cOAtSxGn6KQcS/PW5vgEUshm6c9/O/7GbMK+1xURbKjTPY66WcbZYsSJtbiq+lM+EtzsM8AsnZDYlDC5LkYOc8paIMInZwiinfLRnbdK/+TQ1PS18dl3WqKNu/Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTqOmfgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTqOmfgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFA8C4CED2;
	Thu, 30 Jan 2025 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246977;
	bh=FT5RzeYv7+4ZJmu9k5nSwekv6c6D5P0eThMKBrHnFHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTqOmfgrIykqOwo2EC535b2eE8RaR2Dnh5qjKCK4zZD2EGCrczT8HrzJRt81qIt2r
	 guVGxCtL9q0lpcjQl4NsVXwEMCrZokFIaSXzORZTd+pqTvWk4fCmDTRyWZf8zF/5e7
	 0QcVzeEb3ECdDXz713Y5vePMvD/4ezr/ATZOw6mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Akash M <akash.m5@samsung.com>
Subject: [PATCH 5.10 041/133] usb: gadget: f_fs: Remove WARN_ON in functionfs_bind
Date: Thu, 30 Jan 2025 15:00:30 +0100
Message-ID: <20250130140144.166911749@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akash M <akash.m5@samsung.com>

commit dfc51e48bca475bbee984e90f33fdc537ce09699 upstream.

This commit addresses an issue related to below kernel panic where
panic_on_warn is enabled. It is caused by the unnecessary use of WARN_ON
in functionsfs_bind, which easily leads to the following scenarios.

1.adb_write in adbd               2. UDC write via configfs
  =================	             =====================

->usb_ffs_open_thread()           ->UDC write
 ->open_functionfs()               ->configfs_write_iter()
  ->adb_open()                      ->gadget_dev_desc_UDC_store()
   ->adb_write()                     ->usb_gadget_register_driver_owner
                                      ->driver_register()
->StartMonitor()                       ->bus_add_driver()
 ->adb_read()                           ->gadget_bind_driver()
<times-out without BIND event>           ->configfs_composite_bind()
                                          ->usb_add_function()
->open_functionfs()                        ->ffs_func_bind()
 ->adb_open()                               ->functionfs_bind()
                                       <ffs->state !=FFS_ACTIVE>

The adb_open, adb_read, and adb_write operations are invoked from the
daemon, but trying to bind the function is a process that is invoked by
UDC write through configfs, which opens up the possibility of a race
condition between the two paths. In this race scenario, the kernel panic
occurs due to the WARN_ON from functionfs_bind when panic_on_warn is
enabled. This commit fixes the kernel panic by removing the unnecessary
WARN_ON.

Kernel panic - not syncing: kernel: panic_on_warn set ...
[   14.542395] Call trace:
[   14.542464]  ffs_func_bind+0x1c8/0x14a8
[   14.542468]  usb_add_function+0xcc/0x1f0
[   14.542473]  configfs_composite_bind+0x468/0x588
[   14.542478]  gadget_bind_driver+0x108/0x27c
[   14.542483]  really_probe+0x190/0x374
[   14.542488]  __driver_probe_device+0xa0/0x12c
[   14.542492]  driver_probe_device+0x3c/0x220
[   14.542498]  __driver_attach+0x11c/0x1fc
[   14.542502]  bus_for_each_dev+0x104/0x160
[   14.542506]  driver_attach+0x24/0x34
[   14.542510]  bus_add_driver+0x154/0x270
[   14.542514]  driver_register+0x68/0x104
[   14.542518]  usb_gadget_register_driver_owner+0x48/0xf4
[   14.542523]  gadget_dev_desc_UDC_store+0xf8/0x144
[   14.542526]  configfs_write_iter+0xf0/0x138

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Akash M <akash.m5@samsung.com>
Link: https://lore.kernel.org/r/20241219125221.1679-1-akash.m5@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1856,7 +1856,7 @@ static int functionfs_bind(struct ffs_da
 
 	ENTER();
 
-	if (WARN_ON(ffs->state != FFS_ACTIVE
+	if ((ffs->state != FFS_ACTIVE
 		 || test_and_set_bit(FFS_FL_BOUND, &ffs->flags)))
 		return -EBADFD;
 


