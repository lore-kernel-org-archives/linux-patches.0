Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90971A6827;
	Mon,  4 May 2026 14:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904416; cv=none; b=IPTYdHpAZ+dP3jVs2iPlfHgT+90LuzytqmvX//zFXovlNamwyCcFLA92owJYn/dn/j9bbzxTYwiS6a9eoJofdJNXqB8zNFMt07zOSb8bw8gifxmjp5mhkD5u0bIThHaHFoqiY1Zd0x9rwXx/hfXWIAf9Xq9yQeU3CGiwujyeFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904416; c=relaxed/simple;
	bh=ZPocLCxSVOmPbZ9gfmSxIW/8LsLqWr6OnbgU9MJ/FSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsYDVgi+R89iHkdaKs2Zx9PSw1+f8ZpADTtZ+5WIo+PdAmnMVeAH4tw+CO10CbxLzcNjPGvBJ0T7owQ6p3yKcJLWuXzwicCnS02iQ0xLElCJskxRZF+1y3aSSNo3Cb8Vt9du3EplxXCfQA9mArHkZnXAM9cto0CYrHIEOJXpVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0D0bbhh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0D0bbhh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF42C2BCB8;
	Mon,  4 May 2026 14:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904416;
	bh=ZPocLCxSVOmPbZ9gfmSxIW/8LsLqWr6OnbgU9MJ/FSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0D0bbhh62YEtAV5/uefPy/qjqX3kZj1p1lLMpIbAiIztrt2b5IId4cF9k7BXkrwxX
	 fQFv+CRSwfrNSDofoWJJ6Mw/8TL1fCJJDUv0PPgwWpzdjZAbFnws+34K8wws/B0yuY
	 rLkIm+Uhy+bI+WoOIfDFQTcdCH5uqGi/VW8B1YXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.12 006/215] usb: chipidea: core: allow ci_irq_handler() handle both ID and VBUS change
Date: Mon,  4 May 2026 15:50:25 +0200
Message-ID: <20260504135130.408101113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b94b631d9f78e653855f7fb58dbcb86c2a856f6f upstream.

For USB role switch-triggered IRQ, ID and VBUS change come together, for
example when switching from host to device mode. ID indicate a role switch
and VBUS is required to determine whether the device controller can start
operating. Currently, ci_irq_handler() handles only a single event per
invocation. This can cause an issue where switching to device mode results
in the device controller not working at all. Allowing ci_irq_handler() to
handle both ID and VBUS change in one call resolves this issue.

Meanwhile, this change also affects the VBUS event handling logic.
Previously, if an ID event indicated host mode the VBUS IRQ will be
ignored as the device disable BSE when stop() is called. With the new
behavior, if ID and VBUS IRQ occur together and the target mode is host,
the VBUS event is queued and ci_handle_vbus_change() will call
usb_gadget_vbus_connect(), after which USBMODE is switched to device mode,
causing host mode to stop working. To prevent this, an additional check is
added to skip handling VBUS event when current role is not device mode.

Suggested-by: Peter Chen <peter.chen@kernel.org>
Fixes: e1b5d2bed67c ("usb: chipidea: core: handle usb role switch in a common way")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260402071457.2516021-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |   45 ++++++++++++++++++++++----------------------
 drivers/usb/chipidea/otg.c  |    3 ++
 2 files changed, 26 insertions(+), 22 deletions(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -543,30 +543,31 @@ static irqreturn_t ci_irq_handler(int ir
 			if (ret == IRQ_HANDLED)
 				return ret;
 		}
-	}
 
-	/*
-	 * Handle id change interrupt, it indicates device/host function
-	 * switch.
-	 */
-	if (ci->is_otg && (otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS)) {
-		ci->id_event = true;
-		/* Clear ID change irq status */
-		hw_write_otgsc(ci, OTGSC_IDIS, OTGSC_IDIS);
-		ci_otg_queue_work(ci);
-		return IRQ_HANDLED;
-	}
+		/*
+		 * Handle id change interrupt, it indicates device/host function
+		 * switch.
+		 */
+		if ((otgsc & OTGSC_IDIE) && (otgsc & OTGSC_IDIS)) {
+			ci->id_event = true;
+			/* Clear ID change irq status */
+			hw_write_otgsc(ci, OTGSC_IDIS, OTGSC_IDIS);
+		}
 
-	/*
-	 * Handle vbus change interrupt, it indicates device connection
-	 * and disconnection events.
-	 */
-	if (ci->is_otg && (otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS)) {
-		ci->b_sess_valid_event = true;
-		/* Clear BSV irq */
-		hw_write_otgsc(ci, OTGSC_BSVIS, OTGSC_BSVIS);
-		ci_otg_queue_work(ci);
-		return IRQ_HANDLED;
+		/*
+		 * Handle vbus change interrupt, it indicates device connection
+		 * and disconnection events.
+		 */
+		if ((otgsc & OTGSC_BSVIE) && (otgsc & OTGSC_BSVIS)) {
+			ci->b_sess_valid_event = true;
+			/* Clear BSV irq */
+			hw_write_otgsc(ci, OTGSC_BSVIS, OTGSC_BSVIS);
+		}
+
+		if (ci->id_event || ci->b_sess_valid_event) {
+			ci_otg_queue_work(ci);
+			return IRQ_HANDLED;
+		}
 	}
 
 	/* Handle device/host interrupt */
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -130,6 +130,9 @@ enum ci_role ci_otg_role(struct ci_hdrc
 
 void ci_handle_vbus_change(struct ci_hdrc *ci)
 {
+	if (ci->role != CI_ROLE_GADGET)
+		return;
+
 	if (!ci->is_otg) {
 		if (ci->platdata->flags & CI_HDRC_FORCE_VBUS_ACTIVE_ALWAYS)
 			usb_gadget_vbus_connect(&ci->gadget);


