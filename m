Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F7815ADB4;
	Fri,  9 Jan 2026 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962838; cv=none; b=TNPSY/0Dg1TXGqXKcysYFjD7WETGELob4gBGaV39TvpPJ6DMiTDWwSvqXRf2xZdXpDagVQti7001ZJvDJenO3+PgkjFPpweNt3XZYhUvlsuF1lkm/UeLi1Xix27jhIWC50ypnLnYDHdc5gHa+wJoAv16xjBP8Pq9eBhuBifeA94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962838; c=relaxed/simple;
	bh=s1iH1IYmoz0/dzpwP4mxZjQu9XZKTQhUu7UsqZpoxxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ4aNdW/yPadg+PPHDo7viE/U24AhVMOckPsgYck2CqhgXLNXF23X4IfRZ8BecrpiDlgjyXl5zJTL7BJlIriVJPw4cXfEHu1iYZiP2mIPryO1FQ0RRfO2NQQGDIWJhXP0XbvgApOHfChaF7VOGDgJhwcvlwe6CxqcBlrxgz/GqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sB9ABxi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sB9ABxi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EEEC4CEF1;
	Fri,  9 Jan 2026 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962838;
	bh=s1iH1IYmoz0/dzpwP4mxZjQu9XZKTQhUu7UsqZpoxxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sB9ABxi42bEJvyznY/xbAXpi7hO9+inwb49NgGVQKlTqtfjfwaIw3ZzycbLrWdFgh
	 A+qv1Q1W5Qis9Emn80D0SHZuiGQnQtJkwEpESCgG24fvjO1g5s1t5vdk2xsKQyOCD4
	 hhJYdJPwJ81dTOu/pooc4lUMg96Wj8zEe9oHkDcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.1 506/634] drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()
Date: Fri,  9 Jan 2026 12:43:04 +0100
Message-ID: <20260109112136.592343846@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1919,6 +1919,7 @@ static int mtk_dp_dt_parse(struct mtk_dp
 	endpoint = of_graph_get_endpoint_by_regs(pdev->dev.of_node, 1, -1);
 	len = of_property_count_elems_of_size(endpoint,
 					      "data-lanes", sizeof(u32));
+	of_node_put(endpoint);
 	if (len < 0 || len > 4 || len == 3) {
 		dev_err(dev, "invalid data lane size: %d\n", len);
 		return -EINVAL;


