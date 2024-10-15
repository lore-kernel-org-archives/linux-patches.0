Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C741D0492;
	Tue, 15 Oct 2024 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993260; cv=none; b=Nq0YYLvB6LRi+FU1R16v20do+nvR5PIML8z8lc/CykHQtd0xcatPgDzxp7dTzNjOq0Da0ADI6VdjpyH4iLJKvVR1RXvUQGVwWrh1WynE/9YdoFFfM5mgzV0l+z6ZLDo8IKBmbe0zUz4hRaKHd2dOLicGSaA+LFB+JHvmVGdPglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993260; c=relaxed/simple;
	bh=sIWhw2r3ftuYmXsGmmADjkqImBKV19f7zoic2fBZSGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNYC9CASea8JI5dMxNY7atpUGitsnoYm5/K36dXl9t4ftBqazsMY7Ks+b1dRkNqkqcwCjkbMCGxUdEF4ldIyeg/bEK11RpArv7l8jPIrJp0Xi/pZN6fRKJyYUoHihuUehLsQuAo3nb9gjcRhU9woppWsWHJE/uDxPdDRt+0N5jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1m2/TFzB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1m2/TFzB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2DAC4CEC6;
	Tue, 15 Oct 2024 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993260;
	bh=sIWhw2r3ftuYmXsGmmADjkqImBKV19f7zoic2fBZSGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1m2/TFzBEwAMwN8RQrthZ/uDPM/cbKkaS6ZHhy+1U6Ja52kBzbEpO/urwCvly7Sfn
	 AAJGohTHW1QFqLmQ4WnR7t26dEt0bTxck6QpxhGxUVYiDcjOptXjD/QWyq1weqpSlc
	 wIff1giX6/rR6W5v3zdGf2ji3atarGaro19X+ccI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/691] usb: xhci: fix loss of data on Cadence xHC
Date: Tue, 15 Oct 2024 13:25:07 +0200
Message-ID: <20241015112454.594017330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit e5fa8db0be3e8757e8641600c518425a4589b85c ]

Streams should flush their TRB cache, re-read TRBs, and start executing
TRBs from the beginning of the new dequeue pointer after a 'Set TR Dequeue
Pointer' command.

Cadence controllers may fail to start from the beginning of the dequeue
TRB as it doesn't clear the Opaque 'RsvdO' field of the stream context
during 'Set TR Dequeue' command. This stream context area is where xHC
stores information about the last partially executed TD when a stream
is stopped. xHC uses this information to resume the transfer where it left
mid TD, when the stream is restarted.

Patch fixes this by clearing out all RsvdO fields before initializing new
Stream transfer using a 'Set TR Dequeue Pointer' command.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: stable@vger.kernel.org
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/PH7PR07MB95386A40146E3EC64086F409DD9D2@PH7PR07MB9538.namprd07.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/host.c     |  4 +++-
 drivers/usb/host/xhci-pci.c  |  7 +++++++
 drivers/usb/host/xhci-ring.c | 14 ++++++++++++++
 drivers/usb/host/xhci.h      |  1 +
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/host.c b/drivers/usb/cdns3/host.c
index a27ba6d6adb96..adef92f069329 100644
--- a/drivers/usb/cdns3/host.c
+++ b/drivers/usb/cdns3/host.c
@@ -61,7 +61,9 @@ static const struct xhci_plat_priv xhci_plat_cdns3_xhci = {
 	.resume_quirk = xhci_cdns3_resume_quirk,
 };
 
-static const struct xhci_plat_priv xhci_plat_cdnsp_xhci;
+static const struct xhci_plat_priv xhci_plat_cdnsp_xhci = {
+	.quirks = XHCI_CDNS_SCTX_QUIRK,
+};
 
 static int __cdns_host_init(struct cdns *cdns)
 {
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 37ef6beae8723..e47a3cc078aed 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -75,6 +75,9 @@
 #define PCI_DEVICE_ID_ASMEDIA_2142_XHCI			0x2142
 #define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
+#define PCI_DEVICE_ID_CADENCE				0x17CD
+#define PCI_DEVICE_ID_CADENCE_SSP			0x0200
+
 static const char hcd_name[] = "xhci_hcd";
 
 static struct hc_driver __read_mostly xhci_pci_hc_driver;
@@ -353,6 +356,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			xhci->quirks |= XHCI_ZHAOXIN_TRB_FETCH;
 	}
 
+	if (pdev->vendor == PCI_DEVICE_ID_CADENCE &&
+	    pdev->device == PCI_DEVICE_ID_CADENCE_SSP)
+		xhci->quirks |= XHCI_CDNS_SCTX_QUIRK;
+
 	/* xHC spec requires PCI devices to support D3hot and D3cold */
 	if (xhci->hci_version >= 0x120)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 91c8c49f233f5..f12d30a3307ce 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1446,6 +1446,20 @@ static void xhci_handle_cmd_set_deq(struct xhci_hcd *xhci, int slot_id,
 			struct xhci_stream_ctx *ctx =
 				&ep->stream_info->stream_ctx_array[stream_id];
 			deq = le64_to_cpu(ctx->stream_ring) & SCTX_DEQ_MASK;
+
+			/*
+			 * Cadence xHCI controllers store some endpoint state
+			 * information within Rsvd0 fields of Stream Endpoint
+			 * context. This field is not cleared during Set TR
+			 * Dequeue Pointer command which causes XDMA to skip
+			 * over transfer ring and leads to data loss on stream
+			 * pipe.
+			 * To fix this issue driver must clear Rsvd0 field.
+			 */
+			if (xhci->quirks & XHCI_CDNS_SCTX_QUIRK) {
+				ctx->reserved[0] = 0;
+				ctx->reserved[1] = 0;
+			}
 		} else {
 			deq = le64_to_cpu(ep_ctx->deq) & ~EP_CTX_CYCLE_MASK;
 		}
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index c6162140d641d..977b3fdf4fb59 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1918,6 +1918,7 @@ struct xhci_hcd {
 #define XHCI_ZHAOXIN_TRB_FETCH	BIT_ULL(45)
 #define XHCI_ZHAOXIN_HOST	BIT_ULL(46)
 #define XHCI_WRITE_64_HI_LO	BIT_ULL(47)
+#define XHCI_CDNS_SCTX_QUIRK	BIT_ULL(48)
 
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
-- 
2.43.0



