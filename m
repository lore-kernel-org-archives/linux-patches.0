Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7558F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA3CC433C7;
	Sun, 16 Jul 2023 20:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538971;
	bh=dQvGgRmeWDebYmrjcUuW9pJlQaoBZO15RZPdm+KoYXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAUoR5FxeLgy4ubYEIUZn2pLuUTAqoRQoo8Zb99L3bChnkrTOd+K85OgX+ce+YKfL
	 8KehWl+0LILwj/d7Sy+hVztjVlGGH2l2/JodxahH1GW9iROU2xBlAtRHDVJ5jyj+ME
	 BW6Ir47oPr0F5WPj5W0Wpy0VauglOMx/qqRZtqss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 642/800] phy: qcom: qmp-combo: fix Display Port PHY configuration for SM8550
Date: Sun, 16 Jul 2023 21:48:15 +0200
Message-ID: <20230716195004.025321157@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 6cd52a2a06774c6c454ffef084c3d9b17618ca23 ]

The SM8550 PHY also uses a different offset for the CMN_STATUS reg,
use the right one for the v6 Display Port configuration.

Fixes: 49742e9edab3 ("phy: qcom-qmp-combo: Add support for SM8550")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230601-topic-sm8550-upstream-dp-phy-init-fix-v1-1-4e9da9f97991@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 87b17e5877ab8..1fdcc81661ed8 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -2142,6 +2142,7 @@ static void qmp_v4_configure_dp_tx(struct qmp_combo *qmp)
 static int qmp_v456_configure_dp_phy(struct qmp_combo *qmp,
 				     unsigned int com_resetm_ctrl_reg,
 				     unsigned int com_c_ready_status_reg,
+				     unsigned int com_cmn_status_reg,
 				     unsigned int dp_phy_status_reg)
 {
 	const struct phy_configure_opts_dp *dp_opts = &qmp->dp_opts;
@@ -2198,14 +2199,14 @@ static int qmp_v456_configure_dp_phy(struct qmp_combo *qmp,
 			10000))
 		return -ETIMEDOUT;
 
-	if (readl_poll_timeout(qmp->dp_serdes + QSERDES_V4_COM_CMN_STATUS,
+	if (readl_poll_timeout(qmp->dp_serdes + com_cmn_status_reg,
 			status,
 			((status & BIT(0)) > 0),
 			500,
 			10000))
 		return -ETIMEDOUT;
 
-	if (readl_poll_timeout(qmp->dp_serdes + QSERDES_V4_COM_CMN_STATUS,
+	if (readl_poll_timeout(qmp->dp_serdes + com_cmn_status_reg,
 			status,
 			((status & BIT(1)) > 0),
 			500,
@@ -2241,6 +2242,7 @@ static int qmp_v4_configure_dp_phy(struct qmp_combo *qmp)
 
 	ret = qmp_v456_configure_dp_phy(qmp, QSERDES_V4_COM_RESETSM_CNTRL,
 					QSERDES_V4_COM_C_READY_STATUS,
+					QSERDES_V4_COM_CMN_STATUS,
 					QSERDES_V4_DP_PHY_STATUS);
 	if (ret < 0)
 		return ret;
@@ -2305,6 +2307,7 @@ static int qmp_v5_configure_dp_phy(struct qmp_combo *qmp)
 
 	ret = qmp_v456_configure_dp_phy(qmp, QSERDES_V4_COM_RESETSM_CNTRL,
 					QSERDES_V4_COM_C_READY_STATUS,
+					QSERDES_V4_COM_CMN_STATUS,
 					QSERDES_V4_DP_PHY_STATUS);
 	if (ret < 0)
 		return ret;
@@ -2364,6 +2367,7 @@ static int qmp_v6_configure_dp_phy(struct qmp_combo *qmp)
 
 	ret = qmp_v456_configure_dp_phy(qmp, QSERDES_V6_COM_RESETSM_CNTRL,
 					QSERDES_V6_COM_C_READY_STATUS,
+					QSERDES_V6_COM_CMN_STATUS,
 					QSERDES_V6_DP_PHY_STATUS);
 	if (ret < 0)
 		return ret;
-- 
2.39.2



