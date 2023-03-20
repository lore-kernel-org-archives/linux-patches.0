Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695EF1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:25:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB198C433EF;
	Mon, 20 Mar 2023 15:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325926;
	bh=eMnLxNQcEH7wu5rS5OnW9k7DLs4mlLDrm3Srdqu8Ra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INb+v+0g92jCxrSqosN1984fSn2/yLle3B15wiAtH/kjxqU443s+n9xrPTbpF/ARf
	 nPtDTN5xCPoNwYIvhxE2yb6IRnic+BhDWLgq67TdTi7MA/vILdZtO1C5q8TxYp3DhJ
	 WM+PBZD8BIZLl2L1Q5Z8jSAeYwtcGYRVYgAzlOeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <digetx@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 126/211] memory: tegra124-emc: fix interconnect registration race
Date: Mon, 20 Mar 2023 15:54:21 +0100
Message-Id: <20230320145518.666035318@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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

commit abd9f1b49cf25eebeaba193c7707355be3f48dae upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 380def2d4cf2 ("memory: tegra124: Support interconnect framework")
Cc: stable@vger.kernel.org      # 5.12
Cc: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-19-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/tegra/tegra124-emc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -1351,15 +1351,13 @@ static int tegra_emc_interconnect_init(s
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1380,12 +1378,14 @@ static int tegra_emc_interconnect_init(s
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 


