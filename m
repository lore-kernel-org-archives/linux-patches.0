Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9550D4028F1;
	Wed, 20 May 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302486; cv=none; b=YlNg0+8POhLOF5W+uyfK1mEv/mDTSAn5S3vlSlSMzb8JCVcawbZCCPAPhQQ1BqByuMvRoChpveoJ31E4ZL/PqgMuGkeN6WdPgjjeLYIZmEiwR6MKqEIc21RqThUKvj+3ROY56ryLioNAEQY3owHrmIuDXsjcEiKN63wyAmYKPok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302486; c=relaxed/simple;
	bh=LUTxLl5/1Sk/BfcLC5GDIPnUA2UaWkFAsByrE9ScjlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6R7wQRW70TcWSKVFm3AQR+H5rnrDnhtjDMrqKHXQ+pL+jROm51xlnQk11Ce7pG71u29r5GpQDXqJS84PB3BkSeeuge9ZA8nDY8xynTThioB8KXrmFGgihFsWvijmvXPh7Dhl1ELWNIKSGy74gG1xF+Un0tLKPyesLk5Bz9Klp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXNvCgQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXNvCgQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F811F000E9;
	Wed, 20 May 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302485;
	bh=OmLgnAERAwKG2ozJ9dYWQx6oWYbCrppljnV9h2gy8uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXNvCgQE0jgnca/qBKDHZQz3hbyzsJccNgZVvtqzuXHBSZNnF39nXUGyyvwnOHhOE
	 dTh1LgldpmftmviDq/lTsPEqx5htYxdpsMycZjiFL4r2ZnVHx0jwUicQMK7gSbywKC
	 2XTDX7sB+BtPCCFBjIpzQ8B/+0aOJFjtdl3xJ1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/508] clk: imx: imx6q: Fix device node reference leak in pll6_bypassed()
Date: Wed, 20 May 2026 18:21:47 +0200
Message-ID: <20260520162104.797395040@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



