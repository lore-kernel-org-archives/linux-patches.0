Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9131F55E3;
	Tue, 21 Jan 2025 18:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482912; cv=none; b=IUlVvHnKisflDVeqdek0CotlnHyPuembpG4+zDf9JGLbjjKRZHeOM6vI8mBHB28Rv9C+zfsLQrE2M9HIGUo5DqVisrLMF3uN8m5ZT4AaYl1+IO1tZl4sHVnCgZFVtnUSkfB7xUC+7UKkBXk6V4q+oe8ty3qVoair037k46fUhsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482912; c=relaxed/simple;
	bh=Hl12XAn1lx9HwUaPCWtrUg2i/ofcMr7fcU64I1XzqVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1pUr9SC0ZRw36hCZdiwC4NjrIoZm6zvdj9A6RACqIepHb8SZaWgSOlIOrLH5qGtbpdGCHhwLj/yd1HPM22MpdBkw0Jnz6c6b8qDYCWG9fALi3Sm1Wxy1Cl2BeV2l5beP2R3CXK3vJSsQxyGCNf7V9HpWLjGL9mEAmnW7jtTtQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6Limjy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6Limjy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BC7C4CEE0;
	Tue, 21 Jan 2025 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482912;
	bh=Hl12XAn1lx9HwUaPCWtrUg2i/ofcMr7fcU64I1XzqVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Limjy3RzoxMoPVjvPzV8LcArK20JvZlazrQqTXHjuYZMP1Fb/vmeWIBXFKdPFcB
	 Aow2rKyKx9m87DtfLe1+DzhuFGVw6Dbcxy5r7LXBl1FthS5qVI4JdTaBLwcS4/JrVl
	 L9Nf+FA0Bzma7ba8xBWw8FYOy+vk5SKl5uGvRW9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Akash M <akash.m5@samsung.com>
Subject: [PATCH 5.15 052/127] usb: gadget: f_fs: Remove WARN_ON in functionfs_bind
Date: Tue, 21 Jan 2025 18:52:04 +0100
Message-ID: <20250121174531.674799906@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1868,7 +1868,7 @@ static int functionfs_bind(struct ffs_da
 
 	ENTER();
 
-	if (WARN_ON(ffs->state != FFS_ACTIVE
+	if ((ffs->state != FFS_ACTIVE
 		 || test_and_set_bit(FFS_FL_BOUND, &ffs->flags)))
 		return -EBADFD;
 


