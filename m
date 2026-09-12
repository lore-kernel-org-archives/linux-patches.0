Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08981C5799;
	Sat, 12 Sep 2026 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225352; cv=none; b=QQMigmiHpsAs9rKzbthm72gXbY2dhu/K9eisfvZ4iHIhS2Rimgmj7q90iOSfi6USU0O4t+KOhUSgZkbDZrV1olXRDw6auitmB9ExeMy3hKYfsSV2lQu0zt2FQl+6wFULMxOTgozsX6VvyZQomBS55ZzxNIVjdu7QRMfgAyCT1BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225352; c=relaxed/simple;
	bh=sSOhL2b+xalJDhlPKLK/Pt65FQvEHBX2irOUSsBVQFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG72VkSNPP964D9sw+FUBBLrULMSUgUg9EDmgd339MDh6GPm5u6zKCiQy4N/jUO09FjvXBHqA3wtpoq6TbKouz55bfsIb34IKs6C4Sa0kTkva4qShEpWYhiEuetALZ/pkfAtOFeWQV4tjxRspV8HSfRf6bAVE55CTS3HryV0P/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxxnn0T5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxxnn0T5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A761F000FF;
	Sat, 12 Sep 2026 15:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225351;
	bh=GA7+z+Fx/6pvgsqJauoUY5qw6/7tNGKWfXWRQOKhqbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dxxnn0T5/vHIsO2ESu+PTH5cAH9H61LElQcT0bFfsn/5vbM8z4aYRHTc0Yx8T1aiD
	 oLqUpBwfngeP9XkcB+ufbu1y/NVEX9H+LTu8gVknBc5hUbRKFxYW6j40cD6OrZQ/W4
	 PxsarwszGjZnp+V5zp2pAbgkC65AwLN+mn1+4R8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1178/1424] ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready
Date: Sat, 12 Sep 2026 09:00:10 +0200
Message-ID: <20260912065633.672895381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f76252b3f5913..f447d0cc2baf4 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -573,8 +573,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
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



