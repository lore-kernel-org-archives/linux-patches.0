Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38638395DAA;
	Sat, 12 Sep 2026 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243221; cv=none; b=LbHmT4d8HxaYygCusOCI1y7IuHFzpacdYfW5Y8ZZLSGDkptkW+SRiiBUG/wScrXwe4XNzYwm5gApmUrHdNF7SyTHf8UJsXS9Lz74gZdnePkDB4xmGm9LZCj0vZBICQKqKcQ0+eNjms+fded6AI5uk6gn3ZoxOtrrq7GJiTP5P3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243221; c=relaxed/simple;
	bh=eymZiWpvYmf5QBnYniDqAiLfoSASWH4fK3icQfN/g7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkYX7LD6LXoRyGllBqa9jrvjYidm8ZCP62j3jZtQkQWSuTKmAS0/pqlKmA9XlBUbPMMhst/8qR6mtuVH9N5iK1AvHbDpd+YeNw6SRTgwj0iiaR3YM7yG8u03s1/nRJtqt5aN1JbA0L5F0T2GX91pHMm7XBs8i0gHo0I2Ot1mAEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKLG4T+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKLG4T+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F701F000FF;
	Sat, 12 Sep 2026 20:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243220;
	bh=BjxUQheKCdc9TE4LWbUwpQc8yOx16B/mc6lWj2b5rOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKLG4T+Gz7tM+C9zRJJYpnC2eOLZGXzMQDv8sx8h9nJ9qVUJg/g0+SzG0dYFS3CO7
	 3PD/cImTrF8mOPYdY/763mdzxYRCu6KswqGQ5v+++40DewLKktvCsQ9WF7dIvoDgFA
	 EW2zXByy2fAakxm+w7GrcU7JKTF7zy0WEAV+QDFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 678/798] ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready
Date: Sat, 12 Sep 2026 09:05:06 +0200
Message-ID: <20260912065532.641699087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c876f111d8b03..76fb50e688a1e 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -552,8 +552,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
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



