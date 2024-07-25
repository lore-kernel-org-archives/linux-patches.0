Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6438319D89E;
	Thu, 25 Jul 2024 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721925999; cv=none; b=TV4OcwQi5NQKIJXYeEIU0zCurs7VWEdLeXU7ZsMzXTrBt8fMkrPtB63ux+x2gCG5hAN5/DYn0Of0E0aB3v6xgg/EKCKYblFK3AI3Rcev3uZfLmcnnsCA95gIDo8wBE6kBxoAd5oHji2yKtd2YPJ8FMD6dtyNls3Y1kpby2jWORA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721925999; c=relaxed/simple;
	bh=Qq3CcW40qWfdw5BFZRNSV2DrrWbD7dh0AWeFfVliKVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1qmEI2Y4GOzc/ML0lMB+3dijMny3nDQX7sOMJeds+MbvEIMV4QJZmoKKdPJ5NEZ0kbQhcHIEAi0HDWCJgC3Wz55dRPiQp0JgYrt1W222mCsT2p9Ecbj+QA5HuzCwilQ+Cj7h4G+qlVlvhqWc440W3UqRCGaIgO+PV9jZGDWciA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLtbxnCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLtbxnCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2E9C32782;
	Thu, 25 Jul 2024 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721925999;
	bh=Qq3CcW40qWfdw5BFZRNSV2DrrWbD7dh0AWeFfVliKVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XLtbxnCVsM3H88hxCT4whwdZObEvgfX0FGOw6VDK3bTQ7fqdxxyj/UJb8E+p2SnC3
	 chyIiKVV4cXmLRbif4eKgr4Xf97QJpf8mbJRU2C3Mxqe4teXXiZd0gy288ib9MUjUw
	 twvBSmq1JTuIHyjyYWuWi0lwJUhFqxPGUe/yELQIcb28JPWTsPM3a1yMFdcQSVHe2i
	 EzzpgxcCgq2X2qoLNlw+esFvejW6Awz1x330vAbu429VaPNw5ZsDhlRj6sAlp5VUlt
	 ZOuUgOeFx4ypAnfpg1vb7O1i63mqP2ECLUHoM3gs/J90o2wZxFkfOYcRlrAkDtyY0d
	 S0SfxslSoqqMQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] spmi: pmic-arb: Pass the correct of_node to irq_domain_add_tree
Date: Thu, 25 Jul 2024 09:46:32 -0700
Message-ID: <20240725164636.3362690-3-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
In-Reply-To: <20240725164636.3362690-1-sboyd@kernel.org>
References: <20240725164636.3362690-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

Currently, irqchips for all of the subnodes (which represent a given
bus master) point to the parent wrapper node. This is no bueno, as
no interrupts arrive, ever (because nothing references that node).

Fix that by passing a reference to the respective master's of_node.

Worth noting, this is a NOP for devices with only a single master
described.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240522-topic-spmi_multi_master_irqfix-v2-1-7ec92a862b9f@linaro.org
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 02922ccbb330 ("spmi: pmic-arb: Register controller for bus instead of arbiter")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index f240fcc5a4e1..b6880c13163c 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1737,8 +1737,7 @@ static int spmi_pmic_arb_bus_init(struct platform_device *pdev,
 
 	dev_dbg(&pdev->dev, "adding irq domain for bus %d\n", bus_index);
 
-	bus->domain = irq_domain_add_tree(dev->of_node,
-					  &pmic_arb_irq_domain_ops, bus);
+	bus->domain = irq_domain_add_tree(node, &pmic_arb_irq_domain_ops, bus);
 	if (!bus->domain) {
 		dev_err(&pdev->dev, "unable to create irq_domain\n");
 		return -ENOMEM;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

