Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA081AB51B;
	Mon, 14 Oct 2024 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919855; cv=none; b=PCtAlhnsBUjWIt+xoaQs6kYzkl8IMmHhxeCvL43sk3QfrvfQL7g7kCxfw8qcPvbBefSHQELYe+Hgefh3n5cTq23x8SyXiPIlPpXRZFgO64NfKE6XONyPhNx+2qiSAD/pYwCoIaZEPEb0jPTBk22GCIZapG1kFTFGFAo0wi5ANyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919855; c=relaxed/simple;
	bh=8wwUF7tGxKWFPL1jr3b0x1BkXoy1ru+0j/90ntuAE/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyLgg7oxMgWcDjtA5xDwrjlq91tQTpr9jAELW48Snk9N/o4RUGK4k7IxKyzvN5f7ByKINUsL642n2DzqyMsUAkjf6wQxb3pFmbwoMYHM0X7P/5UPYLimlFs/d/VdJAjRXLMqaKSoEFjT1Wj+Rta755KqnKABnw/D9PHeMDI93TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6Hm+rZA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6Hm+rZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36FEC4CEC3;
	Mon, 14 Oct 2024 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919855;
	bh=8wwUF7tGxKWFPL1jr3b0x1BkXoy1ru+0j/90ntuAE/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6Hm+rZA5/jWmLIUUHqCAEBD0y1KIbxLxKK+PTiRR9prC8IzTODxdqqHwWFvG9dSM
	 eNTHZI0FHPv72pUjDDRAUvWjC+KoZczfgxc0hPrmBpqyoeMFxua/hc3zVfDUsETxkD
	 B3UsyvLiiwtzj1tpyRiR4TBVg4XCfRCgNinh2f70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 699/798] clk: bcm: bcm53573: fix OF node leak in init
Date: Mon, 14 Oct 2024 16:20:53 +0200
Message-ID: <20241014141245.532377035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit f92d67e23b8caa81f6322a2bad1d633b00ca000e ]

Driver code is leaking OF node reference from of_get_parent() in
bcm53573_ilp_init().  Usage of of_get_parent() is not needed in the
first place, because the parent node will not be freed while we are
processing given node (triggered by CLK_OF_DECLARE()).  Thus fix the
leak by accessing parent directly, instead of of_get_parent().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240826065801.17081-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-bcm53573-ilp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-bcm53573-ilp.c b/drivers/clk/bcm/clk-bcm53573-ilp.c
index 84f2af736ee8a..83ef41d618be3 100644
--- a/drivers/clk/bcm/clk-bcm53573-ilp.c
+++ b/drivers/clk/bcm/clk-bcm53573-ilp.c
@@ -112,7 +112,7 @@ static void bcm53573_ilp_init(struct device_node *np)
 		goto err_free_ilp;
 	}
 
-	ilp->regmap = syscon_node_to_regmap(of_get_parent(np));
+	ilp->regmap = syscon_node_to_regmap(np->parent);
 	if (IS_ERR(ilp->regmap)) {
 		err = PTR_ERR(ilp->regmap);
 		goto err_free_ilp;
-- 
2.43.0



