Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4E8234978;
	Mon, 10 Mar 2025 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628477; cv=none; b=ZRmS+9rdSRfT2SRE8nk2xJDI6kTWxOQjF2/ZgkobHlbPVdte5ZnD8oK7M+abPGZGq3lLgxoMmnL7A0gYXuPVQmRtQ2QB7e1i8m6OrXvUuX4HeEQg6q4RbPn3X/tlE3P/YsHfluwjldsG1J/T8gXDBLa9Fyq8JwLWO1f7d9PNQOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628477; c=relaxed/simple;
	bh=aJ+NDj6rKUblYqjSy/hL1UtAELJpiHt04P7YCLlhLZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfi2kGfgwGqqRKut2zgGx+0hccfFUNRM74FscgasFiEJocmjsw//zK+7hsr9fxD1Ar0iKJceglFkaEyVcOO0BAocPsNl/DsizciR9uzdWyL9LDaSHyRqMzJEmx09IycQqSRiMk/4Ah8e6hbhQ/t94R9uOn5WK96i8guIV4EiV3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G62M0Mdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G62M0Mdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6527CC4CEED;
	Mon, 10 Mar 2025 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628476;
	bh=aJ+NDj6rKUblYqjSy/hL1UtAELJpiHt04P7YCLlhLZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G62M0MdjrLM1Cn5BVKlO4uuXe0ha0+sWlt7b5z+8WlUkb61rWjQnAc2ilFwzsmeDp
	 lD5+j+7NSpc1vzsBOD6v5JyqVb2ZM6cuiGC2w2TYf4yrcswiByBRz9Dkds6rvyNnwf
	 xgKQP55g7kElPM2nepBNm5pIPf0RN9zVfOTnlXQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.1 071/109] usb: dwc3: gadget: Prevent irq storm when TH re-executes
Date: Mon, 10 Mar 2025 18:06:55 +0100
Message-ID: <20250310170430.386278805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Badhri Jagan Sridharan <badhri@google.com>

commit 69c58deec19628c8a686030102176484eb94fed4 upstream.

While commit d325a1de49d6 ("usb: dwc3: gadget: Prevent losing events in
event cache") makes sure that top half(TH) does not end up overwriting the
cached events before processing them when the TH gets invoked more than one
time, returning IRQ_HANDLED results in occasional irq storm where the TH
hogs the CPU. The irq storm can be prevented by the flag before event
handler busy is cleared. Default enable interrupt moderation in all
versions which support them.

ftrace event stub during dwc3 irq storm:
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000866: irq_handler_exit: irq=14 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000872: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000874: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000881: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000883: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000889: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000892: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000898: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000901: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000907: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000909: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000915: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000918: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000924: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000927: irq_handler_exit: irq=504 ret=handled
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000933: irq_handler_entry: irq=504 name=dwc3
    irq/504_dwc3-1111  ( 1111) [000] .... 70.000935: irq_handler_exit: irq=504 ret=handled
    ....

Cc: stable <stable@kernel.org>
Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Fixes: d325a1de49d6 ("usb: dwc3: gadget: Prevent losing events in event cache")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250216223003.3568039-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.c   |   16 ++++++----------
 drivers/usb/dwc3/gadget.c |   10 +++++++---
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1692,8 +1692,6 @@ static void dwc3_get_properties(struct d
 	dwc->tx_thr_num_pkt_prd = tx_thr_num_pkt_prd;
 	dwc->tx_max_burst_prd = tx_max_burst_prd;
 
-	dwc->imod_interval = 0;
-
 	dwc->tx_fifo_resize_max_num = tx_fifo_resize_max_num;
 }
 
@@ -1711,21 +1709,19 @@ static void dwc3_check_params(struct dwc
 	unsigned int hwparam_gen =
 		DWC3_GHWPARAMS3_SSPHY_IFC(dwc->hwparams.hwparams3);
 
-	/* Check for proper value of imod_interval */
-	if (dwc->imod_interval && !dwc3_has_imod(dwc)) {
-		dev_warn(dwc->dev, "Interrupt moderation not supported\n");
-		dwc->imod_interval = 0;
-	}
-
 	/*
+	 * Enable IMOD for all supporting controllers.
+	 *
+	 * Particularly, DWC_usb3 v3.00a must enable this feature for
+	 * the following reason:
+	 *
 	 * Workaround for STAR 9000961433 which affects only version
 	 * 3.00a of the DWC_usb3 core. This prevents the controller
 	 * interrupt from being masked while handling events. IMOD
 	 * allows us to work around this issue. Enable it for the
 	 * affected version.
 	 */
-	if (!dwc->imod_interval &&
-	    DWC3_VER_IS(DWC3, 300A))
+	if (dwc3_has_imod((dwc)))
 		dwc->imod_interval = 1;
 
 	/* Check the maximum_speed parameter */
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -4346,14 +4346,18 @@ static irqreturn_t dwc3_process_event_bu
 	dwc3_writel(dwc->regs, DWC3_GEVNTSIZ(0),
 		    DWC3_GEVNTSIZ_SIZE(evt->length));
 
+	evt->flags &= ~DWC3_EVENT_PENDING;
+	/*
+	 * Add an explicit write memory barrier to make sure that the update of
+	 * clearing DWC3_EVENT_PENDING is observed in dwc3_check_event_buf()
+	 */
+	wmb();
+
 	if (dwc->imod_interval) {
 		dwc3_writel(dwc->regs, DWC3_GEVNTCOUNT(0), DWC3_GEVNTCOUNT_EHB);
 		dwc3_writel(dwc->regs, DWC3_DEV_IMOD(0), dwc->imod_interval);
 	}
 
-	/* Keep the clearing of DWC3_EVENT_PENDING at the end */
-	evt->flags &= ~DWC3_EVENT_PENDING;
-
 	return ret;
 }
 


