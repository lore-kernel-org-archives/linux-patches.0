Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C338735CB7D;
	Tue, 16 Dec 2025 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887038; cv=none; b=f3ae/biYa7qYB5UCjwhRfB4YZGBWFnGhYtImH/fsMKr0yCnhvV3T62rIye/x6iZmXvj7QxkZo1LkcR1zOrdvSGNGhwNeACEU44Ook88WQnvK6cfhD0MzmxI5ILqMcIBpT6n/9z4RqLRcT1nkl6DCgmi7NpoJBwprcpmcQoT3sGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887038; c=relaxed/simple;
	bh=aKcBT3Kq/7ReCt+3kS1ZbtOaADtGRDgevpk3r5FD8a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQ98lQ390Ezfv5XENhi+D0oLjurrmgmGe6E5KLIQNfaghiH/KDov6EuvnYP8jq6Fo1kgNoG9VMdxjPvAYdwHruwQFJVnxZgVjs78+qxT7p9oH4lqQE1TRk5yn4r3gZpcEVg3fwpc8xwhDRlBM5/RYxgWi2tpoMvJjHiK7nZsMEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTd9L1jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTd9L1jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C6BC4CEF1;
	Tue, 16 Dec 2025 12:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887038;
	bh=aKcBT3Kq/7ReCt+3kS1ZbtOaADtGRDgevpk3r5FD8a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTd9L1jJjHQTmOeMv6iH/GV3e1dUYPqq3l13fwBjpY+TsjI4TZHgenKova3UYpBDa
	 OJwb00nyfZNi8e3oimbbMdsqmXi5WOC7mNHotpsB6IVgb2EypVEOhmcDTUeoIQ1S2J
	 FJ/Dsl/jOWRp65AYHEHPa59TGYJTUJaHlUhGcbHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 109/614] firmware: imx: scu-irq: fix OF node leak in
Date: Tue, 16 Dec 2025 12:07:56 +0100
Message-ID: <20251216111405.285428754@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



