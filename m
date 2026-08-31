Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0917347CC8C;
	Mon, 31 Aug 2026 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184701; cv=none; b=d5ixZ2T75VPgY7SBXn/rF7dmev16Mo75q87mImHcKge06iPLiEancnn9cF79K1rKGu6VVJHq4JH4V4AOukTcrj/Hu+a7K1o3YwVmkbNC4X26aK/NloDN8R+jGIHKU/v3s6pIST5bWVkGHK1EAWOX2caRWbXOVicLrXa1ZKSyYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184701; c=relaxed/simple;
	bh=mAa7CHypOd19R1nyVhfPvhWBouVGS1uqI8bdCadWJrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP7aNsPTu0Gtirfyt5j/N7Xq4ZcFqZfT2lGJcKEbwoig72bCxoS6YQcM3X6YMggDNUfcMyUWJLjiIUaEuyMnP4fc9bvpEWRFnbqt6Ov34dAV3cqNsqlnKkAt0UBFjpGwuqQT9Lmt4qxdhexn7G45O7tzoYmMhOvmRdlOUA9Fcac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVFzeWgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVFzeWgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622621F00A3D;
	Mon, 31 Aug 2026 13:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184699;
	bh=UzS1/vkNDNRLyiV1PrU30Yx9JAdEKksUxvBBCP0i94c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVFzeWgJp6dYtY+9r8E4GnPnn6gH4QCG/u5xVZiiNnkgfg7g7GbCzWtI7ocCchTLK
	 X9O18MTf/lo2JQdf82bQGFTvL3w5hCvQvuykotrfAW5Y8854NgxXg2oVD/dzZ4pWm9
	 grKhTFpj9Jc6BH19HfXVIrRDL3tE/0DfaELecoAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com,
	Aleksandr Nogikh <nogikh@google.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH 6.6 64/91] usb: usbtest: disable dynamic ID support
Date: Mon, 31 Aug 2026 15:34:52 +0200
Message-ID: <20260831133403.038429198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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


