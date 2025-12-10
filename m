Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6C02FF16C;
	Wed, 10 Dec 2025 07:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352091; cv=none; b=VZNV3leruYjVt5D1pNJuRosWde9WaCLe3nHWYi2+g3v3SufDk8xdkbciR/hjwEYti3HHJWxXtJIfmLYCtLl0lMov6mn8I+9jfhW6uH1wAqLLv5VsdARq2R4NuqIWhDJFVDxpp19PHhDmDzQITVMySeFeQQ3GvzJEohvRJdRSpB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352091; c=relaxed/simple;
	bh=GCjcuPjO3nAlK1W6HmvPBriG1PvTkVfyJE+8bqc5KMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiEhO8me/ihSAIqA02J+WUJdAhsJNpAyf2z8oIgTUFxIy6jl+f1ervSwnWEP4mx0qWs0zSe2omPVZFmjeVBXg4rYe6K0JuZAZj9YtS6NN2UDmNMNHh2aEJivEGGLBO4XjFsrVAHUWRT7tYPsZsKSIaaHCPteoFZkFCzk6p26oPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdrFE0Op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdrFE0Op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB6AC116B1;
	Wed, 10 Dec 2025 07:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352091;
	bh=GCjcuPjO3nAlK1W6HmvPBriG1PvTkVfyJE+8bqc5KMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdrFE0OpoIyMac6CkXP8D+aiODKONZAweGKmoyM04OmIuGd5/Ha0Zu9cr1WN6H8bT
	 YkMeHhGPo8rs3S9Y0toNmm14Qo4DEmcKzznytXo6KajRIAU3YJfK1HkaqbK4Jea4uI
	 n1w8X33psRPX4aI7R0f5pugggiE3lDr1Ovx7eCcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.17 17/60] USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC
Date: Wed, 10 Dec 2025 16:29:47 +0900
Message-ID: <20251210072948.261747319@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


