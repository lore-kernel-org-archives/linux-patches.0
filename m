Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E37383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302039; cv=none; b=BcI9xSiC8FQf53jMWe66UmArH9mXTNKpbWd0GsrJsIoe21Lo+QX541jxCQ6i4Qf0hHn47X69YjHfCGJa1yMpJq+zZ66AB2DVaeCxPXDrg4jaN5LIrCm/KB6xek8zrZgraCpPBv/Z+Z6IkIb27r6VY8AsjEWiequBiLeyAii7fxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302039; c=relaxed/simple;
	bh=V5hwf1Zli8+7lHkcjOvzffvUhfC0fUJ03Ds1/YO6tDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbFZvo0NMjIXgDik+N7owf02sY1X89GfoJlq35x7z6idSJjss9CYHPsibnxPmDguy+K8nDe3RR9/ewa/5ZEhxJFSPHPMu2pU1/lpsgrNmpKpXI6WWV9sqgWatIctMtona8PaRzoX/O4qI4KL4H10jwwsu3z0Gc8VBYjiNR4W2pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnwZ3IBJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnwZ3IBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC275C19425;
	Sat, 28 Feb 2026 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302039;
	bh=V5hwf1Zli8+7lHkcjOvzffvUhfC0fUJ03Ds1/YO6tDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnwZ3IBJ6VgHOlw090IM/Nchk6MwrL7ntjG/1Kx7VIT0DTcPg6Lth1e/FwA0lx4+y
	 MK0TkEQpJu1vimnIMYU5Ldb4QLCUhRwn1jtjwMRfvBusst/yX2vNDCObFHBS1/F78f
	 4WI0tAD6uZWyTqFFtLTERQKapE23FxnXJ9gcVa62SFGnlcpxh8p85Fvsmrq1qWoC41
	 IP1AjQnml5epTbXWZL+jR2CRYYZI3gte+bRgOZHeUd7ievRAGrXZUihmGTjhlqWRLQ
	 XIO9JCVRVgN+4RQm8j8ZZ3uYAoEqllGAQyZq2XKkmqtJorwkuG+Yb/tPNBw5i0p+ij
	 KJ/OUj1GjjPwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/283] i3c: Move device name assignment after i3c_bus_init
Date: Sat, 28 Feb 2026 13:02:33 -0500
Message-ID: <20260228180709.1583486-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 3502cea99c7ceb331458cbd34ef6792c83144687 ]

Move device name initialization to occur after i3c_bus_init()
so that i3cbus->id is guaranteed to be assigned before it is used.

Fixes: 9d4f219807d5 ("i3c: fix refcount inconsistency in i3c_master_register")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260112-upstream_i3c_fix-v1-1-cbbf2cb71809@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 060f70e4d52d7..0c3434e357e26 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2769,7 +2769,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
 	device_initialize(&master->dev);
-	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
 	master->dev.dma_mask = parent->dma_mask;
 	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
@@ -2779,6 +2778,8 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
+	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0

