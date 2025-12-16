Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D7D341645;
	Tue, 16 Dec 2025 11:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884143; cv=none; b=it6WJtPydR49Q6dttDlcR3IPLOlr0rh+cn3m+sOYLz5yAQHwmWpgvGiaFvUNorjABZGNjbjUmVFS1N/GTBmOMqokuOMkr8cjDyEchJV3pcDa47rYWq/50LjisBM9Mz9CTpD+a5sybPr/lwLINPwW/ijljqzokavcAabSFttVKoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884143; c=relaxed/simple;
	bh=QYpNl031yafH8MYfpRP6e7+UqXaZFVkPhCSdeb0BEuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jodPd7UPZgUd7TainjOot7MNH9BFDP0UAy+AxfRe1lXr5jfVP2DVxTpkweFzZMiYiC0H3P629q55NEiDk85N6T+AbMr7D8hTFA5ft9pAQ1iPfL1rl0KfmvFZjYj9rO14T6rWM2Z2lJ4fgfWFtT/eIrOZdb0OqZj0oXMHknJ3wNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVV8LW2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVV8LW2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1196CC4CEF1;
	Tue, 16 Dec 2025 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884143;
	bh=QYpNl031yafH8MYfpRP6e7+UqXaZFVkPhCSdeb0BEuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVV8LW2eOZn9E2p9zEu56x8XQEvr2ZeB+xCuQsv71/OV9MleCdJwzYXAOLYj3e0FQ
	 ynCYOZ573RSxYIjU7kF+9aT29MNXLT1jOHze3eMVr4G9BaiA5dA6TRvk9GV895ZKxM
	 m6uK37q32jbEFQQrQTPRtjED+pTBO5hp2Ez/HgKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/354] firmware: imx: scu-irq: fix OF node leak in
Date: Tue, 16 Dec 2025 12:10:38 +0100
Message-ID: <20251216111323.497385802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit ee67247843a2b62d1473cfa4df300e69b5190ccf ]

imx_scu_enable_general_irq_channel() calls of_parse_phandle_with_args(),
but does not release the OF node reference. Add a of_node_put() call
to release the reference.

Fixes: 851826c7566e ("firmware: imx: enable imx scu general irq function")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu-irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/imx/imx-scu-irq.c b/drivers/firmware/imx/imx-scu-irq.c
index 6125cccc9ba79..f2b902e95b738 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -226,8 +226,10 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
 
 	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", 0, &spec))
+				       "#mbox-cells", 0, &spec)) {
 		i = of_alias_get_id(spec.np, "mu");
+		of_node_put(spec.np);
+	}
 
 	/* use mu1 as general mu irq channel if failed */
 	if (i < 0)
-- 
2.51.0



