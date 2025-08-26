Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F2435AAA3;
	Tue, 26 Aug 2025 14:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218374; cv=none; b=fR4qWKbQ5GOWChppGhnEzaEp/spQfjg4iD0/aZbr3j/CN2Q211m8SZovAI4UklNrj/0wiW5I1GOjVww/DUS2zjX0HcPwP03XiXZ3pKqL7A6n1lgm4a3iDocxoRvOAVMU5Rjupb5Lts5mwiTDGLtFHYu7EDiiKWztsqbuwqB+Vfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218374; c=relaxed/simple;
	bh=hZ/H3EqO3Xr+dMOg5Q3UVgaY6w+ETpUhdfiyQBOXdCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbhpWruw6Efmr92weClF5MvZY4FGWbui5E2aYlz1yksp+2sRf7n1nJmR8GgVZUcTBRcyPdgoSdPR4+zj7HX7x4XTVntLVQ09U3X2jAPQVed/k+q7YKIKi6eb+r5dWhO1WuqHgdBvz/6beN0WbjstcuBuzzxKd2eWFdZ755cKFHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMiQ8SGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMiQ8SGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE67C4CEF1;
	Tue, 26 Aug 2025 14:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218374;
	bh=hZ/H3EqO3Xr+dMOg5Q3UVgaY6w+ETpUhdfiyQBOXdCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMiQ8SGYgkMTKhWYJHTkk9cEq37wDexpDuutPiErlAGKlaBKqp4rTgZkTMbW9T7ZY
	 KpbST7JHw3UBhRk3rPkTSyKUWPS1R2wUn73cV4GfMP8tWMnytE37bRLVL7z2mNo9C4
	 sbBytm2jN/ROEzDxGMLngNbawy747Dggsw3QoVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Meng Li <Meng.Li@windriver.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>
Subject: [PATCH 5.10 497/523] usb: dwc3: core: remove lock of otg mode during gadget suspend/resume to avoid deadlock
Date: Tue, 26 Aug 2025 13:11:47 +0200
Message-ID: <20250826110936.700602710@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meng Li <Meng.Li@windriver.com>

commit 7838de15bb700c2898a7d741db9b1f3cbc86c136 upstream.

When config CONFIG_USB_DWC3_DUAL_ROLE is selected, and trigger system
to enter suspend status with below command:
echo mem > /sys/power/state
There will be a deadlock issue occurring. Detailed invoking path as
below:
dwc3_suspend_common()
    spin_lock_irqsave(&dwc->lock, flags);              <-- 1st
    dwc3_gadget_suspend(dwc);
        dwc3_gadget_soft_disconnect(dwc);
            spin_lock_irqsave(&dwc->lock, flags);      <-- 2nd
This issue is exposed by commit c7ebd8149ee5 ("usb: dwc3: gadget: Fix
NULL pointer dereference in dwc3_gadget_suspend") that removes the code
of checking whether dwc->gadget_driver is NULL or not. It causes the
following code is executed and deadlock occurs when trying to get the
spinlock. In fact, the root cause is the commit 5265397f9442("usb: dwc3:
Remove DWC3 locking during gadget suspend/resume") that forgot to remove
the lock of otg mode. So, remove the redundant lock of otg mode during
gadget suspend/resume.

Fixes: 5265397f9442 ("usb: dwc3: Remove DWC3 locking during gadget suspend/resume")
Cc: Xu Yang <xu.yang_2@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240618031918.2585799-1-Meng.Li@windriver.com
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1735,7 +1735,6 @@ assert_reset:
 
 static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 {
-	unsigned long	flags;
 	u32 reg;
 
 	switch (dwc->current_dr_role) {
@@ -1773,9 +1772,7 @@ static int dwc3_suspend_common(struct dw
 			break;
 
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_DEVICE) {
-			spin_lock_irqsave(&dwc->lock, flags);
 			dwc3_gadget_suspend(dwc);
-			spin_unlock_irqrestore(&dwc->lock, flags);
 			synchronize_irq(dwc->irq_gadget);
 		}
 
@@ -1792,7 +1789,6 @@ static int dwc3_suspend_common(struct dw
 
 static int dwc3_resume_common(struct dwc3 *dwc, pm_message_t msg)
 {
-	unsigned long	flags;
 	int		ret;
 	u32		reg;
 
@@ -1841,9 +1837,7 @@ static int dwc3_resume_common(struct dwc
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_HOST) {
 			dwc3_otg_host_init(dwc);
 		} else if (dwc->current_otg_role == DWC3_OTG_ROLE_DEVICE) {
-			spin_lock_irqsave(&dwc->lock, flags);
 			dwc3_gadget_resume(dwc);
-			spin_unlock_irqrestore(&dwc->lock, flags);
 		}
 
 		break;


