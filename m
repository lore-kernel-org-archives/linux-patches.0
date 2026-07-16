Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634271D435F;
	Thu, 16 Jul 2026 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211869; cv=none; b=dC1D7veTvMZD3G7F+4M6Uz+Q3NBpyJRkUDW6Vo6ZvPVnkpx21e9dWLAuDYB2F/l57cwlGhthPRCgd5bnw3w2gYsNW3eJUO3XqKBquX+7VnNwWOXZNRverNBxDvnGA3sOiNKtltNlXmRyMSfrRYjqla3r973GvHixLNM+gmiDSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211869; c=relaxed/simple;
	bh=FtCjhcD4VZn8yat0sUo1NFles8/RoS1+mkZHNBJyTNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGnoHVmvr5ve9vG/XjgBpzOg27q3kENgO2VLSIDfd2+I8GLYItCfTFZy3h5YscEnbuW8+POPnKUZ/jO0cvWkBjW7pih0Ew1luMgednL7TW8COBqpW0JEJKNyw3vn8UV5X2mp3H2p0T21iPD1CU5xey8c2te5SZALNzJtSaF3erY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijK0qfRL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijK0qfRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F771F00A3A;
	Thu, 16 Jul 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211866;
	bh=t6VMbnFqQRQBa13nVIELVPoykV5OqzvQWKm7p33lSWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijK0qfRLnrZkq7dRuAaV8ZSn/FLQiLWAfEJCzW0EJF1gS51cG50KOj7HF3oROnnoO
	 iw0hzG9HJyRggPLS4+fWbAHbux7/gv4g+2XYRSmjGLlz6s9NGXtzFF5UgZTcD6lAPm
	 ftZXtKcstjGqpSwhQPTcMmg6epbFrmUJYB20yHFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 111/349] usb: dwc3: run gadget disconnect from sleepable suspend context
Date: Thu, 16 Jul 2026 15:30:45 +0200
Message-ID: <20260716133035.797810429@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -3902,15 +3902,48 @@ static void dwc3_endpoint_interrupt(stru
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
@@ -4804,7 +4837,6 @@ void dwc3_gadget_exit(struct dwc3 *dwc)
 
 int dwc3_gadget_suspend(struct dwc3 *dwc)
 {
-	unsigned long flags;
 	int ret;
 
 	ret = dwc3_gadget_soft_disconnect(dwc);
@@ -4818,10 +4850,7 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
 		return -EAGAIN;
 	}
 
-	spin_lock_irqsave(&dwc->lock, flags);
-	if (dwc->gadget_driver)
-		dwc3_disconnect_gadget(dwc);
-	spin_unlock_irqrestore(&dwc->lock, flags);
+	dwc3_disconnect_gadget_sleepable(dwc);
 
 	return 0;
 }


