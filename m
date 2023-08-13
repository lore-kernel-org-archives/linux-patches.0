Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEADA9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEE1C433C8;
	Sun, 13 Aug 2023 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962852;
	bh=MEZW6O7uEg9Ldg9R3lDawqHDsi3Psg26/ohCG6CX2fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2f32TDzGny5Ey1qFJ5N/uPqVrv3zkYEQ+z2PATaFUfefl35R/Pay/yzIqbrm8Pjl/
	 ofjOBzqZq6pjIk84pb3U/zvjcmgmPGff6IVaeQYXKtQNV4/yz+ms9wbaVFQhBF3vDC
	 f5XQoreqOgKIDG6Dv+Lu5k5RGTyJapjg+/D7OjHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Roger Quadros <rogerq@kernel.org>
Subject: [PATCH 5.10 23/68] usb: dwc3: Properly handle processing of pending events
Date: Sun, 13 Aug 2023 23:19:24 +0200
Message-ID: <20230813211708.860875271@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

commit 3ddaa6a274578e23745b7466346fc2650df8f959 upstream.

If dwc3 is runtime suspended we defer processing the event buffer
until resume, by setting the pending_events flag. Set this flag before
triggering resume to avoid race with the runtime resume callback.

While handling the pending events, in addition to checking the event
buffer we also need to process it. Handle this by explicitly calling
dwc3_thread_interrupt(). Also balance the runtime pm get() operation
that triggered this processing.

Cc: stable@vger.kernel.org
Fixes: fc8bb91bc83e ("usb: dwc3: implement runtime PM")
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230801192658.19275-1-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3830,9 +3830,14 @@ static irqreturn_t dwc3_check_event_buf(
 	u32 reg;
 
 	if (pm_runtime_suspended(dwc->dev)) {
+		dwc->pending_events = true;
+		/*
+		 * Trigger runtime resume. The get() function will be balanced
+		 * after processing the pending events in dwc3_process_pending
+		 * events().
+		 */
 		pm_runtime_get(dwc->dev);
 		disable_irq_nosync(dwc->irq_gadget);
-		dwc->pending_events = true;
 		return IRQ_HANDLED;
 	}
 
@@ -4091,6 +4096,8 @@ void dwc3_gadget_process_pending_events(
 {
 	if (dwc->pending_events) {
 		dwc3_interrupt(dwc->irq_gadget, dwc->ev_buf);
+		dwc3_thread_interrupt(dwc->irq_gadget, dwc->ev_buf);
+		pm_runtime_put(dwc->dev);
 		dwc->pending_events = false;
 		enable_irq(dwc->irq_gadget);
 	}


