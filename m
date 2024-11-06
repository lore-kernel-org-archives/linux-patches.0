Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B5C1F80C0;
	Wed,  6 Nov 2024 12:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896667; cv=none; b=HncGBMSI7/gUGNko0zmY3nD8oMhxsrsbaMkr1nEJzN9LNc0OF6GKDye9mBKeXTaMrd7UoX3UgqFAgdS/fsIADdxwLjXxSVNP4ADsAwPuE0xDtqIZN+sHMD8rtVjhpBLPKtaT1MgnxmCOVnf/JNc5B429J7sSINNyViJd9YZqv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896667; c=relaxed/simple;
	bh=OU3RzlLCl8iXChL0B99XM0H1niX5dLC+Ju24ZKy4EYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyXmRm2FkmItKerV/RUUaH3FAmDzsPOv7wbvD4OHGcZkf29zzzJj1cw2oLi0ftQcP9Vqz/4l9NHZi+2HVYpjW91xIOdFiSn8QSQV5Rpke9hQwOrInGXEw6V9K7Tyb2NDVWaWH9tk3EOZ7PGQeg/CnT8P7MA3Ogl8VEQeb1UHIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6AuvETk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6AuvETk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F28CC4CED5;
	Wed,  6 Nov 2024 12:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896666;
	bh=OU3RzlLCl8iXChL0B99XM0H1niX5dLC+Ju24ZKy4EYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6AuvETksTL+76D1z7tdY1Yy549e89/4ro4QOfTz/i1zc6FiliYbme1RseJRz/CII
	 qnIhJ4N8Jym3tIshWmKEMjyCWHiSSQlc/HQsL+lOCC+7EK6BPFI7SyVEkYQ29gCFBX
	 aKUhBnMK2aOAaf7SKnyYWMUJHz6oCs8bGdy2t9eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/110] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Wed,  6 Nov 2024 13:03:34 +0100
Message-ID: <20241106120303.381162083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 358b762400bd94db2a14a72dfcef74c7da6bd845 ]

When (mode->clock * 1000) is larger than (1<<31), int to unsigned long
conversion will sign extend the int to 64 bits and the pclk_rate value
will be incorrect.

Fix this by making the result of the multiplication unsigned.

Note that above (1<<32) would still be broken and require more changes, but
its unlikely anyone will need that anytime soon.

Fixes: c4d8cfe516dc ("drm/msm/dsi: add implementation for helper functions")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/618434/
Link: https://lore.kernel.org/r/20241007050157.26855-2-jonathan@marek.ca
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index fb7792ca39e2c..b69099b533bfe 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -685,7 +685,7 @@ static u32 dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_dual_dsi)
 	struct drm_display_mode *mode = msm_host->mode;
 	u32 pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	/*
 	 * For dual DSI mode, the current DRM mode has the complete width of the
-- 
2.43.0



