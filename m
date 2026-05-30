Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB03F3148DA;
	Sat, 30 May 2026 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161280; cv=none; b=Zlm2TGKRQBqOilNW057mwvlx/519EPFeG7ijA+yTCxsNpr0mXuO3P6/b5q6HNxZ4YSEs306uWxQi4ba4jabjYriiNJoatNIVGmcjL9+MiSII8AUdoOOB8ncQ0Pci85Mg1qlLarELXFa74YHjzX6jLB7fmjERQZ/orHL1wJB1xR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161280; c=relaxed/simple;
	bh=aOIpUR6YcC2J20IwlONyASiLPxh666KRcMl8w8aLTdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQbailTwzgZrmDdJ5vRPKLOeWDxmpvZg2fy+ljEVJmJeQOwQU3PwZyTwbZ2SQk34TsiGxYRIUZRyCt2yH4d2syb1dh8srCar59WBK3e+GrwuIN5LTneAPChVr9RR/AzEF/txUbbOGDIX/wVJ1bXJGhBCkCFB6w+fejtAZU8zCko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8RXYcP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8RXYcP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192981F00893;
	Sat, 30 May 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161279;
	bh=/GDWW5KHutxV8+Z0PFgZN071i/RzdHRStc/IQ9skBpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B8RXYcP5UDfn/Z0uTSM/DiNr2yjbOGMzNykriyp+xjlD0g0jRtrsazwd/0qPiKMYG
	 2mTcjwU5WHG+/WlPeCPXbz6t21mZyChvjupMYJa6B5L8L8+elfPFlB03poO7L/3N56
	 L5y66HBvEy6G+1/SAPv37x0QLapBucs3gBsoMObM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 578/969] soc: qcom: ocmem: use scoped device node handling to simplify error paths
Date: Sat, 30 May 2026 18:01:42 +0200
Message-ID: <20260530160316.369211819@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f4c1c19f5c0e5cf2870df91dedc6b40400fd9c8a ]

Obtain the device node reference with scoped/cleanup.h to reduce error
handling and make the code a bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240813-b4-cleanup-h-of-node-put-other-v1-4-cfb67323a95c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 9dfd69cd89cd ("soc: qcom: ocmem: register reasons for probe deferrals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/ocmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/ocmem.c b/drivers/soc/qcom/ocmem.c
index a21a196fdcc24..a8a0d89ab01b9 100644
--- a/drivers/soc/qcom/ocmem.c
+++ b/drivers/soc/qcom/ocmem.c
@@ -192,23 +192,20 @@ static void update_range(struct ocmem *ocmem, struct ocmem_buf *buf,
 struct ocmem *of_get_ocmem(struct device *dev)
 {
 	struct platform_device *pdev;
-	struct device_node *devnode;
 	struct ocmem *ocmem;
 
-	devnode = of_parse_phandle(dev->of_node, "sram", 0);
+	struct device_node *devnode __free(device_node) = of_parse_phandle(dev->of_node,
+									   "sram", 0);
 	if (!devnode || !devnode->parent) {
 		dev_err(dev, "Cannot look up sram phandle\n");
-		of_node_put(devnode);
 		return ERR_PTR(-ENODEV);
 	}
 
 	pdev = of_find_device_by_node(devnode->parent);
 	if (!pdev) {
 		dev_err(dev, "Cannot find device node %s\n", devnode->name);
-		of_node_put(devnode);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
-	of_node_put(devnode);
 
 	ocmem = platform_get_drvdata(pdev);
 	put_device(&pdev->dev);
-- 
2.53.0



