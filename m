Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C069313298;
	Mon, 13 Apr 2026 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098952; cv=none; b=Jwjk0XtdDXtbB+q6MlM0LzyqggVlpmPWZU3CsjmIwH4557/z6g5Q3ypXKnd4KsiGUf+o2fO94novYPJSHoxXE+R8diwvqvqrQw1ClhIOnR5Ui0OvVOpxf7JWU/hDVl73f3aNQGopzpG3gKJeAhgyncpPmK8NRcF5JT/4YEg/Lc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098952; c=relaxed/simple;
	bh=uOWoieWwb8xJEBdMwxsvlPHgRTT5o5/E+uRnCAH/1iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWn7DNg57ZwTnrTdrxhCq4n9ozsojXY2FowyB6Vzf6zw4UGV9U//S0Ubfk7w33+nD1Sdb5bXfiEZOp2OtzaNaS2BJlVjriLTELvkG1XSNnXKSlKzDQFkJzyTkrl/tB9djTisHzcCdTJD+M2Do0XgaVOx/5ue27EGB6p4weUsnaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDStZ+2H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDStZ+2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A27C2BCAF;
	Mon, 13 Apr 2026 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098951;
	bh=uOWoieWwb8xJEBdMwxsvlPHgRTT5o5/E+uRnCAH/1iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDStZ+2H51CvxuN0iACDeilCGn/b6iDvO9qge/e+hwjYJtsAJXvHIafTrfVE4xwh4
	 hDypOPqGTnC2RQz16SI3ZRsK6GHjpaoNnzn05MWbBiwA3y0msw5JPowRQIeys5wVzW
	 K5UXNABUMJnQzOJB5JO2198KeiibQOY6Z8HfrfUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 153/491] gve: defer interrupt enabling until NAPI registration
Date: Mon, 13 Apr 2026 17:56:38 +0200
Message-ID: <20260413155824.759485387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ankit Garg <nktgrg@google.com>

commit 3d970eda003441f66551a91fda16478ac0711617 upstream.

Currently, interrupts are automatically enabled immediately upon
request. This allows interrupt to fire before the associated NAPI
context is fully initialized and cause failures like below:

[    0.946369] Call Trace:
[    0.946369]  <IRQ>
[    0.946369]  __napi_poll+0x2a/0x1e0
[    0.946369]  net_rx_action+0x2f9/0x3f0
[    0.946369]  handle_softirqs+0xd6/0x2c0
[    0.946369]  ? handle_edge_irq+0xc1/0x1b0
[    0.946369]  __irq_exit_rcu+0xc3/0xe0
[    0.946369]  common_interrupt+0x81/0xa0
[    0.946369]  </IRQ>
[    0.946369]  <TASK>
[    0.946369]  asm_common_interrupt+0x22/0x40
[    0.946369] RIP: 0010:pv_native_safe_halt+0xb/0x10

Use the `IRQF_NO_AUTOEN` flag when requesting interrupts to prevent auto
enablement and explicitly enable the interrupt in NAPI initialization
path (and disable it during NAPI teardown).

This ensures that interrupt lifecycle is strictly coupled with
readiness of NAPI context.

Cc: stable@vger.kernel.org
Fixes: 1dfc2e46117e ("gve: Refactor napi add and remove functions")
Signed-off-by: Ankit Garg <nktgrg@google.com>
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Link: https://patch.msgid.link/20251219102945.2193617-1-hramamurthy@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ modified to re-introduce the irq member to struct gve_notify_block,
  which was introuduced in commit 9a5e0776d11f ("gve: Avoid rescheduling
  napi if on wrong cpu"). ]
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve.h      |    1 +
 drivers/net/ethernet/google/gve/gve_main.c |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -165,6 +165,7 @@ struct gve_notify_block {
 	struct gve_priv *priv;
 	struct gve_tx_ring *tx; /* tx rings on this block */
 	struct gve_rx_ring *rx; /* rx rings on this block */
+	u32 irq;
 } ____cacheline_aligned;
 
 /* Tracks allowed and current queue settings */
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -277,8 +277,9 @@ static int gve_alloc_notify_blocks(struc
 		snprintf(block->name, sizeof(block->name), "%s-ntfy-block.%d",
 			 name, i);
 		block->priv = priv;
+		block->irq = priv->msix_vectors[msix_idx].vector;
 		err = request_irq(priv->msix_vectors[msix_idx].vector,
-				  gve_intr, 0, block->name, block);
+				  gve_intr, IRQF_NO_AUTOEN, block->name, block);
 		if (err) {
 			dev_err(&priv->pdev->dev,
 				"Failed to receive msix vector %d\n", i);
@@ -413,6 +414,7 @@ static void gve_add_napi(struct gve_priv
 
 	netif_napi_add(priv->dev, &block->napi, gve_napi_poll,
 		       NAPI_POLL_WEIGHT);
+	enable_irq(block->irq);
 }
 
 static void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
@@ -420,6 +422,7 @@ static void gve_remove_napi(struct gve_p
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
 	netif_napi_del(&block->napi);
+	disable_irq(block->irq);
 }
 
 static int gve_register_qpls(struct gve_priv *priv)


