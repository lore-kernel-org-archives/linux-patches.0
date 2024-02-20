Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260CC612D7;
	Tue, 20 Feb 2024 21:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463593; cv=none; b=nQf583HZjn82UW1wuyF4GE8MZWWXaU8DcbsHRDKI6Jc2MoCF+1S/+4mxgX7DDVfoVnA+fV3CXzUjwkOsNFmjKreF9mUx9bEkxu1rRRMI3WwbCkISGskhtAm+gIzp3lT4NK2hIr2kXMVLWWzH2BlMy863DcUBjZiTvyg8iLJ56Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463593; c=relaxed/simple;
	bh=Yp0ObszS2MFMgeyHyRjsX+1gCPWLn9E6h2gzVyAlybk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnugwtSSTE/JJffWfTMeLUXq8Y4BakzMy7ppXpevOFQZdl5+j4J6/PtdYkEPAKk4nvILKIPDP4qzXQQSfvnZPeayMwTTRcgn2uNaq15BAgcpD+1xL1hDLn0c1ue3WgrjBq4l5T38yHxEf+R3M3QRVaWr/e5l5qT1do38GZiH6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vemrmcQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vemrmcQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F96C433C7;
	Tue, 20 Feb 2024 21:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463592;
	bh=Yp0ObszS2MFMgeyHyRjsX+1gCPWLn9E6h2gzVyAlybk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vemrmcQ5+e+NLbcQOQn27EHP/flzAX3KMkGAegTzTb7xsvGro9jqbFjs9sawimoAo
	 08Jc5Hd85NcsJxaurI9g+7f+/JrUPSFE+PkSvgIYoRng3HJPJOINgLEN+ZRBbcpF1u
	 UbBC7yY247qeXb9aAxL2BpzTbEwjFkWBiFrIM53g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 6.6 084/331] usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend
Date: Tue, 20 Feb 2024 21:53:20 +0100
Message-ID: <20240220205640.233039637@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4703,15 +4703,13 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
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


