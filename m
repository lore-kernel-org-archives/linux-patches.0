Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562E017555;
	Sat, 30 May 2026 18:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165444; cv=none; b=ox9Xqn13Aj2CRk1AkVGfabgDKfrGUYvv825+wi7OiEBSHNN9N31v8OLB1wHH5as8Sz5R7nh+ziKpNdbdKX8w3HUgNKvXOXWPH9T1f0IzO89L2N+UvHgd5GflvH1d6++ZZd5Wz1AVs+cLhAntDOdUSCM+q/eKx+tk6sLq5eShdWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165444; c=relaxed/simple;
	bh=zczHV+iiesuxZGrVqEqJXxiUMm3Ut6xuV32OSOsqxpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+Cy4wxU5otZtVnXbs8IP0dcL+HB210IlnFs7i4irC6lbxQgoWUhDm8IgQab0u1KOYz3OH5sKTQy6NaEe/AUlosX4XLLSRq/v/y0m0CY1Ny4zoZwV8Af234TsV6I5Tw2H1pAffROwJaqsIHxTCwK3bYwg5+hP3r8oVjVTAclmDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzMq5mXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzMq5mXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1F91F00893;
	Sat, 30 May 2026 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165442;
	bh=8ZCvt6llz37doXh4S1XSOozPvO8JYxxzWrO1Oiopbnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzMq5mXo+J5wimIbJDOk/OSqueGpzioXUBOvkmuoiosp92Lp6qlmgCJDtaaE6sIjP
	 1qPqlJKhWrPvzWq4kD3AEc5bZtWt9MlWG33Cn/7MM9WSmfYHK8RDsjQhs9dVtOL1xk
	 4T/X6JdNy/WYRvnBensPEi3rkb5ymjQxXAnhQ3Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+47321e8fd5a4c84088db@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 080/589] media: as102: fix to not free memory after the device is registered in as102_usb_probe()
Date: Sat, 30 May 2026 17:59:21 +0200
Message-ID: <20260530160226.756172386@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 8bd29dbe03fc5b0f039ab2395ff37b64236d2f0c upstream.

In as102_usb driver, the following race condition occurs:
```
		CPU0						CPU1
as102_usb_probe()
  kzalloc(); // alloc as102_dev_t
  ....
  usb_register_dev();
						fd = sys_open("/path/to/dev"); // open as102 fd
						....
  usb_deregister_dev();
  ....
  kfree(); // free as102_dev_t
  ....
						sys_close(fd);
						  as102_release() // UAF!!
						    as102_usb_release()
						      kfree(); // DFB!!
```

When a USB character device registered with usb_register_dev() is later
unregistered (via usb_deregister_dev() or disconnect), the device node is
removed so new open() calls fail. However, file descriptors that are
already open do not go away immediately: they remain valid until the last
reference is dropped and the driver's .release() is invoked.

In as102, as102_usb_probe() calls usb_register_dev() and then, on an
error path, does usb_deregister_dev() and frees as102_dev_t right away.
If userspace raced a successful open() before the deregistration, that
open FD will later hit as102_release() --> as102_usb_release() and access
or free as102_dev_t again, occur a race to use-after-free and
double-free vuln.

The fix is to never kfree(as102_dev_t) directly once usb_register_dev()
has succeeded. After deregistration, defer freeing memory to .release().

In other words, let release() perform the last kfree when the final open
FD is closed.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+47321e8fd5a4c84088db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=47321e8fd5a4c84088db
Fixes: cd19f7d3e39b ("[media] as102: fix leaks at failure paths in as102_usb_probe()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/as102/as102_usb_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -405,7 +405,9 @@ static int as102_usb_probe(struct usb_in
 failed_dvb:
 	as102_free_usb_stream_buffer(as102_dev);
 failed_stream:
+	usb_set_intfdata(intf, NULL);
 	usb_deregister_dev(intf, &as102_usb_class_driver);
+	return ret;
 failed:
 	usb_put_dev(as102_dev->bus_adap.usb_dev);
 	usb_set_intfdata(intf, NULL);


