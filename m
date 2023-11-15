Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC4733CDF
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyQFnMpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63940C433C7;
	Wed, 15 Nov 2023 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077364;
	bh=bSNT/uEZbOU4/df6QoNE/pf8NCheDYRgFDNOnjn7lmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyQFnMpuAIxKKVwQreifQBqPfog4T6fAzEjP5YgrGGMjaZ7qmgQ83O2/NWJGFRUCM
	 BUTAEIqMS6EDfQ68kfhiH1ykFZ6Tz7A08xo6vbGSTb27Cjq8FzNXJgaGEAWbc5Ek2B
	 LsFQ4bYp7XYplVZyQxcnkeDLD3pMn/HViGHOmz1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/603] drm/msm/a6xx: Fix unknown speedbin case
Date: Wed, 15 Nov 2023 14:13:21 -0500
Message-ID: <20231115191630.998320599@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 75cb60d4f5f762b12643b67cbefefcf05ecfd7eb ]

When opp-supported-hw is present under an OPP node, but no form of
opp_set_supported_hw() has been called, that OPP is ignored by the API
and marked as unsupported.

Before Commit c928a05e4415 ("drm/msm/adreno: Move speedbin mapping to
device table"), an unknown speedbin would result in marking all OPPs
as available, but it's better to avoid potentially overclocking the
silicon - the GMU will simply refuse to power up the chip.

Currently, the Adreno speedbin code does just that (AND returns an
invalid error, (int)UINT_MAX). Fix that by defaulting to speedbin 0
(which is conveniently always bound to fuseval == 0).

Fixes: c928a05e4415 ("drm/msm/adreno: Move speedbin mapping to device table")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/559604/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index d4e85e24002fb..522ca7fe67625 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2237,7 +2237,7 @@ static int a6xx_set_supported_hw(struct device *dev, const struct adreno_info *i
 		DRM_DEV_ERROR(dev,
 			"missing support for speed-bin: %u. Some OPPs may not be supported by hardware\n",
 			speedbin);
-		return UINT_MAX;
+		supp_hw = BIT(0); /* Default */
 	}
 
 	ret = devm_pm_opp_set_supported_hw(dev, &supp_hw, 1);
-- 
2.42.0



