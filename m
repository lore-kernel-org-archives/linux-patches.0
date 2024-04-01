Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376047A5D;
	Mon,  1 Apr 2024 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991469; cv=none; b=rXrg8AnhWGinUmahKTlppO/gxoI0rhuNcrTpJkKseM/3KYmtKW3tM74XSaNtbrmlbdEE7yk6t6jYZW7TejctRaLzauVAmwVslAyO+9M6oPd3OdtxTheG+u6xIOYvPTQxAPEco7MZTvPhcw2npycBBuBIVRmakeX5JuIKrjcH6k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991469; c=relaxed/simple;
	bh=BMWoh66hKoYwmS+SPH3nMwfiSZHBQgnar5ghPFQ2rTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BB3+TNhaMlklRmADSEEvnyN5X4TuMuOABoJF3W5LuJpNU9GWJXe3d/R57rZnIPMkwGqsetHyhZ17uHq27CXT+XOhJW2khYV2r6pM5wsXLbKj9nmu5SwaC3PsJgYKsHon+N2hwZHyJmBSPX+jFOC4O60eTgk4rzPOYdTGF3M4mD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBS9PGug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBS9PGug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1239FC433C7;
	Mon,  1 Apr 2024 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991469;
	bh=BMWoh66hKoYwmS+SPH3nMwfiSZHBQgnar5ghPFQ2rTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBS9PGugW62/W2AJ67EzKtk6OWfjI+cDxeQpm1Y62/ZGNXWVYJrgR80i6frfpeu9E
	 fM2MVMI0CTiY4ygm1OXTP+uknvYsdF34IeVYesXuqs4+Lm1xXGL52IwowHxSkUP9w8
	 g1WU6fCFJRAa+Su/U/mcdZ3HaFlLjmLKubOHCrcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.1 246/272] usb: dwc2: gadget: Fix exiting from clock gating
Date: Mon,  1 Apr 2024 17:47:16 +0200
Message-ID: <20240401152538.680672900@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit 31f42da31417bec88158f3cf62d19db836217f1e upstream.

Added exiting from the clock gating mode on USB Reset Detect interrupt
if core in the clock gating mode.
Added new condition to check core in clock gating mode or no.

Fixes: 9b4965d77e11 ("usb: dwc2: Add exit clock gating from session request interrupt")
Fixes: 5d240efddc7f ("usb: dwc2: Add exit clock gating from wakeup interrupt")
Fixes: 16c729f90bdf ("usb: dwc2: Allow exit clock gating in urb enqueue")
Fixes: 401411bbc4e6 ("usb: dwc2: Add exit clock gating before removing driver")
CC: stable@vger.kernel.org
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/cbcc2ccd37e89e339130797ed68ae4597db773ac.1708938774.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core_intr.c |    9 ++++++---
 drivers/usb/dwc2/gadget.c    |    6 ++++++
 drivers/usb/dwc2/hcd.c       |    2 +-
 drivers/usb/dwc2/platform.c  |    2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)

--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -297,7 +297,8 @@ static void dwc2_handle_session_req_intr
 
 			/* Exit gadget mode clock gating. */
 			if (hsotg->params.power_down ==
-			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended)
+			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended &&
+			    !hsotg->params.no_clock_gating)
 				dwc2_gadget_exit_clock_gating(hsotg, 0);
 		}
 
@@ -408,7 +409,8 @@ static void dwc2_handle_wakeup_detected_
 
 			/* Exit gadget mode clock gating. */
 			if (hsotg->params.power_down ==
-			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended)
+			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended &&
+			    !hsotg->params.no_clock_gating)
 				dwc2_gadget_exit_clock_gating(hsotg, 0);
 		} else {
 			/* Change to L0 state */
@@ -425,7 +427,8 @@ static void dwc2_handle_wakeup_detected_
 			}
 
 			if (hsotg->params.power_down ==
-			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended)
+			    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended &&
+			    !hsotg->params.no_clock_gating)
 				dwc2_host_exit_clock_gating(hsotg, 1);
 
 			/*
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3728,6 +3728,12 @@ irq_retry:
 		if (hsotg->in_ppd && hsotg->lx_state == DWC2_L2)
 			dwc2_exit_partial_power_down(hsotg, 0, true);
 
+		/* Exit gadget mode clock gating. */
+		if (hsotg->params.power_down ==
+		    DWC2_POWER_DOWN_PARAM_NONE && hsotg->bus_suspended &&
+		    !hsotg->params.no_clock_gating)
+			dwc2_gadget_exit_clock_gating(hsotg, 0);
+
 		hsotg->lx_state = DWC2_L0;
 	}
 
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -4657,7 +4657,7 @@ static int _dwc2_hcd_urb_enqueue(struct
 	}
 
 	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
-	    hsotg->bus_suspended) {
+	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
 		if (dwc2_is_device_mode(hsotg))
 			dwc2_gadget_exit_clock_gating(hsotg, 0);
 		else
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -298,7 +298,7 @@ static int dwc2_driver_remove(struct pla
 
 	/* Exit clock gating when driver is removed. */
 	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
-	    hsotg->bus_suspended) {
+	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
 		if (dwc2_is_device_mode(hsotg))
 			dwc2_gadget_exit_clock_gating(hsotg, 0);
 		else


