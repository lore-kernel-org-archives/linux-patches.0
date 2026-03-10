Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AB241C303;
	Tue, 10 Mar 2026 11:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142148; cv=none; b=HD3kwu4yXg6iD2TYNwfTmr/Mf2W3UuwCY7rxLZLk+22+i17NuyGc7gaejXqIZwf2uCdpa20Om6bcXgsOD09ucNPYWF9mzDfkajqnG4h8TiNoEXuOy6RAKZt7gzh23wDxs/BXOmUc85eVXkMZlZxKcPJVN+Feguo9jwa0lxtxiZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142148; c=relaxed/simple;
	bh=bMFQ9Wn3/4vkCtCXjtRmkn5wXiD5GPTTJSQtGrDfthM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN8mNTNGOZJ/JOt2iWHiBNwnUxLtfym3uClSwKsUoRi+7tkbukfH3hxsnTnmVRGeG3Zu0WLKBLP2/TpCGBZd+9O+viH4j9+DONXz05RZ9I2kB7NK3/rhSLfVRLmxCXMLVGvH01/2bhJqTRFBoVfDBTZweP3c+A3h7XKWFbi/AZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=liQW74x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="liQW74x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8A2C19423;
	Tue, 10 Mar 2026 11:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142147;
	bh=bMFQ9Wn3/4vkCtCXjtRmkn5wXiD5GPTTJSQtGrDfthM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liQW74x1GnQ8gTiwbEbHlx1dMc3159CrkZrexGL0cz4/ix5YbXlHvi9fAIAzgTi6J
	 2iZNY/SykVAP4k2wq+p74r4dkN/y7neS/gxy5IbNI0qZ/ZCdt8i0YAyi2bsLOsUl+X
	 7uJ66UgvHZ+lcsEaLfduX4yN19IDCgOaztGJgHzql2BywOS3h/q1/uJ2JhH+NECg7j
	 Ppttw36CJ0WtgeTO2oPgkKJAZ9CI1OG+pWqf1xBN1dI8vkqH/Dgin21QQppvo0KRbv
	 RSek72RZUT/O4iXBBtfrqJ0kGtNPH79IWtGhr2V9MpzH4mm6Zq8aX/7PxuSmy0aexb
	 cVFgb2O4owAPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Junrui Luo <moonafterrain@outlook.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/314] dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler
Date: Tue, 10 Mar 2026 07:18:14 -0400
Message-ID: <e42d44889b139613e7310e9d5c1844204081d977.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 74badb9c20b1a9c02a95c735c6d3cd6121679c93 ]

Commit 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ
handler") introduces a range check for if_id to avoid an out-of-bounds
access. If an out-of-bounds if_id is detected, the interrupt status is
not cleared. This may result in an interrupt storm.

Clear the interrupt status after detecting an out-of-bounds if_id to avoid
the problem.

Found by an experimental AI code review agent at Google.

Fixes: 31a7a0bbeb00 ("dpaa2-switch: add bounds check for if_id in IRQ handler")
Cc: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260227055812.1777915-1-linux@roeck-us.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 78e21b46a5ba8..e212a014c8d41 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1533,7 +1533,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	if_id = (status & 0xFFFF0000) >> 16;
 	if (if_id >= ethsw->sw_attr.num_ifs) {
 		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
-		goto out;
+		goto out_clear;
 	}
 	port_priv = ethsw->ports[if_id];
 
@@ -1553,6 +1553,7 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 			dpaa2_switch_port_connect_mac(port_priv);
 	}
 
+out_clear:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
 	if (err)
-- 
2.51.0

