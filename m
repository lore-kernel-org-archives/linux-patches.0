Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85853D091A;
	Tue, 16 Jun 2026 18:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633462; cv=none; b=IZYZkT8mAw3pXerkiiVd2nRbROzOHx86bNepgf/uvLf5EoZd6wjqkmdWkzs++DmVHaTUhc9GXNA+IxBZf262760fSed657n/dFmp0KffK4knOnrFIA86jWXkrM0sYETisULxMftU2vdW5yoCSAHGozVtNqCsOlhA3AdiL9y9s2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633462; c=relaxed/simple;
	bh=M5f7B3alaj4cMNEfpjwti3LNWEQB62w7BFIs/2pZrGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoyvQcYpvxBl/awhbi4rs7pUKLIkvMHL1IWGwtQudryfWveyOgZBEEw4ElmJ66CTV5K67GG09OV3kQ+JAMLoHtyo5jKqo74FEd+3KKUitar9uKZwHo77hs4dB9V5wPBTBmWP/gWHa05ePKDjGU1/XU/EojvthG8AKZtJae5RLv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vR7zD8QL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vR7zD8QL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCD11F000E9;
	Tue, 16 Jun 2026 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633460;
	bh=VgJ6uDIHhZpdZTB+zFa5LL6NdyDr2TD4ks9YFmkcqG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vR7zD8QLRPeyzdnTAY9Aii+MzIOVFUxe1Y3L8WVmiCkCSMughObe2nnz2MerLuoUn
	 fjimZccliHIv6Vf/WWoT5O2rb7qjqI48TR6zxIrqd8zLE8P8IuOtopJOzcBioBr2s9
	 rVzZzDqxWQ9umMT2AhR0+beRZHcTCiPD30uofeX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 5.15 082/411] usb: dwc2: Fix use after free in debug code
Date: Tue, 16 Jun 2026 20:25:20 +0530
Message-ID: <20260616145104.624522726@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4837,6 +4837,7 @@ static int _dwc2_hcd_urb_dequeue(struct
 	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
 	int rc;
 	unsigned long flags;
+	int urb_status;
 
 	dev_dbg(hsotg->dev, "DWC OTG HCD URB Dequeue\n");
 	dwc2_dump_urb_info(hcd, urb, "urb_dequeue");
@@ -4861,11 +4862,12 @@ static int _dwc2_hcd_urb_dequeue(struct
 
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
 


