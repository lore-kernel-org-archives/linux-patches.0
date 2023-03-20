Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC1D1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA89C433EF;
	Mon, 20 Mar 2023 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325759;
	bh=op+ATlGITwr+eaPzzd4SHgYZEGMEJafQ3vBMJ5bUrSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wijXPgWqXoMiosN9GhPP7Hb3F3EPGnGxmJGbyMS8rzhgk0rzhwaIcGZBLOL2Et7qe
	 NpsTtqzGyHnRSFErtrx+YZgsBuJAOa+TPUg9U8gkEwkeNycyT0RaSmln4R7Roka97k
	 Fse0As3nSedPiNMro2tfhCp9u5eZ39xqK5HdTxgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 6.1 138/198] interconnect: qcom: msm8974: fix registration race
Date: Mon, 20 Mar 2023 15:54:36 +0100
Message-Id: <20230320145513.336441908@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit bfe7bcd2b9f5215de2144f097f39971180e7ea54 upstream.

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 4e60a9568dc6 ("interconnect: qcom: add msm8974 driver")
Cc: stable@vger.kernel.org      # 5.5
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20230306075651.2449-12-johan+linaro@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/msm8974.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/interconnect/qcom/msm8974.c
+++ b/drivers/interconnect/qcom/msm8974.c
@@ -692,7 +692,6 @@ static int msm8974_icc_probe(struct plat
 		return ret;
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = msm8974_icc_set;
 	provider->aggregate = icc_std_aggregate;
@@ -700,11 +699,7 @@ static int msm8974_icc_probe(struct plat
 	provider->data = data;
 	provider->get_bw = msm8974_get_bw;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		goto err_disable_clks;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -712,7 +707,7 @@ static int msm8974_icc_probe(struct plat
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err_del_icc;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -729,15 +724,16 @@ static int msm8974_icc_probe(struct plat
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 
-err_del_icc:
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-
-err_disable_clks:
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
 	return ret;
@@ -747,9 +743,9 @@ static int msm8974_icc_remove(struct pla
 {
 	struct msm8974_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }


