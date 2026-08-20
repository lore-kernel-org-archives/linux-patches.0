Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A0F3815D5;
	Thu, 20 Aug 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239201; cv=none; b=QKmvBaAj3IHYC2Bgr+0NvLbnek60SQ2O/Asp9QNEcLOrwUk5LeVo9fwswoVuqRqXSgQtntZuKyFM8jpKZWXRn/WhqqF4PtMkgMk+J5+ziu9Vcexc90+JqnQj92dHHPZWDbSDb73P0C4/1Mri8FXs+tI5dWISIYdyVGSVHlEhEVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239201; c=relaxed/simple;
	bh=juCHuoUiDZCoCBJWDKWEAlRJdDF67W5AV0g9UxNWhpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Of6FXRJxDWmCS8PSHe8UGYMnRl1GNXqXI6hIrCJGaciybLlVKhWbC6gh7vszHpCYw+J68LhA8VeZ+XwAFFLtPefncYJAWzk7VbFacYtg8S+3prdBFh0g6/2Hu9ckxLHSr/PdvHFgTAUg7sLV/raK4UvjHadqcrSkE2C0JnswBss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kj97vTfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kj97vTfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8BA1F000E9;
	Thu, 20 Aug 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239200;
	bh=Q3kino1nwoLGrIuLVm7akWGjoNvUTCl6Ywl0WJQ4YwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kj97vTfHYv74VSyVYe86/Fp4YZj7SXSPX34o952VLQjRzC/mYdQEDI3PFWtgWqrH7
	 U8IFr/v2cABpLXt0GdeDnp658kNnVIP+IsyqihIL5vJZ2+bsz7U/Eu2202N0y3Ee0Y
	 E7uOMWzxDqfKjkDNHMvCj+QA/dAYMpRnNhBsm/4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/217] eth: bnxt: keep the aRFS rmap updated when TPH is enabled
Date: Thu, 20 Aug 2026 16:55:52 +0200
Message-ID: <20260820145243.263422379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
index 76d6f5979ed2d..29e52df2502ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11643,6 +11643,16 @@ static void bnxt_irq_affinity_notify(struct irq_affinity_notify *notify,
 
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
 
@@ -11716,10 +11726,6 @@ static void bnxt_free_irq(struct bnxt *bp)
 	struct bnxt_irq *irq;
 	int i;
 
-#ifdef CONFIG_RFS_ACCEL
-	free_irq_cpu_rmap(bp->dev->rx_cpu_rmap);
-	bp->dev->rx_cpu_rmap = NULL;
-#endif
 	if (!bp->irq_tbl || !bp->bnapi)
 		return;
 
@@ -11745,6 +11751,11 @@ static void bnxt_free_irq(struct bnxt *bp)
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



