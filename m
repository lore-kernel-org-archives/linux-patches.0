Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F419E7F7;
	Sat, 12 Sep 2026 08:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201170; cv=none; b=ntQTyKeNKmMbaykomDkAXJNegGKjlNvAEgaIJVTNb6Bl0qXV7Jptz7u/yF5tYRLjMdXKtPqTqsHPsVjQBUYB4uyiycnqe8rZojwfhTTdx0GxYRsA5mIcjm6rL0Qi6QzVQQRllHhAyLbzu1pi/Tdf4DSKriu5HOId1NzP7mQhuac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201170; c=relaxed/simple;
	bh=0sKD0i1X4nWl4DGsj7lYaZ+WiuaEzXKKeh+VHpOsxVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmxjkxW2xXEyIJcNQCcbxZ3BXcPQ2Tm4K/t3UBU29vBvwt88Im40osS+/HNltixmgtBHJ+aExQYfUrOs2wnMAtD+iSRxpB6hF5XOugchkGsB/8cr0l/11j8SKutyErh0cS45OatBU0kCoaVX40qYG8vT6R23gLKAtoDndAxrdJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCqV5PNk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCqV5PNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291501F000FF;
	Sat, 12 Sep 2026 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201169;
	bh=+QSAYEEAxpKnPsI10TWI7w4HisKuDr5Jwmckj5VYJRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCqV5PNkPNDXMAAs8lU59D9fLE+uPaBfNGS/Z30VQYXRYzWJ/VB6wWkJMeYoaw08y
	 bb1xeroJuWQpjiJIc8nmBknuyjhOvKa54pa8yJjk3F1XkYmbZDiinDqrrDCTSUr7fL
	 nym0BNdTeFsvIbbiZ04lf4OJjYtdoL0O21ZRQQIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0914/1815] drm/msm/dsi: Drop dev_pm_opp_set_rate(0)
Date: Sat, 12 Sep 2026 08:44:24 +0200
Message-ID: <20260912065710.378329316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 06b7ba206561619bb34116f49e0ef26b867ce3aa ]

dev_pm_opp_set_rate(0) removes the vote specified in required-opps but
does not actually park the clock, making it run without the necessary
power backing. Drop the explicit call to it.

Every call site of ops->link_clk_disable() is followed by
pm_runtime_put(), so the power vote will be rescinded if deemed safe.

Fixes: 32d3e0feccfe ("drm/msm: dsi: Use OPP API to set clk/perf state")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742783/
Link: https://lore.kernel.org/r/20260728-topic-dpu_power-v1-3-e7783b859a70@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 5e1b313f04c0d..2685cc3d03590 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -549,8 +549,6 @@ int dsi_link_clk_enable_v2(struct msm_dsi_host *msm_host)
 
 void dsi_link_clk_disable_6g(struct msm_dsi_host *msm_host)
 {
-	/* Drop the performance state vote */
-	dev_pm_opp_set_rate(&msm_host->pdev->dev, 0);
 	clk_disable_unprepare(msm_host->esc_clk);
 	clk_disable_unprepare(msm_host->pixel_clk);
 	clk_disable_unprepare(msm_host->byte_intf_clk);
-- 
2.53.0



