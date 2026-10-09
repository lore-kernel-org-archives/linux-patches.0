Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DD03BD64D;
	Fri,  9 Oct 2026 14:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556361; cv=none; b=lKPtpGn111hYpB6psbjxnLqHQxDYe+RPFx+Ok+7/YXxNA1TXSqcNiNwUeXK2oMSx+aqiA6Ol79QVahWJRwiu0F+NuhqVftkDiSZt7z81lLIBdXAJLTplA/xcXCuHbbClqo6oCdvH9NcO59DRAXzyqjaAvQydhzvxOffxVDkTISI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556361; c=relaxed/simple;
	bh=5FP49hCxrXe6MYGfXAFMOaDcItNPsNIfExQOklSIlX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dle4/Pm6t5nrC+QzWJrlxwIr4O89XNSzaYjpiI1AkSzP0F/XvkqqZWITdGpShNKYdOP9tIQYKXPx6f048BmoJJf5qW0VuvKfw0LSsW5a1l5kAfjq/swQB96bE/bhnpUoyzL90rntn1SrXMZi0MqXUuoQiidFAk+kutPqnCxuXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpRijLAR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpRijLAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975141F000FF;
	Fri,  9 Oct 2026 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556360;
	bh=H2qNGoXhZc7icqyfYxYeXGaZK5EQYby74tWRwk4PLn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpRijLARn/c3TOzoX8Lk7O87529TDsLPi9c7QOQ5qyzLa3MWY6NRRBF1d+Lf+tESH
	 ZLcER2g/Q+Z6mKiOO1FWoRXhsUUY+E6JGy9vy3o0RWD18rFk1+GqMgPZkkGP0HsiNj
	 +0CRApLXfPwAPaVDgP7/X86XANOuagTuD0NEfRpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 164/428] drm/mediatek: Fix runtime PM leak in mtk_hdmi_ddc_v2_probe()
Date: Fri,  9 Oct 2026 16:08:21 +0200
Message-ID: <20261009140949.760359297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 2af45da333bdd7be2666688a0f861e0750e40e49 ]

pm_runtime_get_sync() unconditionally bumps the usage counter, but
nothing puts it back when devm_i2c_add_adapter() fails, leaving the DDC
runtime-resumed after a failed probe. Drop the reference on that error
path.

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260916174229.2088824-1-vulab@iscas.ac.cn/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
index 31e81a6de6d85..1ec973d3f52c5 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_ddc_v2.c
@@ -376,8 +376,10 @@ static int mtk_hdmi_ddc_v2_probe(struct platform_device *pdev)
 	pm_runtime_get_sync(dev);
 
 	ret = devm_i2c_add_adapter(dev, &ddc->adap);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
 		return dev_err_probe(dev, ret, "Cannot add DDC I2C adapter\n");
+	}
 
 	platform_set_drvdata(pdev, ddc);
 	return 0;
-- 
2.53.0



