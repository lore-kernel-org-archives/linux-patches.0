Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D74336D9EA;
	Wed, 20 May 2026 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298865; cv=none; b=Q3f1khfZtaCCiESvpi45GZTATEK3A0jFjTOCoktQT0f/qoEA0EKIKSa9uhKB9cCpnZnosZs/valIsJi1GZfQr1Yvgl12gLVS8scJAcPiTVqedqUvHwUcUw5pl1CuUZQMVGA3exh7w+E4l7uEjONECCP2Ob8TeOv5rjL7EeLC724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298865; c=relaxed/simple;
	bh=mqRF9lr5ddDgmMNQdPgt3DryfjpETRcvVSzRvW4yAPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/oTuKQ3Taj7nC4LI84OprvezheOYe7QcbplIOruxMaHymlzwd7ytYk5BS9Qn7yW77AvOpY+RKnRukIvIa7rd317aeWo2xQfdmeQyLwJGIKTcRejKpHJYLbjDHSfQbvNQX72laV+YjLdKUjtCBmAgq4W6G0BGSw1aiSc1K1Viio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNEk63au; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNEk63au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F0B1F00893;
	Wed, 20 May 2026 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298864;
	bh=K93w9lcbx7cofnxtyvswu6Ne9deJLFRWgLLwJQDuhoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QNEk63auymEdb3qD+ke488Ipqt4dFklzRcbwX0e2tDuBb6ktYvU2G+fxlKwkmqBOV
	 Dv0S3scXzSNTHlQus0a54gpBt3rE6loZFPP9A4YB7e5bWQKZUvlEDZAwDMdbbC39Nj
	 FK+fhaYRmtjj8Ih9sOY0kaBjU/wM0Hf3WeQaKh1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 571/957] clk: imx: imx6q: Fix device node reference leak in pll6_bypassed()
Date: Wed, 20 May 2026 18:17:34 +0200
Message-ID: <20260520162146.914379120@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4b84d496c804b470124cd3a08e928df6801d8eae ]

The function pll6_bypassed() calls of_parse_phandle_with_args()
but never calls of_node_put() to release the reference, causing
a memory leak.

Fix this by adding proper cleanup calls on all exit paths.

Fixes: 3cc48976e9763 ("clk: imx6q: handle ENET PLL bypass")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260203-clk-imx6q-v3-1-6cd2696bb371@gmail.com
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx6q.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-imx6q.c b/drivers/clk/imx/clk-imx6q.c
index bf4c1d9c99287..ba696cf34fe3b 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -238,8 +238,11 @@ static bool pll6_bypassed(struct device_node *node)
 			return false;
 
 		if (clkspec.np == node &&
-		    clkspec.args[0] == IMX6QDL_PLL6_BYPASS)
+		    clkspec.args[0] == IMX6QDL_PLL6_BYPASS) {
+			of_node_put(clkspec.np);
 			break;
+		}
+		of_node_put(clkspec.np);
 	}
 
 	/* PLL6 bypass is not part of the assigned clock list */
@@ -249,6 +252,9 @@ static bool pll6_bypassed(struct device_node *node)
 	ret = of_parse_phandle_with_args(node, "assigned-clock-parents",
 					 "#clock-cells", index, &clkspec);
 
+	if (!ret)
+		of_node_put(clkspec.np);
+
 	if (clkspec.args[0] != IMX6QDL_CLK_PLL6)
 		return true;
 
-- 
2.53.0



