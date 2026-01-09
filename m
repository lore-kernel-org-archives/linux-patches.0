Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7135A95C;
	Fri,  9 Jan 2026 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961633; cv=none; b=LNjdtVpmaRbxwQduZ3ocksPeFOKIA+8rQrXvGRkzUE6Kx/vSC7tWqF3nrseZzL8S8R9hidZMw0LyIBNUuRkBjtkszDZoMYStBbf0h4TpgOulQxOJggCeRZxTogrsgxwROMpm5kdcnTqMAKjL3M2BybaMkLYQMrErAsHhAOce5cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961633; c=relaxed/simple;
	bh=eK7xY2xeWXyR7MDisOJ/jNz5rJasFh20Cgf123w0aug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAlSX7IFm9mJR+gy6qS86WPPFG4J4rD/mzW82RZACN2FVHPBwmbaHAVa8URkmaaq+EdvneBg3QvN+o0ekGQZEF6ocD7AYYPdqLxtSp2/ChhDnrj2tvgeGI6lSSw4togLE736ruVRtqjsXAQdEVX+vyRi1Ln/A/Gkv2Rupr73vpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZX/L27x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZX/L27x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A3DC4CEF1;
	Fri,  9 Jan 2026 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961632;
	bh=eK7xY2xeWXyR7MDisOJ/jNz5rJasFh20Cgf123w0aug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZX/L27x2a0lTf2k4cU14/GnyH/IvAsj/XNa6DjcpHrDIMhbnbnHgX6fodvJtKc2R
	 +egDbmEhV0peM0L0PNrA62f2bLMo+zxHKJQVlvg+f4xwlGlJO4q8yPgst/cMsdAdKS
	 Yg8TYrS/7Sm3Wgknv3EB8+1fM+wDQf6pOIgSlqEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/634] firmware: imx: scu-irq: fix OF node leak in
Date: Fri,  9 Jan 2026 12:35:43 +0100
Message-ID: <20260109112119.891686127@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



