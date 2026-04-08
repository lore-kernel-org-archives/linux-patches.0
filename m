Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB8A337B81;
	Wed,  8 Apr 2026 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674482; cv=none; b=emMhgYICfNkxo9SuHSbl5r2bZGTTROIbsrgMmzyeHy8OzaUWYPT8WZjM574d/LeHYtEr3SDskIgRLydAGJNfWa4igt5ZUS88klZGx3lFuxbDkxQ2nKPPoCn8jKsVnfk4LkoBrf3xnXBTj/llGiFibVvcLV/2BHGBj6e/OQQ8G8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674482; c=relaxed/simple;
	bh=td+uZAnj5rQSadGmsWhwdnuhCAAS+XUvhd/PxLYhMaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz1c3o/g/eV1uNXjgQv85IHOUU9BI1+tRYPqlsaoXul9teJs6aHDy2vBycJKsptf1lW2cSGMeQmXLhH35cBpWnXxoI+ZZUoWNKsA/e06XcIthxyh32D99KBk+bsMFu9hqGEsY2HWb3djY6IusNLE5Gaq4W2LYNvxiqKKVTpRnFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NULCH50G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NULCH50G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83BBC19421;
	Wed,  8 Apr 2026 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674482;
	bh=td+uZAnj5rQSadGmsWhwdnuhCAAS+XUvhd/PxLYhMaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NULCH50GgVRlMrU7+KQWJusLYZZpy607KTsWJe6vcL6VcVAei4lbhAdBi7Kphdh3e
	 wtM9yRP/nxBfSgiCwKLU7vo8x/KftbmmdKKuX0wzCruEKkaOeEtJy7/7Syh53JC+Bs
	 s/3M/5yn/Bso8yhwoUnrevbukO/U8AbzC9svSZqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 115/311] bnxt_en: Dont assume XDP is never enabled in bnxt_init_dflt_ring_mode()
Date: Wed,  8 Apr 2026 20:01:55 +0200
Message-ID: <20260408175943.712674206@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit e4bf81dcad0a6fff2bbe5331d2c7fb30d45a788c ]

The original code made the assumption that when we set up the initial
default ring mode, we must be just loading the driver and XDP cannot
be enabled yet.  This is not true when the FW goes through a resource
or capability change.  Resource reservations will be cancelled and
reinitialized with XDP already enabled.  devlink reload with XDP enabled
will also have the same issue.  This scenario will cause the ring
arithmetic to be all wrong in the bnxt_init_dflt_ring_mode() path
causing failure:

bnxt_en 0000:a1:00.0 ens2f0np0: bnxt_setup_int_mode err: ffffffea
bnxt_en 0000:a1:00.0 ens2f0np0: bnxt_request_irq err: ffffffea
bnxt_en 0000:a1:00.0 ens2f0np0: nic open fail (rc: ffffffea)

Fix it by properly accounting for XDP in the bnxt_init_dflt_ring_mode()
path by using the refactored helper functions in the previous patch.

Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Fixes: 228ea8c187d8 ("bnxt_en: implement devlink dev reload driver_reinit")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260331065138.948205-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bf888be2c54ed..b4ad85e183390 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16443,6 +16443,10 @@ static void bnxt_adj_dflt_rings(struct bnxt *bp, bool sh)
 	else
 		bp->cp_nr_rings = bp->tx_nr_rings_per_tc + bp->rx_nr_rings;
 	bp->tx_nr_rings = bnxt_tx_nr_rings(bp);
+	if (sh && READ_ONCE(bp->xdp_prog)) {
+		bnxt_set_xdp_tx_rings(bp);
+		bnxt_set_cp_rings(bp, true);
+	}
 }
 
 static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
@@ -16484,16 +16488,17 @@ static int bnxt_set_dflt_rings(struct bnxt *bp, bool sh)
 	rc = __bnxt_reserve_rings(bp);
 	if (rc && rc != -ENODEV)
 		netdev_warn(bp->dev, "Unable to reserve tx rings\n");
-	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+
+	bnxt_adj_tx_rings(bp);
 	if (sh)
-		bnxt_trim_dflt_sh_rings(bp);
+		bnxt_adj_dflt_rings(bp, true);
 
 	/* Rings may have been trimmed, re-reserve the trimmed rings. */
 	if (bnxt_need_reserve_rings(bp)) {
 		rc = __bnxt_reserve_rings(bp);
 		if (rc && rc != -ENODEV)
 			netdev_warn(bp->dev, "2nd rings reservation failed.\n");
-		bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+		bnxt_adj_tx_rings(bp);
 	}
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp)) {
 		bp->rx_nr_rings++;
@@ -16527,7 +16532,7 @@ static int bnxt_init_dflt_ring_mode(struct bnxt *bp)
 	if (rc)
 		goto init_dflt_ring_err;
 
-	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+	bnxt_adj_tx_rings(bp);
 
 	bnxt_set_dflt_rfs(bp);
 
-- 
2.53.0



