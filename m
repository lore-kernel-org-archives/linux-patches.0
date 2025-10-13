Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590B30C606;
	Mon, 13 Oct 2025 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368105; cv=none; b=EjoRJLJwJCrdATaF6MmE1cqW61cxeR4Rz4nsgN99xvjdrjucmPjnnmUQbWWXYIMGvarYgaeuxHAHCj22zBcupNdCCbKfGNyoKch/iURS/4IxyP8YZ+VseNYC1ytlD1/zjaSYmu3XLUBjfQfNER01rAF33n7nbz8iq7pmuGhYLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368105; c=relaxed/simple;
	bh=BxNMKKsVKCO6dvlKcYX5VafShUCxLWHthB1ff/uf5NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXpU9rRky6GmZRm20+W7SyiUZbO3BK+kfc1m6vDO7vml0jlmSOIhFVmNppGjcCYIi78zqsCHkbGo74OeyxFvFl357Eb0Ktt0dtTICKbXrnZfFIKQTDYZd/aRLwxX/e83NS7KbT8IqBBIH5PwP69PSpuGLwdSja3h5DP9ZdhnLiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdnODYF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdnODYF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FCEC4CEE7;
	Mon, 13 Oct 2025 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368104;
	bh=BxNMKKsVKCO6dvlKcYX5VafShUCxLWHthB1ff/uf5NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdnODYF2BIe/WFOGbkYiAtwrB6IkpcYRQe2w208YZG/7WT0phztBuyMgcqW7XZ2Su
	 FcNvDOuc0vp9XvOnUBoe48HEbyW2jkf2DzhFgwLZF0uW4ynAaM3YH0NdMLU5VgA13r
	 2eVW6hu5Y2oRJ85LvBkEia31XiWKJsjmeemyxZr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/262] PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()
Date: Mon, 13 Oct 2025 16:43:08 +0200
Message-ID: <20251013144327.789202710@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit fc33bf0e097c6834646b98a7b3da0ae5b617f0f9 ]

The drv->sram_reg pointer could be set to ERR_PTR(-EPROBE_DEFER) which
would lead to a error pointer dereference.  Use IS_ERR_OR_NULL() to check
that the pointer is valid.

Fixes: e09bd5757b52 ("PM / devfreq: mtk-cci: Handle sram regulator probe deferral")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://patchwork.kernel.org/project/linux-pm/patch/aJTNHz8kk8s6Q2os@stanley.mountain/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/mtk-cci-devfreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/mtk-cci-devfreq.c b/drivers/devfreq/mtk-cci-devfreq.c
index 7ad5225b0381d..6e608d92f7e66 100644
--- a/drivers/devfreq/mtk-cci-devfreq.c
+++ b/drivers/devfreq/mtk-cci-devfreq.c
@@ -386,7 +386,8 @@ static int mtk_ccifreq_probe(struct platform_device *pdev)
 out_free_resources:
 	if (regulator_is_enabled(drv->proc_reg))
 		regulator_disable(drv->proc_reg);
-	if (drv->sram_reg && regulator_is_enabled(drv->sram_reg))
+	if (!IS_ERR_OR_NULL(drv->sram_reg) &&
+	    regulator_is_enabled(drv->sram_reg))
 		regulator_disable(drv->sram_reg);
 
 	return ret;
-- 
2.51.0



