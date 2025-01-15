Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557AC248BBB;
	Wed, 15 Jan 2025 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938796; cv=none; b=Z/fFIrYDy/l0fH5rR827BLyJ/hZsLAdyxvIzMPq8C1Hc3IWTmW3eDxMLLe3Yh26oc7o2d4X80GvaapCA3FHbuC9X668RjqP/qSaJfZDcZKfYdd7vYkN4VycpojbF8OY+uoD66vYE0dXfcl+pwWQL1LfxDqtmWca6FjekAIeqFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938796; c=relaxed/simple;
	bh=i3SGRPTpHeBLn80gOSc6/vW2Tf5YFfy/WQmz9uaSRSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL+K8ZpN/q0GnBB6eGds2LyAbrFtR31RdhyIz6CFarNQeoVdnIMGevym+3iucUwB/r0+m/VfVyx4euPWzk4yOSv/cwOJqva2YZwP+8WWljsP2m7O87HNq0NHuMyS2BeSFH7fsOf/mAGhNTuSoQz/RbFOF4DpzpQhGhWPj6GwGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAj5mwm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAj5mwm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635FDC4CEDF;
	Wed, 15 Jan 2025 10:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938796;
	bh=i3SGRPTpHeBLn80gOSc6/vW2Tf5YFfy/WQmz9uaSRSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAj5mwm4OfXJ0K8XnbqlDgwZ6TIgA9Y2wMIKIiC0c3dkrwvabym6XhVMAz1skayPP
	 +WKrXz3lOzVtLw9HZyVCbuUjk/K9PdvjPnTUAiCqHkev+l5YtAvCw7lI6cHQWfyq+A
	 M5IumzjYBn/ELxKbiPRgKzJcubJAUVOzNQI+/F8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Akash M <akash.m5@samsung.com>
Subject: [PATCH 6.6 100/129] usb: gadget: f_fs: Remove WARN_ON in functionfs_bind
Date: Wed, 15 Jan 2025 11:37:55 +0100
Message-ID: <20250115103558.346710705@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1810,7 +1810,7 @@ static int functionfs_bind(struct ffs_da
 	struct usb_gadget_strings **lang;
 	int first_id;
 
-	if (WARN_ON(ffs->state != FFS_ACTIVE
+	if ((ffs->state != FFS_ACTIVE
 		 || test_and_set_bit(FFS_FL_BOUND, &ffs->flags)))
 		return -EBADFD;
 


