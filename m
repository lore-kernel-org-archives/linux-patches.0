Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E2A633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A49C433D6;
	Wed,  2 Nov 2022 03:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360338;
	bh=9X5aJwJlr+ihluMnQtX3wY7Hn5ANP+WCSlW8HgIurOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaGhXTNrlKTGqL6xSJVbkYpaqLJn/Z18UafV6+48ts9De21u2jgic3KHcY8itrpll
	 89YaWceB0UoTTwNqbzDwdyixivPTg0ILRUgReVkaoeBqupNZRDkt02w31XAsthuzDK
	 HKxe9qcotxTK7m2MLxPdORa8VPKSzmLjFw+vYTmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Jeff Vanhoof <jdv1029@gmail.com>
Subject: [PATCH 4.14 20/60] usb: dwc3: gadget: Dont set IMI for no_interrupt
Date: Wed,  2 Nov 2022 03:34:41 +0100
Message-Id: <20221102022051.738068660@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
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
@@ -965,8 +965,8 @@ static void __dwc3_prepare_one_trb(struc
 			trb->ctrl = DWC3_TRBCTL_ISOCHRONOUS;
 		}
 
-		/* always enable Interrupt on Missed ISOC */
-		trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
+		if (!no_interrupt && !chain)
+			trb->ctrl |= DWC3_TRB_CTRL_ISP_IMI;
 		break;
 
 	case USB_ENDPOINT_XFER_BULK:


