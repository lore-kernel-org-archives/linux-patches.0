Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91223EA92;
	Mon, 27 Oct 2025 19:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593025; cv=none; b=p3YkNrt3gzKJaTIDxF65eRKSnUXSBXry38RZ3RmXKVe+B3e8UjTnoPoooqiUVk2s/TTAw6Atbw21U/MQrWpNQr0Xf+ZNP25CVuxjWLO9M5Vz+XvzgEzz1Yp2rCX2W4o2IefHPtY5zxmWKvtduZ6XTVs5hwSBKRNKgwQSZ0ABLa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593025; c=relaxed/simple;
	bh=TYXGb9lKz/63Wn+4dE04CCGKKDf++MWAGlfrI484ghc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iGLkTKWCnfrImVnk9i8s0dRmH7F8hyjwp9LNI7zHAc9Mx884MkI73mp5nltt3dNwstf0c/xu10taDSv/GKmYycUtNO4uiOx++OeEpNdntPXOQOHdVhtCDZYHAQpr/IZL22MkePOpZWlI2Qprld/hmuxVNjl4wCDE/FUt1EDRRas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLTlBQOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLTlBQOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4137EC4CEF1;
	Mon, 27 Oct 2025 19:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593025;
	bh=TYXGb9lKz/63Wn+4dE04CCGKKDf++MWAGlfrI484ghc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLTlBQOStRgdZcjD7FV3f7qEJzg6xIdpueIJyaTzsTFb1CxmVXtQTWNyZ1QRd0pkH
	 7D69CbTz98It1eC1z7Q9UIJJ6m6aM03NdbrUQ2foT+k55L/83SwN3TsEYCXzgcPvf7
	 dNRVDf74yZUTSACjXq5EiNtNha0sQs6UdwzOYMmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 100/117] xhci: dbc: fix bogus 1024 byte prefix if ttyDBC read races with stall event
Date: Mon, 27 Oct 2025 19:37:06 +0100
Message-ID: <20251027183456.725689051@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

commit f3d12ec847b945d5d65846c85f062d07d5e73164 upstream.

DbC may add 1024 bogus bytes to the beginneing of the receiving endpoint
if DbC hw triggers a STALL event before any Transfer Blocks (TRBs) for
incoming data are queued, but driver handles the event after it queued
the TRBs.

This is possible as xHCI DbC hardware may trigger spurious STALL transfer
events even if endpoint is empty. The STALL event contains a pointer
to the stalled TRB, and "remaining" untransferred data length.

As there are no TRBs queued yet the STALL event will just point to first
TRB position of the empty ring, with '0' bytes remaining untransferred.

DbC driver is polling for events, and may not handle the STALL event
before /dev/ttyDBC0 is opened and incoming data TRBs are queued.

The DbC event handler will now assume the first queued TRB (length 1024)
has stalled with '0' bytes remaining untransferred, and copies the data

This race situation can be practically mitigated by making sure the event
handler handles all pending transfer events when DbC reaches configured
state, and only then create dev/ttyDbC0, and start queueing transfers.
The event handler can this way detect the STALL events on empty rings
and discard them before any transfers are queued.

This does in practice solve the issue, but still leaves a small possible
gap for the race to trigger.
We still need a way to distinguish spurious STALLs on empty rings with '0'
bytes remaing, from actual STALL events with all bytes transmitted.

Cc: stable <stable@kernel.org>
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Tested-by: Łukasz Bartosik <ukaszb@chromium.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -891,7 +891,8 @@ static enum evtreturn xhci_dbc_do_handle
 			dev_info(dbc->dev, "DbC configured\n");
 			portsc = readl(&dbc->regs->portsc);
 			writel(portsc, &dbc->regs->portsc);
-			return EVT_GSER;
+			ret = EVT_GSER;
+			break;
 		}
 
 		return EVT_DONE;
@@ -951,7 +952,8 @@ static enum evtreturn xhci_dbc_do_handle
 			break;
 		case TRB_TYPE(TRB_TRANSFER):
 			dbc_handle_xfer_event(dbc, evt);
-			ret = EVT_XFER_DONE;
+			if (ret != EVT_GSER)
+				ret = EVT_XFER_DONE;
 			break;
 		default:
 			break;


