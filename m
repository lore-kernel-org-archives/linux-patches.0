Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDC415B0E8;
	Tue,  7 May 2024 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116094; cv=none; b=GhaoQGijNM2e5onMkJ/BHpchCGl5P0nAr0txfG+c1cvx/SE+bK4FWSFhcuEcRA1zZbQXxCtafvAd9sGhWp+hdWyZlG1yzEtzqSaSFAL4d825iW86ofAnn7QWA8os7FwTVuCVtYCNZ6r9GjvhGZYhF4PgVkorv7u47TUNPpY3g+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116094; c=relaxed/simple;
	bh=hTYt9yykoNUZnYemRLbUU2aDWH5rmMo3jmzVWlnUb5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hv9gCbNhFy0ReFZQeOLfoGF/KDMwrwFl8uvF8fHdQH7krDND2s93B5QEPLYwOEoBwqgQLzA1Oo2gkUMPLnwvpo6myuuMQKwmYsiAA1/lFGzknoeEgdGvVYXRqNtei9siXhAcyFZDscuSd+v1p6r1jr4BS3jJQNOkQfUWc/1RIrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlV/viAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlV/viAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2911AC2BBFC;
	Tue,  7 May 2024 21:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116093;
	bh=hTYt9yykoNUZnYemRLbUU2aDWH5rmMo3jmzVWlnUb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlV/viAfjXit4fREB+Rt0UAMuTtd4wpBWuZ3xXrD9LC11dIZYvUNSB4G09d/gnt3k
	 Ov3TyqsM4B7G7gLPnlHk9IpMZ4sp3eIr6XCjfYjFMA1f7A/pFma6m32NzR6UFGOHet
	 2ygGdp1eHfWCI3qN2jiMCaqaFoo/83FWh6N8YbwWnxBRMKp3o7TJeH9d1qFsrNGS2W
	 WMwjy3XlDrhRVyY34U8b4EWMJUgcRT9zhRGwqbX2/0MOcTs2/vu0QLypftyq+b79dC
	 /rN8u5FTOH55ukd2nW8TBdcrwjwJhBg9o43RyyrdLkDr8LC9Z9Tuq4wrAShcigWQ+r
	 mngpoNanHizaQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	David Collins <quic_collinsd@quicinc.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 05/12] spmi: pmic-arb: Replace three IS_ERR() calls by null pointer checks in spmi_pmic_arb_probe()
Date: Tue,  7 May 2024 14:07:42 -0700
Message-ID: <20240507210809.3479953-6-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Markus Elfring <elfring@users.sourceforge.net>

The devm_ioremap() function does not return error pointers.
It returns NULL on error.
This issue was detected once more also by using the Coccinelle software.

Update three checks (and corresponding error codes) for failed
function calls accordingly.

Fixes: ffdfbafdc4f4 ("spmi: Use devm_spmi_controller_alloc()")
Fixes: 231601cd22bd ("spmi: pmic-arb: Add support for PMIC v7")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Link: https://lore.kernel.org/r/82a0768e-95b0-4091-bdd1-14c3e893726b@web.de
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: David Collins <quic_collinsd@quicinc.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 9ed1180fe31f..937c15324513 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1462,8 +1462,8 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 	 */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
 	core = devm_ioremap(&ctrl->dev, res->start, resource_size(res));
-	if (IS_ERR(core))
-		return PTR_ERR(core);
+	if (!core)
+		return -ENOMEM;
 
 	pmic_arb->core_size = resource_size(res);
 
@@ -1495,15 +1495,15 @@ static int spmi_pmic_arb_probe(struct platform_device *pdev)
 						   "obsrvr");
 		pmic_arb->rd_base = devm_ioremap(&ctrl->dev, res->start,
 						 resource_size(res));
-		if (IS_ERR(pmic_arb->rd_base))
-			return PTR_ERR(pmic_arb->rd_base);
+		if (!pmic_arb->rd_base)
+			return -ENOMEM;
 
 		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						   "chnls");
 		pmic_arb->wr_base = devm_ioremap(&ctrl->dev, res->start,
 						 resource_size(res));
-		if (IS_ERR(pmic_arb->wr_base))
-			return PTR_ERR(pmic_arb->wr_base);
+		if (!pmic_arb->wr_base)
+			return -ENOMEM;
 	}
 
 	pmic_arb->max_periphs = PMIC_ARB_MAX_PERIPHS;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

