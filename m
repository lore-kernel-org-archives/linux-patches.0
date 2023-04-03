Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF476FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5975C433D2;
	Mon,  3 Apr 2023 14:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532045;
	bh=P8xPeegyLa6SioqVZcANDVZXJg3G0MARxdGK6RA/sTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNkx6CaBfAt+izxXs3CJU29Fb12e3LdbMHbJzINTuNWGcp77F9iZalFBbHWuEPTLu
	 udC890406CvJueBlZqN2LBKHMG5+wQKqmj/m3efa+E99m/3s0Om0RR9vZOgDeNKuGM
	 zgMmn6slf8PxfaZcNZtDGQIQasoiYU8t/1+1rif4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/173] usb: dwc3: gadget: Add 1ms delay after end transfer command without IOC
Date: Mon,  3 Apr 2023 16:08:40 +0200
Message-Id: <20230403140417.844471110@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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

[ Upstream commit d8a2bb4eb75866275b5cf7de2e593ac3449643e2 ]

Previously, there was a 100uS delay inserted after issuing an end transfer
command for specific controller revisions.  This was due to the fact that
there was a GUCTL2 bit field which enabled synchronous completion of the
end transfer command once the CMDACT bit was cleared in the DEPCMD
register.  Since this bit does not exist for all controller revisions and
the current implementation heavily relies on utizling the EndTransfer
command completion interrupt, add the delay back in for uses where the
interrupt on completion bit is not set, and increase the duration to 1ms
for the controller to complete the command.

An issue was seen where the USB request buffer was unmapped while the DWC3
controller was still accessing the TRB.  However, it was confirmed that the
end transfer command was successfully submitted. (no end transfer timeout)
In situations, such as dwc3_gadget_soft_disconnect() and
__dwc3_gadget_ep_disable(), the dwc3_remove_request() is utilized, which
will issue the end transfer command, and follow up with
dwc3_gadget_giveback().  At least for the USB ep disable path, it is
required for any pending and started requests to be completed and returned
to the function driver in the same context of the disable call.  Without
the GUCTL2 bit, it is not ensured that the end transfer is completed before
the buffers are unmapped.

Fixes: cf2f8b63f7f1 ("usb: dwc3: gadget: Remove END_TRANSFER delay")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20230306200557.29387-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ce5131ccd60a9..01cecde76140b 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1453,6 +1453,7 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
  */
 static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
 {
+	struct dwc3 *dwc = dep->dwc;
 	struct dwc3_gadget_ep_cmd_params params;
 	u32 cmd;
 	int ret;
@@ -1466,10 +1467,13 @@ static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool int
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	if (!interrupt)
+	if (!interrupt) {
+		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
+			mdelay(1);
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else if (!ret)
+	} else if (!ret) {
 		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	}
 
 	return ret;
 }
@@ -3299,7 +3303,11 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * enabled, the EndTransfer command will have completed upon
 	 * returning from this function.
 	 *
-	 * This mode is NOT available on the DWC_usb31 IP.
+	 * This mode is NOT available on the DWC_usb31 IP.  In this
+	 * case, if the IOC bit is not set, then delay by 1ms
+	 * after issuing the EndTransfer command.  This allows for the
+	 * controller to handle the command completely before DWC3
+	 * remove requests attempts to unmap USB request buffers.
 	 */
 
 	__dwc3_stop_active_transfer(dep, force, interrupt);
-- 
2.39.2



