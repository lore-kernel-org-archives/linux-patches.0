Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39373221F2F;
	Wed, 10 Dec 2025 07:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351959; cv=none; b=JyQePphhq2ygJg2IaarYPDWUKk6lkI1G284kie+GcrvpiNeVMmmjPM+JYqQ0saqkrNXUNEegfMuxRCoJNa4e2on5MonyoVINt4EYZB3CGD4wbeDAGTg4k8dMLWB3ojYzp7/bcDuO8p3JneBaD8tCk9Xxh0cy4ydPsJ1kAQEI8pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351959; c=relaxed/simple;
	bh=EkBn5PJo+yNmz9gaaxip4yMu3TifRJTfoNwSeem2wPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG1V6sN3b0SM8fTpu55x3ZIvl32rTkuZnaq4OTwMR6RdF/ed1m0hKRSwCeYJlHpIQ5FHE3hiPCcSygBLHERbQSfCNt3LPiq5usQGvbUqqHOAdqnNGp2BMk+ZuL6nJgVNKpzDJFjpPgOvKFUA824aVjDudU5+6ipE5Y45b4ICqlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqpKDFss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqpKDFss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888D6C4CEF1;
	Wed, 10 Dec 2025 07:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351958;
	bh=EkBn5PJo+yNmz9gaaxip4yMu3TifRJTfoNwSeem2wPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqpKDFssipksnMftx6OMTbDocPHPR084ormO2pNs2DeB4Tjg8wQrSTe0xX0BUyL/W
	 1nKeH9bpx2QqX52GO+MyoUaqwNN7iSk6lz1/tbq7vOafMQk4WqxS5NFfX/Qxx+hLyv
	 pbmWTlWtMxW3GeiQWEHKs+PXjJ17yd/IHjV2UuPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 18/49] USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC
Date: Wed, 10 Dec 2025 16:29:48 +0900
Message-ID: <20251210072948.576445467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit b6e0b3016187446ddef9edac03cd9d544ac63f11 upstream.

Asserting or deasserting a modem control line using TIOCMBIS or TIOCMBIC
should not deassert any lines that are not in the mask.

Fix this long-standing regression dating back to 2003 when the
tiocmset() callback was introduced.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/belkin_sa.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -435,7 +435,7 @@ static int belkin_sa_tiocmset(struct tty
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
 	unsigned long control_state;
 	unsigned long flags;
-	int retval;
+	int retval = 0;
 	int rts = 0;
 	int dtr = 0;
 
@@ -452,26 +452,32 @@ static int belkin_sa_tiocmset(struct tty
 	}
 	if (clear & TIOCM_RTS) {
 		control_state &= ~TIOCM_RTS;
-		rts = 0;
+		rts = 1;
 	}
 	if (clear & TIOCM_DTR) {
 		control_state &= ~TIOCM_DTR;
-		dtr = 0;
+		dtr = 1;
 	}
 
 	priv->control_state = control_state;
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	retval = BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST, rts);
-	if (retval < 0) {
-		dev_err(&port->dev, "Set RTS error %d\n", retval);
-		goto exit;
+	if (rts) {
+		retval = BSA_USB_CMD(BELKIN_SA_SET_RTS_REQUEST,
+					!!(control_state & TIOCM_RTS));
+		if (retval < 0) {
+			dev_err(&port->dev, "Set RTS error %d\n", retval);
+			goto exit;
+		}
 	}
 
-	retval = BSA_USB_CMD(BELKIN_SA_SET_DTR_REQUEST, dtr);
-	if (retval < 0) {
-		dev_err(&port->dev, "Set DTR error %d\n", retval);
-		goto exit;
+	if (dtr) {
+		retval = BSA_USB_CMD(BELKIN_SA_SET_DTR_REQUEST,
+					!!(control_state & TIOCM_DTR));
+		if (retval < 0) {
+			dev_err(&port->dev, "Set DTR error %d\n", retval);
+			goto exit;
+		}
 	}
 exit:
 	return retval;


