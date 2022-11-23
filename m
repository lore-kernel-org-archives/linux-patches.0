Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25C01C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419DCC433D7;
	Wed, 23 Nov 2022 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196832;
	bh=wUl7IVCpwie38HmCHTaMz62NWtS26+zgc5NkX9CrU2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yskg0/U11FiA2m7MUf84g+qezMpkVtatYfoSKd4BhR3nXpFQBA7oy9ig+88jRr8wA
	 AnnWHwkS7s8hty2T7/WLN+E7B7+nVTCMawqkHCRBjrn/ummcyOYHes4uPuJY6Dx4Rm
	 WvXmvnXcSsdJd9SdVIuVCT7q3bw0AaU24CkhD8Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 105/314] bnxt_en: refactor bnxt_cancel_reservations()
Date: Wed, 23 Nov 2022 09:49:10 +0100
Message-Id: <20221123084630.256463788@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit b4c66425771ddb910316c7b4cd7fa0614098ec45 ]

Introduce bnxt_clear_reservations() to clear the reserved attributes only.
This will be used in the next patch to fix PCI AER handling.

Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0cf736a18a1e ("bnxt_en: fix the handling of PCIE-AER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index be5df8fca264..72915f40c7a0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9983,17 +9983,12 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 	return -ENODEV;
 }
 
-int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+static void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset)
 {
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	int rc;
 
 	if (!BNXT_NEW_RM(bp))
-		return 0; /* no resource reservations required */
-
-	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
-	if (rc)
-		netdev_err(bp->dev, "resc_qcaps failed\n");
+		return; /* no resource reservations required */
 
 	hw_resc->resv_cp_rings = 0;
 	hw_resc->resv_stat_ctxs = 0;
@@ -10006,6 +10001,20 @@ int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
 		bp->tx_nr_rings = 0;
 		bp->rx_nr_rings = 0;
 	}
+}
+
+int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset)
+{
+	int rc;
+
+	if (!BNXT_NEW_RM(bp))
+		return 0; /* no resource reservations required */
+
+	rc = bnxt_hwrm_func_resc_qcaps(bp, true);
+	if (rc)
+		netdev_err(bp->dev, "resc_qcaps failed\n");
+
+	bnxt_clear_reservations(bp, fw_reset);
 
 	return rc;
 }
-- 
2.35.1



