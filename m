Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DDA3195EF;
	Thu, 16 Jul 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211121; cv=none; b=G7mvFsVBtUg5uACGn3ZIZQMvfQh+ChqjP/H+gJ2GOezbAEM8IXVgPY/aAmWKpP4Ez3JmhP53Z43o/7Ly45cxvdumkDKbm8lTeBXEcFgeV3pZZsD+CHVvzuMwE/is0w2YIi15H5wGLRgIFsEpuCX3h6kbUesVf17zR3WaafAdcWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211121; c=relaxed/simple;
	bh=DiLFRNJdW1MOU+S+sMm3NtquUhNm2PKNzSqobnxDj9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX4aTpohr8vNkYHTzx2pE0KWDaTAMMpu5jZPYLMatbRo+pB3JRVanRxygZU+xsTGZUr4wqySiLSvkfWTd38mmjZiJg5YLAzHZRb8KO7EmVdRPXGqitusAW7w8QW6wFFVMzNlJAOScqN9n0MgY+akyHMXiFQfyoei5fDR146AZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlNQ3EDu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlNQ3EDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DE41F000E9;
	Thu, 16 Jul 2026 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211119;
	bh=juib058C3yrhQ5fGmCYZoB7AkKKFBkgNeMgnttoiOww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlNQ3EDuwjXYuNk9mtj53do+vSsKF2rzzsQhT20H97H9SOAZNcy7eWxIzQrLui2EB
	 kjMvqLbn0qQHt5eK0MN1LfXdwwSBdunv4QoR6az0JeytNdILg8oXSdYo7GSolWYJ4x
	 nvmZUNfhdtyLF7n1KxsxeCEEGPy74JYY4hAUAbH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 306/480] USB: serial: digi_acceleport: fix write buffer corruption
Date: Thu, 16 Jul 2026 15:30:53 +0200
Message-ID: <20260716133051.438500294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 24ca1fea8f2753bf33e1d458ec1ae5d9b7796a65 upstream.

The digi_write_inb_command() is supposed to wait for the write urb to
become available or return an error, but instead it updates the transfer
buffer and tries to resubmit the urb on timeout.

To make things worse, for commands like break control where no timeout
is used, the driver would corrupt the urb immediately due to a broken
jiffies comparison (on 32-bit machines this takes five minutes of uptime
to trigger due to INITIAL_JIFFIES).

Fix this by adding the missing return on timeout and waiting
indefinitely when no timeout has been specified as intended.

This issue was (sort of) flagged by Sashiko when reviewing an unrelated
change to the driver.

Link: https://sashiko.dev/#/patchset/20260610132232.356139-1-johan%40kernel.org?part=11
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/digi_acceleport.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -431,20 +431,22 @@ static int digi_write_inb_command(struct
 	int len;
 	struct digi_port *priv = usb_get_serial_port_data(port);
 	unsigned char *data = port->write_urb->transfer_buffer;
+	unsigned long expire;
 	unsigned long flags;
 
 	dev_dbg(&port->dev, "digi_write_inb_command: TOP: port=%d, count=%d\n",
 		priv->dp_port_num, count);
 
 	if (timeout)
-		timeout += jiffies;
-	else
-		timeout = ULONG_MAX;
+		expire = jiffies + timeout;
 
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 	while (count > 0 && ret == 0) {
-		while (priv->dp_write_urb_in_use &&
-		       time_before(jiffies, timeout)) {
+		while (priv->dp_write_urb_in_use) {
+			if (timeout && time_after(jiffies, expire)) {
+				ret = -ETIMEDOUT;
+				break;
+			}
 			cond_wait_interruptible_timeout_irqrestore(
 				&priv->write_wait, DIGI_RETRY_TIMEOUT,
 				&priv->dp_port_lock, flags);
@@ -453,6 +455,9 @@ static int digi_write_inb_command(struct
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
 		}
 
+		if (ret)
+			break;
+
 		/* len must be a multiple of 4 and small enough to */
 		/* guarantee the write will send buffered data first, */
 		/* so commands are in order with data and not split */


