Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255F118EFD4;
	Mon, 28 Oct 2024 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097553; cv=none; b=pJ6uGsMCZXws6WtwJRTADnvk2o8ZBUKTKpwXFeXT8fKiIqIKCDku+aYtJ106gRGsoGM0SBTYlIXkDX03gW5B0ATkLQhTAy3rMrNXdDY9wUrs8e7hotxhFVEJyJ9F82DdB3R9zFXpokxRZ0jNceHj3ASYomZO3vVYdXUvYuOf3qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097553; c=relaxed/simple;
	bh=W0iaxcirB3oEhRP9luCbBE9GYf7MUWKuV6Viv1070po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDVuFhruYKLjtITmoYiLSZf/LSdPCoCNbQy6eQVgWizlXQ6hfg/BidilVYCM/8slAfg/5ARThZUPp/L5e+mgTo1EiT5LXs4Sp52Q1qALmdJ7YdLYPnSP1kRzxKyYmPKhOu1RW53xtfdu4DnmlGqnYYCwP9yCGQF4KrZbixvRjxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBkzxLfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBkzxLfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B956EC4CEC3;
	Mon, 28 Oct 2024 06:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097553;
	bh=W0iaxcirB3oEhRP9luCbBE9GYf7MUWKuV6Viv1070po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBkzxLfDe415OSA9qMauKIBj3Lxjp7J1dCRs8YciWGMu60z5JKLjVgDA70gcc7Kz8
	 +w4MRoWdgYcGoPkAl2nomVMYOEbdZWX0/Nh7ku/Gp5nTvg//opdMxJy6VABenhfy+V
	 fJ2aS41qrJpkLerpExlO76jpqjjcuTlAcwY8Ssbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/208] drm/msm/dsi: improve/fix dsc pclk calculation
Date: Mon, 28 Oct 2024 07:23:43 +0100
Message-ID: <20241028062307.716843656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 24436a540d16ca6a523b8e5441180001c31b6b35 ]

drm_mode_vrefresh() can introduce a large rounding error, avoid it.

Fixes: 7c9e4a554d4a ("drm/msm/dsi: Reduce pclk rate for compression")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/618432/
Link: https://lore.kernel.org/r/20241007050157.26855-1-jonathan@marek.ca
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 77b805eacb1b1..fcfe612416b0b 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -537,7 +537,7 @@ static unsigned long dsi_adjust_pclk_for_compression(const struct drm_display_mo
 
 	int new_htotal = mode->htotal - mode->hdisplay + new_hdisplay;
 
-	return new_htotal * mode->vtotal * drm_mode_vrefresh(mode);
+	return mult_frac(mode->clock * 1000u, new_htotal, mode->htotal);
 }
 
 static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
-- 
2.43.0



