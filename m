Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F440168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021CAC433EF;
	Mon,  8 May 2023 10:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542615;
	bh=UWzd+PXQ9vZVbZ35H8xPB+Bn2ZnPmIq5lDFlLZQZ1XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBiG7dzUeY8C05bna36vP2d2xC8nCWdcbpGiKs+sh2jfdwThJHMl23ReiCpCEXwC3
	 BAPYBenPkDV9LYtfWw60JEQHvOfJfp6i8fUwwJt7M3fo7IcSnFzz78Pgdj7OoVx80j
	 +/4mT2T/uIrPt3aRzlvuatoOzJJuTTe3FRC1v+9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 460/663] interconnect: qcom: rpm: drop bogus pm domain attach
Date: Mon,  8 May 2023 11:44:46 +0200
Message-Id: <20230508094443.060195849@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 72b2720c18ecde92e6a36c4ac897dd5848e3f379 ]

Any power domain would already have been attached by the platform bus
code so drop the bogus power domain attach which always succeeds from
probe.

This effectively reverts commit 7de109c0abe9 ("interconnect: icc-rpm:
Add support for bus power domain").

Fixes: 7de109c0abe9 ("interconnect: icc-rpm: Add support for bus power domain")
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org> # MSM8996 Sony Kagura
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230313084953.24088-3-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 7 -------
 drivers/interconnect/qcom/icc-rpm.h | 1 -
 drivers/interconnect/qcom/msm8996.c | 1 -
 3 files changed, 9 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 4180a06681b2b..c80819557923e 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -11,7 +11,6 @@
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
-#include <linux/pm_domain.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 
@@ -496,12 +495,6 @@ int qnoc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	if (desc->has_bus_pd) {
-		ret = dev_pm_domain_attach(dev, true);
-		if (ret)
-			return ret;
-	}
-
 	provider = &qp->provider;
 	provider->dev = dev;
 	provider->set = qcom_icc_set;
diff --git a/drivers/interconnect/qcom/icc-rpm.h b/drivers/interconnect/qcom/icc-rpm.h
index a49af844ab13e..02257b0d3d5c6 100644
--- a/drivers/interconnect/qcom/icc-rpm.h
+++ b/drivers/interconnect/qcom/icc-rpm.h
@@ -91,7 +91,6 @@ struct qcom_icc_desc {
 	size_t num_nodes;
 	const char * const *clocks;
 	size_t num_clocks;
-	bool has_bus_pd;
 	enum qcom_icc_type type;
 	const struct regmap_config *regmap_cfg;
 	unsigned int qos_offset;
diff --git a/drivers/interconnect/qcom/msm8996.c b/drivers/interconnect/qcom/msm8996.c
index 25a1a32bc611f..14efd2761b7ab 100644
--- a/drivers/interconnect/qcom/msm8996.c
+++ b/drivers/interconnect/qcom/msm8996.c
@@ -1823,7 +1823,6 @@ static const struct qcom_icc_desc msm8996_a0noc = {
 	.num_nodes = ARRAY_SIZE(a0noc_nodes),
 	.clocks = bus_a0noc_clocks,
 	.num_clocks = ARRAY_SIZE(bus_a0noc_clocks),
-	.has_bus_pd = true,
 	.regmap_cfg = &msm8996_a0noc_regmap_config
 };
 
-- 
2.39.2



