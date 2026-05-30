Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DE21B87C0;
	Sat, 30 May 2026 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166674; cv=none; b=RXGPQ29koipgUxwShwmol53pGODXLQWLzoHRkknDwjuPhSe1DLK0f0Evd6QLw3HrMTnXyzARnvPGRCJBNpSrKJyC9T0IbWXIiCFfsA66mPcmq5+gvYW9jvR57H+AztAEqjGGQyPJhi0c9eFdEI/1fusj7Kl5zszpVeNvLA0mqfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166674; c=relaxed/simple;
	bh=GRXAIb9FfDGHiARp1XyzJ+notyuM8qHQSPmtv6xg5w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYHZIC6DnVzeSzBOwIn+HoPs6XvV1vkUDuwk7Kzeh1OtC01F8GcwA3r4+BsLx4NDa7ct0oL4K8XIFxMAqLuT6fJyDfNtcfxNwj9Y+/ot1pDZjZD/9/EbGL4vERQLdmtZTxKxAUf+ah1gE2I8nxRzHm2nPMiDk5l3Kuvxs7DYwpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNmbQTVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNmbQTVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377841F00893;
	Sat, 30 May 2026 18:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166673;
	bh=sp/cQa0MlCuwRnzxjpDdjfGxC4yHgbLFsHyesxMg4wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNmbQTVWO5KJbIXX5aXzkNff1OA+H9pKG7JzRTDqcQKs073EXDZeM96foWtfNRAKj
	 9TopMUlrVVKtoaJt2lroIt5wSKog8fl80SCFPHIKCDztwqBPWwzehR6eyObSPXBD+M
	 hP6qLa2pubiEmKfM+LIuopQTzpGlwvEfNEanto2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/589] clk: imx: imx6q: Fix device node reference leak in of_assigned_ldb_sels()
Date: Sat, 30 May 2026 18:04:43 +0200
Message-ID: <20260530160235.337858415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1a262b9b56e53..89400f4312252 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -183,9 +183,11 @@ static void of_assigned_ldb_sels(struct device_node *node,
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
@@ -193,9 +195,11 @@ static void of_assigned_ldb_sels(struct device_node *node,
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



