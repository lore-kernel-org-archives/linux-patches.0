Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748173A35D9;
	Thu, 15 Jan 2026 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498910; cv=none; b=A3nq2lpJt5pYMBG78WP1dCOelKjN75fe4HMCj17ZaB1DgQHqkGa2s523BvadnHR6mkhBZQAY3rdcQLZP+re+uoO5b+ZVeylwRV8NKrrOJyjiArsy7ulAkh4WV44YVdnuVAGvre+dloYdmaIBFg4kTVjByWMcRQRoJcQb5FoO7KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498910; c=relaxed/simple;
	bh=mhF6ylQVaa3cnXRefkNYgtWIFF/IpLlIrbmwnopMbT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5LpnX74FkTvBRUOq8LzTi+JjtihqPWqiWKvcjL1yoNLKHSuAdXtOwV4V5zk3G61NhFdye+A+59OcvvtKv1w9/HlDifAXoB/5wGUbt9p1l3s6cTpy1nueD+azKmbsISi1QQnfYxKQFnKnz5USlS3QVxRrqrL++l+TzUW3n6RqEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9lWhkJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9lWhkJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00100C16AAE;
	Thu, 15 Jan 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498910;
	bh=mhF6ylQVaa3cnXRefkNYgtWIFF/IpLlIrbmwnopMbT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9lWhkJDgUM67zD5vL7QcrLMWpoZfoRwFSBmxvzOjlGL1IUgt+IBRmn/CDWrReTRO
	 /SraRm2m25OTKiUdeziF6vUCZxayICnBn334yhikQ6OTkqLv5pn5+SCQHcDWQ43RWn
	 pj/DprtVqaCZn81pxP9udM08OhfUnbug4vYKc5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/451] firmware: imx: scu-irq: fix OF node leak in
Date: Thu, 15 Jan 2026 17:44:02 +0100
Message-ID: <20260115164232.378532575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index d9dcc20945c6a..32b1ca4e10508 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -160,8 +160,10 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
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



