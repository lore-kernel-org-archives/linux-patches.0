Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A7B4BEE2A;
	Sat, 12 Sep 2026 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219743; cv=none; b=JtxnQulE2fT+XVbLB+T4ayPtUxwszG+SXFzB561wOzEipJ8Hbf3vlTb4XCc0qPTIdl+17SwOhL14jrqHOkyopqhV5C3TMdL+HYf6vYVpQHC9OL4SlecW3McDCCmu2XgcsXja1tUtxoVAOLnD6dVydGB85vA+llZHRg+QvnjZ/Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219743; c=relaxed/simple;
	bh=xCSJGjaEPZ998bhfW2VugOtAbuF4bthVQ/jc7bMifD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2tKG/17MaZWrUVKOQWTpnbRZQmv970BcMyZFufTAZVZyFZcdhsH76A0cs+8SvsIM45OYR+TmJB03l2QXRXfLTwzkqmjHstCwICIroqlx/hK3wyWAnE7x2HKpfD7V1fNQUo3J55PEW/MuGsOaslCzuRK+iPPfKk4/oRVPLmFSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxAzygTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxAzygTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC8D1F000FF;
	Sat, 12 Sep 2026 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219741;
	bh=krNzcryviutxezO5+xKh+86lEBuBRiNTMfpRPA1ZBDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mxAzygTomg/RZPUc9Ji78lqj7KtiwErvz5ByNrN7B4Q1MvuNwDQaH4pktn6pE/lwo
	 AfE72POcApJ6f3Az2Br5vfkMm1xJ8XqL+gDpHmd8kbSns0nPSeFusjRb43BDNwtIBR
	 rM1/fS06XjJf/LFeVhhidhFg8Ih3bezzeVqF+VS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de553c19cb054f174a35@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>
Subject: [PATCH 6.6 0036/1424] usb: gadget: uvc: fix dangling pointers in uvc_function_bind() and uvc_function_unbind()
Date: Sat, 12 Sep 2026 08:41:08 +0200
Message-ID: <20260912065608.113520069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -876,9 +876,12 @@ error_unlock:
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
@@ -1060,7 +1063,9 @@ static void uvc_function_unbind(struct u
 	uvc->vdev_release_done = NULL;
 
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
+	uvc->control_req = NULL;
 	kfree(uvc->control_buf);
+	uvc->control_buf = NULL;
 
 	usb_free_all_descriptors(f);
 }


