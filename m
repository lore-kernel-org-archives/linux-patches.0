Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E65217C79;
	Wed,  5 Feb 2025 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768209; cv=none; b=lnvTmgq1UegTn/R9hew3rLoJ2nhXNkoPV/cA4BMN8oiIVuDCw1u5bn6mnIXcj44fM0upzUIhSUiY7gZODr89+sBX5kzCh3zLvMwla+Vh7Hu2vn6SaA05yQXQPHQoZteOQHEz3xy9GH9jo9PiVTtFtf5jHH2ObpvwiOq0dRwFkgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768209; c=relaxed/simple;
	bh=+1MrDgLSRRXr97S9U0X3GvvgsFJvDxdpRa0/5ZYaMn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd1iOsFiJFop3fyvu06054b/Khu0mfEfFScudKzChxAD5PDx00LuIgsFA1X60LXy1hfm1kcd67B4nOnPrBVQjbXn6VVL3G+6ChDJuLYihaLqa9rS557vw7KHJeXNNlgOuM9EhsYARGURcsqmCI/Ut914vNeMUct/62SzfUwFJfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qEo1vuY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qEo1vuY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9ACC4CED1;
	Wed,  5 Feb 2025 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768209;
	bh=+1MrDgLSRRXr97S9U0X3GvvgsFJvDxdpRa0/5ZYaMn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qEo1vuY2GZJLzRbwoZJXk24FnPzgI5JIRQ7MsLLHT64mW0NmbkiQUB3s5dPw+Zbhd
	 bN7Y8+TB7LWcmJ0ZjzIaG8pbqzssmR/XrbVMKiAVMMfRj6JZMUedKAclRepD5go6X1
	 2k+QRP1bFKS0XhY1RjHbpyDvi4+LYxRp/1oUCykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 568/590] media: uvcvideo: Fix double free in error path
Date: Wed,  5 Feb 2025 14:45:23 +0100
Message-ID: <20250205134516.998213014@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit c6ef3a7fa97ec823a1e1af9085cf13db9f7b3bac upstream.

If the uvc_status_init() function fails to allocate the int_urb, it will
free the dev->status pointer but doesn't reset the pointer to NULL. This
results in the kfree() call in uvc_status_cleanup() trying to
double-free the memory. Fix it by resetting the dev->status pointer to
NULL after freeing it.

Fixes: a31a4055473b ("V4L/DVB:usbvideo:don't use part of buffer for USB transfer #4")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20241107235130.31372-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_status.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -269,6 +269,7 @@ int uvc_status_init(struct uvc_device *d
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->int_urb) {
 		kfree(dev->status);
+		dev->status = NULL;
 		return -ENOMEM;
 	}
 


