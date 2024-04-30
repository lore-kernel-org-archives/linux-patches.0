Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F073212C487;
	Tue, 30 Apr 2024 10:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474324; cv=none; b=kYdUH+QfEeDPZ6h6JK3gsmR4WVgseJVSrSgfxLUhSvnXd7UICDVOOirlcC+jxYnCeO3Ut81aPVS1DmMy1Gs83aZxgKBOqVLQbzvKDYxTdxLpq5qwOXQhc8NTJ4elSS26pi9id6tuUIct+/mAbu+q5wk2IJfWLO4gIAs486y9eh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474324; c=relaxed/simple;
	bh=BscQzC8MejwO+Ouxt+Gsp1yUuuNTKjlzdz4W+5O5CAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4uhlGW1Z2RT0O9itbcXwgFxB9urzCaoKTMpOGfDtZ37FqiAOvlsTlvX929FnFKd1GA8fxoGNEeh48qlmzz8tkwZ6SPE2O3DNkjh+XrRmkO6Sop3x+pV9/WR6gNQR8a4G+c6mogkiEhDkYEHIibJTfcPDRGL8Suxxnfv1AfuSCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLk84hpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLk84hpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01165C2BBFC;
	Tue, 30 Apr 2024 10:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474323;
	bh=BscQzC8MejwO+Ouxt+Gsp1yUuuNTKjlzdz4W+5O5CAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLk84hpXw8OWPDQ7VSaP+k6BG7W6OgQFDBT/3tDLUFMbHdUx4Rv3f4nuyLb/UvwpI
	 FYwGK9LluqCazpe/N5k2blmFW7SEwWCMGPPCwI1BGqQrcVy1VmdQCicizDJir56KLe
	 CWnuWo+R0enwvbvG1VXuroPkfvRmWqgXM6w4AGbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 123/228] usb: xhci: correct return value in case of STS_HCE
Date: Tue, 30 Apr 2024 12:38:21 +0200
Message-ID: <20240430103107.355977146@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 5bfc311dd6c376d350b39028b9000ad766ddc934 ]

If we get STS_HCE we give up on the interrupt, but for the purpose
of IRQ handling that still counts as ours. We may return IRQ_NONE
only if we are positive that it wasn't ours. Hence correct the default.

Fixes: 2a25e66d676d ("xhci: print warning when HCE was set")
Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240404121106.2842417-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2306a95d6251a..b2868217de941 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3123,7 +3123,7 @@ static int xhci_handle_events(struct xhci_hcd *xhci, struct xhci_interrupter *ir
 irqreturn_t xhci_irq(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
-	irqreturn_t ret = IRQ_NONE;
+	irqreturn_t ret = IRQ_HANDLED;
 	u32 status;
 
 	spin_lock(&xhci->lock);
@@ -3131,12 +3131,13 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	status = readl(&xhci->op_regs->status);
 	if (status == ~(u32)0) {
 		xhci_hc_died(xhci);
-		ret = IRQ_HANDLED;
 		goto out;
 	}
 
-	if (!(status & STS_EINT))
+	if (!(status & STS_EINT)) {
+		ret = IRQ_NONE;
 		goto out;
+	}
 
 	if (status & STS_HCE) {
 		xhci_warn(xhci, "WARNING: Host Controller Error\n");
@@ -3146,7 +3147,6 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	if (status & STS_FATAL) {
 		xhci_warn(xhci, "WARNING: Host System Error\n");
 		xhci_halt(xhci);
-		ret = IRQ_HANDLED;
 		goto out;
 	}
 
@@ -3157,7 +3157,6 @@ irqreturn_t xhci_irq(struct usb_hcd *hcd)
 	 */
 	status |= STS_EINT;
 	writel(status, &xhci->op_regs->status);
-	ret = IRQ_HANDLED;
 
 	/* This is the handler of the primary interrupter */
 	xhci_handle_events(xhci, xhci->interrupters[0]);
-- 
2.43.0



