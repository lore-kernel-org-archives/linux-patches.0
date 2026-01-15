Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043E258EC2;
	Thu, 15 Jan 2026 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497364; cv=none; b=We25u9aebeQfukiD2P7xHHOSNIW7fhvtIbCI1ZVoEFbvPx7JL2Sy3Jd00zBTlfD120ilu4tW1h1KNUHYk3nS2RG2RDaBjX9KXt9MYGtqwyfrxV+0JeJThyxJuf7qgOm85huBn5oSh5/Wj96wuMYFy+00jygp7AJ6kyh4pz28wNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497364; c=relaxed/simple;
	bh=+NXsEYxw98adp6PbXurqNFGljDs8adHoMTm2QMfhhBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gguIm/RUr8NxutvJBtlPr5CrMoneR+2O5qZYF/9L1Fy8GOWZ56kTAe6nZ0QrM9FfvW0r78LA2wm2oNw2cW4djui9CLkV4D9ifpZcgeziOuSfbYhKl5RDCB7HVXUGWW8O9Fgw1Y6MsJKwYnt0lUJgjeHNJPs6EOaLyeB//itkkxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wcw7tDM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wcw7tDM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9EEC116D0;
	Thu, 15 Jan 2026 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497364;
	bh=+NXsEYxw98adp6PbXurqNFGljDs8adHoMTm2QMfhhBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wcw7tDM/0taKNX+lw9AHM5+4D0uo5COZyeVfjgnj2wB8XvFN+Po8l4LNGCyhGHRFk
	 8fzNzxUZL9saT2R4FfNQbDI/GYytRUcp7IgUcIItqJbrN+W1xr+DmRPM4VFh0iIQLe
	 zh9x8BzDzlE36nlDl6K51eRU0auiDejOyGF/iHfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/554] firmware: imx: scu-irq: fix OF node leak in
Date: Thu, 15 Jan 2026 17:42:00 +0100
Message-ID: <20260115164248.200056930@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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



