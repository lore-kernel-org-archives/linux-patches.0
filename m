Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1293EA979;
	Wed, 20 May 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296235; cv=none; b=fxdDNmNu2Syf1sdKsSh+gFhKHcPs7SEViN31gsjT0gZH9yZKMDXb5p1mpIU01WU1dMVAx+mHO2WBpOqnDJF0vbzDJwwRH/e+jcRuWq/DBgSQ8X5BHltnfYjUm2L1EQQdDW1mKRnHAlVQP+hxE8DMVxTShQjnMBdJcewgz7f5ZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296235; c=relaxed/simple;
	bh=wEMxza+1Jk7mzujdHsdd5Iww8tddzzJm9IMHp5Hq2rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn/zGoPMryIZFRrhc6OKiCtDUfpSDWa5CwdbjE0PzQanHFg2tfvEgdJqsYIcA6tzqXZ3tqBhr2NOLcMf12vi2PrAl1Im/GS/tFd5BI4/HhAW1Nyffd8Ubqd39y4PYiRAIMZt0MlW4xjYOuN/fYNlvIn3OcYfLHcOgxBB+7Hsppg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Tkpol3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Tkpol3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B727B1F000E9;
	Wed, 20 May 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296234;
	bh=EVIFlMzUJh5bGh9i9yvHXH6LBSfA+PyjQ2QqgOtro7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Tkpol3pIb1SkD8SI9HYeOdNu7cHC09mqFCWvkrVldO/jR2pzGhOtflm9wmaXSwB+
	 okNjOpNPsKuYlhUp/g5K6TZBNKg0v8Xu229iziNQMBpXJ2qRNIueLNVKbcNmjNdSX9
	 ye3AAYyjhJiDOScufWfdWPQJIpXKuD/DVkCoqeGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0721/1146] clk: imx: imx6q: Fix device node reference leak in of_assigned_ldb_sels()
Date: Wed, 20 May 2026 18:16:11 +0200
Message-ID: <20260520162204.521341229@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 9faf207208951460f3f7eefbc112246c8d28ff1b ]

The function of_assigned_ldb_sels() calls of_parse_phandle_with_args()
but never calls of_node_put() to release the reference, causing a memory
leak.

Fix this by adding proper cleanup calls on all exit paths.

Fixes: 5d283b083800 ("clk: imx6: Fix procedure to switch the parent of LDB_DI_CLK")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260203-clk-imx6q-v3-2-6cd2696bb371@gmail.com
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6q.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index 5549ef6c31173..35e6b59c01dbe 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -188,9 +188,11 @@ static void of_assigned_ldb_sels(struct device_node *node,
 		}
 		if (clkspec.np != node || clkspec.args[0] >= IMX6QDL_CLK_END) {
 			pr_err("ccm: parent clock %d not in ccm\n", index);
+			of_node_put(clkspec.np);
 			return;
 		}
 		parent = clkspec.args[0];
+		of_node_put(clkspec.np);
 
 		rc = of_parse_phandle_with_args(node, "assigned-clocks",
 				"#clock-cells", index, &clkspec);
@@ -198,9 +200,11 @@ static void of_assigned_ldb_sels(struct device_node *node,
 			return;
 		if (clkspec.np != node || clkspec.args[0] >= IMX6QDL_CLK_END) {
 			pr_err("ccm: child clock %d not in ccm\n", index);
+			of_node_put(clkspec.np);
 			return;
 		}
 		child = clkspec.args[0];
+		of_node_put(clkspec.np);
 
 		if (child != IMX6QDL_CLK_LDB_DI0_SEL &&
 		    child != IMX6QDL_CLK_LDB_DI1_SEL)
-- 
2.53.0



