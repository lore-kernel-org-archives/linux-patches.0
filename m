Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB61FF61E;
	Mon,  2 Jun 2025 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877058; cv=none; b=TsGpVpAOLEC/RdLr2Bxf7mKwsc4Yrf28+tgoYOxJg+rVLzx0XCmoFarwv3HFe/ceUZHnfCjzampo85ScaLyN4nHL/ZXOh1ATYcDMhZ4da7v2dKX7bMuSpuqVThAUTIey+J7x2PdXQyBcmtMeDa2LtBIIKKwWhxT/r39bqrLcxPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877058; c=relaxed/simple;
	bh=k8q08ApU3Wih4xhW+AERN3jezrr705z3fb8wEwz+ZDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZzeM7dfm9rU85b5IXk/YEfxEMHSILJJ9Xx8E9az6fu2o9x+gx1LI3vpmN/VGHTlMb7NhcRUxmKGCbI0nNf0v2OKoBvKR0C8RGZKZOkTBdul+HpA+1/pwqkGW7EcDqDfxaXnwa0uq+fzMNUyAzHD5d27kZIdubFiELc8knIXVxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SY4Hz6Id; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SY4Hz6Id"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77971C4CEEB;
	Mon,  2 Jun 2025 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877057;
	bh=k8q08ApU3Wih4xhW+AERN3jezrr705z3fb8wEwz+ZDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SY4Hz6Idsff0m4SP0tvwO48SdSW/bs627LRiGtk1apxVng97SZQ7B8lgpaEHvcftE
	 WBzeuN2h5FdExYqZW2kBKHsNJ+V6hkqTx7dAyZSMtIanZmhCyhDfadZeelS08iIyXK
	 fAgUNBufnA0HprAE/+7d6Vlly4rBNx2pFtDprxas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/325] pmdomain: imx: gpcv2: use proper helper for property detection
Date: Mon,  2 Jun 2025 15:47:14 +0200
Message-ID: <20250602134326.230116756@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit 6568cb40e73163fa25e2779f7234b169b2e1a32e ]

Starting with commit c141ecc3cecd7 ("of: Warn when of_property_read_bool()
is used on non-boolean properties"), probing the gpcv2 device on i.MX8M
SoCs leads to warnings when LOCKDEP is enabled.

Fix this by checking property presence with of_property_present as
intended.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20250218-gpcv2-of-property-present-v1-1-3bb1a9789654@pengutronix.de
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index 88aee59730e39..6d5b6ed36169f 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -1347,7 +1347,7 @@ static int imx_pgc_domain_probe(struct platform_device *pdev)
 	}
 
 	if (IS_ENABLED(CONFIG_LOCKDEP) &&
-	    of_property_read_bool(domain->dev->of_node, "power-domains"))
+	    of_property_present(domain->dev->of_node, "power-domains"))
 		lockdep_set_subclass(&domain->genpd.mlock, 1);
 
 	ret = of_genpd_add_provider_simple(domain->dev->of_node,
-- 
2.39.5



