Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829FE372EDE;
	Wed, 20 May 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296248; cv=none; b=EtjIaIod3zmxSxLFWKz26ULcbSZ3PEMwDIxmR/IlYccmOuN0dkSLa5MXqjlTJZfiGYPDmIkm+90J4XLIbZyDj+3ym60jE+Vu974BsIeaWCpYZj+388VUsvGa3nuHQJ8eCBVlzqpIxmCzsbG4dONluJVPCngNdR+QWlT1AVAU0OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296248; c=relaxed/simple;
	bh=sa8nmAmsUUkDhf7KcptfDz3eWjbL50AI9jocPZ+tbKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXzeA2oQFDHesp6gz24dzIJjI/i6xLLh5Kx8D+YBPQvb25/UX4oHKLquKhm1ZrA1ivxkW6b8oAlQPxb6x5Tob82CZinN0MA6Qk4WmXLXRFouLqbm8HU9/z6aBn2zHMJPsGbUA6CGvHbxUADMnl8vEM9hFDsGWomiNBWsf/oyDcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siqR57Ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siqR57Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89EC1F000E9;
	Wed, 20 May 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296247;
	bh=EUydgT6odf4CnJOgUfswHghxrXYLCR2cagCPW5Php9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siqR57GeZgZ0g7whjZYh6COFks3LrkcTi80gw/tjqkQU0SyYE5EOHJV6lnZsH4G9J
	 DfRgzhoXBhEPcSE1tQEzzDQ7U3Wi6hZEl2Y0+ADWVbxTf0ywK58kwDgiTtsxBAjVl/
	 07zw4KOv1f9OJo73O/arzXMbJ4jefWc+DB9x9XQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0726/1146] clk: xgene: Fix mapping leak in xgene_pllclk_init()
Date: Wed, 20 May 2026 18:16:16 +0200
Message-ID: <20260520162204.635800679@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f520a492e07bc6718e26cfb7543ab4cadd8bb0e2 ]

If xgene_register_clk_pll() fails, the mapped register block is never
unmapped.

Fixes: 308964caeebc45eb ("clk: Add APM X-Gene SoC clock driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-xgene.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk-xgene.c b/drivers/clk/clk-xgene.c
index ba3b1057e4f0c..abb6c8fcdc91f 100644
--- a/drivers/clk/clk-xgene.c
+++ b/drivers/clk/clk-xgene.c
@@ -188,6 +188,8 @@ static void xgene_pllclk_init(struct device_node *np, enum xgene_pll_type pll_ty
 		of_clk_add_provider(np, of_clk_src_simple_get, clk);
 		clk_register_clkdev(clk, clk_name, NULL);
 		pr_debug("Add %s clock PLL\n", clk_name);
+	} else {
+		iounmap(reg);
 	}
 }
 
-- 
2.53.0



