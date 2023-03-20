Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEF71C29
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0255C433EF;
	Mon, 20 Mar 2023 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326047;
	bh=XXgsjh20dOOAVU9aBn8zTTQ9u5yTkBonbr3FD3pyifw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVOMPooO4qd7uYn1guvQr8qd/L5ykr6iIidZ58h/QDnR5Nj7ihl+QjhZptHOtnGKW
	 uR2WQhgFx8fkTEOfWN4KLF9b8T10/tmQ4QfLhWKNWtGSTkHGM1AbCL9yetu7Ale77M
	 HwKbFRQml+8gTv2HlTbUu7pbXsKsTmU2CRhsAmxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 141/211] interconnect: exynos: fix registration race
Date: Mon, 20 Mar 2023 15:54:36 +0100
Message-Id: <20230320145519.339447976@linuxfoundation.org>
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

commit c9e46ca612cfbb0cf890f7ae7389b742e90efe64 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to trigger a NULL-pointer
deference when either a NULL pointer or not fully initialised node is
returned from exynos_generic_icc_xlate().

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Cc: stable@vger.kernel.org      # 5.11
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-16-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/samsung/exynos.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(str
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 	struct icc_node *parent_node, *node = priv->node;
 
+	icc_provider_deregister(&priv->provider);
+
 	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
 	if (parent_node && !IS_ERR(parent_node))
 		icc_link_destroy(node, parent_node);
 
 	icc_nodes_remove(&priv->provider);
-	icc_provider_del(&priv->provider);
 
 	return 0;
 }
@@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(stru
 	provider->inter_set = true;
 	provider->data = priv;
 
-	ret = icc_provider_add(provider);
-	if (ret < 0)
-		return ret;
+	icc_provider_init(provider);
 
 	icc_node = icc_node_create(pdev->id);
-	if (IS_ERR(icc_node)) {
-		ret = PTR_ERR(icc_node);
-		goto err_prov_del;
-	}
+	if (IS_ERR(icc_node))
+		return PTR_ERR(icc_node);
 
 	priv->node = icc_node;
 	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
@@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(stru
 			goto err_pmqos_del;
 	}
 
+	ret = icc_provider_register(provider);
+	if (ret < 0)
+		goto err_pmqos_del;
+
 	return 0;
 
 err_pmqos_del:
 	dev_pm_qos_remove_request(&priv->qos_req);
 err_node_del:
 	icc_nodes_remove(provider);
-err_prov_del:
-	icc_provider_del(provider);
+
 	return ret;
 }
 


