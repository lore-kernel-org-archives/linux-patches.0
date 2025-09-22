Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D1C27B320;
	Mon, 22 Sep 2025 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569804; cv=none; b=t7tGIYyIMu8GcBXfav9dpRC3wZWQUxH7miiOhdg2/UQbURAIl4ZwDyOZHsTmLdZ/bjpeM8xROVs+SvyeSI8Dlr8adOWH/ZZQXOE5zB8aJq3iI/rx2D8Iv1GcKwyVTGHMUQ/Iiz0Ft7jWhBKKh0PEwt8CU5g5V5hnh60tZqShhDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569804; c=relaxed/simple;
	bh=J4sDDASNib1DGiyfwOplGalAALzXvwhuz42TXppVFCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc7nmP0ab5gMZe2UxKCLzzlq3PtWJkl2Xu7iXLdgCRV3TBr0I8mpnBPiZ0o4o9YMUTwEnd9jZDUlPItg3zoes3FS0/1ykOgEG4/Ketv9i7O6dymzD89c0PBwmg0AI8eeGR+j52+J+dlhoqCdgv/ThLz3EqtE2SFcqfz79CVEZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frLyq8Ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frLyq8Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB2C4CEF0;
	Mon, 22 Sep 2025 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569804;
	bh=J4sDDASNib1DGiyfwOplGalAALzXvwhuz42TXppVFCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frLyq8OkES43QyOcjgdUvS1Ixyv0OM8prp4BY4C4/NjRXcYdSazZUsntrBET7Z0BH
	 Kf1yLTOhOpthXI1k0Wp9WslwYK9P03yhlHfWj9D2F6e1iI3LlGCqk1lvNt9XEc9G3N
	 IlSsBEw0qD3qR3dhys21idXjo57e9NI5LiDLelUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 63/70] xhci: dbc: Fix full DbC transfer ring after several reconnects
Date: Mon, 22 Sep 2025 21:30:03 +0200
Message-ID: <20250922192406.295583832@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit a5c98e8b1398534ae1feb6e95e2d3ee5215538ed ]

Pending requests will be flushed on disconnect, and the corresponding
TRBs will be turned into No-op TRBs, which are ignored by the xHC
controller once it starts processing the ring.

If the USB debug cable repeatedly disconnects before ring is started
then the ring will eventually be filled with No-op TRBs.
No new transfers can be queued when the ring is full, and driver will
print the following error message:

    "xhci_hcd 0000:00:14.0: failed to queue trbs"

This is a normal case for 'in' transfers where TRBs are always enqueued
in advance, ready to take on incoming data. If no data arrives, and
device is disconnected, then ring dequeue will remain at beginning of
the ring while enqueue points to first free TRB after last cancelled
No-op TRB.
s
Solve this by reinitializing the rings when the debug cable disconnects
and DbC is leaving the configured state.
Clear the whole ring buffer and set enqueue and dequeue to the beginning
of ring, and set cycle bit to its initial state.

Cc: stable@vger.kernel.org
Fixes: dfba2174dc42 ("usb: xhci: Add DbC support in xHCI driver")
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250902105306.877476-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-dbgcap.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -447,6 +447,25 @@ static void xhci_dbc_ring_init(struct xh
 	xhci_initialize_ring_info(ring, 1);
 }
 
+static int xhci_dbc_reinit_ep_rings(struct xhci_dbc *dbc)
+{
+	struct xhci_ring *in_ring = dbc->eps[BULK_IN].ring;
+	struct xhci_ring *out_ring = dbc->eps[BULK_OUT].ring;
+
+	if (!in_ring || !out_ring || !dbc->ctx) {
+		dev_warn(dbc->dev, "Can't re-init unallocated endpoints\n");
+		return -ENODEV;
+	}
+
+	xhci_dbc_ring_init(in_ring);
+	xhci_dbc_ring_init(out_ring);
+
+	/* set ep context enqueue, dequeue, and cycle to initial values */
+	xhci_dbc_init_ep_contexts(dbc);
+
+	return 0;
+}
+
 static struct xhci_ring *
 xhci_dbc_ring_alloc(struct device *dev, enum xhci_ring_type type, gfp_t flags)
 {
@@ -871,7 +890,7 @@ static enum evtreturn xhci_dbc_do_handle
 			dev_info(dbc->dev, "DbC cable unplugged\n");
 			dbc->state = DS_ENABLED;
 			xhci_dbc_flush_requests(dbc);
-
+			xhci_dbc_reinit_ep_rings(dbc);
 			return EVT_DISC;
 		}
 
@@ -881,7 +900,7 @@ static enum evtreturn xhci_dbc_do_handle
 			writel(portsc, &dbc->regs->portsc);
 			dbc->state = DS_ENABLED;
 			xhci_dbc_flush_requests(dbc);
-
+			xhci_dbc_reinit_ep_rings(dbc);
 			return EVT_DISC;
 		}
 


