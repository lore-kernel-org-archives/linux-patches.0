Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9CF214813;
	Wed,  7 May 2025 19:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645155; cv=none; b=SPHCUxRiEGUYH7RMZa6QCYyqy1rt/z93fxubmamHGmv7RnNB1dhCcjxQnGX4UROpRKYIItHl/5KwbWXjIiHOydMA87m7PXtHhLuk6X4VEiCwajWSMsCGqto3P1i5TczZVx+fpDRbQhwNeItGFhgjT8BOuJ0KJ/Fhopm+9V83JiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645155; c=relaxed/simple;
	bh=jpb8c7riOmR8h9D1XCkeFxefrp4HVgaLXnpGcDDE1xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0lScqJKhc3iYtRv6Afd1gnLoVSauyV+0xXvs44uyNUzoLS7Xe7l5YWf2bhMpx03Shjbh4XKZK7WZiB2b2Ggukt+9B3Ulb1fDYFd/gyqGqihRkBPaRoCbZ0xswULmDCObdPZV4yyX3bJmbx6hj7l9JgKNHgvBBzdNs/hkLQCmoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rautck9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rautck9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F4AC4CEE2;
	Wed,  7 May 2025 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645155;
	bh=jpb8c7riOmR8h9D1XCkeFxefrp4HVgaLXnpGcDDE1xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rautck9CxMQ9TSBA0NzT4sMT3Ti72RCFJIzTqUIsyJaXxJErvZLbV4Fpp4URQQATX
	 9p1LbtY6Zsdp6U7PhAdlGF1VirVdJImZ80Uww6oTpUZ0LFIqe6M5JAk5Nh+/TZwYW7
	 1QEdaJVlzEl7GMpQXjLkNiLgMfg1pO5+b3Hu0lPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Bell <jonathan@raspberrypi.com>,
	Lukas Wunner <lukas@wunner.de>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/129] xhci: Use more than one Event Ring segment
Date: Wed,  7 May 2025 20:40:47 +0200
Message-ID: <20250507183817.989811986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Jonathan Bell <jonathan@raspberrypi.com>

[ Upstream commit 28084d3fcc3c8445542917f32e382c45b5343cc2 ]

Users have reported log spam created by "Event Ring Full" xHC event
TRBs.  These are caused by interrupt latency in conjunction with a very
busy set of devices on the bus.  The errors are benign, but throughput
will suffer as the xHC will pause processing of transfers until the
Event Ring is drained by the kernel.

Commit dc0ffbea5729 ("usb: host: xhci: update event ring dequeue pointer
on purpose") mitigated the issue by advancing the Event Ring Dequeue
Pointer already after half a segment has been processed.  Nevertheless,
providing a larger Event Ring would be useful to cope with load peaks.

Expand the number of event TRB slots available by increasing the number
of Event Ring segments in the ERST.

Controllers have a hardware-defined limit as to the number of ERST
entries they can process, but with up to 32k it can be excessively high
(sec 5.3.4).  So cap the actual number at 2 (configurable through the
ERST_MAX_SEGS macro), which seems like a reasonable quantity.  It is
supported by any xHC because the limit in the HCSPARAMS2 register is
defined as a power of 2.  Renesas uPD720201 and VIA VL805 controllers
do not support more than 2 ERST entries.

An alternative to increasing the number of Event Ring segments would be
an increase of the segment size.  But that requires allocating multiple
contiguous pages, which may be impossible if memory is fragmented.

Signed-off-by: Jonathan Bell <jonathan@raspberrypi.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 10 +++++++---
 drivers/usb/host/xhci.h     |  5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index f236fba5cd248..45240299fa171 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -2237,14 +2237,18 @@ xhci_alloc_interrupter(struct xhci_hcd *xhci, gfp_t flags)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	struct xhci_interrupter *ir;
+	unsigned int num_segs;
 	int ret;
 
 	ir = kzalloc_node(sizeof(*ir), flags, dev_to_node(dev));
 	if (!ir)
 		return NULL;
 
-	ir->event_ring = xhci_ring_alloc(xhci, ERST_NUM_SEGS, 1, TYPE_EVENT,
-					0, flags);
+	num_segs = min_t(unsigned int, 1 << HCS_ERST_MAX(xhci->hcs_params2),
+			 ERST_MAX_SEGS);
+
+	ir->event_ring = xhci_ring_alloc(xhci, num_segs, 1, TYPE_EVENT, 0,
+					 flags);
 	if (!ir->event_ring) {
 		xhci_warn(xhci, "Failed to allocate interrupter event ring\n");
 		kfree(ir);
@@ -2280,7 +2284,7 @@ xhci_add_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir,
 	/* set ERST count with the number of entries in the segment table */
 	erst_size = readl(&ir->ir_set->erst_size);
 	erst_size &= ERST_SIZE_MASK;
-	erst_size |= ERST_NUM_SEGS;
+	erst_size |= ir->event_ring->num_segs;
 	writel(erst_size, &ir->ir_set->erst_size);
 
 	erst_base = xhci_read_64(xhci, &ir->ir_set->erst_base);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 0325fccfaa2a4..76a3010b8b74a 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1427,8 +1427,9 @@ struct urb_priv {
  * Each segment table entry is 4*32bits long.  1K seems like an ok size:
  * (1K bytes * 8bytes/bit) / (4*32 bits) = 64 segment entries in the table,
  * meaning 64 ring segments.
- * Initial allocated size of the ERST, in number of entries */
-#define	ERST_NUM_SEGS	1
+ * Reasonable limit for number of Event Ring segments (spec allows 32k)
+ */
+#define	ERST_MAX_SEGS	2
 /* Poll every 60 seconds */
 #define	POLL_TIMEOUT	60
 /* Stop endpoint command timeout (secs) for URB cancellation watchdog timer */
-- 
2.39.5



