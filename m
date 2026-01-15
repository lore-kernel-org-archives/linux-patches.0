Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9133B2D73A0;
	Thu, 15 Jan 2026 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496600; cv=none; b=msgnGZGPAQWQU96jLqiqf7+akeYILvJgqIewdqRvF25pZTCtEu+GeVoayY4vGzx7/NF5sLr0Xn4303lBopHxiS2MqhaACn8LwLvtLDS+8hbYAsFakjXOK6Uz2p2knkTQJ2RymaJ5NlQuh6SR8L1/53NADm6AhJT8ED0s0oLvAUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496600; c=relaxed/simple;
	bh=pfLtNF9FlT5jc8txtTiBKdTDyZNlEFvexpCxN7RmMaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbvivBVi5LyMPeImUK6cImF8sj8wqw8SEgf8vWNodQO8imrDeFq/p7GI2oIUT24iroluLeoqkbtBAHq/sWf6TlL+mocDfKpzkDHFYye+tUTwwHB/ePwCgfIsB0T5L6hc2FRTQ8XVD/NTrxjqR77rght+Om5xaaVKxpJNgvBwAII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bp4J3fu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bp4J3fu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C648C116D0;
	Thu, 15 Jan 2026 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496600;
	bh=pfLtNF9FlT5jc8txtTiBKdTDyZNlEFvexpCxN7RmMaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2bp4J3fuBqzYCAh4uE0C88QUKNeFpDLlb4PuPEgZhW/PP1TigZ6higryemH3bhViN
	 EeUtn5A1bWys+2Fj6+vHN/dSBVyZdcnZGqaI40n+SMSDqZwxKbUi+Yr0Un061Xv8wS
	 x93+qPLsD0LFXbmiEcd5yqCJ2NqQlABAF6lAekDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/119] ASoC: rockchip: Fix Wvoid-pointer-to-enum-cast warning (again)
Date: Thu, 15 Jan 2026 17:47:31 +0100
Message-ID: <20260115164153.264338142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cae91108f7a8e..30d51e03d49e9 100644
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



