Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F3A3FDC06;
	Tue, 21 Jul 2026 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649648; cv=none; b=MBAr1WscJVljRAHO2Ic8llm+SX5KWwwGP1NhdOPP+EQBU/o0Xa4qAXbrxGtgkQYSN7eGrXeSuaTbk/zlYDp0WzW2r5eIOe1ew6CUhm46KvFe/s4NzX+yPfWo5FwNAQMdHz2VMbhhI82zYuDqVZgnMHSAumkYU9Nh5lb5Viw1SDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649648; c=relaxed/simple;
	bh=otVKAPrMez6xA63AYNSrb5yckhWcOlAaH/Y2NVfMB3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bhue9/y51F8QXNgX+dHt01QRRNPPZfOCuzEs2kQhdKtOdzOmqguHVn2Z4QECqL2058GAD2KrULP+P0qFTdC2LIZIeovwtMDV21Zdlx/szHSsE6dRBZnqrEoMcumjIE0N6jkUL9fUT4IeBc5OUefznLIPWO7xE33pf759/34prVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPne/jlx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPne/jlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D71F000E9;
	Tue, 21 Jul 2026 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649646;
	bh=1LUIZjpWrRlwfaXY6OOx6Hg1gI9KjxtkdNcb4EjwqR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPne/jlxmJMe6YTbcd2Dr7OgiSyCN9UZkcZc8uumWyrkmNFANtEZxbxkmUVK6wWMQ
	 n+8DLBD7Wo2Zj8CnrddCRf+X4RsW9Hr/Q/eyLCDn0Rypk9DK/i9YfzaNfDf3+CsZxx
	 lsFvJ2wWlJrSux4ta9qyTckhspQQRa8TGW6wpliY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0657/2077] cxl/test: Zero out LSA backing memory to avoid leaking to user
Date: Tue, 21 Jul 2026 17:05:30 +0200
Message-ID: <20260721152608.300808980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 60f065dbaf46e65830da62a0041761f0c039e086 ]

Memory through vmalloc() is not zeroed out. When this memory is copied
into output payload, it leaks memory content to user. Use vzalloc()
instead to zero out the memory.

Suggested-by: sashiko-bot
Link: https://lore.kernel.org/linux-cxl/20260605173146.2B9A31F00893@smtp.kernel.org/
Fixes: 7d3eb23c4ccf ("tools/testing/cxl: Introduce a mock memory device + driver")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260605184426.4070913-1-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/cxl/test/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 9a7cd3f46a1ee5..739343cd58022a 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1724,7 +1724,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
-	mdata->lsa = vmalloc(LSA_SIZE);
+	mdata->lsa = vzalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
 	mdata->fw = vmalloc(FW_SIZE);
-- 
2.53.0



