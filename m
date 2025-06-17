Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5D02FA624;
	Tue, 17 Jun 2025 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179478; cv=none; b=GjV8i6yGXpZ+OR2SaDJCE/b/oTzLgVL/yiI09zSRJYuQ0MEKAtKQ2sZ2HIDXBAewCatA0WCcQkwB1//LHbxLyUshqnf9O1zpgDvGubCKTHUTtBW8H8q644alItDASzZ11N0cmMeUY5Gnf2UDAHzCNWAU0nvAU7IknxIzVBX4+/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179478; c=relaxed/simple;
	bh=tQXjlStfPU9KJCqDJpQIka2l65II/vZKODV+Fa6GOJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHCfmwBkjC5MC5JIHfEGM9opvr+1pMKrf17peJ8xNo3wVyRIBlLPsaRn4WrSlX9Z0kTS2Qsb0DYkPHSDXAx2nQe6c2t5b6jwcPMF4uXB8QyjoC2KvAmDWsh6J1WU2rubeibwsTCxRpqdAH6iGTCQR8NHAJE6/tmYWBws+GGYDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJxxs3oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJxxs3oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C089C4CEE3;
	Tue, 17 Jun 2025 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179478;
	bh=tQXjlStfPU9KJCqDJpQIka2l65II/vZKODV+Fa6GOJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJxxs3oR08sOHfrma4INmUQMZcbwQ8QMIMt+/jynUi6K0FKTjPpL7g7WrluqRPKEI
	 zgFmLI/FmwSQVrJstNe9ZISsiiVYVMPFqVPzU0aISiDqueXCwCQJ2hYH78T8NYIo46
	 /GcZTCVVq14yAaIS3cQoNC3I2Z3q5EXO/MMSY248=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.15 758/780] usb: cdnsp: Fix issue with detecting USB 3.2 speed
Date: Tue, 17 Jun 2025 17:27:46 +0200
Message-ID: <20250617152522.375115452@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

commit 2852788cfbe9ca1ab68509d65804413871f741f9 upstream.

Patch adds support for detecting SuperSpeedPlus Gen1 x2 and
SuperSpeedPlus Gen2 x2 speed.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95387AD98EDCA695FECE52BADD96A@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    3 ++-
 drivers/usb/cdns3/cdnsp-gadget.h |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -29,7 +29,8 @@
 unsigned int cdnsp_port_speed(unsigned int port_status)
 {
 	/*Detect gadget speed based on PORTSC register*/
-	if (DEV_SUPERSPEEDPLUS(port_status))
+	if (DEV_SUPERSPEEDPLUS(port_status) ||
+	    DEV_SSP_GEN1x2(port_status) || DEV_SSP_GEN2x2(port_status))
 		return USB_SPEED_SUPER_PLUS;
 	else if (DEV_SUPERSPEED(port_status))
 		return USB_SPEED_SUPER;
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -285,11 +285,15 @@ struct cdnsp_port_regs {
 #define XDEV_HS			(0x3 << 10)
 #define XDEV_SS			(0x4 << 10)
 #define XDEV_SSP		(0x5 << 10)
+#define XDEV_SSP1x2		(0x6 << 10)
+#define XDEV_SSP2x2		(0x7 << 10)
 #define DEV_UNDEFSPEED(p)	(((p) & DEV_SPEED_MASK) == (0x0 << 10))
 #define DEV_FULLSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_FS)
 #define DEV_HIGHSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_HS)
 #define DEV_SUPERSPEED(p)	(((p) & DEV_SPEED_MASK) == XDEV_SS)
 #define DEV_SUPERSPEEDPLUS(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP)
+#define DEV_SSP_GEN1x2(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP1x2)
+#define DEV_SSP_GEN2x2(p)	(((p) & DEV_SPEED_MASK) == XDEV_SSP2x2)
 #define DEV_SUPERSPEED_ANY(p)	(((p) & DEV_SPEED_MASK) >= XDEV_SS)
 #define DEV_PORT_SPEED(p)	(((p) >> 10) & 0x0f)
 /* Port Link State Write Strobe - set this when changing link state */


