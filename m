Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6190B1A76BE;
	Tue, 30 Jul 2024 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360560; cv=none; b=IzyU9qfsVHST1G2jHHrKIEHkMgzJVFeu4/S8IoRiUopAExK3Ub48deTfZDv+8wtSCoO0lr7E/OlChRxRSoRsbCfwQNqbUGY7wXk3ePe578wQAKSytd7cUKaDDYL15mvys12UpO7XLqetBwJAwEofMXS+1G6qSkuv2oEzwXnm1ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360560; c=relaxed/simple;
	bh=yEMsH3O7/PUmrYTED2ueBb5KJfJmi61IJxoZcHNDQmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuSouEADH4XhgmrDuof2sp9kD8/eqcv3ahldb/pbFyjb3k8aWNML4ZSV7Acb4TpI3/M8WDi13EtDR1Tbw6da3pFOtzK0/ULMQDkqT6mwukx7X3vINJ9gYcCFQTjnnTQK7GqONkKa3JjGRzjJxRmsTuv1wglpDPwu01avOH5RDTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9T4MPun; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9T4MPun"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9950EC4AF0A;
	Tue, 30 Jul 2024 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360560;
	bh=yEMsH3O7/PUmrYTED2ueBb5KJfJmi61IJxoZcHNDQmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9T4MPuneX04VAKByj9spsFuZczLv1AWifNtUDT28jbyFX6O65zj1WTFDUmphUoGO
	 F5Jl/p0gB9YFksn5BchWaAv+vuJ4b4H8gMgn43afMdk0sGzhXaz9e03RJVi2HCwZQ8
	 G5DLOix2ChVKYj40HVRT93UO8W3MKJowlPunHLQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 737/809] phy: qcom: qmp-pcie: restore compatibility with existing DTs
Date: Tue, 30 Jul 2024 17:50:13 +0200
Message-ID: <20240730151754.057431103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 912cee11c14376a6f707d72fcaf343a40bff48e8 ]

Existing device trees specify only a single clock-output-name for the
PCIe PHYs. The function phy_aux_clk_register() expects a second entry in
that property. When it doesn't find it, it returns an error, thus
failing the probe of the PHY and thus breaking support for the
corresponding PCIe host.

Follow the approach of the combo USB+DT PHY and generate the name for
the AUX clocks instead of requiring it in DT.

Fixes: 583ca9ccfa80 ("phy: qcom: qmp-pcie: register second optional PHY AUX clock")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240614-fix-pcie-phy-compat-v3-1-730d1811acf4@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 6c796723c8f5a..8fcdcb193d241 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -3730,14 +3730,11 @@ static int phy_aux_clk_register(struct qmp_pcie *qmp, struct device_node *np)
 {
 	struct clk_fixed_rate *fixed = &qmp->aux_clk_fixed;
 	struct clk_init_data init = { };
-	int ret;
+	char name[64];
 
-	ret = of_property_read_string_index(np, "clock-output-names", 1, &init.name);
-	if (ret) {
-		dev_err(qmp->dev, "%pOFn: No clock-output-names index 1\n", np);
-		return ret;
-	}
+	snprintf(name, sizeof(name), "%s::phy_aux_clk", dev_name(qmp->dev));
 
+	init.name = name;
 	init.ops = &clk_fixed_rate_ops;
 
 	fixed->fixed_rate = qmp->cfg->aux_clock_rate;
-- 
2.43.0



