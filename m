Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F633D6F7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301619; cv=none; b=DuzhgoeuajYOti2rQuDrYmthBLv7CUlGDHnwtV5jBFJUm0NzsiA1p9loUfy7JT6X730YF4WLLAH+yK/K9cMaqmW22fN/q1gMrzfdoIUKVCH4Oy/HtgYqogXM9+cWnUJZ/C27csEYeld3GzOOCNOEb9uXwQEhpn76h7a5mWPxP3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301619; c=relaxed/simple;
	bh=GtAP+K6Aas0k4ypEd45MVyAwd4JugamZ1feR8n+SRSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMsaJ1DFoxRe46zi2WQpHFlsxp7bqLwezzOIX8J9b8xsdi4VcwuimStucWRhZdxLZlRUUVfF3fDMUpiV4mvBd7G/PM+IptFwM5R6ha7X2p9SLrQ5M4k74Ar/VPYRbXFtx2NI9ykQ16vXHQpr3FKUYjdCC+k/XIEbTtCGF95+Mwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Apl8syrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Apl8syrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A56CC19424;
	Sat, 28 Feb 2026 18:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301619;
	bh=GtAP+K6Aas0k4ypEd45MVyAwd4JugamZ1feR8n+SRSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Apl8syrIlDzPEJWnSaeBcTx9WgRSje+z+H7luukn82FoskVl0+Gt4hwUtc054W2K8
	 Ffxrxi8SZoOrIqsAXVNrxvbJAJZMGOzR/a1BX2h13yDiK6WwCIyVv0YNVSQ7CYQqbk
	 J8LJ2mRyK4lCfBcrb6TJtkWEcjv047kRR5eVk6jG/l4x8b0/RnlRSY8PoAVqRH1Kar
	 uRPLRt4iHFASljINXcH/W8MTE0WoyT9+z/vICu0f5uH8/CuVQqP+SnBZqDX6J2cmUA
	 39mZhgPwt6FkCgpQQDD3x420YOYWEmn2gCAQ4yih0Vw5Lri8F1UH208ZD4kZEBqt97
	 qYVqe9N5SYKbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Billy Tsai <billy_tsai@aspeedtech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/385] i3c: Move device name assignment after i3c_bus_init
Date: Sat, 28 Feb 2026 12:53:51 -0500
Message-ID: <20260228180011.1568201-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 6eb779affaba8..5c0cb3f38c90b 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2810,7 +2810,6 @@ int i3c_master_register(struct i3c_master_controller *master,
 	INIT_LIST_HEAD(&master->boardinfo.i3c);
 
 	device_initialize(&master->dev);
-	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
 
 	master->dev.dma_mask = parent->dma_mask;
 	master->dev.coherent_dma_mask = parent->coherent_dma_mask;
@@ -2820,6 +2819,8 @@ int i3c_master_register(struct i3c_master_controller *master,
 	if (ret)
 		goto err_put_dev;
 
+	dev_set_name(&master->dev, "i3c-%d", i3cbus->id);
+
 	ret = of_populate_i3c_bus(master);
 	if (ret)
 		goto err_put_dev;
-- 
2.51.0

