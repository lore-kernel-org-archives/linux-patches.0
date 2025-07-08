Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB392DCF48;
	Tue,  8 Jul 2025 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993662; cv=none; b=eTC3e5rBsJzwK3P+yom8xOq9C9CobwQkT1daRLC3kMd1o46NthwENIhQ2FFoEhpoKYkhtSa9mNSp2gq/wEYUO9Axh+Khbmt51CG2CGi9ArzlRn79boAZcUD6yd1EpEmUKmyOFU9J8Cj0PmTbgq0kYN4cB47rZnS5Mie5b17nL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993662; c=relaxed/simple;
	bh=owVdmBhV5fqgUH98terFKhHCv1GWl6KUjFWpbm2+V1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSGsk8NoB5RUHYetyHPxhdS1/RNcv39k7PcwGpFPSBtv8HfiTtTA+ZUcYa2y0ndMKWqFFQ3mjmvpWnpuBiJYhjTr9E1ILa6s9RJRuB4oHUMtgIAAi/azWcpmhyW+wpGU9p2zyl6560SuPLVxjsYJZZpuk/gIlTREFQNHrqhFB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOGNB8nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOGNB8nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C860FC4CEED;
	Tue,  8 Jul 2025 16:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993662;
	bh=owVdmBhV5fqgUH98terFKhHCv1GWl6KUjFWpbm2+V1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOGNB8njU2h6lf1PgwauCHl9d4uRzARshN0b+7HIfyBQE2lX0j6C6Uq2a3Z4cSaPx
	 DKSiIWoX+vJqfOWbYDMVpnPyViN1SZgpMdm84CvDZLfcVRPD3F1BaZaQInzlMJ/gGd
	 A4tz9Z2JtcOn2XDzLtHdOCnqdpCFHNlGox6j1DMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.15 151/178] usb: cdnsp: Fix issue with CV Bad Descriptor test
Date: Tue,  8 Jul 2025 18:23:08 +0200
Message-ID: <20250708162240.454997859@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 2831a81077f5162f104ba5a97a7d886eb371c21c upstream.

The SSP2 controller has extra endpoint state preserve bit (ESP) which
setting causes that endpoint state will be preserved during
Halt Endpoint command. It is used only for EP0.
Without this bit the Command Verifier "TD 9.10 Bad Descriptor Test"
failed.
Setting this bit doesn't have any impact for SSP controller.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95382CCD50549DABAEFD6156DD7CA@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-debug.h  |    5 +++--
 drivers/usb/cdns3/cdnsp-ep0.c    |   18 +++++++++++++++---
 drivers/usb/cdns3/cdnsp-gadget.h |    6 ++++++
 drivers/usb/cdns3/cdnsp-ring.c   |    3 ++-
 4 files changed, 26 insertions(+), 6 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-debug.h
+++ b/drivers/usb/cdns3/cdnsp-debug.h
@@ -327,12 +327,13 @@ static inline const char *cdnsp_decode_t
 	case TRB_RESET_EP:
 	case TRB_HALT_ENDPOINT:
 		ret = scnprintf(str, size,
-				"%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c",
+				"%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c %c",
 				cdnsp_trb_type_string(type),
 				ep_num, ep_id % 2 ? "out" : "in",
 				TRB_TO_EP_INDEX(field3), field1, field0,
 				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+				field3 & TRB_CYCLE ? 'C' : 'c',
+				field3 & TRB_ESP ? 'P' : 'p');
 		break;
 	case TRB_STOP_RING:
 		ret = scnprintf(str, size,
--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,6 +414,7 @@ static int cdnsp_ep0_std_request(struct
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
+	struct cdnsp_ep *pep;
 	int ret = -EINVAL;
 	u16 len;
 
@@ -427,10 +428,21 @@ void cdnsp_setup_analyze(struct cdnsp_de
 		goto out;
 	}
 
+	pep = &pdev->eps[0];
+
 	/* Restore the ep0 to Stopped/Running state. */
-	if (pdev->eps[0].ep_state & EP_HALTED) {
-		trace_cdnsp_ep0_halted("Restore to normal state");
-		cdnsp_halt_endpoint(pdev, &pdev->eps[0], 0);
+	if (pep->ep_state & EP_HALTED) {
+		if (GET_EP_CTX_STATE(pep->out_ctx) == EP_STATE_HALTED)
+			cdnsp_halt_endpoint(pdev, pep, 0);
+
+		/*
+		 * Halt Endpoint Command for SSP2 for ep0 preserve current
+		 * endpoint state and driver has to synchronize the
+		 * software endpoint state with endpoint output context
+		 * state.
+		 */
+		pep->ep_state &= ~EP_HALTED;
+		pep->ep_state |= EP_STOPPED;
 	}
 
 	/*
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -987,6 +987,12 @@ enum cdnsp_setup_dev {
 #define STREAM_ID_FOR_TRB(p)		((((p)) << 16) & GENMASK(31, 16))
 #define SCT_FOR_TRB(p)			(((p) << 1) & 0x7)
 
+/*
+ * Halt Endpoint Command TRB field.
+ * The ESP bit only exists in the SSP2 controller.
+ */
+#define TRB_ESP				BIT(9)
+
 /* Link TRB specific fields. */
 #define TRB_TC				BIT(1)
 
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2485,7 +2485,8 @@ void cdnsp_queue_halt_endpoint(struct cd
 {
 	cdnsp_queue_command(pdev, 0, 0, 0, TRB_TYPE(TRB_HALT_ENDPOINT) |
 			    SLOT_ID_FOR_TRB(pdev->slot_id) |
-			    EP_ID_FOR_TRB(ep_index));
+			    EP_ID_FOR_TRB(ep_index) |
+			    (!ep_index ? TRB_ESP : 0));
 }
 
 void cdnsp_force_header_wakeup(struct cdnsp_device *pdev, int intf_num)


