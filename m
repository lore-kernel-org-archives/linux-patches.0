Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573F832D45B;
	Sun,  7 Jun 2026 10:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828909; cv=none; b=gXW1TTYGaFA0PmSQNbluEW9Et5lJxCvn+lT8+DSyTpWj5YsYyIdRtIE+QqwJ25r9VEyOHE524pruAj7poGeomT2HHz6h8KPXoPni2MqkL97WCPA6q9QPyw+bj4PZWHhT2TfWelPyS69qmTsWG6LRxTtYoG2XLK4Tfvmb5NfffAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828909; c=relaxed/simple;
	bh=6RU+EC8Mq0f/Wou2yzqtYATKuUxR6wqfyFWf35xPqF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idBvOyQry0tfIUvVUygCIcFXpJOMKa3CH8Ra0aKHLI8Uw3gh/X41G8oHcM0pGHZ381z9BkEVWgkL9PCW78jfUeaJiILfoUhXndRQV6f4TZ7903nqnG6q6tZqZwbtxpzuokUcQSaOfJ0TKUshheG01b4uPFledUvEkwfjie5fdT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4aZ6QJ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4aZ6QJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E83E1F00893;
	Sun,  7 Jun 2026 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828907;
	bh=/34RAGcIJ2iD5Rhwj/yeFksRz9snMhugJo6gb6Vad+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4aZ6QJ3qC+bKTznho6+ZhCM/5e+Bt4wV7JRwDoFXKeV7hXQdN6KnvGkbeHzPBem6
	 A7Rj1gZTOG2J2qGIySiyIPcKAL+eHVujFb2rr+Fdzi9spbyWn7uTgX+I0mUFW9uW65
	 BmN4UNZ7ZgG9XHiDOcqh4UQKc5ZBfSJVwDtKejrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>
Subject: [PATCH 6.12 178/307] usb: cdns3: gadget: fix request skipping after clearing halt
Date: Sun,  7 Jun 2026 11:59:35 +0200
Message-ID: <20260607095734.252335810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
 


