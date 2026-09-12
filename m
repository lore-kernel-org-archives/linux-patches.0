Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7FD24CEEA;
	Sat, 12 Sep 2026 11:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211015; cv=none; b=Ujtc/HmchIrC913J4nF9hK/oXrYmd4oXIjb6pkHkGfOznxSCwrWLNVC+1zn1MMiRuQX3c68lGSubhgJe9S0h+v4hQlxM67qRwhQohLiMKSSfXH/xFNwUNbBsw23iSv+222fWkf6MMD/hJcS88/CB0zp82ITK1AHQiiy60gMduQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211015; c=relaxed/simple;
	bh=kxfUNLfbyxN3WoPe1x0h9ujt2an+INThWUYTfeMDCUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqPr7GcfWVKKEzIskb+YuJ0uzuuRkfwYjlpAd4rljayfr3U+9FYr4PRZdurhSZS2GO5aDsST1CWesDIsK5KsHH5L8mLVGUfud8RrtQfzMlMlSu4mFJy2WPWMBek65gHqjDQ3EHt5+piyh0ufl15uRm0/MNDh22dzHPHWYq34CiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrxtR+IU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrxtR+IU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89AF1F000FF;
	Sat, 12 Sep 2026 11:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211013;
	bh=IrWePbdG9TzZptM63v/9O0whMc0DPzCD5/oAsMeI2q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrxtR+IUQg1ZAZD+nPo2G663w5olPyef1QpK/0CVBMcHBGaC0QQY12O4v2ARmligb
	 utwGHs1E/Dd3NGnqewpV680EBBU1lqLLJgmSmWr0eXIzSovnk9uXInZd0FZ0b7dqfw
	 bas/KT5FsICOOp9g1fYLPbNuKTaeQlJnOe57P7OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiangCheng Wang <zaq14760@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1142/1518] ASoC: fsl-asoc-card: defer probe when the CPU DAI device is not ready
Date: Sat, 12 Sep 2026 08:55:11 +0200
Message-ID: <20260912065649.292626981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 71113886e494b..f660eeb8e5451 100644
--- a/sound/soc/fsl/fsl-asoc-card.c
+++ b/sound/soc/fsl/fsl-asoc-card.c
@@ -651,8 +651,8 @@ static int fsl_asoc_card_probe(struct platform_device *pdev)
 
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



