Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4B17E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF94C433D6;
	Wed,  2 Nov 2022 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356601;
	bh=esvagZpQYMpOUH+hSuQyuJZB9gIPycY16zkzfI9nBUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPIkh0gDGykqLDIfjZ2LLwb/WoJhQS6Ah2Oi8P7g/VA0lnFrm3FCKBrKet9Zfz3PQ
	 YwFWrwvRv7v7Vm/UNKu48HQ9Y4ACAkRLVfKfWgFs8v+vheNZG+xapdwNZg1Wnijcme
	 L6v6q9gx+r5hRKiaXRNtkbxZR96LBCAgr3/fmabw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Wesley Cheng <quic_wcheng@quicinc.com>
Subject: [PATCH 6.0 027/240] usb: dwc3: gadget: Force sending delayed status during soft disconnect
Date: Wed,  2 Nov 2022 03:30:02 +0100
Message-Id: <20221102022112.017557530@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit e1ee843488d58099a89979627ef85d5bd6c5cacd upstream.

If any function drivers request for a delayed status phase, this leads to a
SETUP transfer timeout error, since the function may take longer to process
the DATA stage.  This eventually results in end transfer timeouts, as there
is a pending SETUP transaction.

In addition, allow the DWC3_EP_DELAY_STOP to be set for if there is a
delayed status requested.  Ocasionally, a host may abort the current SETUP
transaction, by issuing a subsequent SETUP token.  In those situations, it
would result in an endxfer timeout as well.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220817182359.13550-3-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2501,6 +2501,9 @@ static int dwc3_gadget_soft_disconnect(s
 	if (dwc->ep0state != EP0_SETUP_PHASE) {
 		int ret;
 
+		if (dwc->delayed_status)
+			dwc3_ep0_send_delayed_status(dwc);
+
 		reinit_completion(&dwc->ep0_in_setup);
 
 		spin_unlock_irqrestore(&dwc->lock, flags);
@@ -3699,7 +3702,7 @@ void dwc3_stop_active_transfer(struct dw
 	 * timeout. Delay issuing the End Transfer command until the Setup TRB is
 	 * prepared.
 	 */
-	if (dwc->ep0state != EP0_SETUP_PHASE && !dwc->delayed_status) {
+	if (dwc->ep0state != EP0_SETUP_PHASE) {
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return;
 	}


