Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E942F12D9;
	Fri, 17 Oct 2025 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714347; cv=none; b=FJ+XQNuEVT+1cW6uEBSj80p34YTIpxqikohqNkklfzxwr8CuFbES2HzOH5uchY8RMZ2nzwOqJCOs3GznvTzNocGW7bZf5ppdD9VNv6FXmZ37d30GnvN2qRY9g2hSm7FgyE9i4kURyC+aZvxAaNPb2oJLeIG9EL+5gLMwWuICrC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714347; c=relaxed/simple;
	bh=LsZg75N0lA+uEXJfVm+PXgAOkF9h9qlh3FJWbpu9ED4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAMXBNBiM8PnSV2U4gIdTCOYeFZ4om8ks9UQkNIi8VDxk7Yhgts3kcSJ2+tCjxG24MBdkrARArJC+wQcoErfEjaUCJ+LLiWrk4qTJY6Tez0tbfdWW39vfDT1qREaMoqNvc4KZSq+QhQ/xL5D7dLTOy6xOIq+7Q3v9gmvoDS8jNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNjj/Tbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNjj/Tbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4C7C4CEE7;
	Fri, 17 Oct 2025 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714347;
	bh=LsZg75N0lA+uEXJfVm+PXgAOkF9h9qlh3FJWbpu9ED4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNjj/TbuoSmfaYCsqQKPhOK3R1ioBj2xykLC5a6lY/qeGuJkv+zg2S1ddLprgp4Xn
	 +x+EtjbgncE2lFs0SeS88Ye4h2dPe8PkL3rmA2x2Oqd0VDSNECxJ91X9Y843tr/0dl
	 n+XhQoPqJjWkdlt8f5oLpxV4nx8nW4bLFe/Rg+Ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 114/277] media: lirc: Fix error handling in lirc_register()
Date: Fri, 17 Oct 2025 16:52:01 +0200
Message-ID: <20251017145151.290069704@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 4f4098c57e139ad972154077fb45c3e3141555dd upstream.

When cdev_device_add() failed, calling put_device() to explicitly
release dev->lirc_dev. Otherwise, it could cause the fault of the
reference count.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a6ddd4fecbb0 ("media: lirc: remove last remnants of lirc kapi")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/lirc_dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -736,11 +736,11 @@ int lirc_register(struct rc_dev *dev)
 
 	cdev_init(&dev->lirc_cdev, &lirc_fops);
 
+	get_device(&dev->dev);
+
 	err = cdev_device_add(&dev->lirc_cdev, &dev->lirc_dev);
 	if (err)
-		goto out_ida;
-
-	get_device(&dev->dev);
+		goto out_put_device;
 
 	switch (dev->driver_type) {
 	case RC_DRIVER_SCANCODE:
@@ -764,7 +764,8 @@ int lirc_register(struct rc_dev *dev)
 
 	return 0;
 
-out_ida:
+out_put_device:
+	put_device(&dev->lirc_dev);
 	ida_free(&lirc_ida, minor);
 	return err;
 }


