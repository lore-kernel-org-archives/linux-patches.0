Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9EB1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61696C433EF;
	Mon, 20 Mar 2023 15:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325961;
	bh=FwEafGK3MCe9FJYti0DvSQD0dVjCiZOHkwLeXBPnFSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIb/WcaJeKJXt8LJ/34XruNP++OcGdx+2y74T51YEwi76Ndalh5wXlU9fO6gfLrUc
	 ICNFWpGk5n8ye3C9LOvIskvMozx6mDB1Osv2YMpOJdQij3bRuhzwxoJOerKtL2kuaM
	 wsPyaX6PXpvbWywITzHbjZgaHjo9xWbt/UEETPHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Bailon <abailon@baylibre.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH 6.2 132/211] interconnect: imx: fix registration race
Date: Mon, 20 Mar 2023 15:54:27 +0100
Message-Id: <20230320145518.959555019@linuxfoundation.org>
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

commit 9fbd35520f1f7f3cbe1873939a27ad9b009f21f9 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
Cc: stable@vger.kernel.org      # 5.8
Cc: Alexandre Bailon <abailon@baylibre.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # i.MX8MP MSC SM2-MB-EP1 Board
Link: https://lore.kernel.org/r/20230306075651.2449-5-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/imx/imx.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -295,6 +295,9 @@ int imx_icc_register(struct platform_dev
 	provider->xlate = of_icc_xlate_onecell;
 	provider->data = data;
 	provider->dev = dev->parent;
+
+	icc_provider_init(provider);
+
 	platform_set_drvdata(pdev, imx_provider);
 
 	if (settings) {
@@ -306,20 +309,18 @@ int imx_icc_register(struct platform_dev
 		}
 	}
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
+	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	if (ret)
 		return ret;
-	}
 
-	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	ret = icc_provider_register(provider);
 	if (ret)
-		goto provider_del;
+		goto err_unregister_nodes;
 
 	return 0;
 
-provider_del:
-	icc_provider_del(provider);
+err_unregister_nodes:
+	imx_icc_unregister_nodes(&imx_provider->provider);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(imx_icc_register);
@@ -328,9 +329,8 @@ void imx_icc_unregister(struct platform_
 {
 	struct imx_icc_provider *imx_provider = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&imx_provider->provider);
 	imx_icc_unregister_nodes(&imx_provider->provider);
-
-	icc_provider_del(&imx_provider->provider);
 }
 EXPORT_SYMBOL_GPL(imx_icc_unregister);
 


