Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCB1DF26B;
	Wed,  6 Nov 2024 12:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895668; cv=none; b=g5n9RIFI9pxkSgwxtKn7UAK84eZ9pxsfrGCEcPwVZNTwfRJy/Acwq3s9sgdu5GW5u3o0UT5ilY4Kzlg6d1u7BObxjGnXeAhcoutekbO7rr1OYd703OZEZQI12CUhxiGkN/1HCSN08EQ0YKpEI/hf5LA0h6AJtCYJIMFTFbBcmt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895668; c=relaxed/simple;
	bh=za4hLLcq5kRj/fHnVm21o8n8iYDMCQcribV/yVi6KQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj+vey2Vb5CGn3wtLNU7Qc1CGyC1qg1UjTtNr8FT7vFOUKnqexC2eyE80NcJCWKnrqmN6Uxfa1qHkGCoZ8TEDuJJw95GU3+xLhpVtLt5q9BVLvol0/Yk9YRJznIwQdRVHjcycajhjxWRSpObeZgBdwX7Oje6L9KGAoQBgseymxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5DiDFsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5DiDFsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9659AC4CECD;
	Wed,  6 Nov 2024 12:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895668;
	bh=za4hLLcq5kRj/fHnVm21o8n8iYDMCQcribV/yVi6KQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5DiDFsHoZ/qlb1ipTEyjPRotFfmr4TceazOzatbswpEkLpeFbHbX//l2ZxB/CK/8
	 Do8dZ/z9NFXrR+Alf87pmCuYGemXJX8tT5P+8EOC4tlBO4gxsFKqEw0T9LjbQSq0sw
	 aZA2NoMPpnzLsE5mOtZ3604ucIzkIR6Q0nXx3OnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 296/350] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Wed,  6 Nov 2024 13:03:44 +0100
Message-ID: <20241106120328.125042129@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4dd3659bf96..137c0ec1b5772 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -671,7 +671,7 @@ static u32 dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_dual_dsi)
 	struct drm_display_mode *mode = msm_host->mode;
 	u32 pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	/*
 	 * For dual DSI mode, the current DRM mode has the complete width of the
-- 
2.43.0



