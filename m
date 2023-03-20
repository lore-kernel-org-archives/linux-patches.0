Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E711C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39504C433EF;
	Mon, 20 Mar 2023 15:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325997;
	bh=oinfXLo2mn+fp3UP3KORY6Jo907fJHxz+HjgO9B2WCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+uL1+wQ0JzAOieEuBjxwvfZr/Uy0fe7VtNrbEwrQjOSkpHpW2hbaRATPR2PxMWJy
	 PTr5xvBGMPmWCOj7/9Rb4oT7OdA8kJKKnSmEETkx+a6BhWhhTIGO/y67bHBUGyOF0M
	 r+YT8xl4Jo/7oVLkQWpGyjWPEA44cijVw4cNVgZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.2 138/211] interconnect: qcom: rpmh: fix registration race
Date: Mon, 20 Mar 2023 15:54:33 +0100
Message-Id: <20230320145519.211532787@linuxfoundation.org>
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

commit 74240a5bebd48d8b843c6d0f1acfaa722a5abeb7 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Cc: stable@vger.kernel.org      # 5.7
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-11-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -192,9 +192,10 @@ int qcom_icc_rpmh_probe(struct platform_
 	provider->pre_aggregate = qcom_icc_pre_aggregate;
 	provider->aggregate = qcom_icc_aggregate;
 	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
+	icc_provider_init(provider);
+
 	qp->dev = dev;
 	qp->bcms = desc->bcms;
 	qp->num_bcms = desc->num_bcms;
@@ -203,10 +204,6 @@ int qcom_icc_rpmh_probe(struct platform_
 	if (IS_ERR(qp->voter))
 		return PTR_ERR(qp->voter);
 
-	ret = icc_provider_add(provider);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < qp->num_bcms; i++)
 		qcom_icc_bcm_init(qp->bcms[i], dev);
 
@@ -218,7 +215,7 @@ int qcom_icc_rpmh_probe(struct platform_
 		node = icc_node_create(qn->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qn->name;
@@ -232,19 +229,27 @@ int qcom_icc_rpmh_probe(struct platform_
 	}
 
 	data->num_nodes = num_nodes;
+
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
 	if (of_get_child_count(dev->of_node) > 0) {
 		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
 		if (ret)
-			goto err;
+			goto err_deregister_provider;
 	}
 
 	return 0;
-err:
+
+err_deregister_provider:
+	icc_provider_deregister(provider);
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_rpmh_probe);
@@ -253,8 +258,8 @@ int qcom_icc_rpmh_remove(struct platform
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }


