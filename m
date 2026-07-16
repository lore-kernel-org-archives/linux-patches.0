Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F5E5A79B;
	Thu, 16 Jul 2026 14:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210711; cv=none; b=Nb45KPJplqwX5ZMomC5PddzYXfyt3iYg3H8QN8GtaaMYYiXddYwYo/dphX/fseNnQKBB5WU32BCHA2PQOA0S9EAh/AxIA/ugIF2G61gVmJOvAH7SHKsw+GsYUH7oXKKHIPjTMfdtbZmxrGKcIZQ3GwBKkA/tyW/TTfCJrFOnla0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210711; c=relaxed/simple;
	bh=fMqJeUW2jy2jMdetVWwRQXneqykNGhe+T+z+o2pw7iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acfpgan8TVGb/H3cn6qnTLd22eqx8yb4V/RXuJHYrRNLSh9amj/cEwBZwlpoeqmllBev0ml20O9j43Fy6Y1RrcwCXbc/7ERl8KiP3nHd0fuyZ1PnOwekkBrwHKTiQVVf2vnh7sU+p5zCfbmo6M1a8aKkeyvpI22cebG6wuBF8n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJTuDrza; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJTuDrza"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1F31F000E9;
	Thu, 16 Jul 2026 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210710;
	bh=3uuzPy2QyWLtmpbo5of2JmTd6Ynjege6RVloTiJjCKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJTuDrzaBBHAlNYCRbEEWklPqD74K81Wcn8YjTDG5plqQQG6kVhidfLMg6bvvNc+9
	 BqcC/9gMjUne0oGz0Es00TFiPpWrxlS4WjsJNk2wOrlB+BJCJKUu5NiMvHjs/K4vf/
	 bTR6wsxoFMIVIYy3o9VgkMkwXr6F5eRcq25iksN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cen Zhang <zzzccc427@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 152/480] usb: misc: usbio: fix disconnect UAF in client teardown
Date: Thu, 16 Jul 2026 15:28:19 +0200
Message-ID: <20260716133047.994847633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 0bfeec21984fedd32987f4e4c0cde34b445af404 upstream.

usbio_disconnect() walks usbio->cli_list in reverse and uninitializes each
auxiliary device. auxiliary_device_uninit() drops the device reference, and
for an unbound child that can run usbio_auxdev_release() and free the
containing struct usbio_client.

list_for_each_entry_reverse() advances after the loop body by reading
client->link.prev. If the current client is freed by
auxiliary_device_uninit(), the iterator dereferences freed memory.

Use list_for_each_entry_safe_reverse() so the previous client is
cached before the body can drop the final reference. This preserves
reverse teardown order while keeping the next iterator cursor independent
of the current client's lifetime.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in usbio_disconnect+0x12e/0x150

Call Trace:
 <TASK>
 dump_stack_lvl+0x66/0xa0
 print_report+0xce/0x630
 ? usbio_disconnect+0x12e/0x150
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __virt_addr_valid+0x188/0x320
 ? usbio_disconnect+0x12e/0x150
 kasan_report+0xe0/0x110
 ? usbio_disconnect+0x12e/0x150
 usbio_disconnect+0x12e/0x150
 usb_unbind_interface+0xf3/0x400
 really_probe+0x316/0x660
 __driver_probe_device+0x106/0x240
 driver_probe_device+0x4a/0x110
 __device_attach_driver+0xf1/0x1a0
 ? __pfx___device_attach_driver+0x10/0x10
 bus_for_each_drv+0xf9/0x160
 ? __pfx_bus_for_each_drv+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? trace_hardirqs_on+0x18/0x130
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? _raw_spin_unlock_irqrestore+0x44/0x60
 __device_attach+0x133/0x2a0
 ? __pfx___device_attach+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_raw_spin_unlock+0x9a/0x100
 ? srso_alias_return_thunk+0x5/0xfbef5
 device_initial_probe+0x55/0x70
 bus_probe_device+0x4a/0xd0
 device_add+0x9b9/0xc10
 ? __pfx_device_add+0x10/0x10
 ? _raw_spin_unlock_irqrestore+0x44/0x60
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lockdep_hardirqs_on_prepare+0xea/0x1a0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? usb_enable_lpm+0x3c/0x260
 usb_set_configuration+0xb64/0xf20
 usb_generic_driver_probe+0x5f/0x90
 usb_probe_device+0x71/0x1b0
 really_probe+0x46b/0x660
 __driver_probe_device+0x106/0x240
 driver_probe_device+0x4a/0x110
 __device_attach_driver+0xf1/0x1a0
 ? __pfx___device_attach_driver+0x10/0x10
 bus_for_each_drv+0xf9/0x160
 ? __pfx_bus_for_each_drv+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? trace_hardirqs_on+0x18/0x130
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? _raw_spin_unlock_irqrestore+0x44/0x60
 __device_attach+0x133/0x2a0
 ? __pfx___device_attach+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_raw_spin_unlock+0x9a/0x100
 ? srso_alias_return_thunk+0x5/0xfbef5
 device_initial_probe+0x55/0x70
 bus_probe_device+0x4a/0xd0
 device_add+0x9b9/0xc10
 ? __pfx_device_add+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? add_device_randomness+0xb7/0xf0
 usb_new_device+0x492/0x870
 hub_event+0x1b10/0x29c0
 ? __pfx_hub_event+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lock_acquire+0x187/0x300
 ? process_one_work+0x475/0xb90
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? lock_release+0xc8/0x290
 ? srso_alias_return_thunk+0x5/0xfbef5
 process_one_work+0x4d7/0xb90
 ? __pfx_process_one_work+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __list_add_valid_or_report+0x37/0xf0
 ? __pfx_hub_event+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 worker_thread+0x2d8/0x570
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x1ad/0x1f0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x3c9/0x540
 ? __pfx_ret_from_fork+0x10/0x10
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __switch_to+0x2e9/0x730
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 121a0f839dbb ("usb: misc: Add Intel USBIO bridge driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260618124029.3704089-1-zzzccc427@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/misc/usbio.c
+++ b/drivers/usb/misc/usbio.c
@@ -518,7 +518,7 @@ static int usbio_resume(struct usb_inter
 static void usbio_disconnect(struct usb_interface *intf)
 {
 	struct usbio_device *usbio = usb_get_intfdata(intf);
-	struct usbio_client *client;
+	struct usbio_client *client, *next;
 
 	/* Wakeup any clients waiting for a reply */
 	usbio->rxdat_len = 0;
@@ -535,7 +535,7 @@ static void usbio_disconnect(struct usb_
 	usb_kill_urb(usbio->urb);
 	usb_free_urb(usbio->urb);
 
-	list_for_each_entry_reverse(client, &usbio->cli_list, link) {
+	list_for_each_entry_safe_reverse(client, next, &usbio->cli_list, link) {
 		auxiliary_device_delete(&client->auxdev);
 		auxiliary_device_uninit(&client->auxdev);
 	}


