Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1325BBA3F;
	Mon,  1 Apr 2024 16:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990580; cv=none; b=AebjTbWsFjDC/llEOHVSjCuLj2dG00n8YlXNgsn08EaJnASCPAx/gU2F1CyAJ8KCNXOKePiCiSwnUt3OkVvuoK2wSD1ssr/zRk3F3hTg1g39cnWmdKReZ4Yh3xe+qIfdrPfcFnSFAPoMLnFBtkEYyXAkN4RODmCwavVAjPSET7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990580; c=relaxed/simple;
	bh=Ky1NRhY+E9cWuw+3wGHqRCs4LAjCz97df+7zp8gOqR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdwUzMlUyOZK37balzDhUVLlFP0ix2fOGFnu7RICBeVybw1a52jJrJ5afm5lcB2V9Msu3k1tREUImkHDyAJQdkvK/tYyaaGzA4rA+b9YIOcXe2/UmrFRYbZpNZdudd7e0JnqqcG7ARymLCp7P0jsRJrIJcd2JsmV6PPX5mhqtcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znqFaWgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znqFaWgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807EAC433C7;
	Mon,  1 Apr 2024 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990579;
	bh=Ky1NRhY+E9cWuw+3wGHqRCs4LAjCz97df+7zp8gOqR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znqFaWgZlTa3d9/+Zy9zA5kLLaddO3JnktNbqsv626spAbxmPgRICuUad68LSTZus
	 SLg+L6Vo8Je47sk/3fbrH5fY0H3PNqOFGBO1BfuGigWldx+tVgLNqSVzu5Q4KOHSYy
	 VMQdTk8uvNY+OSMBQjv3+mTgg8H14zQihYIQlEUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 6.6 369/396] usb: dwc2: gadget: Fix exiting from clock gating
Date: Mon,  1 Apr 2024 17:46:58 +0200
Message-ID: <20240401152558.916368922@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3727,6 +3727,12 @@ irq_retry:
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
@@ -331,7 +331,7 @@ static void dwc2_driver_remove(struct pl
 
 	/* Exit clock gating when driver is removed. */
 	if (hsotg->params.power_down == DWC2_POWER_DOWN_PARAM_NONE &&
-	    hsotg->bus_suspended) {
+	    hsotg->bus_suspended && !hsotg->params.no_clock_gating) {
 		if (dwc2_is_device_mode(hsotg))
 			dwc2_gadget_exit_clock_gating(hsotg, 0);
 		else


