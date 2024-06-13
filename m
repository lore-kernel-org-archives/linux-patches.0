Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3DC1420C6;
	Thu, 13 Jun 2024 12:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281918; cv=none; b=TQda/NRmyMf8z1fn3Xk5nF27+JbFTFfmGM2DlTZVRMVf2wXwHaeBjAMyd+WloVJsC/f67HHGuXMS1UfMe/Tab0BtpYgy4lrlp57itYEijXW0xTqk/RJy7Vo668/VH+HEmg3kIn1xUw62gpXcaXJzPdkvz5VqXIb0tJ55XSxj3TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281918; c=relaxed/simple;
	bh=Jd4GKJ6riX+nVRgCyLLeuOgcqJsIyhS0VKcEhxDGCB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atZ43RuNFxDxOBI7Te8DCTQsqIN5GEkjo7ETt9sqBrjjB1+aW84chQd2h/AJe75TWsYj2ozAezH2NbfgG4/IOQMb5n1SCr953Cm46W4IShfI5DH6ZpEd40nnJNGxXFjNKnUcKfu2Y6yJZR7v/Plk9l/aVrIu3OKM7FAj3gHrjps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFrclsqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFrclsqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1399EC4AF1C;
	Thu, 13 Jun 2024 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281918;
	bh=Jd4GKJ6riX+nVRgCyLLeuOgcqJsIyhS0VKcEhxDGCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFrclsqjLhf9oN+vStFH2lfk5RKJOADjB7BLfnjpvKY+8eRh2L1oMDdwtRzrxV0x/
	 aRZVpKUkBW5P/FRTReEeifGDjlVkB8L7m/ZXssqjP8xr8xHmP3myDprumHBw6dbSmY
	 Yeyhx9jdscmoJFSSzH0QOu6HrDcsYblRvfNxqs3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/402] thermal/drivers/tsens: Fix null pointer dereference
Date: Thu, 13 Jun 2024 13:30:40 +0200
Message-ID: <20240613113305.374649231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 926cd8b41132c..2f31129cd5471 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -84,7 +84,7 @@ void compute_intercept_slope(struct tsens_priv *priv, u32 *p1,
 	for (i = 0; i < priv->num_sensors; i++) {
 		dev_dbg(priv->dev,
 			"%s: sensor%d - data_point1:%#x data_point2:%#x\n",
-			__func__, i, p1[i], p2[i]);
+			__func__, i, p1[i], p2 ? p2[i] : 0);
 
 		if (!priv->sensor[i].slope)
 			priv->sensor[i].slope = SLOPE_DEFAULT;
-- 
2.43.0



