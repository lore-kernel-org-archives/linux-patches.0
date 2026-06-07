Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4BC2D3A69;
	Sun,  7 Jun 2026 10:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828699; cv=none; b=U0HBwDGoc5Au8b2U55oCz94TgiXCR0LQA7SFmALdcC8ggc6CLXu8QcKAQDzbUY35Mp7t+kcc/2ogc73ZURKltYLe/LiVtx+z8iek9dDNr9otBIGZK7AOCD53hOlfMuvQ/YrJLk0OgTE2F0+0T6pp1ZbZJtVO/UBQlRxAIKND8QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828699; c=relaxed/simple;
	bh=4XewEGjVAQIgaxyCz4ktmc69/WChgSitI/t2q+4lOkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdwPtPwq3GKnJ9niXVVIihncP0kdF4BvE1Ntrz+948xuFnASNgYoynDIjq17BxQ1ywedH+hPlj2XTAAKwqZeMt3gQLub3qdgwH1qlz5YMm+HUBTwvHgRygHDTnqurbTcF9myJOl7mIoXba15Jc7Qza1N6LwvLqmvoS0/Yg/1f7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHzyiP/h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHzyiP/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EC61F00893;
	Sun,  7 Jun 2026 10:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828698;
	bh=Qau/mJtFr2HZBMX1oABx2OdkGFSJFS4JmZ5pdSlHSiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHzyiP/hv8MIlEDIEratL3Kia/KrkKCx14tvm+ksKlVEuvDu9Bl0HaIhBQHIVtq0f
	 h84vG8w8I+lBWeuHWH2AsN3WfixrvbB2qaQEQnpmI5+iN0KlTlIGH1HhPd6Lt+iB96
	 CKGjTf/8SRjItU/nGwzLe/WJRMrTvGivzATUvC3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 7.0 204/332] usb: dwc2: Fix use after free in debug code
Date: Sun,  7 Jun 2026 11:59:33 +0200
Message-ID: <20260607095735.555439836@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4804,6 +4804,7 @@ static int _dwc2_hcd_urb_dequeue(struct
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	int rc;
 	unsigned long flags;
+	int urb_status;
 
 	dev_dbg(hsotg->dev, "DWC OTG HCD URB Dequeue\n");
 	dwc2_dump_urb_info(hcd, urb, "urb_dequeue");
@@ -4828,11 +4829,12 @@ static int _dwc2_hcd_urb_dequeue(struct
 
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
 


