Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3E3137C55;
	Tue, 23 Jan 2024 01:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972126; cv=none; b=egqJQzUz62/EV12nQag7C0or3CbZeYBevLxWwE90cs78j7CQ5bzTC/IgnlMrXxeltrb0R1W2vvN95H7KP4XpHT5bj/+FmNFTzcguynurw7AMNvqO/2t7znTbJWVfYrLJ7kUJBVTYAdPXFJjhRmygX093PKi5dmYFkB7xVCMV5JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972126; c=relaxed/simple;
	bh=n1XuVIRJ4k11X2S/jyUIryA7lFcXEVOpX0L5ARNRy7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1bssV7LIb9eP79rzxro0DL9sWBgm8VM2YLu2AZ/GrvMX3CWS1Zat0Pa7cPrFtCZb8NU1Pm+TZ94gCzblKXU66NPfQbqCJdGK9lv2hNaFfXfYMdf2THFGinVUa76WKmqql+7nOpzxN0ZeHwm2xsmJ4QbOAqdnXe0+xY21d13Z8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/EWiSZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/EWiSZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEDDC43399;
	Tue, 23 Jan 2024 01:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972126;
	bh=n1XuVIRJ4k11X2S/jyUIryA7lFcXEVOpX0L5ARNRy7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/EWiSZVG2rEhT06b5ISAlq8BZkZ71Fq0Io4x6kHkICnwIZBKcVRXcQ1p+HPwS0KH
	 fRR6oGHLN36j3dDUtNsWN7b5cEgH4w7M24+dbjbpbomATsw8/W9wnQIzNEe4u8h57i
	 LwY6ad5QjnmUnBzF47yk1CpQWFcLWM/VMpCxYZPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: [PATCH 5.15 059/374] uio: Fix use-after-free in uio_open
Date: Mon, 22 Jan 2024 15:55:15 -0800
Message-ID: <20240122235746.658160536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,13 +464,13 @@ static int uio_open(struct inode *inode,
 
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
@@ -1062,9 +1062,8 @@ void uio_unregister_device(struct uio_in
 	wake_up_interruptible(&idev->wait);
 	kill_fasync(&idev->async_queue, SIGIO, POLL_HUP);
 
-	device_unregister(&idev->dev);
-
 	uio_free_minor(minor);
+	device_unregister(&idev->dev);
 
 	return;
 }


