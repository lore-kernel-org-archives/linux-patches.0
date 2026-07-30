Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFFC3C1D70;
	Thu, 30 Jul 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425564; cv=none; b=dzox5D8v/URbvMI81BSW3AA3YmxdcLy3UuwvGU/1slHhUGU59Ms19v5ksQy0mmZhB9YBdqvhnjU/Ll4O+yRu9XZ30//uosn85r606brJM06ZhUn7L3QIThWxjUU8QDjFQrGxcrInkEjwzpmrqf4RYQJ01Sm0OkFuHvjbvZFvWCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425564; c=relaxed/simple;
	bh=n2e+dJ6JAMbHN09cbwqajwnI1hK1QMSiAv2RSeVvUPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8jgfn6XLh/7u/tQhcDb90z/Hafgn00Jm2y+sfW9rJWeDIm+w810B/L0bffL41gmUrT3998Jqp+1sZbArbv15EyarXq55p9TI+WiNmB8561YHxp+fAz85AzfT71s4WDIutVr2ZfsaE4H+/KQ/7b6B+PYkjlXV51aDdOEvgcu5fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OItAq+2z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OItAq+2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C132D1F000E9;
	Thu, 30 Jul 2026 15:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425563;
	bh=QiF+gpPrgYx76ARo/Ue3Yvm2Aw3J9106Ri8fohG2lTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OItAq+2z2TlXDvBAfpMAxdePgI9sp+UXScIOe91Ax4Xm1iqQlT5CQxsonh9X87gnd
	 MqQRjpp4wNrRaM+ucHJkLHaksl3eCzCyla9aPkBnxC/UovbLwCeompszLrI48XPBgm
	 Hf67StaO7ivEH61lnsrs+no+OkHs8kcNQpAtxcS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 113/602] usb: core: sysfs: add lock to bos_descriptors_read()
Date: Thu, 30 Jul 2026 16:08:25 +0200
Message-ID: <20260730141438.365884797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
 static BIN_ATTR_RO(bos_descriptors, 65535); /* max-size BOS */


