Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03337E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8CBC433D6;
	Wed,  2 Nov 2022 03:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358903;
	bh=MAoQKYuJO2UVtv5vL+xfA3/iOpD+eRoNRmFUwozXIAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9c4UeNpAzRQreUD9JVLKdLnJciA/Zh+bhkGvzTgE6Qh5LIUtyDx/u8gNXdzQaZrH
	 cmwKSVi8yJsM0auUY4fE8yBF/P4+O0ZzEhBlhJ94jAWLAf4dIbJ1+zx8gy5Suddbj1
	 GVTgP4JY9FWAIjHw//tHIqyN881q0cQ4YihBXGs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Jeff Vanhoof <jdv1029@gmail.com>
Subject: [PATCH 5.10 08/91] usb: dwc3: gadget: Dont set IMI for no_interrupt
Date: Wed,  2 Nov 2022 03:32:51 +0100
Message-Id: <20221102022055.283956513@linuxfoundation.org>
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

commit 308c316d16cbad99bb834767382baa693ac42169 upstream.

The gadget driver may have a certain expectation of how the request
completion flow should be from to its configuration. Make sure the
controller driver respect that. That is, don't set IMI (Interrupt on
Missed Isoc) when usb_request->no_interrupt is set. Also, the driver
should only set IMI to the last TRB of a chain.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/ced336c84434571340c07994e3667a0ee284fefe.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1064,8 +1064,8 @@ static void dwc3_prepare_one_trb(struct
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:


