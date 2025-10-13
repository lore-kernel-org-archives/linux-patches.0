Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A75211290;
	Mon, 13 Oct 2025 14:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367598; cv=none; b=BPQi/vw0bc0swGyWQUVA2bvuMVA9wyNVeIyu2N2Kcw6xIht99wkOAdLapbcpfD+z72kzZzsnwzj5qJHWv5/AklvuvXdkpV/qe/yy7koTTuB7S5aWiZrhbKfMdjUmi5pbLB5WGHotjzr2gy8TM3cZP7zdTs4f/cjuUFiCzcmLgzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367598; c=relaxed/simple;
	bh=XDJlq+1PdtEwx7PXARcY3v+BoT34t66t/JNhmhB4uqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1NxyQgXUwRusIti6KP+TW+3NzAAb0ad7bnhrJ+ACGabGzGwVADIyiUiyhHbNFQb7AQSjYn5CW26NnxK/ovwZMYruo9CsRKNegYwr+W6LdcZzrDtMjqfz5k83UGw7/LUAIQOctGUQg9i6wvYynqIc5H/xENaJtQ2fi/jw3Rvk/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txZxXBHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txZxXBHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810E2C4CEE7;
	Mon, 13 Oct 2025 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367597;
	bh=XDJlq+1PdtEwx7PXARcY3v+BoT34t66t/JNhmhB4uqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txZxXBHnsceVOxnDW6rPsQ3tvE4zvnjF2D/aBW2+B1dDWmvMTXzhUbYmW1WTpZEuD
	 B2o8c0HmDA3MOKWnaC8v1HTBMlFy1SeW4WaHI/S2oPNloy9ptDV0QdBISWeKXhSVgX
	 //SLU7/2BM+ihoH8/P/wUA0WYHK+TW2ZO2/fJCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/196] PM / devfreq: mtk-cci: Fix potential error pointer dereference in probe()
Date: Mon, 13 Oct 2025 16:43:45 +0200
Message-ID: <20251013144316.438780956@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 83a73f0ccd803..eff9b2c06aef4 100644
--- a/drivers/devfreq/mtk-cci-devfreq.c
+++ b/drivers/devfreq/mtk-cci-devfreq.c
@@ -385,7 +385,8 @@ static int mtk_ccifreq_probe(struct platform_device *pdev)
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



