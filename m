Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C6314A4E2;
	Tue, 20 Feb 2024 21:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462838; cv=none; b=PJhDgYlC+kMBXBKd61eKQs0hzqXB8S9Kt7nu7j2ArwhWKfHXR0/nagaO3f93TgTcbSlRkSync6ElvKh5+KsjbPeincah3fEIXlhLoquIebYmDbqgZGZ9BaVSHL1bb2ahj5vJBMDOO/0Rui4gy09IUmpie7XofWyWJCUbvhqTClM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462838; c=relaxed/simple;
	bh=6aJtE3ASqWDOezjq2eoU0Wb15kHo6U1/FIo8LXZS/Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af++54vdabPmS2icS4U8Xv0XnlDNbM/PtjAD8vpueTmWcOQO9HRHuil8cQyxmxUprvL76CtCCn0TO39kPb2xv30z1wh+zDcN5J/zutEk2rm8OWLg9gN77vcDbJXNStgMie5u2kBl6NGMKubutnk/QoPN7HQNKUEtlBTwdRYqudE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EL3rEHkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EL3rEHkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FACC433F1;
	Tue, 20 Feb 2024 21:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462838;
	bh=6aJtE3ASqWDOezjq2eoU0Wb15kHo6U1/FIo8LXZS/Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EL3rEHkInuPELF4Tx6eb9upkIlaJt7/eormdaeivX5I5iFF+WvlY2BzuxRr4hxRpE
	 StjKCooAjLQuLTBhV33RFz3K+aCZ/SOUvIvgxczDUp5pH+xBWcIMZlQEx78NRePNvv
	 qqM2/8S9ePduBIcLrM5N1HlHdkHWYvy1tUVoFMR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 6.1 053/197] usb: dwc3: gadget: Fix NULL pointer dereference in dwc3_gadget_suspend
Date: Tue, 20 Feb 2024 21:50:12 +0100
Message-ID: <20240220204842.666827054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -4583,15 +4583,13 @@ int dwc3_gadget_suspend(struct dwc3 *dwc
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


