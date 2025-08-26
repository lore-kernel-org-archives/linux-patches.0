Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189B51B85F8;
	Tue, 26 Aug 2025 13:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213917; cv=none; b=EkmSNojVCL4yBLaMVagmeA9j+4b96HQaPzn7hQnWKfEeiXvF4mb/t/uvxnAxOAT6m0E2L3yNhqW5Xna0v+IfSdA1SX8BoofVquRaEX4W/FUMbY1WQMGWMxXO91Qm1aEfz2NEts2RCtBPIBOAXO8DdjcGQeeK2CZ5YB5MP+g1Pjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213917; c=relaxed/simple;
	bh=dKryqYESpxFWyA2Zj2UpthW7AqliIHtATpp4UuawvsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ew0kQaQga7YPJw5I9oPDoHX7hSNwrB5uDoNylrWK1VId+M23w1d8D+4id60HzjeQhRG9nUxgxMA/2Q9znPkjcYlbGgPqKSQhxa4TCuaADw2sG39tD74OXim7Xi/pZHFxe8mCrXA2Qw2BqVDjt91Z84agpWns7bRv25Ars709b3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTVDkmjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTVDkmjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C90EC116B1;
	Tue, 26 Aug 2025 13:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213917;
	bh=dKryqYESpxFWyA2Zj2UpthW7AqliIHtATpp4UuawvsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTVDkmjvspuZpmROQ+YMnCCG6vWrIVmyC4Z25x+Fy3INIDKLogSFFj6TH+8I2kvwX
	 J805M8CBSAuxRxGhybFEDJ6CtHXv+iHXF6Nu43y99aY4/0LpHoOkAUMNR5KSbfCqDl
	 9x8UdTSQPf2sk6BqJi4os+JuBySlYbPxz6khVepY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Akash M <akash.m5@samsung.com>,
	Selvarasu Ganesan <selvarasu.g@samsung.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.6 529/587] usb: dwc3: Remove WARN_ON for device endpoint command timeouts
Date: Tue, 26 Aug 2025 13:11:18 +0200
Message-ID: <20250826111006.459447424@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 45eae113dccaf8e502090ecf5b3d9e9b805add6f upstream.

This commit addresses a rarely observed endpoint command timeout
which causes kernel panic due to warn when 'panic_on_warn' is enabled
and unnecessary call trace prints when 'panic_on_warn' is disabled.
It is seen during fast software-controlled connect/disconnect testcases.
The following is one such endpoint command timeout that we observed:

1. Connect
   =======
->dwc3_thread_interrupt
 ->dwc3_ep0_interrupt
  ->configfs_composite_setup
   ->composite_setup
    ->usb_ep_queue
     ->dwc3_gadget_ep0_queue
      ->__dwc3_gadget_ep0_queue
       ->__dwc3_ep0_do_control_data
        ->dwc3_send_gadget_ep_cmd

2. Disconnect
   ==========
->dwc3_thread_interrupt
 ->dwc3_gadget_disconnect_interrupt
  ->dwc3_ep0_reset_state
   ->dwc3_ep0_end_control_data
    ->dwc3_send_gadget_ep_cmd

In the issue scenario, in Exynos platforms, we observed that control
transfers for the previous connect have not yet been completed and end
transfer command sent as a part of the disconnect sequence and
processing of USB_ENDPOINT_HALT feature request from the host timeout.
This maybe an expected scenario since the controller is processing EP
commands sent as a part of the previous connect. It maybe better to
remove WARN_ON in all places where device endpoint commands are sent to
avoid unnecessary kernel panic due to warn.

Cc: stable <stable@kernel.org>
Co-developed-by: Akash M <akash.m5@samsung.com>
Signed-off-by: Akash M <akash.m5@samsung.com>
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20250808125315.1607-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/ep0.c    |   20 ++++++++++++++++----
 drivers/usb/dwc3/gadget.c |   10 ++++++++--
 2 files changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -288,7 +288,9 @@ void dwc3_ep0_out_start(struct dwc3 *dwc
 	dwc3_ep0_prepare_one_trb(dep, dwc->ep0_trb_addr, 8,
 			DWC3_TRBCTL_CONTROL_SETUP, false);
 	ret = dwc3_ep0_start_trans(dep);
-	WARN_ON(ret < 0);
+	if (ret < 0)
+		dev_err(dwc->dev, "ep0 out start transfer failed: %d\n", ret);
+
 	for (i = 2; i < DWC3_ENDPOINTS_NUM; i++) {
 		struct dwc3_ep *dwc3_ep;
 
@@ -1061,7 +1063,9 @@ static void __dwc3_ep0_do_control_data(s
 		ret = dwc3_ep0_start_trans(dep);
 	}
 
-	WARN_ON(ret < 0);
+	if (ret < 0)
+		dev_err(dwc->dev,
+			"ep0 data phase start transfer failed: %d\n", ret);
 }
 
 static int dwc3_ep0_start_control_status(struct dwc3_ep *dep)
@@ -1078,7 +1082,12 @@ static int dwc3_ep0_start_control_status
 
 static void __dwc3_ep0_do_control_status(struct dwc3 *dwc, struct dwc3_ep *dep)
 {
-	WARN_ON(dwc3_ep0_start_control_status(dep));
+	int	ret;
+
+	ret = dwc3_ep0_start_control_status(dep);
+	if (ret)
+		dev_err(dwc->dev,
+			"ep0 status phase start transfer failed: %d\n", ret);
 }
 
 static void dwc3_ep0_do_control_status(struct dwc3 *dwc,
@@ -1121,7 +1130,10 @@ void dwc3_ep0_end_control_data(struct dw
 	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
 	memset(&params, 0, sizeof(params));
 	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-	WARN_ON_ONCE(ret);
+	if (ret)
+		dev_err_ratelimited(dwc->dev,
+			"ep0 data phase end transfer failed: %d\n", ret);
+
 	dep->resource_index = 0;
 }
 
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1765,7 +1765,11 @@ static int __dwc3_stop_active_transfer(s
 		dep->flags |= DWC3_EP_DELAY_STOP;
 		return 0;
 	}
-	WARN_ON_ONCE(ret);
+
+	if (ret)
+		dev_err_ratelimited(dep->dwc->dev,
+				"end transfer failed: %d\n", ret);
+
 	dep->resource_index = 0;
 
 	if (!interrupt)
@@ -4045,7 +4049,9 @@ static void dwc3_clear_stall_all_ep(stru
 		dep->flags &= ~DWC3_EP_STALL;
 
 		ret = dwc3_send_clear_stall_ep_cmd(dep);
-		WARN_ON_ONCE(ret);
+		if (ret)
+			dev_err_ratelimited(dwc->dev,
+				"failed to clear STALL on %s\n", dep->name);
 	}
 }
 


