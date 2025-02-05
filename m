Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F281632C8;
	Wed,  5 Feb 2025 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767130; cv=none; b=Uf3AlXj2i3FXm8gJcy+/j6z0dshJkkQsMR4VlpygQ23odwoLsdDuzF3jUE5mrxTHCgWDJvzcFf7hzMnRmGputBq8GALEXlSiHrtJkE/9mh8dF41cEc4Cf4/dqQYovvsIizJDY4u8Dx8dxmUfv5mp5aAPP7IUpGi6F4agtwgnYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767130; c=relaxed/simple;
	bh=U/nD9DftISFG85QxFmYTPhX5E4DqD1871l4iy9OaLmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzUPnTI19syQ1EBCZkIvcVTJl/AS77z7tEpdO8H2foemiklPH9wQSP5fFZLeAiaodu0P6X2NMbFR3RrfzNlot07YrX2gR/sppkV3WCuNvSrO+1LXp7vYGT8Em43U0VYWPCfOobksfNqMOpDDHYEAX2gaB3u8vKChi4d2lAf1qoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bAwxV6BD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bAwxV6BD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38D7C4CED1;
	Wed,  5 Feb 2025 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767130;
	bh=U/nD9DftISFG85QxFmYTPhX5E4DqD1871l4iy9OaLmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bAwxV6BD7Sh2iUqF/Hn/3b1ps4l3A/h6Rh6i/SuQRJqH3sEoK3MBSTWhuYlgIqj4F
	 w+pcew3DjT1MXDcAaGkdJm+daqJ9B/vx63Ha+ucYNJQd0BQpGkwwBqa+SHRUuF6p8V
	 OKj9SPgSVl5Z2GH1DaNa5ZSxLrCsgtaP/ac5XncQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tinghan Shen <tinghan.shen@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/590] remoteproc: mtk_scp: Only populate devices for SCP cores
Date: Wed,  5 Feb 2025 14:42:45 +0100
Message-ID: <20250205134510.953981669@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit dbb9c372555c0b2a5a9264418bfba6d017752808 ]

When multi-core SCP support was added, the driver was made to populate
platform devices for all the sub-nodes. This ended up adding platform
devices for the rpmsg sub-nodes as well, which never actually get used,
since rpmsg devices are registered through the rpmsg interface.

Limit of_platform_populate() to just populating the SCP cores with a
compatible string match list.

Fixes: 1fdbf0cdde98 ("remoteproc: mediatek: Probe SCP cluster on multi-core SCP")
Cc: Tinghan Shen <tinghan.shen@mediatek.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20241211072009.120511-1-wenst@chromium.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/mtk_scp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/mtk_scp.c b/drivers/remoteproc/mtk_scp.c
index e744c07507eed..f98a11d4cf292 100644
--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -1326,6 +1326,11 @@ static int scp_cluster_init(struct platform_device *pdev, struct mtk_scp_of_clus
 	return ret;
 }
 
+static const struct of_device_id scp_core_match[] = {
+	{ .compatible = "mediatek,scp-core" },
+	{}
+};
+
 static int scp_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1357,13 +1362,15 @@ static int scp_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&scp_cluster->mtk_scp_list);
 	mutex_init(&scp_cluster->cluster_lock);
 
-	ret = devm_of_platform_populate(dev);
+	ret = of_platform_populate(dev_of_node(dev), scp_core_match, NULL, dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to populate platform devices\n");
 
 	ret = scp_cluster_init(pdev, scp_cluster);
-	if (ret)
+	if (ret) {
+		of_platform_depopulate(dev);
 		return ret;
+	}
 
 	return 0;
 }
@@ -1379,6 +1386,7 @@ static void scp_remove(struct platform_device *pdev)
 		rproc_del(scp->rproc);
 		scp_free(scp);
 	}
+	of_platform_depopulate(&pdev->dev);
 	mutex_destroy(&scp_cluster->cluster_lock);
 }
 
-- 
2.39.5



