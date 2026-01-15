Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01A22C21F4;
	Thu, 15 Jan 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498832; cv=none; b=IDgpdSt7rk6NX+PCRhZhUi7+QNwSOg1K6TJGCA6hZSnDd/2NvB/kekwXc2MpleOAAH7Jd21/EJyfbaNXTD2GJ2bmvRnCvDJxkfnNOicWr7yIxxiZZ9DlEsoJHBpBr5L3MoFcipDN9aBJKcdYrJdl+eZWHu1W8PkokzJWFRfkK8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498832; c=relaxed/simple;
	bh=v3KeZSkV2F1Fq440TzrHfPJ+dl4Zkk13fQ4XhaypkvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo/kQiS4y8KRhodd6Ai/1yLxuTdS/8mjiZqCrNLw9U0rpOvGB2K1gu/EwJukYGaVqtjHQty9LmSdx1OdEATAYf6IJiYIIcWyh4yZE7OC7jm106Tbih3du+Cqdn9tl3ENGwWhP52m17SNvu50cDfGVQuLNj/9HDA3h4ukvyOzr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmCDeCNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmCDeCNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59629C19423;
	Thu, 15 Jan 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498832;
	bh=v3KeZSkV2F1Fq440TzrHfPJ+dl4Zkk13fQ4XhaypkvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmCDeCNIWtmNV9N2lF0B+jpKuIMTajSd137uMfIe+YhCuYoru9txBExtI0ejriHtr
	 w8VAvLBTY/OiK8lYk1zeCXzm1I6V2lk744YdTM3VMsTXRymsoHmQTA43kK+WKaN7/a
	 Cmwx+SYDuT9xlY369/vSaYRkFvI5NpY3ejZ1cYhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 015/451] USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC
Date: Thu, 15 Jan 2026 17:43:36 +0100
Message-ID: <20260115164231.441137932@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
@@ -448,7 +448,7 @@ static int belkin_sa_tiocmset(struct tty
 	struct belkin_sa_private *priv = usb_get_serial_port_data(port);
 	unsigned long control_state;
 	unsigned long flags;
-	int retval;
+	int retval = 0;
 	int rts = 0;
 	int dtr = 0;
 
@@ -465,26 +465,32 @@ static int belkin_sa_tiocmset(struct tty
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


