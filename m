Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698061BD00C;
	Tue,  2 Jul 2024 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941516; cv=none; b=Nf/4CkaD4RH8vmnau7F3zqBO8SuxSpjzaRAXQP67a12bHRgfRcoXdf+hOpY9yoPq5ufZrmj36oxC4AZ5Q29MhEJAf2mF44E4D/KHA5sdtu0NV2Sr4ZlP8Kcyt7Eqfa65ljOm/2ps5pUtOvpnn9jNAfrwg7DdclYYuYzk1cZgKeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941516; c=relaxed/simple;
	bh=htT1zAgEkAVVia9OXqNn33H4SLqhyUSfuJqvac3opto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpoZbONl2bL9VJVPbIcYyPFygAmjxNbPF6WMnTJ12x2YNODcuxsjlV/AdjDh0imVLMN9Q3lnOQidwJf6GsDjwa4gY0ZF4tMTahn8UoDZMhqJcNNfj+a1j4DzP0Dbffp08lQOJb6YTuUZY6gZ8tAy6YqYelBSO8DuITp4Tz5Re8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWldVqfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWldVqfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CC8C4AF07;
	Tue,  2 Jul 2024 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941516;
	bh=htT1zAgEkAVVia9OXqNn33H4SLqhyUSfuJqvac3opto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWldVqfdrub+Y+eT6j87df75jkg4mN9TWHytvE57IAwIg1TN/g8xLR4qDXNrJe+v1
	 A5sKhb7gkPFdjx7IuHAAmwJCdKZzaKt69nrqHeCBywWNkKoLDw1gIyHjIOC27S3sKv
	 pObCryo1+N2qAWeHuGnZ+LVRqFvP5waGVbwEAxHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Meng Li <Meng.Li@windriver.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 087/128] usb: dwc3: core: remove lock of otg mode during gadget suspend/resume to avoid deadlock
Date: Tue,  2 Jul 2024 19:04:48 +0200
Message-ID: <20240702170229.510842335@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -2087,7 +2087,6 @@ assert_reset:
 
 static int dwc3_suspend_common(struct dwc3 *dwc, pm_message_t msg)
 {
-	unsigned long	flags;
 	u32 reg;
 
 	switch (dwc->current_dr_role) {
@@ -2125,9 +2124,7 @@ static int dwc3_suspend_common(struct dw
 			break;
 
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_DEVICE) {
-			spin_lock_irqsave(&dwc->lock, flags);
 			dwc3_gadget_suspend(dwc);
-			spin_unlock_irqrestore(&dwc->lock, flags);
 			synchronize_irq(dwc->irq_gadget);
 		}
 
@@ -2144,7 +2141,6 @@ static int dwc3_suspend_common(struct dw
 
 static int dwc3_resume_common(struct dwc3 *dwc, pm_message_t msg)
 {
-	unsigned long	flags;
 	int		ret;
 	u32		reg;
 
@@ -2193,9 +2189,7 @@ static int dwc3_resume_common(struct dwc
 		if (dwc->current_otg_role == DWC3_OTG_ROLE_HOST) {
 			dwc3_otg_host_init(dwc);
 		} else if (dwc->current_otg_role == DWC3_OTG_ROLE_DEVICE) {
-			spin_lock_irqsave(&dwc->lock, flags);
 			dwc3_gadget_resume(dwc);
-			spin_unlock_irqrestore(&dwc->lock, flags);
 		}
 
 		break;


