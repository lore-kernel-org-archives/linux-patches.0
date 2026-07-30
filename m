Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E1633D4E2;
	Thu, 30 Jul 2026 14:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421534; cv=none; b=SDLUu3MHZsrjr/B2G+OGxhr42kwSJsqhKUMxMFT5fNi9+FZSK+/RL0/l5tzmtfw6YovjRVsI2Cld00OvzNTtuKPKulMVJJDRJxta4C4/aSbq5+LBVH9MSLdUhfbDwH4hJy7oV5GAS2gsxhsA0dzwyshj1V0kBa/DitqyYP2ZXwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421534; c=relaxed/simple;
	bh=MAiHsBnwJ0XOQCgb3UKy2TX+20as/JQLtARXTkSGkxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKhCxv09rKU1NY4oqbkjdcXv+f/UkdQfDCW7ZiyA7Mhd9EdoRK/qduxQ8P6TLca3krpP2LW/2QscWzbIcCA8hrcmYOLPUmBczRq0BYnNQXU72Djl+VjzR9tqiH2le7iaOz/MzNyUVNHuPvwKbFTFMAGZ/jGwcf6DKfpkIxlkNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOzZ9OgA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOzZ9OgA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9CB1F000E9;
	Thu, 30 Jul 2026 14:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421533;
	bh=uXxI4fN6cwcBIZUSqt4kHd4gxw/lk6AGaHsgs8FtiiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOzZ9OgALvG9SHI4AEwAs/enS8BHvcba8IIxJC5cIEOpTtOI34ZeLRLbSKn4WXrD7
	 3Qz9NgDGoFMYJWF0xZA/yJQ9wCYMNP/EDeyOEs9VSs46YIVQ+l6gy8AebOQe8Mm1S/
	 0qL1RjMfSN0zgh4rHN3EKgsw+DHAGOxomSz49yiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 7.1 137/744] usb: core: sysfs: add lock to bos_descriptors_read()
Date: Thu, 30 Jul 2026 16:06:50 +0200
Message-ID: <20260730141447.193104551@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 4e0197fbb0eec588795d5431716a244d9ac8fa93 upstream.

Add a lock to the function bos_descriptors_read().

This function accesses udev->bos, which could be simultaneously freed in
usb_reset_and_verify_device(), a function that is commonly called in
drivers all over the kernel.

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260715-usb_core_patches_3-v1-1-53021f5576fd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/sysfs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -899,10 +899,15 @@ bos_descriptors_read(struct file *filp,
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct usb_device *udev = to_usb_device(dev);
-	struct usb_host_bos *bos = udev->bos;
+	struct usb_host_bos *bos;
 	struct usb_bos_descriptor *desc;
 	size_t desclen, n = 0;
+	int rc;
 
+	rc = usb_lock_device_interruptible(udev);
+	if (rc < 0)
+		return -EINTR;
+	bos = udev->bos;
 	if (bos) {
 		desc = bos->desc;
 		desclen = le16_to_cpu(desc->wTotalLength);
@@ -911,6 +916,7 @@ bos_descriptors_read(struct file *filp,
 			memcpy(buf, (void *) desc + off, n);
 		}
 	}
+	usb_unlock_device(udev);
 	return n;
 }
 static const BIN_ATTR_RO(bos_descriptors, 65535); /* max-size BOS */


