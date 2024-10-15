Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B081D89F5;
	Tue, 15 Oct 2024 11:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993139; cv=none; b=Qae3kMvZyINgM3DsfTcYJcE9BqG0fEcmh7NVaLlwR4K70mdMtwMdnMcYTCE9LVQ6UBlraAC86vpYqBpILg35Ato9lna83Qzvr4CWhO9LTlFyHE+z9CWcsvReZNAgZUgfq8abWcklU2Y3bxWp1RUnqXolphTma7Kvvr5MO6PYS4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993139; c=relaxed/simple;
	bh=z2xtKaEOhaC6+Wb0iB53An8aMrzhwscPA1nJbACoDnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYk+w2j3QB8/zblVmjuryvjCfIMRj4ezo9qcFiLz9shTDXVHzi2G8arZwj9oWToTOjwrtIMWYPBuQoRe78AkN/oQScfJNYEKKX7GYxn6Vv3SRAxGtgeaaL9WcevaUH2YJnFZ9G5PM4L0WEPFOx1jLhsiXyhjU4nSLQ4Qiqlt+wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9JvmbBa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9JvmbBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED88C4CEC6;
	Tue, 15 Oct 2024 11:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993139;
	bh=z2xtKaEOhaC6+Wb0iB53An8aMrzhwscPA1nJbACoDnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9JvmbBa+GNTdH2Zj0O1XOZW9cOEDft600OarFa9eEtnNaZQdYer5LCjDDy3dSRdw
	 uAjHuaTblYTvt4ILBzL4b5ZP1e1NNgFFulm/h25ju6cMsLG2zi8aVRIbZWnFP/1NfN
	 QOl8TBe2KB5bVelBMZKCHDiMagmzrubraSKJAMaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Marek <tomas.marek@elrest.cz>
Subject: [PATCH 5.15 323/691] usb: dwc2: drd: fix clock gating on USB role switch
Date: Tue, 15 Oct 2024 13:24:31 +0200
Message-ID: <20241015112453.157032233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Tomas Marek <tomas.marek@elrest.cz>

commit 2c6b6afa59e78bebcb65bbc8a76b3459f139547c upstream.

The dwc2_handle_usb_suspend_intr() function disables gadget clocks in USB
peripheral mode when no other power-down mode is available (introduced by
commit 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr function.")).
However, the dwc2_drd_role_sw_set() USB role update handler attempts to
read DWC2 registers if the USB role has changed while the USB is in suspend
mode (when the clocks are gated). This causes the system to hang.

Release the gadget clocks before handling the USB role update.

Fixes: 0112b7ce68ea ("usb: dwc2: Update dwc2_handle_usb_suspend_intr function.")
Cc: stable@vger.kernel.org
Signed-off-by: Tomas Marek <tomas.marek@elrest.cz>
Link: https://lore.kernel.org/r/20240906055025.25057-1-tomas.marek@elrest.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/drd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/dwc2/drd.c
+++ b/drivers/usb/dwc2/drd.c
@@ -105,6 +105,15 @@ static int dwc2_drd_role_sw_set(struct u
 
 	spin_lock_irqsave(&hsotg->lock, flags);
 
+	if ((IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) ||
+	     IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)) &&
+	     dwc2_is_device_mode(hsotg) &&
+	     hsotg->lx_state == DWC2_L2 &&
+	     hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
+	     hsotg->bus_suspended &&
+	     !hsotg->params.no_clock_gating)
+		dwc2_gadget_exit_clock_gating(hsotg, 0);
+
 	if (role == USB_ROLE_HOST) {
 		already = dwc2_ovr_avalid(hsotg, true);
 	} else if (role == USB_ROLE_DEVICE) {


