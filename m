Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764733F7867;
	Tue, 31 Mar 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976158; cv=none; b=RCESposwUTeCS76sE9zurnc/qRjfsctBMBLTizDB1Q+2q8K8oksmVrQ0u0rlZ6WXvrQqkGiAZ53tnuhVfY3h9EnjzkBOnjk9pmgQwYvGUcA1nO6vBG0LAzQ5/uFxfaxMcqisLKHco/JL5pTegQtZ2hoEzyU/RncgD9goXZJz9lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976158; c=relaxed/simple;
	bh=dltlIVAfslAH4soztbZI1k9d8IVhrlkZtLpvxZytWjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUSJyj+y85dGfa1U5NezFi3rhRK7+jUi+/HW8xEfgrjLqVojXI+BqCwzx+kMRaqHmsfrF7/AeI4rQ9EKmszsMCoxdYzRz9FSNLrx8cTjDpE1+CpHtzFzT+lJFcwqjckH0MJCvNpQ5FblGkggOoHadTzqYfo+TgZk5++eGXfzja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLbIlmoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLbIlmoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D08C19423;
	Tue, 31 Mar 2026 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976158;
	bh=dltlIVAfslAH4soztbZI1k9d8IVhrlkZtLpvxZytWjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLbIlmoyoz9oLInWNhAUZBLvxkd5kUfyp8uJzcXOi5Gmpw3iMrk6iKejNFSmVkGNu
	 xAlYwEwiH7M/1UXeqFPl/RTFqYbacSx8y5bJk9FQh0r8cxtpmZCP4kvRtusd0mwri+
	 SUlvVJobNn6lBw1E8GO2UzGaKuMD1WmPq5NBYtb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/244] dmaengine: xilinx: xdma: Fix regmap init error handling
Date: Tue, 31 Mar 2026 18:22:59 +0200
Message-ID: <20260331161750.222897810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e0adbf74e2a0455a6bc9628726ba87bcd0b42bf8 ]

devm_regmap_init_mmio returns an ERR_PTR() upon error, not NULL.
Fix the error check and also fix the error message. Use the error code
from ERR_PTR() instead of the wrong value in ret.

Fixes: 17ce252266c7 ("dmaengine: xilinx: xdma: Add xilinx xdma driver")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251014061309.283468-1-alexander.stein@ew.tq-group.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index 2726c7154fcef..6781c6754e65a 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -1240,8 +1240,8 @@ static int xdma_probe(struct platform_device *pdev)
 
 	xdev->rmap = devm_regmap_init_mmio(&pdev->dev, reg_base,
 					   &xdma_regmap_config);
-	if (!xdev->rmap) {
-		xdma_err(xdev, "config regmap failed: %d", ret);
+	if (IS_ERR(xdev->rmap)) {
+		xdma_err(xdev, "config regmap failed: %pe", xdev->rmap);
 		goto failed;
 	}
 	INIT_LIST_HEAD(&xdev->dma_dev.channels);
-- 
2.53.0



