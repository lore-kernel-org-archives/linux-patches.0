Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5031F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C197BC433C9;
	Tue,  1 Aug 2023 09:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882619;
	bh=+cSykmEd8jLkDlWWxthMSy1Nu6DBJj/GdLkrby1HzzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiGlg94YZ/D3S2bNJa4H8+MxwGWO3PzNx0u7FdL8aguQSeCPePBwp0VL8yf7b0R92
	 TT8ekdsPQS/v66jydCfvIhIoQnGsRN4h31G4K+6j3jocH+2JtYyUQp7ebdNE5EldGp
	 sDxbs3OiHMbqSaIKUpN+HxYT1WUv7P5izlITVsRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ravi Gunasekaran <r-gunasekaran@ti.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.1 170/228] usb: cdns3: fix incorrect calculation of ep_buf_size when more than one config
Date: Tue,  1 Aug 2023 11:20:28 +0200
Message-ID: <20230801091929.010324033@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

commit 2627335a1329a0d39d8d277994678571c4f21800 upstream.

Previously, the cdns3_gadget_check_config() function in the cdns3 driver
mistakenly calculated the ep_buf_size by considering only one
configuration's endpoint information because "claimed" will be clear after
call usb_gadget_check_config().

The fix involves checking the private flags EP_CLAIMED instead of relying
on the "claimed" flag.

Fixes: dce49449e04f ("usb: cdns3: allocate TX FIFO size according to composite EP number")
Cc: stable <stable@kernel.org>
Reported-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Tested-by: Ravi Gunasekaran <r-gunasekaran@ti.com>
Link: https://lore.kernel.org/r/20230707230015.494999-2-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3012,12 +3012,14 @@ static int cdns3_gadget_udc_stop(struct
 static int cdns3_gadget_check_config(struct usb_gadget *gadget)
 {
 	struct cdns3_device *priv_dev = gadget_to_cdns3_device(gadget);
+	struct cdns3_endpoint *priv_ep;
 	struct usb_ep *ep;
 	int n_in = 0;
 	int total;
 
 	list_for_each_entry(ep, &gadget->ep_list, ep_list) {
-		if (ep->claimed && (ep->address & USB_DIR_IN))
+		priv_ep = ep_to_cdns3_ep(ep);
+		if ((priv_ep->flags & EP_CLAIMED) && (ep->address & USB_DIR_IN))
 			n_in++;
 	}
 


