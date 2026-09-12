Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41644486424;
	Sat, 12 Sep 2026 19:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240027; cv=none; b=LcUWPh4qA1gAx7A0j3Lp/dmNrVLks3cpGAQZxMJTOTZI4P5R7dFcMReIaRuqsZEi1VGbZ5txAV34sz/smL/svxb6i9JsRz+QVdW4xAWm3ZC6wc5qPXy2P9GoY0S9WzUQdeiSgyJhhSfxorGQDUsOIQ5zNaPojXySMLIsd+uC+WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240027; c=relaxed/simple;
	bh=xaEXuepYBx1zCbcf8xeUHn2LSe3asc2agfR4O15S0mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrTKY++RxUP3d940lQsEu6M2ir/PPsx08Ov5dGjaKyJnSSrdy6up50blBFLul6jTvwn9GMqAnfoE+GkepPLjpoS32VTHlyHpKL3NIJ/8Hq4JCp0U7Tp3qYzvQg+p5JKMTR7+AfcFobIl2E/IEG/a08OZKTzDbjS2W+YURDEuLXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ue9qVABX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ue9qVABX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC86B1F000FF;
	Sat, 12 Sep 2026 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240025;
	bh=3/EKk7Z4VIpPOFUQAwlpTfwepRrn1AEvfNMksxbERS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ue9qVABXbs+qenwP8Gjw7i+yw9YfvEmdX1Y87Mltjsw/7GXl/7galpKvP9lPiQXOH
	 bfgQ0GW7dsdHdwtwV+N1KIVO5hugt7aJVh8Nxt5vXhfCY9UN1b/sGHfGwB+2+5lII/
	 VyE7l1Rdtuot6dXFdaGfUN9yEAUpdtXBZz29FTkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 784/935] ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready
Date: Sat, 12 Sep 2026 09:03:34 +0200
Message-ID: <20260912065544.811950597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 98a157e46637a..be18100efd0e5 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -562,8 +562,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
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



