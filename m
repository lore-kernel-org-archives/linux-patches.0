Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307AC8821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BABAC433D2;
	Fri, 10 Mar 2023 14:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460151;
	bh=LYVkhV2R9Y0Xbs9lgsbHg3J/TGSZbq112DGEJlK19cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMJO0OfWev41sZUSVW0pzvaXTiE1hv17Mj0/BNucrSF0j+A6C8ih8lMdmTAP31A7+
	 XOh1TU1gltNmx21HGYFiZbrKD6igz2xYPQQ/fr9gGqXTbwHuiqxC6gO1MhGhCxedPJ
	 DSMOznPD76WZwTvmNvYKU+XsoAFmljcO1IVCZQOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/529] clk: renesas: cpg-mssr: Fix use after free if cpg_mssr_common_init() failed
Date: Fri, 10 Mar 2023 14:36:22 +0100
Message-Id: <20230310133816.064492757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit fbfd614aeaa2853c2c575299dfe2458db8eff67e ]

If cpg_mssr_common_init() fails after assigning priv to global variable
cpg_mssr_priv, it deallocates priv, but cpg_mssr_priv keeps dangling
pointer that potentially can be used later.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1f7db7bbf031 ("clk: renesas: cpg-mssr: Add early clock support")
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/1671806417-32623-1-git-send-email-khoroshilov@ispras.ru
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 94db883703377..12e5a78819773 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -960,7 +960,6 @@ static int __init cpg_mssr_common_init(struct device *dev,
 		goto out_err;
 	}
 
-	cpg_mssr_priv = priv;
 	priv->num_core_clks = info->num_total_core_clks;
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
@@ -990,6 +989,8 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	if (error)
 		goto out_err;
 
+	cpg_mssr_priv = priv;
+
 	return 0;
 
 out_err:
-- 
2.39.2



