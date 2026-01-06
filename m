Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4DE21A92F;
	Tue,  6 Jan 2026 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721199; cv=none; b=EgPG8snvjrGE+JYyfJbwgLHKyvxJN5V98ery3ajh9z9Jx8cZJGlm3q5HbKYyXH4DX3Idzg/lXEPvkghaIjkgmDOmlKOmH6JN5hVA8DMvbpLeuQUjqZzL2Y6uRcpg3HszIxXnjW/g/f/B2CFJzo+d8qcKRpKhoydkBcwW9bMBoQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721199; c=relaxed/simple;
	bh=NDiFgdGxDqq4oGopDEqPZ685eOGHa4IhLmrFgRSEg7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TR/jbP6GiKzB13vCvfURYUZPpmhWTtUfuFn3DwS6wK92b1OdlTg+P2fwL1xNp3iUPMb1Q6rr08ZbNlA7bUW76qS7Fj+reHBD+8M0/ChoEdEth5kW4c/iFfsC0VLd0xsDsjLa/ZnqP0qJvFnLwiicNedO7EC5bbye/RvzWbXrvnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBHsDzOr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBHsDzOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B306C116C6;
	Tue,  6 Jan 2026 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721198;
	bh=NDiFgdGxDqq4oGopDEqPZ685eOGHa4IhLmrFgRSEg7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBHsDzOrdrSBHdfFnWem+WXAI9M817IlbAUYeIMUHnjmkBbDJpdBnk8NLxfrUUKUW
	 qkYAi9Pbrd8fgrwpc/0JnmQ3Mp3M5dm87zeRqANRhYXtutPl+8VH1OIQbtd9GorKl5
	 HvExMgytbUtcyFKTPdQ/8SVWP1x60rSETST2P/wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 466/567] drm/mediatek: Fix device node reference leak in mtk_dp_dt_parse()
Date: Tue,  6 Jan 2026 18:04:08 +0100
Message-ID: <20260106170508.588683985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2067,6 +2067,7 @@ static int mtk_dp_dt_parse(struct mtk_dp
 	endpoint = of_graph_get_endpoint_by_regs(pdev->dev.of_node, 1, -1);
 	len = of_property_count_elems_of_size(endpoint,
 					      "data-lanes", sizeof(u32));
+	of_node_put(endpoint);
 	if (len < 0 || len > 4 || len == 3) {
 		dev_err(dev, "invalid data lane size: %d\n", len);
 		return -EINVAL;


