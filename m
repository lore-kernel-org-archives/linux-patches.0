Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101CA67E81;
	Tue, 23 Jan 2024 02:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975312; cv=none; b=fqgsObm6Ircp7+mrallMaU/KsTSUymJx4sCdz9gvt5E/jHO68h7nTpjJLGlL8ea7b6LQG/R1KwkFST2qVthVvbv7zAPjo5Xl0t+BerZ53eBFGSH+Y2hnvAQVWEy2BcYuSoAk89Kyw9eGSso41H8eiCc5TTvtfpfexJGaztJr2CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975312; c=relaxed/simple;
	bh=XPUnAAdf43QAQGFY9axF80L3AOnp8MgtGtqd6SORMLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDb/NBjOi0PwuByh6llKmFJBf+1vZ2tP3etkQ4nHjOjhg91hm2Po4N+DeL5FFzdbsruvABenMXjzrYo4QBI7COXXFr7sLEPzxy8FWHToUvaz7c9WfSZqTEnrRAtrCtcpGKCX13r0/sgO6/Fc9v2IT+cGWh4omAKYHIW3KrrThQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5uQbKHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5uQbKHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84EFC43394;
	Tue, 23 Jan 2024 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975311;
	bh=XPUnAAdf43QAQGFY9axF80L3AOnp8MgtGtqd6SORMLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5uQbKHPFx0LcXoudgqOh232HmmtENS50Zu3lIQXzLrq9JfWoEuLkLTd3prWMyrSM
	 kEaqWbkym/hkyPynd8tYCC4laHykJnV2ubn7A4edaloVHWwi5FNNkIMiWnf+AJxqjL
	 Uk7Q0Hs3Xx1B1xqZrn6UoV+7j2ebtg2m4aZlNnJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/583] drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks
Date: Mon, 22 Jan 2024 15:55:03 -0800
Message-ID: <20240122235819.715980814@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 05621e5e7d63..b6314bb66d2f 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -516,7 +516,9 @@ static int dsi_phy_enable_resource(struct msm_dsi_phy *phy)
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



