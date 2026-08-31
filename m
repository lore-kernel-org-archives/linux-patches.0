Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7695AEC7A;
	Mon, 31 Aug 2026 13:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184410; cv=none; b=Ga7SRGXJ9eUeA1f118mzU6FOeVyE1uvOX5RWbRpFOiInLTogUq1Fv5L9BjO/5VezPBpHmN0gHmUVJwdQIR6TIEYAgw/Y7Iah5C2J7N4AR5C0JY86pzkLOplxZz7v4ti1IB+5ukImF3OT7XJdVc/bSLG+/j2en7guwPnPSHbc6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184410; c=relaxed/simple;
	bh=EmmRYq5BY2+Gu3HYAxDsytS1W8ZoCbnn0dOHMwX5vr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqC8uGU85yLbGKwOAV2WRTA7Xz0CQx2/WkCKK7EimjP53fC8RzMB34RTeVSJISDJX2SLmTPF0H+K1Ehfiad5RfRZT61Bk/s0252E/MvghmWIm/qkglZrweac3ffEzvGnSM8EvmFNNptSkbgNqDk/D472aLPPP3quyknLtAsKdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpIHk4mS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpIHk4mS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AC21F000E9;
	Mon, 31 Aug 2026 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184408;
	bh=ZtlQlKoDCDvXspGf1L/gnqIIA4Lz8vtV/eXLWuchxW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpIHk4mSewpx3YaqCC8UV+FBbng/O8/Q1Yz9lF5X8lP+u3pF3I7zBuizG21uep0Z6
	 LGtodzE+w9/hv17TLdBO63CRjO9pPldxFSe1pTRvVWvbekFZeaGDm+HR6hkuxGwYrW
	 aH6qUmVINzdeCdD8XUnWYlHoqesI3NpVbUkBZgow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3b514b87202742f22c44@syzkaller.appspotmail.com,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 96/99] USB: serial: spcp8x5: drop broken carrier detect support
Date: Mon, 31 Aug 2026 15:35:05 +0200
Message-ID: <20260831133404.492200773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

commit d37186bd95a07e334447f47274a38a311dad2172 upstream.

The driver does not support modem status notifications and instead used
to fetch the modem status once at open() and subsequently operate on and
report stale state.

As part of fixing this, a call to fetch the status was added to
carrier_raised(), which does not work as that callback must not sleep
(e.g. unlike tiocmget()).

Drop the broken carrier detect support.

Fixes: e1ed212d8593 ("USB: spcp8x5: add proper modem-status support")
Cc: stable@vger.kernel.org	# 3.10
Reported-by: syzbot+3b514b87202742f22c44@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a73cea2.01d0871a.3a0d52.000d.GAE@google.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/spcp8x5.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -237,18 +237,6 @@ static void spcp8x5_set_work_mode(struct
 		dev_err(&port->dev, "failed to set work mode: %d\n", ret);
 }
 
-static int spcp8x5_carrier_raised(struct usb_serial_port *port)
-{
-	u8 msr;
-	int ret;
-
-	ret = spcp8x5_get_msr(port, &msr);
-	if (ret || msr & MSR_STATUS_LINE_DCD)
-		return 1;
-
-	return 0;
-}
-
 static void spcp8x5_dtr_rts(struct usb_serial_port *port, int on)
 {
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
@@ -460,7 +448,6 @@ static struct usb_serial_driver spcp8x5_
 	.num_bulk_out		= 1,
 	.open			= spcp8x5_open,
 	.dtr_rts		= spcp8x5_dtr_rts,
-	.carrier_raised		= spcp8x5_carrier_raised,
 	.set_termios		= spcp8x5_set_termios,
 	.init_termios		= spcp8x5_init_termios,
 	.tiocmget		= spcp8x5_tiocmget,


