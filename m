Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB3F47AF4D;
	Tue, 16 Jun 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630892; cv=none; b=QDpdlpVs1/uXXWnbw1L6SXVJbXRe8LPU4Iq1P911BBNa7uCOZqmheWOaBfVggYzWYFZS5+uN5J0JjI5Op7G3iEq41uoPgk8jaAlG3tB6hqATz3/CeCwxeV3k+KF65j2SAPt9FXqgAX/+hQ8mUEcEcnzgerS6+Q3JNds7KskaUu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630892; c=relaxed/simple;
	bh=VWw9PC4wjuBzTeDRAdZ6l0ZvSxgFX8qPuQh9W65h3ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SumR6YxM1Y+GlTIyKbrjaW61erZ5eI4h2kS23fHM9t6JbFPbXwYScCBupR5g1XE2TCo8FHUOzc3kVMVHaMXvkKhKVI5svjVNr4Csb7oPYNEVxTuYv7tL6qn3Evkz91FQdmDwV6k3W69PR4P2u8bJ5lpcrXsqdQV4oDpE6u9EGV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPAp+OCK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPAp+OCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173471F000E9;
	Tue, 16 Jun 2026 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630890;
	bh=T0crAsvewkrSR4VnniJh7TPQL7gwdaFpZagSfTH9CwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPAp+OCKFwntZw0Aul/vTPHQLfnnOM+IOGdR4VadfbM1bJPZP5jXuXFZnO8O1NrFP
	 SOBrx6Uo4bTX4eZyASMoQ+/1tnlru6OK8AjCoPO5X1/MBtukPxlCZ+zwBzLpeOqI+J
	 Ym4P3UkGtDIaY9YPe+VUUAO3A1cD445YWJSFLLKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 6.1 117/522] usb: dwc2: Fix use after free in debug code
Date: Tue, 16 Jun 2026 20:24:24 +0530
Message-ID: <20260616145131.443396491@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


