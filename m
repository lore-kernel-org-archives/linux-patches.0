Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A6D18CC1F;
	Mon, 28 Oct 2024 06:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096847; cv=none; b=tE2PJjk0lVG380cXeZulKLC+qwQyZ9Lelctk0Ay31uqPkihsb3xfUoq2l2C7nS/5kjyWbreNzOCZmeLtamHX6pXuLUEVbbYv8uU4fMd/WSrOYYGgrsuGlLnHLN4dV8MGLmhm1qj0Saj8qWPJFfX0nSmD12PYpxAoEFYnf/o9pek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096847; c=relaxed/simple;
	bh=M+VkIRPjUNTFydhxiFteeDoH9Fw0wjcB30dVu78a5Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4SJZrskdbbQwbDBkPfwQbpWKpDqAJo2BJSDhSbxbWnNW3mHXQitwpe8aZgHIoU84L1T83/due6ZS70R84dV60uAmts4c5/iZqRgpCri8MS7NNgQhbHJTqQY8c2S1++mgnN7dp1X/tbJwc1iAHFzcsNuiPTuPySaaE/2MxrwlKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKNql7Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKNql7Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05B2C4CEC3;
	Mon, 28 Oct 2024 06:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096847;
	bh=M+VkIRPjUNTFydhxiFteeDoH9Fw0wjcB30dVu78a5Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKNql7HaoeAoVeVNKJ5clXWL7rCr/80zcolCsk1sebMJIwhk1FL5nsv5o4NZV7Cn/
	 qx9svclsKk3wFcy5rsVX3sZTAqtaQrI4pn5b1JAfeWpLrbqWcYpYGduf7RDEEX6OHw
	 EjGlN1St30qubsaK9odwzo4H+35GbJbRcgNxr/jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/80] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Mon, 28 Oct 2024 07:24:53 +0100
Message-ID: <20241028062252.992244227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index c563ecf6e7b94..eb7cd96d9ece1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -678,7 +678,7 @@ static unsigned long dsi_get_pclk_rate(struct msm_dsi_host *msm_host, bool is_bo
 	struct drm_display_mode *mode = msm_host->mode;
 	unsigned long pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	/*
 	 * For bonded DSI mode, the current DRM mode has the complete width of the
-- 
2.43.0



