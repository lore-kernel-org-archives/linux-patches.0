Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344207474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC51C433D2;
	Tue, 10 Jan 2023 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374031;
	bh=P5RnGk+PCodDtv0xhmpQ0M+NtPgVtGzSb5j6g2zOY3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5zXtaoOxDCkEvhagEqW50xUDko1D0Cxl8xGrGnnhyb2drkeChOd2dwsZUrSxHGzP
	 RG6qSAh8tSwEyzdUgdgOzl93gKkLiHVouqxfj6OwJSus9d10O4CXQ+wuqHVcITrl7I
	 EmD2DvB1wLi/fSXSKdK3lIxwjuQiacxVEMYYfoJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.0 005/148] usb: dwc3: gadget: Ignore End Transfer delay on teardown
Date: Tue, 10 Jan 2023 19:01:49 +0100
Message-Id: <20230110180017.339439834@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit c4e3ef5685393c5051b52cf1e94b8891d49793ab upstream.

If we delay sending End Transfer for Setup TRB to be prepared, we need
to check if the End Transfer was in preparation for a driver
teardown/soft-disconnect. In those cases, just send the End Transfer
command without delay.

In the case of soft-disconnect, there's a very small chance the command
may not go through immediately. But should it happen, the Setup TRB will
be prepared during the polling of the controller halted state, allowing
the command to go through then.

In the case of disabling endpoint due to reconfiguration (e.g.
set_interface(alt-setting) or usb reset), then it's driven by the host.
Typically the host wouldn't immediately cancel the control request and
send another control transfer to trigger the End Transfer command
timeout.

Fixes: 4db0fbb60136 ("usb: dwc3: gadget: Don't delay End Transfer on delayed_status")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/f1617a323e190b9cc408fb8b65456e32b5814113.1670546756.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1702,6 +1702,7 @@ static int __dwc3_stop_active_transfer(s
 	else if (!ret)
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
 
+	dep->flags &= ~DWC3_EP_DELAY_STOP;
 	return ret;
 }
 
@@ -3701,8 +3702,10 @@ void dwc3_stop_active_transfer(struct dw
 	if (dep->number <= 1 && dwc->ep0state != EP0_DATA_PHASE)
 		return;
 
+	if (interrupt && (dep->flags & DWC3_EP_DELAY_STOP))
+		return;
+
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
-	    (dep->flags & DWC3_EP_DELAY_STOP) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
 


