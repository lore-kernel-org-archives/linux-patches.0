Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23CC149C4F;
	Tue, 25 Jun 2024 10:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309641; cv=none; b=qB+qndOwFHc8rhpSS6syAwzmrHAP+PA2kZeWslpXUkf4BnQIO4Cnbw6qIYpeTGRGbEPHQhuz233FRg0A9WgWxtnpP7Mrn5pHv/rJQ7QzO2gfNtQZ7Vj+Oc0roBUnS1caKEwHWxZODqKa4nAI9FQSAz+f4Jee7MbMrEfK49/jW1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309641; c=relaxed/simple;
	bh=z3EOpDELPxMgZPQnX7vq65yNcRyTcfRkK3JjuDP0mrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAqllHby7ePia/evT+uqRDMv5kg7/bVd/XjIUHvt44qQJgJbMUHi169bSrLthOtse7ZQgdFrR6gaZQ9+yyvQgTZ1+27e9/jGs6xwOga/Dfn/OhTJFhZf1OiAXuWBWEJxp4FNLYppncsjC/dMNygQiXLB/JluNOsfmj8Hp8lURrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQjoHjG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQjoHjG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2572DC32781;
	Tue, 25 Jun 2024 10:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309641;
	bh=z3EOpDELPxMgZPQnX7vq65yNcRyTcfRkK3JjuDP0mrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQjoHjG8BciM52RhwWJx/qK+Ap6bFyy756rdfzFjxnJ46UkOF8AwemMH/WgA6qSot
	 yPlT7rPgyo99H9eNCJuUHa4nEcbRLtifG52wcz5pgW3ao8LK9UTqbRwk04txb+X7J2
	 vElbK7thLnSqSLjRgHE7/x0wpSygx4J/fOKCh6WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/131] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Tue, 25 Jun 2024 11:34:00 +0200
Message-ID: <20240625085529.171398352@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 5422145d0b749ad554ada772133b9b20f9fb0ec8 ]

Fix missing kmem_cache_destroy() for ioat_sed_cache in
ioat_exit_module().

Noticed via:

```
modprobe ioatdma
rmmod ioatdma
modprobe ioatdma
debugfs: Directory 'ioat_sed_ent' with parent 'slab' already present!
```

Fixes: c0f28ce66ecf ("dmaengine: ioatdma: move all the init routines")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240514-ioatdma_fixes-v1-1-2776a0913254@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index d54b3f120b4dd..ec8b2b5e4ef00 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1448,6 +1448,7 @@ module_init(ioat_init_module);
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
+	kmem_cache_destroy(ioat_sed_cache);
 	kmem_cache_destroy(ioat_cache);
 }
 module_exit(ioat_exit_module);
-- 
2.43.0



