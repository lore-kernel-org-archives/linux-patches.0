Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48914BEE5E;
	Sat, 12 Sep 2026 15:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226684; cv=none; b=F8N/1Kg+IK8MPpdn7F78RSDDXHvqjSc597birOSIsAGGrUY0qF10twK/NHqZKEq7faJX23HKqkv1TbT9M252PJiNR77WGKp/kuE1RmhO3zSqQv0u5/qgOWrGq/x05JQ+nVMTwPYsHpD7/e7hWr3GJcYjWCb/KBI3m9/lKUDdXkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226684; c=relaxed/simple;
	bh=yAcbjMdPRihEo/v2odFkcw5Oz3+CFLmJjHddVcxeRKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCD0ciGTBByqmqJm36LmeZ1ioam4TGXhDSjWHbzo2clYsPhOHZHLCPx7et6uZm1SKbvZtaQN57Q5Q4JQYqMObCYJnlraAUYB41XZr58mNbMev3gghUab5locLClrozpc4QVvmnIeZNw6/N3WBaaymYtaO1l4QF1XzBxJW7iQj1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmNOPHAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmNOPHAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD90C1F000FF;
	Sat, 12 Sep 2026 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226682;
	bh=HlMtjGMTWKjBv4A7hS7pzStxu+0CzzxQK/BbHYeDm2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmNOPHAHC64yMXcRjwxonA70aqMapgYcfQJZ8yviDbuSbikv9NylhNVnLVrckYb1V
	 AXGdSyWlW7gTH6CdMoE3xjqQgLl1rwhv4QRp7SbAHk6JpRd/s9eZSNTNn2Qx1lGGyq
	 z4IRbUexksIZohaFoO0PmqAmxI9QYs6uFICcLvEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.1 0028/1191] usb: gadget: uvc: fix dangling pointers in uvc_function_bind() and uvc_function_unbind()
Date: Sat, 12 Sep 2026 08:45:56 +0200
Message-ID: <20260912065548.752323053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -785,9 +785,12 @@ uvc_function_bind(struct usb_configurati
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
@@ -968,7 +971,9 @@ static void uvc_function_unbind(struct u
 	uvc->vdev_release_done = NULL;
 
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	uvc->control_req = NULL;
 	kfree(uvc->control_buf);
+	uvc->control_buf = NULL;
 
 	usb_free_all_descriptors(f);
 }


