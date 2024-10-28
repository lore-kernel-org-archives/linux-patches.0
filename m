Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDB118E35B;
	Mon, 28 Oct 2024 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097555; cv=none; b=WwNDKWLutrQdRr26WxJJYHfgXB3xfSbWZ857NaSyYYkJMIAPt87zmXCjo1EeasPQcFpSkhXS3NieJTA2e6sAyMT1po80YKnG6/wmnn+96/MBztIEO6flK9tddsHVor6ko7CcdWqFW3RSsXxhMU+aZgODMEj5vLwkpEbvzB7HF7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097555; c=relaxed/simple;
	bh=kq1uyohoiNf2MX+6XsaXI2n683vj9cCx22vUCg+6/qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=birNHeqlGOrHzDVPEpo3pbT+efnDOE2Ec7LJ0WQu9mXl66mHxn231SofEMN2kroQr9JIaHw027ExigGvCL2rZ5HIACGG4ENQwCCHE8HmZIT/suLE9IwozEqyVf+RDIxuHfK3V1nmRd3wY9h+8X3Gdj+/I5LcUrrZHAar/HhH34E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY45ste9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY45ste9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D78C4CEC3;
	Mon, 28 Oct 2024 06:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097555;
	bh=kq1uyohoiNf2MX+6XsaXI2n683vj9cCx22vUCg+6/qM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AY45ste9CqiL3UQZqk4fIYVou7vdrmZYuE0FwEWYtcphD+pJstSlQQmi/8gbJAB/n
	 giykb/W0S8PS0c8H87TLBN6X1V5kL7tgob1Zih/65lO/CE22nJAh/hb+JuMf8qZMto
	 ZXheZa6gaQ7Q2m/+R5tw8ovwrshF8hKpS9Zp6xE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/208] drm/msm/dsi: fix 32-bit signed integer extension in pclk_rate calculation
Date: Mon, 28 Oct 2024 07:23:44 +0100
Message-ID: <20241028062307.741769872@linuxfoundation.org>
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
index fcfe612416b0b..f920329fe2e09 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -545,7 +545,7 @@ static unsigned long dsi_get_pclk_rate(const struct drm_display_mode *mode,
 {
 	unsigned long pclk_rate;
 
-	pclk_rate = mode->clock * 1000;
+	pclk_rate = mode->clock * 1000u;
 
 	if (dsc)
 		pclk_rate = dsi_adjust_pclk_for_compression(mode, dsc);
-- 
2.43.0



