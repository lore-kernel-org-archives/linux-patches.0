Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7173EFD3D;
	Wed, 20 May 2026 17:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298984; cv=none; b=QxHZlnTuNVtIUAhPUVPcW9nl9e2p6r6o/+XBIOlvvhl8xBU+DIB3WlIy68TQBQj8Hy15Bhg25G+RWRitJFFc9ahWTDe9r6EoZZsS6mdo55v5LTf5dNx/AnccLC6SkpzUi9fxkGjt21NY02EJp9kO02wW/VLbTHfh8fRPwTx1yBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298984; c=relaxed/simple;
	bh=+2E0ZN3GSD0iFBPE1Kyym0nN9i2dPR6Ye8SmbNsPJMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AmSlHBxBnTh4R5p2p5YlsUZyl9udQuoqelKQ77WZO/w/GdWmxo2mdMz4pknPAB7rupe2MH8JKEgUMCYN4XOtSDcx9stPzXAVTlyGSm02i0DllAEuPc+f7NBoVMndjAdbmE9gHJMOhRZYQBhC+IYYKhOATuydMMOJsB/FY5ix5aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMqK29m7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMqK29m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E4E1F000E9;
	Wed, 20 May 2026 17:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298983;
	bh=g74DSMhJFzhqAuWYqS0o7SuA3pzK8BjMhJmJVgDcl+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMqK29m7X4B68gN3/xHn0/KfzsFXhvIKhV4da5r2LUkyUIpec5RBrg0pmBROhW2HH
	 UtsIf552Fkr4qGSvIWqko4ASBNK9b0Sr0szwkAchKTbtW8AyPhdQqYa/4FxofZfrSK
	 i7CCp5f/yL02eGmxHcsIpPr+yRcb2/6GECSdDKPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 577/957] clk: xgene: Fix mapping leak in xgene_pllclk_init()
Date: Wed, 20 May 2026 18:17:40 +0200
Message-ID: <20260520162147.043272582@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 92e39f3237c2f..7dc247eb880fb 100644
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



