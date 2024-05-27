Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D526ACA;
	Mon, 27 May 2024 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836727; cv=none; b=A01C8h0udZVE4wX55dx3tXS+t1YkUrf26k4jJjrbGGjHwVbHb/pypGaZwePFFch27wfUQSBTWuk8sWEBEqQLBZnZF1v5pYTrBCIMhFg3w3diizl6y4JtGPlkr/1bEssioGRanejh9spU85VGgj6UmzcxOeNpMZDJv14NXZoNDZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836727; c=relaxed/simple;
	bh=mWn/0csLZxSczEiwq/7XD47Prv4jGIRQJR4g3zuSpy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NN5RhkttFv6Gzp/tpREh9WHZw9z+7N4YP73onxzJwsCvuTDRUVmPZD7ZJtrKTvjyWHGj90tAggC9x3H/smobJo4Vcl9fl9+GuwulWv2MJIg37nvVzrXKt1aG8+fb06PgAHd7RDIvALvJiZCAJdZ3FRE2/3CDIrfh+MzzRGBIYXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXbhtcn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXbhtcn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF208C2BBFC;
	Mon, 27 May 2024 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836727;
	bh=mWn/0csLZxSczEiwq/7XD47Prv4jGIRQJR4g3zuSpy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXbhtcn80GdvHzRr6UX362VVI3vDiNosJq33c3xzNyXXwXstp6FPTtj7Acp6KFXUr
	 unN6XdlmLiOEQbNszBvd279+4pu1prhFxYbpUsXZYmtz0BbAEAS8yd2cVDd4OqVC2w
	 URGUSh1/cAI8SgePdLPOgaO8h7zjD9CSn9+7z4UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 164/427] thermal/drivers/tsens: Fix null pointer dereference
Date: Mon, 27 May 2024 20:53:31 +0200
Message-ID: <20240527185617.688222868@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit d998ddc86a27c92140b9f7984ff41e3d1d07a48f ]

compute_intercept_slope() is called from calibrate_8960() (in tsens-8960.c)
as compute_intercept_slope(priv, p1, NULL, ONE_PT_CALIB) which lead to null
pointer dereference (if DEBUG or DYNAMIC_DEBUG set).
Fix this bug by adding null pointer check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: dfc1193d4dbd ("thermal/drivers/tsens: Replace custom 8960 apis with generic apis")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20240411114021.12203-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 6d7c16ccb44dc..4edee8d929a75 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -264,7 +264,7 @@ void compute_intercept_slope(struct tsens_priv *priv, u32 *p1,
 	for (i = 0; i < priv->num_sensors; i++) {
 		dev_dbg(priv->dev,
 			"%s: sensor%d - data_point1:%#x data_point2:%#x\n",
-			__func__, i, p1[i], p2[i]);
+			__func__, i, p1[i], p2 ? p2[i] : 0);
 
 		if (!priv->sensor[i].slope)
 			priv->sensor[i].slope = SLOPE_DEFAULT;
-- 
2.43.0



