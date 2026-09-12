Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FF137C916;
	Sat, 12 Sep 2026 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229626; cv=none; b=ib8CLgB60mrhRVIDZfpNYs7mLYGxlubS5EXiqzZALU7ou0/ZRasczJegQEYti64iMdfRroGvWSY+7KPEdvkkvPmniXIXVBOcRZ1Hv1vaklf453mLeYLZIURG3hro08mgajQ1a6O60W4i79XO7HBZ8LwhprltsUVGD2fNLnnuE2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229626; c=relaxed/simple;
	bh=HDlCfl92rjk1Aa8Y0Ja4EbGIom8nEQ/5RF/dCBeXIz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWRCu8arEERlGPrf218qGkVGsOgUd5A3xX0FhN/CzXYCtFV6Ld7+eYVpjmWot2XTmNYc1VVozswzDNobcm2d/+nUVO5qhdrsrT50XuoeJcOKF51rk0JptLHatrIgSGahTiP2S7fzQT06Q9NVJ9s+1UICRTYRTVuMIUHV6C68LD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HchnCb2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HchnCb2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C231F000FF;
	Sat, 12 Sep 2026 16:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229624;
	bh=TJScM5GgsfIPVoBLKzc09vxogPrWJdNdmX3SIyW7tow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HchnCb2QNAJLUc0iQK/3F7s1VvQDS3SdMQH6ZYQJIlzRaVIEAJiV51KlBGvXksrf/
	 DDqIVWJiDAJ4DhCucxDeBUzdmg/ngrzWqCNM0CANiARhvZcjtmI8bAZzHS+5yMlyL0
	 todgNwfY0i5WaDwVluWqsQM9jUJ/smc1PBo4Qv10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Stefan Wahren <wahrenst@gmx.net>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0601/1191] pmdomain: bcm: bcm2835: handle genpd provider registration errors
Date: Sat, 12 Sep 2026 08:55:29 +0200
Message-ID: <20260912065601.748566701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a1d9d3b958d69a13783613304f524f489fecdd1f ]

bcm2835_power_probe() initializes all power domains and then registers
the onecell genpd provider, but ignores of_genpd_add_provider_onecell()
failures. Probe can therefore return success even though no provider was
published.

Check the provider registration return value and jump to the existing
cleanup path on failure.

Fixes: 670c672608a1 ("soc: bcm: bcm2835-pm: Add support for power domains under a new binding.")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/bcm/bcm2835-power.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/bcm/bcm2835-power.c b/drivers/soc/bcm/bcm2835-power.c
index fbe8d57770a31..5669763aea7eb 100644
--- a/drivers/soc/bcm/bcm2835-power.c
+++ b/drivers/soc/bcm/bcm2835-power.c
@@ -682,7 +682,12 @@ static int bcm2835_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto fail;
 
-	of_genpd_add_provider_onecell(dev->parent->of_node, &power->pd_xlate);
+	ret = of_genpd_add_provider_onecell(dev->parent->of_node,
+					    &power->pd_xlate);
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to add genpd provider\n");
+		goto fail;
+	}
 
 	dev_info(dev, "Broadcom BCM2835 power domains driver");
 	return 0;
-- 
2.53.0



