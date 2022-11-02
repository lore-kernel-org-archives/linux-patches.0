Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D157E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F914C433D6;
	Wed,  2 Nov 2022 03:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358725;
	bh=fuavFHgkoySo8dWtw54JLcPQmzC1dSeCJtY/9J9ejIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATuR7GhAwBowgL5IUEnINNUvaJDeGOwVpBnMjAGn8mjrJ/s8c1Mz0EaqTodgEZN6U
	 ClSwpcVcvKPXd0F7IRxhAI0j/UcSecjCOPIAYSg/4PEbpNGEuSv3vLBt8wFn3eGAm3
	 cE77kMM2MpfCybVZN1YGstRiujGjl+CJ1is+5o0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Vanhoof <jdv1029@gmail.com>,
	Dan Vacura <w36195@motorola.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.10 07/91] usb: dwc3: gadget: Stop processing more requests on IMI
Date: Wed,  2 Nov 2022 03:32:50 +0100
Message-Id: <20221102022055.254341291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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

commit f78961f8380b940e0cfc7e549336c21a2ad44f4d upstream.

When servicing a transfer completion event, the dwc3 driver will reclaim
TRBs of started requests up to the request associated with the interrupt
event. Currently we don't check for interrupt due to missed isoc, and
the driver may attempt to reclaim TRBs beyond the associated event. This
causes invalid memory access when the hardware still owns the TRB. If
there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
to stop servicing further.

Note that only the last TRB of chained TRBs has its status updated with
missed isoc.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
Reported-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2800,6 +2800,10 @@ static int dwc3_gadget_ep_reclaim_comple
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;


