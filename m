Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326322AF07;
	Mon, 28 Oct 2024 06:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098051; cv=none; b=WzdCzR15NJfKSOQV8dL9iXUOx4X95AOModJjcZsOk/KFMfQiupI8mGKYPnloq/H5UFqH7KictGO4ZV4zh0f7Lkw0rU58oId4hJklcoo3dPfW2WwjvhF72S1z04NvH5nzTZLA2HIQww6v2iue0j245AqlgODInvdxWyPP+2MLu7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098051; c=relaxed/simple;
	bh=4euNk9mePrjF3dapGjaKAjLqXovsYwCHgC4f2m1K708=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZTQMsCasW1YYOef2a1rXQF2SzzHuLETZOx9NJXhokQ1TYwJpwchz4/A0XZJ09aK8AlKPiD+vkO5Xcy6U8HPT/cqc5jBnqO9PanwbtuVP+F5UCaobHdn13bqyRur6a7fpGnibihoHFn90o2wi5SymZA5142h9F5wki6nnBqxq2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vD3QoDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vD3QoDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A76C4CEC3;
	Mon, 28 Oct 2024 06:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098051;
	bh=4euNk9mePrjF3dapGjaKAjLqXovsYwCHgC4f2m1K708=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vD3QoDZz6EDjlHqNHMNSfHzF/IDS5V6JoNQgT3kk46lpe0oCx/RL5CGl+na2I6xy
	 AQtXqKst39b9KslmN0urUblgDS692nfiyvMso12oQxLte4g36vzUgRuzvSMOAUzXwu
	 TiZ5y/N7Mz20ZgyikndXhdb9LCfHwYjItVORAccs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 054/261] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Mon, 28 Oct 2024 07:23:16 +0100
Message-ID: <20241028062313.368521599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1205aa398e445..a98d24b7cb00b 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -550,7 +550,7 @@ static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
 {
 	unsigned long pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	if (dsc)
 		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc);
-- 
2.43.0



