Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4976E3A5E91;
	Tue, 16 Jun 2026 18:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633898; cv=none; b=TyqewSkhYSi4LgGYFjjQog8EdEirUMNzDKKN9DvWJ0HW8k/Gm1d3WBWZXgiijBgMN8KclJlYzOJ0/MS4VqWdPzoVCialKu+g6annFr3D3lGHswO72LjaOq4mC8AqUic0hImOdw5TwCTCVl7DlC3WhFMl2kNiRs3JDmbQG8JxZ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633898; c=relaxed/simple;
	bh=wEd8JwzYHuKu4qp39h8IQTGdkmTimje/XveSDY1VhgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAfq4iuEDcivPag+PQUtSdcU9ZGda+Pi2FTjZRkONPybT9iWphnSvjB1bE5aT1Ukj6u5xevQvZrw1f9Jmi59XskBetj704kzgN4LSPZxRK5ObBq+mrloaBYnxeaDZG7Ub9C37FvD58cc2KsR+/l4FCgVocvzliuF68oYtcT/vYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsdRHTLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsdRHTLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA2C1F000E9;
	Tue, 16 Jun 2026 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633897;
	bh=Gr5TQnB6kJCAJpDIWjaVWt2IFIbgCru02gnDD2lNF/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsdRHTLxBl3R6kUd9obeziJuNYEMWmZPH1BnjyAhd1xC2/1IxJNek079fGETAkEtG
	 wQSqAXVdtJ6wY91E668KFB3GI49kT0GaDUy9v+o/cFz66C06IfG41cfW1+d9Y1EfOx
	 GETEgX0elo8kJUEPWNg2yU/EiuH8tAEriKIvzvEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 121/411] usb: gadget: net2280: Fix double free in probe error path
Date: Tue, 16 Jun 2026 20:25:59 +0530
Message-ID: <20260616145106.758480324@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c8547c74988e0b5f4cbb1b895e2a57aae084f070 upstream.

usb_initialize_gadget() installs gadget_release() as the release
callback for the embedded gadget device.  The struct net2280 instance is
therefore released through gadget_release() when the gadget device's last
reference is dropped.

The probe error path calls net2280_remove(), which tears down the
partially initialized device and drops the gadget reference with
usb_put_gadget().  Calling kfree(dev) afterwards can free the same object
again.

Drop the explicit kfree() and let the gadget device release callback
handle the final free.  This issue was found by a static analysis tool
I am developing.

Fixes: f770fbec4165 ("USB: UDC: net2280: Fix memory leaks")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260427153651.337846-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2280.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3796,10 +3796,8 @@ static int net2280_probe(struct pci_dev
 	return 0;
 
 done:
-	if (dev) {
+	if (dev)
 		net2280_remove(pdev);
-		kfree(dev);
-	}
 	return retval;
 }
 


