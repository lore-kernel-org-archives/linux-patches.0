Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF7A12CDB7;
	Tue, 23 Jan 2024 00:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971480; cv=none; b=iVP3WFUXEeE2fW364ka/OnjstvRbyvUFRThG498ryelMWNYgdNR8jaPy7BiroQkmEPUnNdsTR2ygBl6LvEs2bLjbPe+cK5dl6Jv0XuRSLmt2No+myBSnpMTecTABaBU4m77iPO2hp4Mkrr0bH57b5fhjEeJ+ARzjztBEx5pbmBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971480; c=relaxed/simple;
	bh=OKdIKxi9zOge00vowgo/2fJ+zkijyWqjPlycb9f5oOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGbac9bHvIbviqtkqMy7nkTnoEInQT9+vPho1LtTHq+LhOJNozFDAC6aPbZx47h+vESfOvGS1GuFmDSxWVbjygUX/W63sUuIwQ2+VK7tmQ8rF0k7i2meSFkVyuQwngQ4rQ1KLtym+2TlxKPF3R6hdIHQIz63GKdyCswJT5k+3ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+5qV1XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+5qV1XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D95C433C7;
	Tue, 23 Jan 2024 00:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971480;
	bh=OKdIKxi9zOge00vowgo/2fJ+zkijyWqjPlycb9f5oOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+5qV1XDqHvDcuGwwGV2V3DXTt6mzVdmzgDKrGq77ik8+RXMS+rTaOMvq2m78iTD6
	 SRzqFJTbaoO+imJ50wo1tAMUoLT0+NDW17WTuwSBuUmmmXxygz9rTx5591ngdQVeTF
	 wSQRo0k6eCZazuFr6iLNhhzFURMfk1K4klQ2Tq3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/286] drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks
Date: Mon, 22 Jan 2024 15:57:44 -0800
Message-ID: <20240122235738.256550497@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 3d07a411b4faaf2b498760ccf12888f8de529de0 ]

This helper has been introduced to avoid programmer errors (missing
_put calls leading to dangling refcnt) when using pm_runtime_get, use it.

While at it, start checking the return value.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Fixes: 5c8290284402 ("drm/msm/dsi: Split PHY drivers to separate files")
Patchwork: https://patchwork.freedesktop.org/patch/543350/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-1-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index 2e0be85ec394..10eacfd95fb1 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -558,7 +558,9 @@ static int dsi_phy_enable_resource(struct msm_dsi_phy *phy)
 	struct device *dev = &phy->pdev->dev;
 	int ret;
 
-	pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(phy->ahb_clk);
 	if (ret) {
-- 
2.43.0



