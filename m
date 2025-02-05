Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D121885BE;
	Wed,  5 Feb 2025 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766675; cv=none; b=hA/aKL8VzbbQ9KeZagyNJEEFk96Wo9XjCF3ycxfdGGlyfKvhRWV0a3MuDCYNhXDuZRv9MvBus+mqH9qKr+TJn2O/u0NYBFHo6qhcT7qqUGjdxIBktkdwyszI62NRDUFbeeVwFYmmIMMsNzw5JYITwlYTMpQTeeRzFGnI2h4Ut9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766675; c=relaxed/simple;
	bh=3gktq9iSpJ39B37BuUWANhegD+cTP1JavfC+LX3VBgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5uU+ndw5mxxFwtdCeMF190eUBrB4R48sXBLslLtIKraK3sWsiFwr9LE3km60xKwp8kEFbyEpIJvzDVxG1wyPSXHf5/+HbM1O+wdc0BkpFy1/TO9btIyOhSTKX9RZyBFstglnO6JpmPgbY9do3GosaNCrcTubXxBcvJDLwU6AGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wufpJi+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wufpJi+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F7EC4CED6;
	Wed,  5 Feb 2025 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766675;
	bh=3gktq9iSpJ39B37BuUWANhegD+cTP1JavfC+LX3VBgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wufpJi+Xq1Z99NPKAxPft8FdcNs5zrfmi8cNgFglq2VsWFBVbXrIwWAxTBqYM2ecE
	 quoV3yaXVJ7+ygC+dA6bmDhttd83QGAijUEt/M1KNFVUEUYcOWeky3qtK/v6A2Uouq
	 JbSiikYztl/+axW45BSkfj8JK6HAF8WxqK47N5GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 386/393] media: uvcvideo: Fix double free in error path
Date: Wed,  5 Feb 2025 14:45:05 +0100
Message-ID: <20250205134435.063715589@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


