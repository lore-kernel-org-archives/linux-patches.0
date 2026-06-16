Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB48E3D5656;
	Tue, 16 Jun 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633611; cv=none; b=HqG0lvxsjSN0XZ0APULscwxpKFfoQ3iGCWCXLrmomQ7n/TOnMy3+obuUlU1ZnOSyAzb2jnrGzGAaxUXfKjQH7oc8rvToxjFuXeaHnJe+Rp2OboB/T35etAwE1YVMMxsfZNOaXs+xDJcwg31T+KKbBOsA4+hj1iw+lyh2uuCqlcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633611; c=relaxed/simple;
	bh=prlPY+Peeuba4bYjxcrBV8ZWy7X2n0gONKDdMeOwRLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XA/stXppKEjk5OGIv7vCm9pSfGOtFJesSPCb5qIAcoV39tIChQP2ZfVzovnUru7NXtTMuptu3/74lYwxPjQfNDWQQ4C6ygw9jqtYEe50oSc8jxc0PP1Y8cmkheiPVmyGN4TTF15BtVNBm7DGPF5af7yqvcd92Txb/hyT53QX1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHY4OgJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHY4OgJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53661F000E9;
	Tue, 16 Jun 2026 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633609;
	bh=gnM2qZaHwNBCDJZ2xh/texjmujZ7kA32eO4Wc4Cnmzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QHY4OgJI4hPsShkTKe5pwQpxOc6xMV20ZCljXxIUHiUGNZTr5KKedGjL35QYVQhDc
	 AJoAB6PEGJgbWXt0u/DpNxi/a8kI90YzthDh66pHDGBI4BvdKwatv+kGkH7dherhTH
	 unGYzI29TvpAF0iS3ToDrb8yFDwjpZyZwXW0IcFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Zheng Wang <zyytlz.wz@163.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 111/411] usbip: vudc: Fix use after free bug in vudc_remove due to race condition
Date: Tue, 16 Jun 2026 20:25:49 +0530
Message-ID: <20260616145106.184338010@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit d96209626a29ea64666be98c30b30ac82e5f1be6 upstream.

This patch follows up Zheng Wang's 2023 report of a use-after-free in
vudc_remove(). The original thread stalled on Shuah Khan's request for
runtime testing of the unplug/unbind path. This patch supplies that
testing and keeps Zheng's original fix shape.

In vudc_probe(), v_init_timer() binds udc->tr_timer.timer to v_timer().
usbip_sockfd_store() starts the timer via v_start_timer()/v_kick_timer().
vudc_remove() can then free the containing struct vudc while the timer is
still pending or executing.

KASAN confirms the race on an unpatched x86_64 QEMU guest with
CONFIG_KASAN=y, CONFIG_USBIP_VUDC=y, CONFIG_USB_ZERO=y, and a tight loop
that repeatedly writes a socket fd to usbip_sockfd, closes the socket
pair, and unbinds/rebinds usbip-vudc.0:

  BUG: KASAN: slab-use-after-free in __run_timer_base.part.0+0x8ba/0x8e0
  Write of size 8 at addr ffff888001b80740 by task trigger_and_unb/239
  Allocated by task 239:
    vudc_probe+0x4d/0xaa0
  Freed by task 239:
    kfree+0x18f/0x520
    device_release_driver_internal+0x388/0x540
    unbind_store+0xd9/0x100

This lands in the timer core rather than v_timer() itself because the
embedded timer_list is being walked after its containing struct vudc has
already been freed. The underlying lifetime bug is the same one Zheng
reported.

With v_stop_timer() called from vudc_remove() and the timer deleted
synchronously, the same harness completed 5000 bind/unbind iterations
with no KASAN report.

Fixes: b6a0ca111867 ("usbip: vudc: Add UDC specific ops")
Cc: stable <stable@kernel.org>
Reported-by: Zheng Wang <zyytlz.wz@163.com>
Closes: https://lore.kernel.org/linux-usb/20230317100954.2626573-1-zyytlz.wz@163.com/
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20260417163552.807548-1-michael.bommarito@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/usbip/vudc_dev.c      |    1 +
 drivers/usb/usbip/vudc_transfer.c |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -633,6 +633,7 @@ int vudc_remove(struct platform_device *
 {
 	struct vudc *udc = platform_get_drvdata(pdev);
 
+	v_stop_timer(udc);
 	usb_del_gadget_udc(&udc->gadget);
 	cleanup_vudc_hw(udc);
 	kfree(udc);
--- a/drivers/usb/usbip/vudc_transfer.c
+++ b/drivers/usb/usbip/vudc_transfer.c
@@ -490,7 +490,8 @@ void v_stop_timer(struct vudc *udc)
 {
 	struct transfer_timer *t = &udc->tr_timer;
 
-	/* timer itself will take care of stopping */
+	/* Delete the timer synchronously before teardown frees udc. */
 	dev_dbg(&udc->pdev->dev, "timer stop");
+	timer_delete_sync(&t->timer);
 	t->state = VUDC_TR_STOPPED;
 }


