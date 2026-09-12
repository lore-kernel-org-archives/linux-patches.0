Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CCE28B4FA;
	Sat, 12 Sep 2026 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203398; cv=none; b=LerVGTMQEbKHYQ5RJGv/nY23j1oRhJe0JMmICZk1SmguMM6oCpj+O+Q+wkrr4tH1ef+2yNvZeIP3yfnied9t4iGXVq1Y3KNBZLgGOmoQMJ+46YJJTIx62N21Df5zNzxTr3RS3jaGH0NK1Ec4S7b8ljxH7cezJOMasboj5ftRpEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203398; c=relaxed/simple;
	bh=TkH9lf4UubfPAxFh8nYGIw7srmnrhGvhYqDlBaTHTVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bz+ou70gKSRESpa8B0yFgbKyYs7d0Hr/8WxHt0Sg025pTrgwLs6f386Tt4IC1HovIby7yB2HHnQM1Ih6emhE3IOaT4fu0I2NSTA9dGKOAG52gBFU8TtSYckGWdumBE/eM7fQWJPtxHNulsdR/rwyaGZnAgmJA50dV0XHz89L9mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJJkFd6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJJkFd6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31681F000FF;
	Sat, 12 Sep 2026 08:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203397;
	bh=4ZVjt9MBZBfePPzZGfc2aJeSHjOS13DJxQV9UZl2FwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJJkFd6I7tkfZvuF+Oo2tKg45eIHFFcMAHBiaUO8jeCEQmZRe7EkT/uV8mmY6Pyfl
	 ygScpJ48s9hNkeZERiyFDTiHLfGnsJr3gMjhdVI2sbiZXMREsnps//WTvWzPYiJ7p/
	 tLtUoCL1IUcIMrob5x6OqMTWSXEpSQk6702wYnPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1373/1815] ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready
Date: Sat, 12 Sep 2026 08:52:03 +0200
Message-ID: <20260912065721.261087574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: LiangCheng Wang <zaq14760@gmail.com>

[ Upstream commit 0286324da660875dc504fd65b3be87e9c8b9a547 ]

fsl_asoc_card_probe() hard-fails with -EINVAL when the CPU DAI (SAI)
platform device is not found. Like the codec, the CPU DAI may just be
probed later than the machine driver; the order is not guaranteed and
varies across kernel versions, so a permanent -EINVAL leaves the card
unregistered with no analog playback or capture.

Defer probe instead, mirroring commit e396dec46c56 ("ASoC:
fsl-asoc-card: Defer probe when fail to find codec device").

Tested on i.MX8MP with an ALC5672 on SAI3: the card that failed to
register on v6.18 now comes up during boot.

Fixes: 708b4351f08c ("ASoC: fsl: Add Freescale Generic ASoC Sound Card with ASRC support")
Signed-off-by: LiangCheng Wang <zaq14760@gmail.com>
Link: https://patch.msgid.link/20260805-fsl-asoc-defer-cpu-dai-v1-1-43f7f538e384@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl-asoc-card.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl-asoc-card.c b/sound/soc/fsl/fsl-asoc-card.c
index 709543308fe9e..eff46666c8add 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -728,8 +728,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
 	cpu_pdev = of_find_device_by_node(cpu_np);
 	if (!cpu_pdev) {
-		dev_err(&pdev->dev, "failed to find CPU DAI device\n");
-		ret = -EINVAL;
+		ret = dev_err_probe(&pdev->dev, -EPROBE_DEFER,
+				    "failed to find CPU DAI device\n");
 		goto fail;
 	}
 
-- 
2.53.0



