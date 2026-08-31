Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ADB572694;
	Mon, 31 Aug 2026 13:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184129; cv=none; b=KycXlz/CId8C5s6NXSP0A4p5/ZT0xaKIkI5epab4SYpPIbbI8YxXs2SGXq8M0Q8KSvBLdsGQt6U/wPGWsmmRgnVyrtrCWaWQhzRU3uXBa+S8/bcMxy+rYixrj2LCejIbAEsMFNSeWLOwMu3fmZtGH2L+gKVXfxoKAoVPK8F6VAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184129; c=relaxed/simple;
	bh=RaElDS+c/Q1wberwx68yo5vr9ORd+SHgsytznX5uDwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkviWUs9WElCUwiKwB9gCTOJOubpbuz4K4YpwWPC+3uViblkzjeofYzy+xWRL0cRu/5E2Z1tJBA0NYT+uDATlJnBQ5MbpAfoxLR8PkOaTLtiJ8fCSbWBKBugxv27hIMxi2H1sbNu+usqSIdqvxsv+OaZd46MQpeo6NztRhb6qqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OFXvjmVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OFXvjmVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C131F00A3E;
	Mon, 31 Aug 2026 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184127;
	bh=eRircS0tnNE7f9HWTAwHC2VEFU5tSPv5CXl4k0UUexs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFXvjmVhPcLn5k/fnODhBgOevyTKwQ0BpddWFpvxJyl9/sH1x8RygKz0UaL7FJ/jH
	 Dhmf7qGRM5mkf7zTr8UBnlzyBSfMURxVLnK1k0reWlM5i6m/wX8NX4fRzIJ/vz/X8k
	 a8KGr7cGPqKvYKWs1zC0OCxRIZMu1asJmVZRrZWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH 6.18 38/83] usb: usbtest: disable dynamic ID support
Date: Mon, 31 Aug 2026 15:34:14 +0200
Message-ID: <20260831133401.437896429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Aleksandr Nogikh <nogikh@google.com>

commit 00e2071f6d5621a5ddea311a5e6b143ae6e474af upstream.

The usbtest driver relies on the driver_info field of struct usb_device_id
to point to a valid struct usbtest_info descriptor. This structure contains
essential test configurations, such as endpoint addresses and test modes,
which are required during probe.

When a user dynamically adds a new device ID via the sysfs new_id
interface without specifying a reference device, the USB core initializes
driver_info to 0 (NULL). When a matching device is subsequently probed,
usbtest_probe() unconditionally casts driver_info to a struct usbtest_info
pointer and dereferences it, leading to a NULL pointer dereference crash:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2822

Because usbtest strictly requires pre-defined usbtest_info descriptors
to function, dynamic ID binding via sysfs is fundamentally unsupported
for this driver.

Fix this by setting .no_dynamic_id = 1 on usbtest_driver. This instructs
the USB core to skip creating the new_id and remove_id sysfs interfaces
for usbtest, preventing invalid dynamic ID entries from being created.

Cc: stable@vger.kernel.org
Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20260806152651.2370795-1-nogikh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usbtest.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -3054,6 +3054,7 @@ static struct usb_driver usbtest_driver
 	.disconnect =	usbtest_disconnect,
 	.suspend =	usbtest_suspend,
 	.resume =	usbtest_resume,
+	.no_dynamic_id = 1,
 };
 
 /*-------------------------------------------------------------------------*/


