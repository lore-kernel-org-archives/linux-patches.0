Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77C4F405C;
	Wed, 30 Sep 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782656; cv=none; b=RBJgodhD77zNyqGzeJGyKhJtt1BzVqv+SBus6nUoXzS8zqAaBsiDUM57k3a3zuwCQoLvH86pkz5HVkcL5sqTGqGD7PdhDv1dKHOexGIrs80pAqU4bnnLPTWYGOu/1CIxrs5vXUCmCcEkyGfOzo6xFHqNyxeQr88TeRgZ1AmVqSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782656; c=relaxed/simple;
	bh=7m1UFexHnY6mF6G5aBmvcK7KyEYUHmZdwVp84NUCnsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH+ohghlWrzxq6rWwiwiS3GSbcFCLtlHaMzdid60TNHSz9yxnLeFtkgpwmQ679IoyGBI6TQ8DzWa6fRIehO5xcyoCc5yFZhXJJUT7hcMwd7tHdSbms9D9har03i40yr5vKkIMVQWN3bcOANHLz9FbL8k4t65+JgVQUkB50id3Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPo3elUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPo3elUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4B41F00898;
	Wed, 30 Sep 2026 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782649;
	bh=beRRrTzWpaVKELwq1twSvyHVHvB+K8iCLpUANLE8vMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPo3elUeXl1xWKeOIS+Xymh/GzNTi+jih7QeBL/xM7PUTMcSkqnQRHwsPciaAaBaH
	 flVNIK5BDxkF+Dd8WOBLCEceLRpRvmyeZitgvEbjjWHF2Q4FWxkcvcLoolJbTPo/68
	 6CzGE+FJBrHtT3YxqIsRgBm9xKU1KN5FgKusS/lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/595] ASoC: rockchip: rockchip_pdm: Reorder clock enable sequence
Date: Wed, 30 Sep 2026 17:20:15 +0200
Message-ID: <20260930152350.364318777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3168721d6ec3b610edf6a3c22ad190722a27d276 ]

Enable the 'hclk' bus clock before the 'clk' controller clock during
runtime resume.
The bus clock provides the register access interface, so enable it before
the controller clock. This also makes the resume sequence the reverse of
the suspend sequence, which keeps the clock ordering consistent.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 5d7a12ca4c819..736d211479741 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -364,16 +364,16 @@ static int rockchip_pdm_runtime_resume(struct device *dev)
 	struct rk_pdm_dev *pdm = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(pdm->clk);
+	ret = clk_prepare_enable(pdm->hclk);
 	if (ret) {
-		dev_err(pdm->dev, "clock enable failed %d\n", ret);
+		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
 		return ret;
 	}
 
-	ret = clk_prepare_enable(pdm->hclk);
+	ret = clk_prepare_enable(pdm->clk);
 	if (ret) {
-		clk_disable_unprepare(pdm->clk);
-		dev_err(pdm->dev, "hclock enable failed %d\n", ret);
+		clk_disable_unprepare(pdm->hclk);
+		dev_err(pdm->dev, "clock enable failed %d\n", ret);
 		return ret;
 	}
 
-- 
2.53.0



