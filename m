Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEAB168D1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E34C433EF;
	Mon,  8 May 2023 11:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545200;
	bh=J4497q3g48UXVm4LnYW/eDGFcHphydBw9WUgNTCHFuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUJOroRRmHxphS+yMztgdFiGdjxjTedeYJxq7roSPOP+M+O61lk/olOn9h96uQ2nS
	 DW8hWxCGWN0sfUm1mwtEvJ7lx8OPRjwFIF7NOqB0clCV22k/FEWAC/eZdjqEtQpDSv
	 vTaDNTPETAIvHt2lHki5nGgMGmp7ouSaHcSjepTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 658/694] thermal/drivers/mediatek: Use devm_of_iomap to avoid resource leak in mtk_thermal_probe
Date: Mon,  8 May 2023 11:48:13 +0200
Message-Id: <20230508094457.336183703@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kang Chen <void0red@hust.edu.cn>

[ Upstream commit f05c7b7d9ea9477fcc388476c6f4ade8c66d2d26 ]

Smatch reports:
1. mtk_thermal_probe() warn: 'apmixed_base' from of_iomap() not released.
2. mtk_thermal_probe() warn: 'auxadc_base' from of_iomap() not released.

The original code forgets to release iomap resource when handling errors,
fix it by switch to devm_of_iomap.

Fixes: 89945047b166 ("thermal: mediatek: Add tsensor support for V2 thermal system")
Signed-off-by: Kang Chen <void0red@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20230419020749.621257-1-void0red@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/mediatek/auxadc_thermal.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/mediatek/auxadc_thermal.c b/drivers/thermal/mediatek/auxadc_thermal.c
index ab730f9552d0e..3372f7c29626c 100644
--- a/drivers/thermal/mediatek/auxadc_thermal.c
+++ b/drivers/thermal/mediatek/auxadc_thermal.c
@@ -1142,7 +1142,12 @@ static int mtk_thermal_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	auxadc_base = of_iomap(auxadc, 0);
+	auxadc_base = devm_of_iomap(&pdev->dev, auxadc, 0, NULL);
+	if (IS_ERR(auxadc_base)) {
+		of_node_put(auxadc);
+		return PTR_ERR(auxadc_base);
+	}
+
 	auxadc_phys_base = of_get_phys_base(auxadc);
 
 	of_node_put(auxadc);
@@ -1158,7 +1163,12 @@ static int mtk_thermal_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	apmixed_base = of_iomap(apmixedsys, 0);
+	apmixed_base = devm_of_iomap(&pdev->dev, apmixedsys, 0, NULL);
+	if (IS_ERR(apmixed_base)) {
+		of_node_put(apmixedsys);
+		return PTR_ERR(apmixed_base);
+	}
+
 	apmixed_phys_base = of_get_phys_base(apmixedsys);
 
 	of_node_put(apmixedsys);
-- 
2.39.2



