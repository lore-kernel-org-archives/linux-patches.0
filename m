Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1663A1EF0BA;
	Tue, 15 Oct 2024 12:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994305; cv=none; b=W8uBMv1l/xYrL/PuqqkUW/HaMc9wKmuEbg4jQr/7e5EXRjMgn/iP5MEkuKUH+45GDt6HtAtisbQCAhZc1/nF+WZE+dBkuAKDxNbP4kufKnZ94ZjTfMlEai9BjOZWLJeR9ZhmujJbrHVoIW3nLjZMrusa0cgbZjM2tNqEj2THcXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994305; c=relaxed/simple;
	bh=t31HJX0AXQJI2CnKtt+Bpac0NqFRNkUreHSK//TmSAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejBblheEYcZVGTVEdUS6Dlb84K5WbgzLMFusQrb+PeUQTnjx6q1a0oaSIlLiPEiid/orSJsqkDBdMHeNMzPaLqiqWKF+HT7hbjk48IPoDEpLahagsACMqWAtROgGI18+Xs3cmBlncHG528Cq0dE27E3Bw+GP4F9XjcrqqVOIayU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZeGpx1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZeGpx1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908A6C4CECE;
	Tue, 15 Oct 2024 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994305;
	bh=t31HJX0AXQJI2CnKtt+Bpac0NqFRNkUreHSK//TmSAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZeGpx1AalYcf7XTWFcOLsEAqBZOWy6rYKZhiRkI4gYv3FVhCwVqoiFlsMgMG5mdZ
	 TJ3LHYoc8fwEgVupdHwZFzgkq4MQygsUyB+erKvBlhHAd+fHDQ22f9DQIkcGUIaVix
	 MhVlXf/ijV9zTu1hxX6zPQnQ8hfashY0KvmvjGCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 667/691] Revert "usb: yurex: Replace snprintf() with the safer scnprintf() variant"
Date: Tue, 15 Oct 2024 13:30:15 +0200
Message-ID: <20241015112506.797621888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit 71c717cd8a2e180126932cc6851ff21c1d04d69a upstream.

This reverts commit 86b20af11e84c26ae3fde4dcc4f490948e3f8035.

This patch leads to passing 0 to simple_read_from_buffer()
as a fifth argument, turning the read method into a nop.
The change is fundamentally flawed, as it breaks the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20241007094004.242122-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -34,8 +34,6 @@
 #define YUREX_BUF_SIZE		8
 #define YUREX_WRITE_TIMEOUT	(HZ*2)
 
-#define MAX_S64_STRLEN 20 /* {-}922337203685477580{7,8} */
-
 /* table of devices that work with this driver */
 static struct usb_device_id yurex_table[] = {
 	{ USB_DEVICE(YUREX_VENDOR_ID, YUREX_PRODUCT_ID) },
@@ -403,7 +401,8 @@ static ssize_t yurex_read(struct file *f
 {
 	struct usb_yurex *dev;
 	int len = 0;
-	char in_buffer[MAX_S64_STRLEN];
+	char in_buffer[20];
+	unsigned long flags;
 
 	dev = file->private_data;
 
@@ -413,16 +412,14 @@ static ssize_t yurex_read(struct file *f
 		return -ENODEV;
 	}
 
-	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN)) {
-		mutex_unlock(&dev->io_mutex);
-		return -EIO;
-	}
-
-	spin_lock_irq(&dev->lock);
-	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
-	spin_unlock_irq(&dev->lock);
+	spin_lock_irqsave(&dev->lock, flags);
+	len = snprintf(in_buffer, 20, "%lld\n", dev->bbu);
+	spin_unlock_irqrestore(&dev->lock, flags);
 	mutex_unlock(&dev->io_mutex);
 
+	if (WARN_ON_ONCE(len >= sizeof(in_buffer)))
+		return -EIO;
+
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
 }
 


