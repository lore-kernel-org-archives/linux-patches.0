Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A295722F0F;
	Thu, 18 Jan 2024 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575082; cv=none; b=Zm+FGK9pH9/eUdV1llL/u4S4SQjwVGiZzXMBv4d31YYXzCItBT7tIjAHFzhjb0Vej7CyKNThTyaYfLFwgY9ZUds+aJPMeScpu7Xea32+ciJfzuvAqwqtLeXa1UFQjrOi6jj4y5RKaf+qYjnFxi30abUeYE7snPC+B1EWnThG3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575082; c=relaxed/simple;
	bh=6XTz+Of4eRkxGNjAtfIL5dEGZOIGf50+gPiboboxYqQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=cbYA8Yyamd14AxHXWoqTjFOVYmSbxeGlGCQgJDrh6n+gZ/IHu66vUcDAGGb/0jhgHD5d/jZ6c7QaAps6cGt1/R29yo0Hm0FChjQrujw5Z600y31Erv2bQLtWkRC3TRimell9lb1DaseYO9ue7sIipKto0xnjAWIhqoz5BNBVEyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irr8aOQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irr8aOQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61DDC433F1;
	Thu, 18 Jan 2024 10:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575082;
	bh=6XTz+Of4eRkxGNjAtfIL5dEGZOIGf50+gPiboboxYqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irr8aOQk5xl3GZkmmKa/tRt6/85Cxu9GjQTI9n22ATF59elTheYP0Kgcs1hL5udu1
	 tkHYf1fMYfekQc52oXHAbn52YtxrKKLTAQHLi/AvLh3ggNRBNneIJWmxqoHyiskS+V
	 lmD48ecJm1nEL7xPITsAxttuKQRwHpE//y8VRq8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 6.7 20/28] uio: Fix use-after-free in uio_open
Date: Thu, 18 Jan 2024 11:49:10 +0100
Message-ID: <20240118104301.930766266@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

commit 0c9ae0b8605078eafc3bea053cc78791e97ba2e2 upstream.

core-1				core-2
-------------------------------------------------------
uio_unregister_device		uio_open
				idev = idr_find()
device_unregister(&idev->dev)
put_device(&idev->dev)
uio_device_release
				get_device(&idev->dev)
kfree(idev)
uio_free_minor(minor)
				uio_release
				put_device(&idev->dev)
				kfree(idev)
-------------------------------------------------------

In the core-1 uio_unregister_device(), the device_unregister will kfree
idev when the idev->dev kobject ref is 1. But after core-1
device_unregister, put_device and before doing kfree, the core-2 may
get_device. Then:
1. After core-1 kfree idev, the core-2 will do use-after-free for idev.
2. When core-2 do uio_release and put_device, the idev will be double
   freed.

To address this issue, we can get idev atomic & inc idev reference with
minor_lock.

Fixes: 57c5f4df0a5a ("uio: fix crash after the device is unregistered")
Cc: stable <stable@kernel.org>
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/1703152663-59949-1-git-send-email-guanghuifeng@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -466,13 +466,13 @@ static int uio_open(struct inode *inode,
 
 	mutex_lock(&minor_lock);
 	idev = idr_find(&uio_idr, iminor(inode));
-	mutex_unlock(&minor_lock);
 	if (!idev) {
 		ret = -ENODEV;
+		mutex_unlock(&minor_lock);
 		goto out;
 	}
-
 	get_device(&idev->dev);
+	mutex_unlock(&minor_lock);
 
 	if (!try_module_get(idev->owner)) {
 		ret = -ENODEV;
@@ -1064,9 +1064,8 @@ void uio_unregister_device(struct uio_in
 	wake_up_interruptible(&idev->wait);
 	kill_fasync(&idev->async_queue, SIGIO, POLL_HUP);
 
-	device_unregister(&idev->dev);
-
 	uio_free_minor(minor);
+	device_unregister(&idev->dev);
 
 	return;
 }


