Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289AE33F5B4;
	Thu, 28 May 2026 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998265; cv=none; b=YozqEvRvcSOx1XbcYWbZKiUYlC1HhawMZeyL5rhCA2mZYR1ft1h3hGD5IXO2UgHN1l3AcB2M01Q9h4SkY3o3YY4oBNqzkGLspGnMR2nBhQzm3rcj6FGAeX0owVUhDvzPohao2NBHzZE355815W+tdKrLN0c2+rXBlrWLKWabwCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998265; c=relaxed/simple;
	bh=V0cObrbj+57VsaUeU2dos0yz7hnHBTFx//ayWXlznX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKuMcjKxmU7CHhQEvw6O4EGmxKRwaZgxuBEvrZfoLcZBZqZHcza2HLujWgZdo9iHaBu3NhdwSK2E/kc9Io+WqGas2GJtXjG5O4ypnRu5t2GZvvNPAEJl4q/et4clwxZdUuxuVJA7nGk5c+XPE2O6ljRKPvc4H5G+LgreFigF2lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKYlIVoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKYlIVoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865BE1F000E9;
	Thu, 28 May 2026 19:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998264;
	bh=EjjSdrsZWKGsHyJJCcxx+9OQyxO1PqgrnI5U3l3k8no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKYlIVoPfnQdviXsXLL0geoPjBfc4guzmbgjuP32KFFlWlmtlvpDHlNEaQ+5XYWJZ
	 78Ji3mirsJeouuUpDvx5YJN98AIyaoTlPxUPD+c3IGFXC/uD+fS1WYz82Pq8TL0fhE
	 zyqw3vXj3Zg3HiN+B9jkNhUgV9kduuBVGULgX+9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.0 111/461] phy: qcom-qmp-ufs: Fix kaanapali PHY PLL lock failure after SM8650 G4 fix
Date: Thu, 28 May 2026 21:44:00 +0200
Message-ID: <20260528194650.182779400@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

commit 80305760d7a55b884fb9023c490b75568d1ea0b1 upstream.

Commit 81af9e40e2e4 ("phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4")
moved QPHY_V6_PCS_UFS_PLL_CNTL register configuration from the shared
sm8650_ufsphy_g5_pcs table to the SM8650-specific sm8650_ufsphy_pcs base
table to fix Gear 4 operation on SM8650.

However, this change inadvertently broke kaanapali and SM8750 SoCs
which also rely on the shared sm8650_ufsphy_g5_pcs table for Gear 5
configuration but use their own sm8750_ufsphy_pcs base table. After the
change, kaanapali PHYs are left without the required PLL_CNTL = 0x33
setting, causing the PHY PLL to remain at its hardware reset default
value, preventing PLL lock and resulting in DME_LINKSTARTUP timeouts.

Fix this by adding the missing QPHY_V6_PCS_UFS_PLL_CNTL = 0x33 entry
to the sm8750_ufsphy_pcs table, mirroring what the original commit
already did for sm8650_ufsphy_pcs.

Cc: stable@vger.kernel.org # v6.19.12
Fixes: 81af9e40e2e4 ("phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4")
Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260415104851.2763238-1-nitin.rawat@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -1112,6 +1112,7 @@ static const struct qmp_phy_init_tbl sm8
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0x40),
+	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S4, 0x0e),


