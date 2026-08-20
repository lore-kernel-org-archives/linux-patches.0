Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5D037EFFE;
	Thu, 20 Aug 2026 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238570; cv=none; b=iNNAUznuxRSKwPrK7SvAQqa3oELREJ6PWDaRxfiqsiq/OkhVYxQtYA9FesqfhVWNzorsE7MV5D/egPLDpMwOM0H116LRHLI8ftvzw7gdqYTM8/gcXCwhmZ5oGa3kzbeuFV76GW1XzAWo9dVmTLAy20X4qWlcrLM/3YOkwC56e+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238570; c=relaxed/simple;
	bh=4MjvobFvqGyTQTdQpM0IThyKqRDLh3rTjYqzs8v/NvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5ieNZ5Gj1fmbn3jjreMBiFQx6hasc/iXRSPRqg89cav56VJIIoEFYr0QMk0mxfJoVF3QnnqFTGpJu3kYnAZ68MM+72TC2mW+LNYRMBKkACFIs5nVX+xpse4Yww95Nu46Cp9KJPgddmfDHo0l0XGpTW+m2mXU6J/mC/OX2mjdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN8hmwUv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN8hmwUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DA01F000E9;
	Thu, 20 Aug 2026 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238569;
	bh=MIMKlgwKpDNPpO1Q9CqmC1WuBOucJ4PTcXPUhtHNKvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BN8hmwUvDD9aQo+cEp+/IN1WyJZ8oR7yy0chgH35r3IiGiOFEER7z/MdOLcOD5aEh
	 3DE3/ZhA5LSxshfiUeOqZUzb3jndVhP2j43JPZ5DQQ8KSTJeG86FsrBuDBGX8iOtdd
	 gylVdlllBrUwqfStREhnTfGu49p5ePnIx/JKrX+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 194/228] eth: bnxt: keep the aRFS rmap updated when TPH is enabled
Date: Thu, 20 Aug 2026 16:55:36 +0200
Message-ID: <20260820145250.616979355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4b5cb58a4443fff67aa18a0d7b645b2220f2fcf8 ]

The TPH support must have broken aRFS in bnxt. IRQ can only have one
notifier, so installing the TPH notifier is overriding the one implicitly
installed by irq_cpu_rmap_add().

Make sure we call cpu_rmap_update() from the TPH notifier.

We need to be careful with the ordering and not free the rmap
until we unregistered the notifier. Note that moving the rmap
freeing after the early return in bnxt_free_irq() is fine -
there's no path that could leave rmap with irq_tbl being NULL.

Fixes: c214410c47d6 ("bnxt_en: Add TPH support in BNXT driver")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260803193135.2030368-3-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0ccf150eb9f42..55b5abc84a04b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11789,6 +11789,16 @@ static void bnxt_irq_affinity_notify(struct irq_affinity_notify *notify,
 
 	irq = container_of(notify, struct bnxt_irq, affinity_notify);
 
+#ifdef CONFIG_RFS_ACCEL
+	if (irq->bp->dev->rx_cpu_rmap && irq->ring_nr < irq->bp->rx_nr_rings) {
+		err = cpu_rmap_update(irq->bp->dev->rx_cpu_rmap, irq->ring_nr,
+				      mask);
+		if (err)
+			netdev_warn(irq->bp->dev,
+				    "aRFS rmap update failed: %d\n", err);
+	}
+#endif
+
 	if (!irq->bp->tph_mode)
 		return;
 
@@ -11862,10 +11872,6 @@ static void bnxt_free_irq(struct bnxt *bp)
 	struct bnxt_irq *irq;
 	int i;
 
-#ifdef CONFIG_RFS_ACCEL
-	free_irq_cpu_rmap(bp->dev->rx_cpu_rmap);
-	bp->dev->rx_cpu_rmap = NULL;
-#endif
 	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
@@ -11891,6 +11897,11 @@ static void bnxt_free_irq(struct bnxt *bp)
 	/* Disable TPH support */
 	pcie_disable_tph(bp->pdev);
 	bp->tph_mode = 0;
+
+#ifdef CONFIG_RFS_ACCEL
+	free_irq_cpu_rmap(bp->dev->rx_cpu_rmap);
+	bp->dev->rx_cpu_rmap = NULL;
+#endif
 }
 
 static int bnxt_request_irq(struct bnxt *bp)
-- 
2.53.0



