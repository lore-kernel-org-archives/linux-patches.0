Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4F2407597;
	Thu, 30 Jul 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423707; cv=none; b=I5AUjWEnZtw/L/n9EmQNO5pEm30ivR7/ATFkRI+HoQ2vENFFxcolhg6fgobTgTYLy2b0UIeTg+xIUkdaP9Wndoa8UEmfbedUEYAZkiqTbydSP9GTdlmT8r6PHGbrEuFOrLU9WmrpMVSPaEX1r08CeyUbENV1c1/bIWsLCLsj17g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423707; c=relaxed/simple;
	bh=W2Vpns4yYhos3GoG4ORXg87jlRGdr4YmUMcvA165wMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toYsrSy1VaIqS78p6ixRNAsJ+FKbgi4M/CwtF1Yw+VGqwTOHG5T+ZmpRSfz2EnW8CFlw5BbWDanBlis6x8e+U/FmmvICjKk2WuUvs3LOF47LjerLf5DqCzI64uA/dmVo4z5orjwSSAhdxwuqUhSSIVfNTTsaebrl75fy/DzI3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1EFztVx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1EFztVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314C01F000E9;
	Thu, 30 Jul 2026 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423706;
	bh=IelDKd+oXakZRtTWXuWPmLGORkAro1KSOf70nTSE008=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1EFztVxgndmEKpPAM0XNDPUXtVLfUR0WNcUxlyDVzB6Nbufz9uJqG3/Es1m6eUUK
	 DgxOQLYfMeYVvZqYxk9acBPifxGarTz0GSTPX/9BHONfjvEyjm5bG6NkaU2OSFd89v
	 EZLdD/dcR0Z3X8c71vtUfWKGs7mzhwRGdzSdFlqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 139/675] usb: core: sysfs: add lock to bos_descriptors_read()
Date: Thu, 30 Jul 2026 16:07:49 +0200
Message-ID: <20260730141448.091974052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


