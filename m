Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61443199EA4;
	Thu,  6 Jun 2024 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683255; cv=none; b=kHGFfkjS5BIB4cjPpO0diNLQ6qccGQW86JnrnLf7f25I+ZfJg2+eK+bxRjZWt9lFxFF2USCF41pjnrXvrJbVtlye33b2ZE8TAw6gAPWhzZ5coz4zuDYMEVjmIo2RswPjkchpcjBhcZuCo2fJ8TuqBqn/6lykuYrSmeWhB5PSaYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683255; c=relaxed/simple;
	bh=VidrXSh72vobvQ6X2rdq+NRMQwGb72UiJTFZtwQIqXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVLoeX2DuE74S5gw3qSLwMwFf9ofjEgwZOPtCcC4qhRoRApyijfFv86wjnrm0QG1xivrGtFgNxIqMtxidkP3mimN0Vh1fwgW/htY0bKLrcNXd1ZL/jm8aqm4nT0/lCNSp3JhweZg3cFncsUSgAe2C8CBDpmLlg6I7EDafwmlYwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+P3nkY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+P3nkY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4181BC2BD10;
	Thu,  6 Jun 2024 14:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683255;
	bh=VidrXSh72vobvQ6X2rdq+NRMQwGb72UiJTFZtwQIqXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+P3nkY5Gh7quNnufZEHjmr5SvAXrpDBnZQtv4AvnZkZinOnHRF/BZS/zxv+mmzNk
	 pVGxsfEhF+rrLYvZZIzYdyfWvOt9vVGvECXlnjldcuJxNQbX02YOMlZv6yDZnNpkfn
	 +kw8NTGoT4AN3P68vctO746ipgqvQb7VVHyojvps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/473] thermal/drivers/tsens: Fix null pointer dereference
Date: Thu,  6 Jun 2024 16:01:00 +0200
Message-ID: <20240606131704.257945586@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 252c5ffdd1b66..fc58db60852a0 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -85,7 +85,7 @@ void compute_intercept_slope(struct tsens_priv *priv, u32 *p1,
 	for (i = 0; i < priv->num_sensors; i++) {
 		dev_dbg(priv->dev,
 			"%s: sensor%d - data_point1:%#x data_point2:%#x\n",
-			__func__, i, p1[i], p2[i]);
+			__func__, i, p1[i], p2 ? p2[i] : 0);
 
 		if (!priv->sensor[i].slope)
 			priv->sensor[i].slope = SLOPE_DEFAULT;
-- 
2.43.0



