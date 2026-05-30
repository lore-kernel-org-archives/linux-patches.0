Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2690F340A6F;
	Sat, 30 May 2026 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164401; cv=none; b=qV0UxXIS9EwmFDt1M6p3hQKwEHmQBavuoWD9NopNZMYEeWeI+u6aA7ApO2xJxoUznQjTV7CIo+dCoE96pGxdoB99KrXwgFS8CFbdPUbVnm3Z6V1YGC1iiVxvSvfhopOvGyCyjkzavkeOVN6D5xcTdq/cCW0NKluixsxClXUeCWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164401; c=relaxed/simple;
	bh=jWV+5VJw41GA9rycJ1y50MZ8hCxYOIQ0hFe+CM/Qd0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KKlbEuBXBDdVjNYiXyy3Yr72WouAVhwGcbg6RwXycZBhLLYPdmWMUJvW4cbqXveD+zk0HXUDTkjTZYvWtuFr0kWgJPyo1PSBvSFOBy/bcgbrdx9MdMFuprc5toSiXhGFDJKkk4IlhnXZQ5wItXIMxvnS6jAm70/LKzWvXZHqusc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7zC4YDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7zC4YDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3DC1F00893;
	Sat, 30 May 2026 18:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164400;
	bh=K2RhuAEMRmiwX4ZrE6KASRLSda3M2vKjJtjZC0ynA0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7zC4YDX1qvhG6zRGl5rWgCcKHjCMTVrZhu7EIckP+urdF3l1k4iBvWGvmS1uDCVZ
	 pDfp+Y1UvQlr32ef/4HBYoeXchVmllb5hYgnbU2sfMo3FqIF5o2lLwRi4+gwinVyH4
	 87J7IuTZrisqz5k2oiyoAH3zi7iJbcRrhTBPc2G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 543/776] clk: imx: imx6q: Fix device node reference leak in pll6_bypassed()
Date: Sat, 30 May 2026 18:04:17 +0200
Message-ID: <20260530160254.210621015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index de36f58d551c0..b14c1606466d7 100644
--- a/drivers/clk/imx/clk-imx6q.c
+++ b/drivers/clk/imx/clk-imx6q.c
@@ -233,8 +233,11 @@ static bool pll6_bypassed(struct device_node *node)
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
@@ -244,6 +247,9 @@ static bool pll6_bypassed(struct device_node *node)
 	ret = of_parse_phandle_with_args(node, "assigned-clock-parents",
 					 "#clock-cells", index, &clkspec);
 
+	if (!ret)
+		of_node_put(clkspec.np);
+
 	if (clkspec.args[0] != IMX6QDL_CLK_PLL6)
 		return true;
 
-- 
2.53.0



