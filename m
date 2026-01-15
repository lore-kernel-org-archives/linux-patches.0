Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2B13BC4E2;
	Thu, 15 Jan 2026 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496029; cv=none; b=ddX0A+njLf77hwPOZd8C+2BFY/pzwoTr5jKpoeqB/7qGEXJ1exJUnmN4QnnSKQzI7PeGCPdLyB7IR9njBodKdF+EDmJwSp7K490+VUYIGTv4tqDCYT+UaAmK5wFY6UWrMcZIFYUqFquooiVizo6uUh5GsHkOkqiP5Q+8MYkw5ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496029; c=relaxed/simple;
	bh=4A/P1R17Y+VdgtM13U0hN3UwnHD/zaiv33URe67yk+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmYg9eOwQwBL9B9Bjucbj5OS9uJZvdQ8B0k1m4UEtAWKeh35dc4UVx3h3SgakPIGHsVz8VQVoYB5xDyaIXfnPbLgXEUjIBYhmET9+XFmseiKBN3UsRMgT4TK0F0WXd8pPh6hZaMJgbwQQVWz9PbCBR/jaQtwqK6qooO3JTbCBwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDrP98DZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDrP98DZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8278C116D0;
	Thu, 15 Jan 2026 16:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496029;
	bh=4A/P1R17Y+VdgtM13U0hN3UwnHD/zaiv33URe67yk+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDrP98DZXouozdIeSZ/uYCIqOv4HisBUCUl1OU3X915alytb7iiDJCCOiEkvsCbN/
	 6vwwJ54jOxI/i3llphwyNGDYZxrfd9+8DmT7FQ8cqJuqHDc2qHlU3o06M9PFQPYIaZ
	 mII/WMIdSOtxWQOuVRTWlJCxz6hIH51NY3PO9fT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 053/181] ASoC: rockchip: Fix Wvoid-pointer-to-enum-cast warning (again)
Date: Thu, 15 Jan 2026 17:46:30 +0100
Message-ID: <20260115164204.243208954@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 57d508b5f718730f74b11e0dc9609ac7976802d1 ]

'version' is an enum, thus cast of pointer on 64-bit compile test with
clang W=1 causes:

  rockchip_pdm.c:583:17: error: cast to smaller integer type 'enum rk_pdm_version' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

This was already fixed in commit 49a4a8d12612 ("ASoC: rockchip: Fix
Wvoid-pointer-to-enum-cast warning") but then got bad in
commit 9958d85968ed ("ASoC: Use device_get_match_data()").

Discussion on LKML also pointed out that 'uintptr_t' is not the correct
type and either 'kernel_ulong_t' or 'unsigned long' should be used,
with several arguments towards the latter [1].

Link: https://lore.kernel.org/r/CAMuHMdX7t=mabqFE5O-Cii3REMuyaePHmqX+j_mqyrn6XXzsoA@mail.gmail.com/ [1]
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20251203141644.106459-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index c1ee470ec6079..c69cdd6f24994 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -580,7 +580,7 @@ static int rockchip_pdm_probe(struct platform_device *pdev)
 	if (!pdm)
 		return -ENOMEM;
 
-	pdm->version = (enum rk_pdm_version)device_get_match_data(&pdev->dev);
+	pdm->version = (unsigned long)device_get_match_data(&pdev->dev);
 	if (pdm->version == RK_PDM_RK3308) {
 		pdm->reset = devm_reset_control_get(&pdev->dev, "pdm-m");
 		if (IS_ERR(pdm->reset))
-- 
2.51.0



