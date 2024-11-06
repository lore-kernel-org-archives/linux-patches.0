Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0FC646;
	Wed,  6 Nov 2024 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899000; cv=none; b=d7UuDCt9qKuYryPNfhJI+cOeqfMnSEEbC5l0PfL30wQjC2BHidzsKIvCtPv8VVQs5ixgg8L2ceGipuRKEvNoUg5pmEvk41E682+wnmgRO1KePMqy0FRwWT9qlQ8oNUgEPCE1SgBvCqazLgJhn/hC+YvVGMA2+R00R88Z8eZn4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899000; c=relaxed/simple;
	bh=iu1oVAJ8txIhzyzfSWnu0mUVpElUaac54UByH4F52HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK5EtYsrqYCrXZHnjwTM53nk5ovJNqaOr+oxPGPWA/dCOFx8gdojui6z1xt67doIyD6lRXIt6yl1jKV/qC1MSGEDU/MyGTlaD0+TcJmQv6xuo6bnAg45CUb45opnhFanul/2PYSwVefcK1lf7bJZOnW8yT9BijoBiZjLJZVgIzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ehg9ZCqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ehg9ZCqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE55C4CECD;
	Wed,  6 Nov 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899000;
	bh=iu1oVAJ8txIhzyzfSWnu0mUVpElUaac54UByH4F52HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ehg9ZCqrNZggaVnCTPDpYBCyUm5vFO0uZ7WWtiClZwMAzH13sIfB1UaEZWBp/U2oe
	 PZCHldgtALO92/PBokePN+p4h61Y99to+CquL3BbVuoDmqIGYd8Dz4X/GzCDInZlGA
	 3ftv0A8qdZMdPFiPM/c9lamZR7A1i7YWACbDJ/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 390/462] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Wed,  6 Nov 2024 13:04:43 +0100
Message-ID: <20241106120341.157377847@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 419cad31830ea..41b68047bf61b 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -663,7 +663,7 @@ static u32 dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_dual_dsi)
 	struct drm_display_mode *mode = msm_host->mode;
 	u32 pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	/*
 	 * For dual DSI mode, the current DRM mode has the complete width of the
-- 
2.43.0



