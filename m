Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1080D1946C7;
	Wed,  5 Mar 2025 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197079; cv=none; b=CSQ/THAslHPMS1vH1IlfM7aRnNOLPjxeYxIx+vt5dgfO63aWWNhlPVXtwXc2W0yk52UYiEZI9p0hPSuhbXiPpNUk7/s5XazscHT7FkGWbK0epzRMy2qTx/eHO4eBVzSJAHromEFy/+uSnHI4sFzaCBF4ncsZM1OUGTcQ/lfckcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197079; c=relaxed/simple;
	bh=aJNFtZfNbLLFl/UWidywGSeo/5fTJX9kgnpdbByWE3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+IcE24ZKyJCGCyVw3MpznIYH0D4urM+Ns8NyQ2gbgRrITxcWTGx7qxiDfcnyHX27T0axTZk3Ccx1BztRA+kPsi0tBbkhe0osrLkC8T5qhlq0fBaPUwC3cWKKjnf31VLJW+ovDYxORf46M4vaJxnBgTrk37hT2KniFW+NqFsLYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tB9JXmlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tB9JXmlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B8CC4CED1;
	Wed,  5 Mar 2025 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197077;
	bh=aJNFtZfNbLLFl/UWidywGSeo/5fTJX9kgnpdbByWE3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tB9JXmlmGAZlGn6EZHbVH4u2yg7VSbmvXVBg/4wQN8D5TJC0U2d5oKhxYsCh/ddUY
	 L5yO0+3NZgKq5ZebvqkrHG35SlTo5a95MvpmYOi0PJfdjd7TGbdzwJTCQFLwy0Z6LH
	 Y+uLGu25UZrpvIaUpPz5dViJJ12SN8nK1TTL2WGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/176] soc: mediatek: mtk-devapc: Switch to devm_clk_get_enabled()
Date: Wed,  5 Mar 2025 18:46:39 +0100
Message-ID: <20250305174506.672167194@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 916120df5aa926d65f4666c075ed8d4955ef7bab ]

This driver does exactly devm_clk_get() and clk_prepare_enable() right
after, which is exactly what devm_clk_get_enabled() does: clean that
up by switching to the latter.

This commit brings no functional changes.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221006110935.59695-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Stable-dep-of: c0eb059a4575 ("soc: mediatek: mtk-devapc: Fix leaking IO map on error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-devapc.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-devapc.c b/drivers/soc/mediatek/mtk-devapc.c
index fc13334db1b11..bad139cb117ea 100644
--- a/drivers/soc/mediatek/mtk-devapc.c
+++ b/drivers/soc/mediatek/mtk-devapc.c
@@ -276,19 +276,14 @@ static int mtk_devapc_probe(struct platform_device *pdev)
 	if (!devapc_irq)
 		return -EINVAL;
 
-	ctx->infra_clk = devm_clk_get(&pdev->dev, "devapc-infra-clock");
+	ctx->infra_clk = devm_clk_get_enabled(&pdev->dev, "devapc-infra-clock");
 	if (IS_ERR(ctx->infra_clk))
 		return -EINVAL;
 
-	if (clk_prepare_enable(ctx->infra_clk))
-		return -EINVAL;
-
 	ret = devm_request_irq(&pdev->dev, devapc_irq, devapc_violation_irq,
 			       IRQF_TRIGGER_NONE, "devapc", ctx);
-	if (ret) {
-		clk_disable_unprepare(ctx->infra_clk);
+	if (ret)
 		return ret;
-	}
 
 	platform_set_drvdata(pdev, ctx);
 
@@ -303,8 +298,6 @@ static int mtk_devapc_remove(struct platform_device *pdev)
 
 	stop_devapc(ctx);
 
-	clk_disable_unprepare(ctx->infra_clk);
-
 	return 0;
 }
 
-- 
2.39.5



