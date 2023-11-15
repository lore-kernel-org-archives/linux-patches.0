Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F563A8C9
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/FI8A7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D897CC433CA;
	Wed, 15 Nov 2023 19:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077693;
	bh=OwilQIF6Yi8x+haqpcXNaio3+GY1FVtrcES8KDdfCsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/FI8A7ZyOTA9SoFHHFp0EbPfAYFTfWpLNBCChAGqhSoCyu+VJ2nBLL20LlS899I/
	 m0cuNkvLRN6n1jQHWVUL7jlOiABCR69yiXAyknDWPprs6FGvXuNQRIbr8JGgrZfLJD
	 thrUWixbOZwKjR8yYCAFL1vA9jHOv6n8MVi6Q8vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/603] interconnect: fix error handling in qnoc_probe()
Date: Wed, 15 Nov 2023 14:16:45 -0500
Message-ID: <20231115191644.437343412@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 273f74a2e7d15a5c216a4a26b84b1563c7092c9d ]

Add missing clk_disable_unprepare() and clk_bulk_disable_unprepare()
in the error path in qnoc_probe(). And when qcom_icc_qos_set() fails,
it needs remove nodes and disable clks.

Fixes: 2e2113c8a64f ("interconnect: qcom: rpm: Handle interface clocks")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230803130521.959487-1-yangyingliang@huawei.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 2c16917ba1fda..e76356f91125f 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -497,7 +497,7 @@ int qnoc_probe(struct platform_device *pdev)
 
 	ret = devm_clk_bulk_get(dev, qp->num_intf_clks, qp->intf_clks);
 	if (ret)
-		return ret;
+		goto err_disable_unprepare_clk;
 
 	provider = &qp->provider;
 	provider->dev = dev;
@@ -512,13 +512,15 @@ int qnoc_probe(struct platform_device *pdev)
 	/* If this fails, bus accesses will crash the platform! */
 	ret = clk_bulk_prepare_enable(qp->num_intf_clks, qp->intf_clks);
 	if (ret)
-		return ret;
+		goto err_disable_unprepare_clk;
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
 
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
+			clk_bulk_disable_unprepare(qp->num_intf_clks,
+						   qp->intf_clks);
 			ret = PTR_ERR(node);
 			goto err_remove_nodes;
 		}
@@ -534,8 +536,11 @@ int qnoc_probe(struct platform_device *pdev)
 		if (qnodes[i]->qos.ap_owned &&
 		    qnodes[i]->qos.qos_mode != NOC_QOS_MODE_INVALID) {
 			ret = qcom_icc_qos_set(node);
-			if (ret)
-				return ret;
+			if (ret) {
+				clk_bulk_disable_unprepare(qp->num_intf_clks,
+							   qp->intf_clks);
+				goto err_remove_nodes;
+			}
 		}
 
 		data->nodes[i] = node;
@@ -563,6 +568,7 @@ int qnoc_probe(struct platform_device *pdev)
 	icc_provider_deregister(provider);
 err_remove_nodes:
 	icc_nodes_remove(provider);
+err_disable_unprepare_clk:
 	clk_disable_unprepare(qp->bus_clk);
 
 	return ret;
-- 
2.42.0



