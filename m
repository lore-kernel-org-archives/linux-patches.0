Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF8A2E8E09;
	Tue,  2 Sep 2025 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819574; cv=none; b=TWdPVXJk+6RqHFBVkQikerGlS99AN8BFCg4n0i7YrGiHqZA7uAt+bAIRuiRjZvqe+ZYeI7omDbL4d10umL14ABE8ypLlN9RHGu4zkqBG1YYFoQqPR1+Ogaf88JnpUTaWU27hfWyFUQg3wfr47DRmHPw9vNHYRD79hMTMYYmS5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819574; c=relaxed/simple;
	bh=9oW3DJ82XMe7w5SSBj2O6fMa4eqESVJfUKbfQDoP03E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMM3mCYb4/1FqS0oV4EGuIvSvSum6b53PtukZPxykATlx7wVLWAKgw1Al3Lc3H3DC58L1kWr8e7QNDlY4tke1K7dzM9abfv4kDy5eLeKoU+WjFFnSqMqw4wdu6OR88nsKMLOxqmx7sT7K3qlpp/sC6VEjD1dNJkSZOyMa5zQdJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FD5Gah9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FD5Gah9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59220C4CEED;
	Tue,  2 Sep 2025 13:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819573;
	bh=9oW3DJ82XMe7w5SSBj2O6fMa4eqESVJfUKbfQDoP03E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FD5Gah9V0bW5hc8SRXAt9JMgUuaTxCh1phU3c7kbgjgCOHSRTalBYaMNIjRLlOYu0
	 XZazsWpuClGpGqhTkA4scqtIRJATCZP4clkEZ7dTiBUMXcfDtXfxujOpd6MEIoFTaJ
	 ReExXtTmvX8yHZnLUn6izxI9sfUHT7YK8AwD3H9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 075/142] bnxt_en: Fix memory corruption when FW resources change during ifdown
Date: Tue,  2 Sep 2025 15:19:37 +0200
Message-ID: <20250902131951.142100481@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 2747328ba2714f1a7454208dbbc1dc0631990b4a ]

bnxt_set_dflt_rings() assumes that it is always called before any TC has
been created.  So it doesn't take bp->num_tc into account and assumes
that it is always 0 or 1.

In the FW resource or capability change scenario, the FW will return
flags in bnxt_hwrm_if_change() that will cause the driver to
reinitialize and call bnxt_cancel_reservations().  This will lead to
bnxt_init_dflt_ring_mode() calling bnxt_set_dflt_rings() and bp->num_tc
may be greater than 1.  This will cause bp->tx_ring[] to be sized too
small and cause memory corruption in bnxt_alloc_cp_rings().

Fix it by properly scaling the TX rings by bp->num_tc in the code
paths mentioned above.  Add 2 helper functions to determine
bp->tx_nr_rings and bp->tx_nr_rings_per_tc.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ec8752c298e69..a4f4d90caf5e9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12844,6 +12844,17 @@ static int bnxt_set_xps_mapping(struct bnxt *bp)
 	return rc;
 }
 
+static int bnxt_tx_nr_rings(struct bnxt *bp)
+{
+	return bp->num_tc ? bp->tx_nr_rings_per_tc * bp->num_tc :
+			    bp->tx_nr_rings_per_tc;
+}
+
+static int bnxt_tx_nr_rings_per_tc(struct bnxt *bp)
+{
+	return bp->num_tc ? bp->tx_nr_rings / bp->num_tc : bp->tx_nr_rings;
+}
+
 static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
@@ -16338,7 +16349,7 @@ static void bnxt_trim_dflt_sh_rings(struct bnxt *bp)
 	bp->cp_nr_rings = min_t(int, bp->tx_nr_rings_per_tc, bp->rx_nr_rings);
 	bp->rx_nr_rings = bp->cp_nr_rings;
 	bp->tx_nr_rings_per_tc = bp->cp_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 }
 
 static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
@@ -16370,7 +16381,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		bnxt_trim_dflt_sh_rings(bp);
 	else
 		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
-	bp->tx_nr_rings = bp->tx_nr_rings_per_tc;
+	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
 
 	avail_msix = bnxt_get_max_func_irqs(bp) - bp->cp_nr_rings;
 	if (avail_msix >= BNXT_MIN_ROCE_CP_RINGS) {
@@ -16383,7 +16394,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 	rc = __bnxt_reserve_rings(bp);
 	if (rc && rc != -ENODEV)
 		netdev_warn(bp->dev, "Unable to reserve tx rings\n");
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	if (sh)
 		bnxt_trim_dflt_sh_rings(bp);
 
@@ -16392,7 +16403,7 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 		rc = __bnxt_reserve_rings(bp);
 		if (rc && rc != -ENODEV)
 			netdev_warn(bp->dev, "2nd rings reservation failed.\n");
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 	}
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp)) {
 		bp->rx_nr_rings++;
@@ -16426,7 +16437,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	if (rc)
 		goto init_dflt_ring_err;
 
-	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
 
 	bnxt_set_dflt_rfs(bp);
 
-- 
2.50.1



