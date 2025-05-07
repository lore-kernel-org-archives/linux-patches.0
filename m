Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF68A214813;
	Wed,  7 May 2025 19:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645165; cv=none; b=laJpfOauRRPIAcbl1RAMqYjbQhEduN9PSwMV3E7VkXuM6HF32tpClcbA2CdXaiRkUVr9nHVQOGe2QQCFiSr4IdrsErGKA2/AQaSX5Hj4NtucTEuW5ogqaK3otaaY1yRubUf/0cVnofr+mXnNALcDnrXUsXOhIvtcEtx1r2I1RX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645165; c=relaxed/simple;
	bh=tBw3DqupKfNUjUoMVx0RDaJqcpmT0p5BmRUD/P+SJ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6EqjVAusakSF17xHvnmIkLmZPc9/Vn8Zjk7wwj2FaF5hlpGGJRM3uuPZzzI9gxL9vLAzCUXrmg2haw21X3E1WuKa4T07ikOzTk5kZjxXcTrzT1mukZ3oUrUdqjaV9E70e6tR+kD9HCtGYcLluI3deLdFpUzF5kghipR3DJ+HBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/Tohxln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/Tohxln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABB6C4CEE2;
	Wed,  7 May 2025 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645164;
	bh=tBw3DqupKfNUjUoMVx0RDaJqcpmT0p5BmRUD/P+SJ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/TohxlnS7c/T22q56attOT11bs9+qI+WPrTQYz+RWh9WAfK9kXZ2SB8qQFENamo8
	 +JMtbcdbCCxm9tpig0ja+TaOG8sgnq1X04mjcL6XFfEuu8VGAyeMXd8U8UBn5Z1pNa
	 5UthgUeioXbIgQB7ZnXfPhWZ9DRUOcB1HqAfk2ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/129] xhci: split free interrupter into separate remove and free parts
Date: Wed,  7 May 2025 20:40:49 +0200
Message-ID: <20250507183818.171198647@linuxfoundation.org>
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit 47f503cf5f799ec02e5f4b7c3b9afe145eca2aef ]

The current function that both removes and frees an interrupter isn't
optimal when using several interrupters. The array of interrupters need
to be protected with a lock while removing interrupters, but the default
xhci spin lock can't be used while freeing the interrupters event ring
segment table as dma_free_coherent() should be called with IRQs enabled.

There is no need to free the interrupter under the lock, so split this
code into separate unlocked free part, and a lock protected remove part.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20231019102924.2797346-17-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bea5892d0ed2 ("xhci: Limit time spent with xHC interrupts disabled during bus resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 45240299fa171..f00e96c9ca57a 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1803,22 +1803,13 @@ int xhci_alloc_erst(struct xhci_hcd *xhci,
 }
 
 static void
-xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
+xhci_remove_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 {
-	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
-	size_t erst_size;
 	u32 tmp;
 
 	if (!ir)
 		return;
 
-	erst_size = sizeof(struct xhci_erst_entry) * ir->erst.num_entries;
-	if (ir->erst.entries)
-		dma_free_coherent(dev, erst_size,
-				  ir->erst.entries,
-				  ir->erst.erst_dma_addr);
-	ir->erst.entries = NULL;
-
 	/*
 	 * Clean out interrupter registers except ERSTBA. Clearing either the
 	 * low or high 32 bits of ERSTBA immediately causes the controller to
@@ -1831,10 +1822,28 @@ xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
 
 		xhci_write_64(xhci, ERST_EHB, &ir->ir_set->erst_dequeue);
 	}
+}
+
+static void
+xhci_free_interrupter(struct xhci_hcd *xhci, struct xhci_interrupter *ir)
+{
+	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
+	size_t erst_size;
+
+	if (!ir)
+		return;
+
+	erst_size = sizeof(struct xhci_erst_entry) * ir->erst.num_entries;
+	if (ir->erst.entries)
+		dma_free_coherent(dev, erst_size,
+				  ir->erst.entries,
+				  ir->erst.erst_dma_addr);
+	ir->erst.entries = NULL;
 
-	/* free interrrupter event ring */
+	/* free interrupter event ring */
 	if (ir->event_ring)
 		xhci_ring_free(xhci, ir->event_ring);
+
 	ir->event_ring = NULL;
 
 	kfree(ir);
@@ -1847,6 +1856,7 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 
 	cancel_delayed_work_sync(&xhci->cmd_timer);
 
+	xhci_remove_interrupter(xhci, xhci->interrupter);
 	xhci_free_interrupter(xhci, xhci->interrupter);
 	xhci->interrupter = NULL;
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "Freed primary event ring");
-- 
2.39.5



