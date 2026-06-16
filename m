Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3F743D4E9;
	Tue, 16 Jun 2026 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628564; cv=none; b=NaxQujGkKSshGQDpwCGq7MNtJZ0+ZzXrvUMiDctMpSkm419vj9phP+7lSO9aegtRT5tsXFT2MVTMHNj10xKcKDb46NTSvNMu77nq8+rwpO4kX0R11r4qNqb67BVuxaOEWM7NPdbyQr31lsmKLQWImBcIUnkQjJ6Lh6BY7RgnJ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628564; c=relaxed/simple;
	bh=U3I3i1DWdk2fcpaLEnndvKrU0s0yd4YAGy/4FIks5oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAi/BFEGtEoEQBtNxauJ4vVn4SnO2Iqp50iMTSmAbTIMvjQuogFfS8wK/oMXOWF+uaYwx0EljpTQC4wpbA9m38e7KnKcQEe/VLbSbyaI9qFEXtspjocLRnFt1FGLDk3XCZ3OBtlPY2InGkbP72Fs0rkrc35Ygy9G6h8KoF9RY7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jqxc6HFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jqxc6HFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2A01F000E9;
	Tue, 16 Jun 2026 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628563;
	bh=iJ9/ADGpl3LEEGma4lm3QNPMjaif1Jyr0FUiwFG5c3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jqxc6HFiL7BEanTssvbIe8POY6FtWrZzzDDZ3Mebt0G+Euf5q/BCtVT5V81+X5Vmd
	 50s6eVwkFmX3J2wCHG7nELnPcHEeI0kbKqJdXsgJbT9T1xap0GdcOZqSmrUadbUscX
	 S8yHng+qLNiIWKuFU5aDsApD5cdi76mn9D4hZJ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Peter Chen <peter.chen@kernel.org>,
	Yongchao Wu <yongchao.wu@autochips.com>
Subject: [PATCH 6.6 120/452] usb: cdns3: gadget: fix request skipping after clearing halt
Date: Tue, 16 Jun 2026 20:25:47 +0530
Message-ID: <20260616145124.013143485@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2816,9 +2816,19 @@ int __cdns3_gadget_ep_clear_halt(struct
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
 


