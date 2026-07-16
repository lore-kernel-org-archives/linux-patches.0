Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ABC33C1BE;
	Thu, 16 Jul 2026 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209338; cv=none; b=CaPbGdzNx8vv3KTyil7YmYcTB83CgltJIuk3lJ51zl/NmK+bntXa5PuHC8toXi9k3BHSgFuwsHtZzcoRCi9lQRTjinqVfOcTO964NCwxmbTSl0swXw/pFjCsrlC7tY3TRuG9FZ+jKPflwOtMcINFSwoy2EQ/l1LI8emP1myIB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209338; c=relaxed/simple;
	bh=m3qhxAUveQv2iizAXB7m6L/SgOOE+vlMusjICvqqBas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTOngsZVGIwXteGyvfD/QAGNTPEx9vDCnuSgF0LMYI5MxZ54ZiWY2UT8Uex/fnLbNvoRGgdEKmNsFrHGCQ7tzRi/OCCHMihPn2YtBScgl/d7ALxuv5omoXhrEZQpr7BHoEa56EkKNH+tOUKi090+/g5FcfD67Taxxi3JtoCyxrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7JHKavQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7JHKavQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3931F000E9;
	Thu, 16 Jul 2026 13:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209337;
	bh=uNWHu6KLt/LWyYNbbybXd9m/4ohy5n3+r3p+UYcIN28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7JHKavQEaHA2B8IUolT6Y6jTmsDuhgYHT5RLsDxY+fzUb0FajO4JRQezb57+fmwb
	 euofqX2u5HKQj136DO3B1sk5Py7xc+UZ+5i4s+J4lDsn/9xDtd6s2KiF8WPIw2gLGQ
	 p2SkbmxAo4fTH099cPM2DiQ65IVsbX2XQ0SeBuBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 7.1 147/518] usb: dwc3: run gadget disconnect from sleepable suspend context
Date: Thu, 16 Jul 2026 15:26:55 +0200
Message-ID: <20260716133051.065664330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 010382937fb69892b3469ac4d30af072262f59e8 upstream.

dwc3_gadget_suspend() takes dwc->lock with IRQs disabled and then calls
dwc3_disconnect_gadget().  For async callbacks that helper only uses
plain spin_unlock()/spin_lock(), so the gadget ->disconnect() callback
still runs with IRQs disabled and any sleepable callback trips Lockdep.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the dwc3_gadget_suspend() ->
dwc3_disconnect_gadget() -> gadget_driver->disconnect() chain, and
Lockdep reported:

  BUG: sleeping function called from invalid context
  gadget_disconnect+0x21/0x39 [vuln_msv]
  dwc3_gadget_suspend.constprop.0+0x2b/0x42 [vuln_msv]

Keep the disconnect callback selection in one common helper, but add a
sleepable suspend-side wrapper which snapshots the callback under
dwc->lock and then runs it after spin_unlock_irqrestore().  The regular
event path still uses the existing spin_unlock()/spin_lock() window.

Fixes: c8540870af4c ("usb: dwc3: gadget: Improve dwc3_gadget_suspend() and dwc3_gadget_resume()")
Cc: stable <stable@kernel.org>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20260612052005.3849659-1-runyu.xiao@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3934,15 +3934,48 @@ static void dwc3_endpoint_interrupt(stru
 	}
 }
 
+static bool dwc3_prepare_disconnect_gadget(struct dwc3 *dwc,
+					   struct usb_gadget_driver **driver,
+					   struct usb_gadget **gadget)
+{
+	if (!dwc->async_callbacks || !dwc->gadget_driver ||
+	    !dwc->gadget_driver->disconnect)
+		return false;
+
+	*driver = dwc->gadget_driver;
+	*gadget = dwc->gadget;
+
+	return true;
+}
+
 static void dwc3_disconnect_gadget(struct dwc3 *dwc)
 {
-	if (dwc->async_callbacks && dwc->gadget_driver->disconnect) {
+	struct usb_gadget_driver *driver;
+	struct usb_gadget *gadget;
+
+	if (dwc3_prepare_disconnect_gadget(dwc, &driver, &gadget)) {
 		spin_unlock(&dwc->lock);
-		dwc->gadget_driver->disconnect(dwc->gadget);
+		driver->disconnect(gadget);
 		spin_lock(&dwc->lock);
 	}
 }
 
+static void dwc3_disconnect_gadget_sleepable(struct dwc3 *dwc)
+{
+	struct usb_gadget_driver *driver;
+	struct usb_gadget *gadget;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dwc->lock, flags);
+	if (!dwc3_prepare_disconnect_gadget(dwc, &driver, &gadget)) {
+		spin_unlock_irqrestore(&dwc->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&dwc->lock, flags);
+	driver->disconnect(gadget);
+}
+
 static void dwc3_suspend_gadget(struct dwc3 *dwc)
 {
 	if (dwc->async_callbacks && dwc->gadget_driver->suspend) {
@@ -4838,7 +4871,6 @@ EXPORT_SYMBOL_GPL(dwc3_gadget_exit);
 
 int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
-	unsigned long flags;
 	int ret;
 
 	ret = dwc3_gadget_soft_disconnect(dwc);
@@ -4852,10 +4884,7 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
 		return -EAGAIN;
 	}
 
-	spin_lock_irqsave(&dwc->lock, flags);
-	if (dwc->gadget_driver)
-		dwc3_disconnect_gadget(dwc);
-	spin_unlock_irqrestore(&dwc->lock, flags);
+	dwc3_disconnect_gadget_sleepable(dwc);
 
 	return 0;
 }


