Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB6340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301064; cv=none; b=SFNea6t3DNbL6xV0PsCbCAeERnLVZm6YELuxH5t5lMeGFeGGoNQNRmaVSSpS0JmBKEgiBkgMnDxff/yQpf1P7HGN5P2kMvFTdZuh4cOVvYizx57tckI12g00UV7K391D4gX5oPBZliLNxjyfGGhEXiKhYS08eJhmgekiW+Y93ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301064; c=relaxed/simple;
	bh=SIfzGEicaXiCjBcV50bvfzgGKiwNjSrvEnyg+Jf+vec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o2RuZApBmgbGA6vFePIVQ+0wVfv3w1N1gVF3pSGCf6wa3ozQtpIuV01pmiEYmcSP6jJI0pjMXWxtq5zDTj2T+zUZZ+tfM/Re6rOSjXhgTnYNHVNaOab+Aa75JR92TilGd4Sw7U4Y6dzbAZJMlSKANZEO2yGgsYeUjXCYTTG0KlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6gkcxHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6gkcxHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF278C19423;
	Sat, 28 Feb 2026 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301064;
	bh=SIfzGEicaXiCjBcV50bvfzgGKiwNjSrvEnyg+Jf+vec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6gkcxHNKN5eZ9g0Dm+cEBj+aGQamyuFHB20+2vZAZC1X1oMZkmJhUwNmv+A0LhHp
	 kTVw2UfqdAfvJ0I6sQImHI+IBzoS7oI7uN/BOAEceG3kJ4Fot93ygjWb0BcRUESuOG
	 VAsQGMQSLXJH1LFnKhrQwzcyWdAqJt+uN6lVvOrr2GJgSPmSz/Rza9Wh0ssN03mlBd
	 Rt1JCpFmhw0KMZcS1VIv6LKtG0LxuydqChzD3srDxie5wqttJugr/wRamgOR/5BdBP
	 RoXVz9CMY05yngdr2a9V9DF0M7FEt8SPFLbmGZ/dSHpdOAGNWt+oNguYUeJZn7ps8m
	 zm+HtyfLaogfw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/752] ASoC: fsl: imx-rpmsg: use snd_soc_find_dai_with_mutex() in probe
Date: Sat, 28 Feb 2026 12:38:38 -0500
Message-ID: <20260228174750.1542406-207-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 84faa91585fa22a161763f2fe8f84a602a196c87 ]

imx_rpmsg_probe() calls snd_soc_find_dai() without holding client_mutex.
However, snd_soc_find_dai() has lockdep_assert_held(&client_mutex)
indicating callers must hold this lock, as the function iterates over the
global component list.

All other callers of snd_soc_find_dai() either hold client_mutex via the
snd_soc_bind_card() path or use the snd_soc_find_dai_with_mutex() wrapper.

Use snd_soc_find_dai_with_mutex() instead to fix the missing lock
protection.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260205052429.4046903-1-n7l8m4@u.northwestern.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-rpmsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-rpmsg.c b/sound/soc/fsl/imx-rpmsg.c
index 7cd3aa4c87060..39b2d64eb410d 100644
--- a/sound/soc/fsl/imx-rpmsg.c
+++ b/sound/soc/fsl/imx-rpmsg.c
@@ -145,7 +145,7 @@ static int imx_rpmsg_probe(struct platform_device *pdev)
 	data->dai.ignore_pmdown_time = 1;
 
 	data->dai.cpus->dai_name = pdev->dev.platform_data;
-	cpu_dai = snd_soc_find_dai(data->dai.cpus);
+	cpu_dai = snd_soc_find_dai_with_mutex(data->dai.cpus);
 	if (!cpu_dai) {
 		ret = -EPROBE_DEFER;
 		goto fail;
-- 
2.51.0

