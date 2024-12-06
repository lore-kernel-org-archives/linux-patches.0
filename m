Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6D453A7;
	Fri,  6 Dec 2024 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497577; cv=none; b=PUdu1g9UT0FDuLA0gD8wAa4JPFI2j43M0ImcIyARcwubrnx+1hD5iMlShcnIrzSfoOs6JjawR+RuTm6c02AUMe+cCCP0diVcbURJfM6XJJE7MXYJ66OVTwk5Zei4ZF0msxO3ePTj1XHNJ1/1WUTqcSw5dtKI8QEBM0mvYTY9Ml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497577; c=relaxed/simple;
	bh=jvW+0Ktu+6/iHa6+/UmH3ZMJy8xCoT6bjXtHaZvH8YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shPBoCKKJPCrRgG5r8ho1snpVvcu39RiJC/fRflO4WF6aUGdeRaX2F5VnJdXT6k4ECTlRbb4FWHFkDwzMu+lZ3qTmHtnNw9MCbLuDmspOWA0dWjaodTuJK4fN9sZlDgQyPszzGj2rCqUb8w2TZBahabjVTjWdPm+8tgHWLhkVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2C/Ysl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2C/Ysl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C4BC4CEDC;
	Fri,  6 Dec 2024 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497577;
	bh=jvW+0Ktu+6/iHa6+/UmH3ZMJy8xCoT6bjXtHaZvH8YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2C/Ysl6lMKF6oUmolPZiZyEtBVYjpb630fuktR9+Lsew1LNnNEQW/vJE6P9UPYU5
	 ypfn6Nmmj6TVKK58hJCo8hV1pm0nW62nIJPXS3wk16JzK9RjBSo//nOcCHqoEOA0cB
	 TIaSBjsUkyFkwAaPidbciaqv2Lh7fkiu/osckH0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 330/676] clk: clk-axi-clkgen: make sure to enable the AXI bus clock
Date: Fri,  6 Dec 2024 15:32:29 +0100
Message-ID: <20241206143706.235465584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit c64ef7e4851d1a9abbb7f7833e4936973ac5ba79 ]

In order to access the registers of the HW, we need to make sure that
the AXI bus clock is enabled. Hence let's increase the number of clocks
by one.

In order to keep backward compatibility and make sure old DTs still work
we check if clock-names is available or not. If it is, then we can
disambiguate between really having the AXI clock or a parent clock and
so we can enable the bus clock. If not, we fallback to what was done
before and don't explicitly enable the AXI bus clock.

Note that if clock-names is given, the axi clock must be the last one in
the phandle array (also enforced in the DT bindings) so that we can reuse
as much code as possible.

Fixes: 0e646c52cf0e ("clk: Add axi-clkgen driver")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20241029-axi-clkgen-fix-axiclk-v2-2-bc5e0733ad76@analog.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-axi-clkgen.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-axi-clkgen.c b/drivers/clk/clk-axi-clkgen.c
index bf4d8ddc93aea..934e53a96ddda 100644
--- a/drivers/clk/clk-axi-clkgen.c
+++ b/drivers/clk/clk-axi-clkgen.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/clk.h>
 #include <linux/clk-provider.h>
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -512,6 +513,7 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 	struct clk_init_data init;
 	const char *parent_names[2];
 	const char *clk_name;
+	struct clk *axi_clk;
 	unsigned int i;
 	int ret;
 
@@ -528,8 +530,24 @@ static int axi_clkgen_probe(struct platform_device *pdev)
 		return PTR_ERR(axi_clkgen->base);
 
 	init.num_parents = of_clk_get_parent_count(pdev->dev.of_node);
-	if (init.num_parents < 1 || init.num_parents > 2)
-		return -EINVAL;
+
+	axi_clk = devm_clk_get_enabled(&pdev->dev, "s_axi_aclk");
+	if (!IS_ERR(axi_clk)) {
+		if (init.num_parents < 2 || init.num_parents > 3)
+			return -EINVAL;
+
+		init.num_parents -= 1;
+	} else {
+		/*
+		 * Legacy... So that old DTs which do not have clock-names still
+		 * work. In this case we don't explicitly enable the AXI bus
+		 * clock.
+		 */
+		if (PTR_ERR(axi_clk) != -ENOENT)
+			return PTR_ERR(axi_clk);
+		if (init.num_parents < 1 || init.num_parents > 2)
+			return -EINVAL;
+	}
 
 	for (i = 0; i < init.num_parents; i++) {
 		parent_names[i] = of_clk_get_parent_name(pdev->dev.of_node, i);
-- 
2.43.0



