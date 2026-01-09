Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723872737EE;
	Fri,  9 Jan 2026 12:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961059; cv=none; b=d8s0qqULl8LZqg2zEaAohSL2URC3aMs5K/TAT0BML9f3hdEftNGzUUxydScTpD+nUxlXGtpu7tiJ2BO49UYkacEf/sFqzglTxBiA4iAXnBC5zlMNb4KgthHihexMRMOajQu7f4p0k7eegF7T00zHSgRR5Lhib3OwfOP2zswYT04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961059; c=relaxed/simple;
	bh=LQwO7B3SlV9PyhSTOceCGDTm9c15SnzB4cARyc2CcFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r50tGv44aJR6qX77MJVBXf6df0UxxM1DrOtnYDXvMjl/XnZItiOdG3OeiUcQw9jZ0saRVLhmSUdsCPyq4OsaRDeZsFAeUcB8S8S+uKS19wjBoV82H3GjLXybh5qTivasCT25qC9vxIryO+fzij89bzhY5V9jDRq/jXd7ZaiGibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zM9KTtkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zM9KTtkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05DBC16AAE;
	Fri,  9 Jan 2026 12:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961059;
	bh=LQwO7B3SlV9PyhSTOceCGDTm9c15SnzB4cARyc2CcFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM9KTtkD9bVkwpRe4QJbL72u9IlmfAi4KbZJKwD/REnES3UXZg6Qzq3f4bnBkXGZP
	 mVzVPh3XOdtRGTQTxVUWHWEj/f6QkhKO7l/Gbyde0IercLrhbG6BBK3ZxMjZ5HS33r
	 4duSwo56VzlPvlsunkBRqXe7MkR7LYmT2UmSmyDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 620/737] drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()
Date: Fri,  9 Jan 2026 12:42:39 +0100
Message-ID: <20260109112157.326373418@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miaoqian Lin <linmq006@gmail.com>

commit a846505a193d7492ad3531e33cacfca31e4bcdd1 upstream.

The function mtk_dp_dt_parse() calls of_graph_get_endpoint_by_regs()
to get the endpoint device node, but fails to call of_node_put() to release
the reference when the function returns. This results in a device node
reference leak.

Fix this by adding the missing of_node_put() call before returning from
the function.

Found via static analysis and code review.

Fixes: f70ac097a2cf ("drm/mediatek: Add MT8195 Embedded DisplayPort driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20251029072307.10955-1-linmq006@gmail.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/mediatek/mtk_dp.c
+++ b/drivers/gpu/drm/mediatek/mtk_dp.c
@@ -1969,6 +1969,7 @@ static int mtk_dp_dt_parse(struct mtk_dp
 	endpoint = of_graph_get_endpoint_by_regs(pdev->dev.of_node, 1, -1);
 	len = of_property_count_elems_of_size(endpoint,
 					      "data-lanes", sizeof(u32));
+	of_node_put(endpoint);
 	if (len < 0 || len > 4 || len == 3) {
 		dev_err(dev, "invalid data lane size: %d\n", len);
 		return -EINVAL;


