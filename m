Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB1715B122;
	Wed,  5 Feb 2025 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768606; cv=none; b=AeW++CqZqM8V8ILvBccmGbuqJZ/wihQ44M2yzpe00oirTXps0ATBxJ1x9wI2ovMTCWRwYbqwMlbyS18fj7huKw7LWROA2AYqZilHb+6gfKn+/yA2e2ij0om5FBJ/sTHrtEAn5c1kCxsPOESBzm6oRl/9lpkj6O7RWLTfj4nlQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768606; c=relaxed/simple;
	bh=MXaWJa36/GBMseAx6OJlBuUviUbad68PD34TrbvTPD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skqnajg8VNnxOeXbd3YeIkyIUeezNQlbeO7R7Q5wyEB6pemRiysV1s9nDI2iU9NPmlrMF9Naa4gXtBMh68Dpa9aTynjjlvKfBa/AW27WVBRO+Kuz57WD8tnKmOzVDKnZVR+opF+7IF6H5vwCfx+dscobfuhtZQ0Hz+jhyzKlLro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEC4DDHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEC4DDHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E001CC4CED1;
	Wed,  5 Feb 2025 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768606;
	bh=MXaWJa36/GBMseAx6OJlBuUviUbad68PD34TrbvTPD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEC4DDHhbiwigUuN33y9Uhh6J7FabfxuRSbL3X3n4b4/8uLRzXQ2+b8nJ6xN2KYi6
	 yJBAtErk8ukyYlgq+VTHUNn01JzHRRGYAqWcXBXhJ5GwXKG1q0X6LqEgVHruyd+L8L
	 +Z+2tOioIKzc9WpCYDNIBwtzZfqISG/zSs8m3uEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.13 605/623] media: uvcvideo: Fix double free in error path
Date: Wed,  5 Feb 2025 14:45:47 +0100
Message-ID: <20250205134519.366904923@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -271,6 +271,7 @@ int uvc_status_init(struct uvc_device *d
 	dev->int_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!dev->int_urb) {
 		kfree(dev->status);
+		dev->status = NULL;
 		return -ENOMEM;
 	}
 


