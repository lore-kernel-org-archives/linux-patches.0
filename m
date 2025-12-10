Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2849F304BBF;
	Wed, 10 Dec 2025 07:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352174; cv=none; b=qY7oOrdx+FGhOc6u9Mf7XmAWDEu4f1025YXUoOvxnmQsKZ6JUcVqD3eK647y7iFOHQ//Q08WcZUHqLiB+D3Wfaa4j+YFHkkHE6jUdugZz+CcmdQQSGaEpMips2Qiw8ooJy7Fkz7zpn5HOzRf1QFAxepNEhKXmK/1/bRL/sIEAOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352174; c=relaxed/simple;
	bh=Xw2mJ96CqwdIqzVpQ0SNeoLwEemTZg1L9h7cp0RiRW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c429I5UOLW9ffBiQuxxXg/gxqebr5p4/1VXjLl4LJkvjyVBuygTdsc38FpYhfab1qSCsiKXjLm2S6mEzMD9KaTEucQ4EnHZ+gzIG+dXr7h2g1H7WVfSkrDWVTAgTWmficspjC8NzrMtLM0f+CmtOwRTnBkvPGxrFdwQgjHAsaDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKKQhUMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKKQhUMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78715C4CEF1;
	Wed, 10 Dec 2025 07:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352174;
	bh=Xw2mJ96CqwdIqzVpQ0SNeoLwEemTZg1L9h7cp0RiRW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKKQhUMhAH0y6dt9kAt0jpiuc1JlYy7YZJu+L0ki8IV+EZrj0pc1sJ0B+4bb9BXtJ
	 88fEmzAednti4LMImM5QJjJwf0Bm2WjV/NPDirb5BoEu8LIQPyWZKyurSOzi3frE/j
	 1VOomlo5IoE4XBVmhLaaEKGUw4gq8FgvxHGKLpwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 18/29] USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC
Date: Wed, 10 Dec 2025 16:30:28 +0900
Message-ID: <20251210072944.861607961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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


