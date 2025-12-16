Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA5F34C81E;
	Tue, 16 Dec 2025 11:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885282; cv=none; b=uxsIxDaIB31h5cxFo7HYXOmy+Bq1AhbZ4fl49ZCViRr7Ho7ee5OloEU5uheOCVW0T1CoU9lrVx/adejWiasyXuD5moWaoJDKxh1QR17XgrbuWhwhYgMtbMn5ueKlLWgrMnixPn2TraT6PL72fAb8C4tpQnfHPudOc5nH5a/67to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885282; c=relaxed/simple;
	bh=+yo+4E6UYQOl1J4NHb3LI09yFtLqKnLT2oYcA3ZSBRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbP1VxZp1nTfgX27uYKl3hrG7OqElSPRReGCjEOuMg/e6DW0ezlvzFu8DglGICsOo+wrFs3qrZrASDJZjX8L/DUuOIL76NQj14HuV6/USylQzYUInZl2PSsjDQ4WEWs/ivLDqX5yS6pMxM6H/Vd/T1cttlIzsaP1DnjiU43FZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVMI4DHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVMI4DHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1296EC4CEF1;
	Tue, 16 Dec 2025 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885282;
	bh=+yo+4E6UYQOl1J4NHb3LI09yFtLqKnLT2oYcA3ZSBRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVMI4DHWEhK7xo+1SboomLT5kt9XjNCEDl4qKHos4nXk1v43Ba/I2U0son/Wy20DQ
	 FBQcORNWiFHiqeovJcVnr3HsEjcQHMEJuEeGnnsskexvzHu/NBXRvHfkwY/s0WWWTS
	 6j8nDQaqvMnBSul9kgbSwgOavlOib0VqzO25EwzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/507] firmware: imx: scu-irq: fix OF node leak in
Date: Tue, 16 Dec 2025 12:08:52 +0100
Message-ID: <20251216111348.835602385@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



