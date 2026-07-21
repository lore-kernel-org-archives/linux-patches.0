Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9338B415F0C;
	Tue, 21 Jul 2026 22:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674775; cv=none; b=ddAHfMsIfEAhX6LURf2C7n+7EV4i7Ol0lUwkbgwHX0EPdkklyYmhg/eDGKC5UIdtFV71fz4/6V914qO33mrFXX3/4xK/7UvqPYW7EEQ32b8VHS/ONUhCihKS6aPITFaPWW1l/6tLMYlN7cOVhV0pde72YfEzvGn520yD5Y+PQ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674775; c=relaxed/simple;
	bh=hXGWq/8Vp5QbR5mO5olbgNFGahaCDKGeSlxEq/OZ7Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KguXS+C/AIU3I2PwHwIAhBkYMlDzOut4zW+0Ndwu7nhLqeVS+pI/Z1fc/NX1IbngXYRDQ1XKuK0yuQebjjVPamhT2VQmFuZ+c3PzjsLX8aUZ9NZNWVSaWa062Zyos82GzZmJv3d+/ab2lZQOVz5g2fE1Kkoift4ePJU3VtTGBCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS5RKtA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS5RKtA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047D71F000E9;
	Tue, 21 Jul 2026 22:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674774;
	bh=Fs2I1ubNZsyNs7db74tUaG0+DekVkVcRSE0ZzeXsxVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yS5RKtA8EUxQUEWWgDuvWierpSJCSLby1IERRicI3oeWfo7GjGifYKdPBQ6FMw200
	 yhtqlGCwrfeFb8UCXmEqwLl0/G+204VVoOpkmKdUGwfAAge8yTDM/skvnoEg2Po82u
	 CuxCLTJPtWaxGE/8b4bgd8mvMEoVeQtlWIUzcUk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 667/699] USB: serial: digi_acceleport: fix write buffer corruption
Date: Tue, 21 Jul 2026 17:27:06 +0200
Message-ID: <20260721152410.810060345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 24ca1fea8f2753bf33e1d458ec1ae5d9b7796a65 ]

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
[ adjusted context for 5.10's `&port->write_wait` (no `priv->write_wait`) and kept the existing `unsigned long flags = 0;` declaration alongside the new `expire` variable ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 	unsigned long flags = 0;
 
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
 				&port->write_wait, DIGI_RETRY_TIMEOUT,
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


