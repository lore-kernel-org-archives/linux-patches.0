Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B222D3A69;
	Sun,  7 Jun 2026 10:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828661; cv=none; b=aE5sTvkMLq7Eqr8T/jgogX0wrN/ydBlx0FC7PKDYntW34ra1FquOfq5IWSQYcDqUE8llDSCUixK+70YUh4mOhchtvgv8nUU35VIC50/U3Q6d7EfAXrTyxOpaE3OeJmTpBUsOnxD+XrXZKuhbFeh6urj2idQdZPsBOSKkzsvUMM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828661; c=relaxed/simple;
	bh=q6wxvO0AKokay83q4FeDcUQ5Z85Bhu//IUJuQSJTSk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrCXVbv505mRY+l2Ayywjvkk8ZncBAB6DHNumN6GklytKmuTglsPV6tZmP0sepzuEGaKjfn1QnQcXGA5YgfMWs2CrhLmuEpf2kVuLy/ixIU2258n+tsUVw1wSroFYVEyUtvTi+rWNMWWxElUhEt2USAwMtEzu4Ne8NiaULzuFIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnMGiQvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnMGiQvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04BD1F00893;
	Sun,  7 Jun 2026 10:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828660;
	bh=8J7rRVpUdc95BQmrRt0M07PrtObLATkx4QUyJ4aSNRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TnMGiQvNPSv2vhYOwmT83S4qV54WG+Uvi6yYWcACg25mwT3gkvt81ZPOwgt++/HM3
	 UTYJ8xIR4VauOkSIfyUJA+2WYVxpYfLuEdKlZ6G0lE9ponN4coa6zWhUF/S0My+iTw
	 l1ED8alK5OrffAx6ikDoFqw9Xg5bTSirhdOeLCRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>
Subject: [PATCH 7.0 201/332] usb: cdns3: gadget: fix request skipping after clearing halt
Date: Sun,  7 Jun 2026 11:59:30 +0200
Message-ID: <20260607095735.435806125@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongchao Wu <yongchao.wu@autochips.com>

commit c8778ff817a7047d6848fefba99dcb27b1bf01fe upstream.

According to the cdns3 datasheet, the EPRST (Endpoint Reset) command
causes the DMA engine to reposition its internal pointer to the next
Transfer Descriptor (TD) if it was already processing one.

This issue is consistently observed during the ADB identification
process on macOS hosts, where the host issues a Clear_Halt. Although
commit 4bf2dd65135a ("usb: cdns3: gadget: toggle cycle bit before reset
endpoint") attempted to avoid DMA advance by toggling the cycle bit,
trace logs show that on certain hosts like macOS, the DMA pointer
(EP_TRADDR) still shifts after EPRST:

  cdns3_ctrl_req: Clear Endpoint Feature(Halt ep1out)
  cdns3_doorbell_epx: ep1out, ep_trbaddr f9c04030  <-- Should be f9c04000
  cdns3_gadget_giveback: ep1out: req: ... length: 16384/16384

As shown above, the DMA pointer jumped to the next TD, causing
the controller to skip the initial TRBs of the request. This leads to
data misalignment and ADB protocol hangs on macOS.

Fix this by manually restoring the EP_TRADDR register to the starting
physical address of the current request after the EPRST operation is
complete.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: stable <stable@kernel.org>
Cc: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Yongchao Wu <yongchao.wu@autochips.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260513160012.2547894-1-yongchao.wu@autochips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2817,9 +2817,19 @@ int __cdns3_gadget_ep_clear_halt(struct
 	priv_ep->flags &= ~(EP_STALLED | EP_STALL_PENDING);
 
 	if (request) {
-		if (trb)
+		if (trb) {
 			*trb = trb_tmp;
 
+			/*
+			 * Per datasheet, EPRST causes DMA to reposition to the next TD.
+			 * Manually reset EP_TRADDR to the current TRB to prevent
+			 * the hardware from skipping the interrupted request.
+			 */
+			writel(EP_TRADDR_TRADDR(priv_ep->trb_pool_dma +
+						priv_req->start_trb * TRB_SIZE),
+						&priv_dev->regs->ep_traddr);
+		}
+
 		cdns3_rearm_transfer(priv_ep, 1);
 	}
 


