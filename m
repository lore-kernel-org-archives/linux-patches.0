Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326023563EC;
	Tue,  6 Jan 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722582; cv=none; b=ZpQcMKeAvW1MHuVS7C1Ew+m/We55ryOzr9hPgeE0HQ2omWKBFBQB0An8h0jQM2cxiJRf0rQA3aEdgx06abdEvq5HJVJBUQRVt4qdcST9s/9ggwtAsOh1t3HR1piTz1YXp2ehgKyp7ocCjtefRhK/70bCZ/k9NafSkxWeSvtTOw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722582; c=relaxed/simple;
	bh=xz2avXP8R1cTmR4S6N0UJkMZGV1y5OiFiKS9WFZAQt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMkevyHevPrB2MXA2qA1PGnjQOVcrQvwelOqMCCDIbH+mHyW3DhwiraqagJD04zVWpxbV03kGQJoiA7MDUTiLDqU5oW1a0nDAj8itufIp0IbmyAXWgNcnsOZhtKRvNe46cKmjgkW3c7mHGW3q6oxCi8KLkys2pwRZ/Yb2CmDOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjED+XcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjED+XcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0D2C116C6;
	Tue,  6 Jan 2026 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722582;
	bh=xz2avXP8R1cTmR4S6N0UJkMZGV1y5OiFiKS9WFZAQt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjED+XcHPbCG7rz4s5xtg64bpiyJhpAqxVXuXPXj1gsyDNnnXv18Brl0YMLgqK0wi
	 0f2Wc1J3N1bsFTCSfA1V8cJXnXKjH/ry7xCbZC3YPm71XbEIGCHqJoMbu/H3o5nVmr
	 iayym6uF1AEnulpJj1p2o+IZVq3OX61yS3suMilY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.18 274/312] drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()
Date: Tue,  6 Jan 2026 18:05:48 +0100
Message-ID: <20260106170557.760747499@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2087,6 +2087,7 @@ static int mtk_dp_dt_parse(struct mtk_dp
 	endpoint = of_graph_get_endpoint_by_regs(pdev->dev.of_node, 1, -1);
 	len = of_property_count_elems_of_size(endpoint,
 					      "data-lanes", sizeof(u32));
+	of_node_put(endpoint);
 	if (len < 0 || len > 4 || len == 3) {
 		dev_err(dev, "invalid data lane size: %d\n", len);
 		return -EINVAL;


