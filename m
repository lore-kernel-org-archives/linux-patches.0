Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F094BD0E7;
	Mon, 31 Aug 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185086; cv=none; b=MTDsOusjigdrXM1jA6X2v97BIbiV9+ryyqu1Ry+cvKl4MTHp5CWsdnLRmRklOUuDWr7KZiNaeAubRcuhgrGBNeDPltt1sGHiS39GY4meoHKcSfnZnhy9hFQ+KE/qk8OuOy66ijYT7diAQQBJjzK+9ii2bXbCULzi+iSmXRSmAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185086; c=relaxed/simple;
	bh=L5uzHJjZKPStT7FCFArwJsnvpE9gKQU3dJNuz0Wvh0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX/u0xy4RcskEfbG3Kh8tD8m7Uj4lkNj7pRStSginJp7l0obNtM6dWNocPWHhklfmKOjG/2fHuHLbNpvCNy9BbKuDQld805K6brZmk5wHxM+pOvm50AkjfaggNFNBzLSf6L3PEDH6XwUSJ/cGH+RwCAPi1H0lz485Ec61w5Hlpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEKLnS5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEKLnS5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169D21F000E9;
	Mon, 31 Aug 2026 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185084;
	bh=FJzbWwSU310fCWaqksIJsary6cEgETOFnubHjciq02E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEKLnS5XY4IXKJIDb7vf91H1KFN1zAp4DEMZuJGiQ6AhtiPdqMkoVMiML49ObV+I5
	 J2BA1oLoGw76tx3mdkxUhOCFrFnB0s8W+ol1R0haTAk0AhQjxwnAU04LWXTNg+QyNH
	 o0OBQb0ckLozvBQhDxC1hGY4AwMlGjdQf+1CIwwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH 5.15 48/69] usb: usbtest: disable dynamic ID support
Date: Mon, 31 Aug 2026 15:35:21 +0200
Message-ID: <20260831133401.051160157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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
@@ -3053,6 +3053,7 @@ static struct usb_driver usbtest_driver
 	.disconnect =	usbtest_disconnect,
 	.suspend =	usbtest_suspend,
 	.resume =	usbtest_resume,
+	.no_dynamic_id = 1,
 };
 
 /*-------------------------------------------------------------------------*/


