Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8668301472;
	Thu, 28 May 2026 20:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999681; cv=none; b=j00RomIEwrEDue5B3t2P5tjk/D/b8S6EVFQvd1ACWtPbQ4PeAG/o0xqQD9+7hAiKwGtX8YQ8TffaZAcpooR2a6GMi+wvtwim+D7s3Idt8s2lN+oSsCuUFh8eXji+WVTeFxgpzQgMwiUCRSUwXFuAvf8UwZr4kkckV0QbzxHTXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999681; c=relaxed/simple;
	bh=m+fWbOtD9JgUr7a7pjxSZv4KcSalQoQhh7cQiJ3Tqkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gO/qEYYpXgfXZO/4d//VDva96+KojIvAvIS1/Gza4k2jCvGxBVFmm3vLqaSH3utT7mDIUX0zlAsfHjqvNPxwrmuDBqmjDw+7FWAwO28SQsghSuwwTrGI4eE9PcYTPVM717EHVAET9pNX+bMWqfBChRg3QEYiO0dz6RLhEJcjk7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzruY+Ix; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzruY+Ix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB881F000E9;
	Thu, 28 May 2026 20:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999680;
	bh=T4XMCcEBBBOx2NC/RTISFOW1KZDnTC/Y3ozC5vfbPj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzruY+Ix2faleIb3a/0Q40hXEPqd3e8xjoL4vdho+pBiQw6wYJe/i3zJ1pcFIj39+
	 zIcWdJjeSkEiN6+cb0fFKYpP/CHrlifNh99ORaNeybOnB/ZWnPRcKGHiQhOAk3TXl9
	 chpTSL9OmK8ZKIExc/HZUftfTu7JhLBJRqhRcnkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 117/377] phy: qcom-qmp-ufs: Fix kaanapali PHY PLL lock failure after SM8650 G4 fix
Date: Thu, 28 May 2026 21:45:55 +0200
Message-ID: <20260528194641.723658541@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -1050,6 +1050,7 @@ static const struct qmp_phy_init_tbl sm8
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0x40),
+	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S4, 0x0e),


