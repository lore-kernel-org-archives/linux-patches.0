Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F10037F75B;
	Sat, 12 Sep 2026 19:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241074; cv=none; b=XrVVUiqkoDX5WQgsmkfm7ki3caioiqxaGK2wz8MkbGYdx8U3manJTqhP1FtQJba0gQzXiol7rQdVFeBUyzq/2N38cxDNGASbV1iA8xYzo9calzdYx0UpBa7ZOWIJn7LfibVRUY4fqyuvx53Spd7N8yPe+hQZ8Hiz5mYiusM0rok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241074; c=relaxed/simple;
	bh=GdclS1Ihagot2m3JeZCzwkg0ASbx4yLr2iT+8R47hFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twhFdSX1ZMTk5VBJwuIZXMyJn/yATIhrxxj8QN68xCO8zzZTZMiOAm2yth63b/rV448GgzkSVcRs97A3MRA5SCnG9P7SivM4qCeA4sQ5L/xjbCxj1Ud2rW7YcCsc7b+Yk+R2nZEsu/k+ORa8njEfORdCxNNYkKMuXTrqUfkYcrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NVV/JBc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NVV/JBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227001F000FF;
	Sat, 12 Sep 2026 19:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241073;
	bh=4yeLqzChMHGb757Js8/IB/DutdqLGsCJ6ssK7Hv5llk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NVV/JBc9QeHO84laTj3a3L5ufVmVDg1mPeIbXGCVKWHmUYlsivAkMvho834I4PtF
	 frof9eQtWXWUa3gN4torVtBsh7K/uvOTa8XKQqtBiDr9glSBGUJS3aDyVt5H5Y1Bfh
	 GwOTrLmTg0lpAtOpK4kQnIFu0qZ8ZKdfCItzwlag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 5.10 018/798] usb: gadget: uvc: fix dangling pointers in uvc_function_bind() and uvc_function_unbind()
Date: Sat, 12 Sep 2026 08:54:06 +0200
Message-ID: <20260912065517.377700230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit bdab5605259ba5d6ff927c1a85cc83eb3ecfdacc upstream.

In uvc_function_bind() error path, we use usb_ep_free_request which
uses uvc->control_req but does not set it to NULL afterwards. Thus,
uvc->control_req is a dangling pointer causing a UAF. Also we do not set
the uvc->control_buf pointer to NULL after freeing it, which is another
dangling pointer. Fix it by setting uvc->control_req to NULL after we run
usb_ep_free_request() and uvc->control_buf to NULL after kfree. Do the
same for uvc_function_unbind().

Reported-by: syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de553c19cb054f174a35
Fixes: 0f9df9393855 ("usb: gadget: uvc: fix error path in uvc_function_bind()")
Fixes: 6d11ed76c45d ("usb: gadget: f_uvc: convert f_uvc to new function interface")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Link: https://patch.msgid.link/20260813174311.130823-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -780,9 +780,12 @@ uvc_function_bind(struct usb_configurati
 v4l2_error:
 	v4l2_device_unregister(&uvc->v4l2_dev);
 error:
-	if (uvc->control_req)
+	if (uvc->control_req) {
 		usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+		uvc->control_req = NULL;
+	}
 	kfree(uvc->control_buf);
+	uvc->control_buf = NULL;
 
 	usb_free_all_descriptors(f);
 	return ret;
@@ -957,7 +960,9 @@ static void uvc_function_unbind(struct u
 	uvc->vdev_release_done = NULL;
 
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	uvc->control_req = NULL;
 	kfree(uvc->control_buf);
+	uvc->control_buf = NULL;
 
 	usb_free_all_descriptors(f);
 }


