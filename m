Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA5428B4F0;
	Tue,  2 Sep 2025 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819577; cv=none; b=LhlHG9MhjqoCbiUqOi8+SkRv7vs3ZoxVL2YMESl4jlQUnvJSl6PQSzcjZKyEpOEQBzi/Y0TBODhc7vTTXAtNu+fKC2YHYan68KB67SMmYplduclOlpI/RU48i1/WKs9mAYKqCfr0UyR4m2XsOect5zHPU6TW84g4uxX9X6VhCZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819577; c=relaxed/simple;
	bh=OW65tS29Og1Sk5OPIL1eePfV5lLVyztEVYVIO16Q0zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPW/YcqgfevwIoBsU3pQnFAfgwfa4HglC3XBE1nVEWgsGh6lQxISzHrV2CH9mCexK2WlgdPB+prr6GLEZZEHqHroZF/kGFxAS3hSPjvnGl22CzUZH0rzv/g5njQ+YSGpli2gi6c6kcQK5IgUtPMiBu2uTr+Te0b8b1nJOkrhxEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHinbXdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHinbXdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47FC4CEED;
	Tue,  2 Sep 2025 13:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819577;
	bh=OW65tS29Og1Sk5OPIL1eePfV5lLVyztEVYVIO16Q0zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHinbXdMyHMPNA/fG/qrVtiZCFLFIGPIb1NtSr6Mcy5J42S+llMbtY6nZ+aNCVoX0
	 mTbH2URibKQf5PZTaRPh8SiRo/ZNXoriUNuJXQV11exR7fxNgXqkZz6VA95u4Hx6LA
	 ctkmvErgCoV86g+U4ncNYQC7o3pLI57Yv4Si/qnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 076/142] bnxt_en: Adjust TX rings if reservation is less than requested
Date: Tue,  2 Sep 2025 15:19:38 +0200
Message-ID: <20250902131951.182511947@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 1ee581c24dfdcbc6de25aac95a48c1f08e9a542c ]

Before we accept an ethtool request to increase a resource (such as
rings), we call the FW to check that the requested resource is likely
available first before we commit.  But it is still possible that
the actual reservation or allocation can fail.  The existing code
is missing the logic to adjust the TX rings in case the reserved
TX rings are less than requested.  Add a warning message (a similar
message for RX rings already exists) and add the logic to adjust
the TX rings.  Without this fix, the number of TX rings reported
to the stack can exceed the actual TX rings and ethtool -l will
report more than the actual TX rings.

Fixes: 674f50a5b026 ("bnxt_en: Implement new method to reserve rings.")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250825175927.459987-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a4f4d90caf5e9..5360c42ad409c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8017,6 +8017,11 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 		hwr.rx = rx_rings << 1;
 	tx_cp = bnxt_num_tx_to_cp(bp, hwr.tx);
 	hwr.cp = sh ? max_t(int, tx_cp, rx_rings) : tx_cp + rx_rings;
+	if (hwr.tx != bp->tx_nr_rings) {
+		netdev_warn(bp->dev,
+			    "Able to reserve only %d out of %d requested TX rings\n",
+			    hwr.tx, bp->tx_nr_rings);
+	}
 	bp->tx_nr_rings = hwr.tx;
 
 	/* If we cannot reserve all the RX rings, reset the RSS map only
@@ -12872,6 +12877,13 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (rc)
 		return rc;
 
+	/* Make adjustments if reserved TX rings are less than requested */
+	bp->tx_nr_rings -= bp->tx_nr_rings_xdp;
+	bp->tx_nr_rings_per_tc = bnxt_tx_nr_rings_per_tc(bp);
+	if (bp->tx_nr_rings_xdp) {
+		bp->tx_nr_rings_xdp = bp->tx_nr_rings_per_tc;
+		bp->tx_nr_rings += bp->tx_nr_rings_xdp;
+	}
 	rc = bnxt_alloc_mem(bp, irq_re_init);
 	if (rc) {
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
-- 
2.50.1



