Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0447D923;
	Tue, 16 Jun 2026 18:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635528; cv=none; b=uUPEsXI7TlUiKbfie96WV5ok38ieShzFsgeK+2euPGQ1iBKdlyunXJA20kkpbOV21IPSYAFsmW5dCcYHoPyI2bAkIEIB0sKINxMF6QT3iFAARuhjrXk/Wdd3bI8Rq1L+owxYBhHd8e4+s9lnqBCLH776ou8/bSaAP6P3r/7zEZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635528; c=relaxed/simple;
	bh=0sBsRXxj6pMChM2AfCYjXS487mXfBQV7Mmff9dVvLF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tARJLbSb8Aynk5eoRbFE9fbqh0RPOQJHWNla6LhlVZw7cZ0P9iZGaDbSEQMvvGEg/zw3c0I/amJty67nZwfS/gIlfGpUpj9Of4YGpPkrRiwWWxNbfB0C1G8ROH4vetT+2IPREajpPnwVNiYJfAwANtK9/dwkxYUiv6jtRDPCTWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgn533D2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgn533D2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4411F000E9;
	Tue, 16 Jun 2026 18:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635525;
	bh=yhIMKxDsPYPskknQPPE/yZuNqdbmiyOhRZKGh2xMIY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgn533D2FbUcJ/pNQrTlNVg7mByAtrzRFInc8mbnH1xstGELsLpm4vh+t7lSZMyRj
	 hCuCbTQBtME7rXK7/d/1ZjYUcd4dVWyDY7sTlrHyUsK1Bedcbff4LmTa7AL4Nru1zY
	 QAVXqfC92TvPzDHmov6lnjbg8OSLyvb5lSPxKL48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 5.10 066/342] usb: dwc2: Fix use after free in debug code
Date: Tue, 16 Jun 2026 20:26:02 +0530
Message-ID: <20260616145051.327053147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit 9ea06a3fbf9f16e0d98c52cb3b99642be15ec281 upstream.

We're not allowed to dereference "urb" after calling
usb_hcd_giveback_urb() so save the urb->status ahead of time.

Fixes: 7359d482eb4d ("staging: HCD files for the DWC2 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/ag1NwBpqT4IEQcdJ@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/hcd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4718,6 +4718,7 @@ static int _dwc2_hcd_urb_dequeue(struct
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	int rc;
 	unsigned long flags;
+	int urb_status;
 
 	dev_dbg(hsotg->dev, "DWC OTG HCD URB Dequeue\n");
 	dwc2_dump_urb_info(hcd, urb, "urb_dequeue");
@@ -4742,11 +4743,12 @@ static int _dwc2_hcd_urb_dequeue(struct
 
 	/* Higher layer software sets URB status */
 	spin_unlock(&hsotg->lock);
+	urb_status = urb->status;
 	usb_hcd_giveback_urb(hcd, urb, status);
 	spin_lock(&hsotg->lock);
 
 	dev_dbg(hsotg->dev, "Called usb_hcd_giveback_urb()\n");
-	dev_dbg(hsotg->dev, "  urb->status = %d\n", urb->status);
+	dev_dbg(hsotg->dev, "  urb->status = %d\n", urb_status);
 out:
 	spin_unlock_irqrestore(&hsotg->lock, flags);
 


