Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7FA1E4B2;
	Wed, 21 Feb 2024 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523211; cv=none; b=noeFeiT51MUrW/UhVJrYoj88JYp4gT+CCxScrMbSMRO0es+weOxgJXVpZKV8pK+zs+4CWZXmR2kiupsXBm/pYedsRjlVo5T92VRUx36ozeIqTyIPinxP9Cdnw025BFiCIUUmW7mKGObd8IN4/HMk10m1+wMytE/GjazYcSSLYWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523211; c=relaxed/simple;
	bh=Go6BPD981oLS4BIdkZn87Yq3fONwhhOmZcLKkQLbEO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcVF0dWEbPLG0VmA1hyzLbFQwwoyF0f4OxkGilQKO+dw8TqUOSELu2Ar1D7B2WaN8W3PJAG/pmFdJzaRKbsbmXwVrqFVfj3CDHDV25I1el24vDT+gys1DDU3OO1ZcbvmfQBLhFbBQVt34haR13s+RA0QUonYvxhVVVFjIWs2xrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUy/qT1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUy/qT1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2428C433F1;
	Wed, 21 Feb 2024 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523211;
	bh=Go6BPD981oLS4BIdkZn87Yq3fONwhhOmZcLKkQLbEO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUy/qT1i5gQfaCqovzeINhQaO4t1LcDohi2fGJhVMFHuCEjEt1jOflgcjtXW+7UzI
	 3/LJFzlKXF4HdJq1JCDc4pEdMKxwMPhz7viBUSNcBFl3GAxf0fy3EEv++Tt/iJbE7S
	 t4cOxGdpNJhUAEx4gS5pseDrTB1a/uBRm4M+AHVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 5.15 369/476] usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend
Date: Wed, 21 Feb 2024 14:07:00 +0100
Message-ID: <20240221130021.679723758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>

commit 61a348857e869432e6a920ad8ea9132e8d44c316 upstream.

In current scenario if Plug-out and Plug-In performed continuously
there could be a chance while checking for dwc->gadget_driver in
dwc3_gadget_suspend, a NULL pointer dereference may occur.

Call Stack:

	CPU1:                           CPU2:
	gadget_unbind_driver            dwc3_suspend_common
	dwc3_gadget_stop                dwc3_gadget_suspend
                                        dwc3_disconnect_gadget

CPU1 basically clears the variable and CPU2 checks the variable.
Consider CPU1 is running and right before gadget_driver is cleared
and in parallel CPU2 executes dwc3_gadget_suspend where it finds
dwc->gadget_driver which is not NULL and resumes execution and then
CPU1 completes execution. CPU2 executes dwc3_disconnect_gadget where
it checks dwc->gadget_driver is already NULL because of which the
NULL pointer deference occur.

Cc: stable@vger.kernel.org
Fixes: 9772b47a4c29 ("usb: dwc3: gadget: Fix suspend/resume during device mode")
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Link: https://lore.kernel.org/r/20240119094825.26530-1-quic_uaggarwa@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4412,15 +4412,13 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
 	unsigned long flags;
 	int ret;
 
-	if (!dwc->gadget_driver)
-		return 0;
-
 	ret = dwc3_gadget_soft_disconnect(dwc);
 	if (ret)
 		goto err;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	dwc3_disconnect_gadget(dwc);
+	if (dwc->gadget_driver)
+		dwc3_disconnect_gadget(dwc);
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return 0;


