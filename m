Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FCD36CE1C;
	Tue,  6 Jan 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722368; cv=none; b=iAtNi8P4smmc8//PBynlKYt5GloIEIc4EtYFdyYIpA01oSRerROcPh0Df5BSQkbLIcTaVEyTXknNSygU8aYfLqLp9jmbD1YrD/VGjWgC6MkLGhNOP8K4+hAs5LvPSA8vpqXNI7M16cmTrFTPj0gOjOIq7eBLRO3PP1pGXEeK3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722368; c=relaxed/simple;
	bh=NP9DbtMaafKj/42o0GmKCh7R/dWNJzozcJLkQR3wFmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzUIAmadC4z5uH7aVkk87qKBJs8kxjdPe9inkCo6y3hqwd0lAVpzUhHqVXKGb9E1vQjzPHx1r7zTLkArxN8sZqhua2kFoZL/RmnWGRjlAEmQGCJz6TKHwn9uCk4sUY5eN8Mat94R0gLSTf87BdYp1VRu/3f/xKY/77NFJPm/l5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BS9Gih+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BS9Gih+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165E1C116C6;
	Tue,  6 Jan 2026 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722367;
	bh=NP9DbtMaafKj/42o0GmKCh7R/dWNJzozcJLkQR3wFmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS9Gih+erCoC5d5S1gBaBpfo9GTA71ZiZvEPo4xRlLdf5f/GjjdClZ3V0Md/rElhk
	 GGAoM+sx7YerupO9MTdziLwbJ85mRczjykzwwaETkJrY5rNuB6iTrF6BuOnWzL0d+H
	 sGOrcsKq7nSQxGFRTgA+OhCsuwKiUZGj0PUUeBrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankit Garg <nktgrg@google.com>,
	Jordan Rhee <jordanrhee@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 244/312] gve: defer interrupt enabling until NAPI registration
Date: Tue,  6 Jan 2026 18:05:18 +0100
Message-ID: <20260106170556.677677747@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c  |    2 +-
 drivers/net/ethernet/google/gve/gve_utils.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -558,7 +558,7 @@ static int gve_alloc_notify_blocks(struc
 		block->priv = priv;
 		err = request_irq(priv->msix_vectors[msix_idx].vector,
 				  gve_is_gqi(priv) ? gve_intr : gve_intr_dqo,
-				  0, block->name, block);
+				  IRQF_NO_AUTOEN, block->name, block);
 		if (err) {
 			dev_err(&priv->pdev->dev,
 				"Failed to receive msix vector %d\n", i);
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -112,11 +112,13 @@ void gve_add_napi(struct gve_priv *priv,
 
 	netif_napi_add_locked(priv->dev, &block->napi, gve_poll);
 	netif_napi_set_irq_locked(&block->napi, block->irq);
+	enable_irq(block->irq);
 }
 
 void gve_remove_napi(struct gve_priv *priv, int ntfy_idx)
 {
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 
+	disable_irq(block->irq);
 	netif_napi_del_locked(&block->napi);
 }


