Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B88E646;
	Tue,  3 Dec 2024 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239132; cv=none; b=F7hCdxno0DLjQ5xCL8sC47AARuKgGaFrsEwNGx5e35a2dD3wy6RGj5FzF4HM1jNgpfccvmoJh4Oay6WtxsqYUeUboGaiaqM2s7JyKJuP6A0IF5n0hw1dVdZuRwkzMD5h5AM7E4WXbrgX8QXgumsvuj2IQMWCPytkpmaizFC3yDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239132; c=relaxed/simple;
	bh=LtqxKH5NRHcKDixSFTde9uHOIaxX5MnKqTqaUdz3vMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVxnq1mAYZyiz+rhdK4GlJu1TK1eHj4oYHOrIl8oa5ponlVGXcP6HTQyXEONFB5d0sCuOQtLqp+YmIaDyI75M5UANLDm+TTeWj/sE3fG3ogKJSkPhdw/7avoBoTepwUFYF1StErLkQktiAju4NgNkDynvXaQHzYGZA2B+EO6P5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeC585D+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeC585D+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FA4C4CECF;
	Tue,  3 Dec 2024 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239132;
	bh=LtqxKH5NRHcKDixSFTde9uHOIaxX5MnKqTqaUdz3vMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeC585D+A6EcsWmFiHjuCdD2wOcdBFUr8k3j/BufS+aJlrm9gf+JwntcFlv3j9Jox
	 0ytiyL54WTOhyB6iix0FuDBVT2PLfRk9R9bdL/sdLWzSv2EmPAtwFXIfV5vJkP4nFA
	 ALGoHkHSA0REd3YL/h7w9bHkrJgqLgKY+QKOxnx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 473/817] clk: clk-axi-clkgen: make sure to enable the AXI bus clock
Date: Tue,  3 Dec 2024 15:40:45 +0100
Message-ID: <20241203144014.333929509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



