Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF39472533;
	Tue, 21 Jul 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656618; cv=none; b=Yi8DKUihjPbf+qemuphxz2KbQ54KwUesjBDCktsp89lW0aZNcLUWqx3DU+IqSFTyBNrzZEx8+CJQwPes86CZFFC1V4Axotcr4jydE+ChE3uAQEf+6B+Gn1CzwnjGxqlgRrAuRLmGt0kxoN6GjUI08DUJ6NoEZgcHHQEcneylaH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656618; c=relaxed/simple;
	bh=1wSo7VywfHkaiOui2ivWYsVfoYSSko2l27CkzBeR+qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQMJDrLavclUL3p834pC7zN4oB8N2utn64BuUb4bnbuDJUU6+hIl4jUjNezaIVo5BIVXBCnVOJVln4yWlfM6WfluJwlJOWNlUC+NXfaUCgxueIJI/Pf2Mv86wC0hOPCO3nhi5DVONXGCA7l79jDkuCv2pvu6+3SS6HkKL5+/Bs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ic0k0oTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ic0k0oTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7E21F000E9;
	Tue, 21 Jul 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656617;
	bh=dH2ekosJDI6LDjnNJDbBxo7dDwaAO9qyXCO89sMMBwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic0k0oTHYq33wBKQbNvP8pAx+adunFnFqZ/NdXuwTB/5Jf6QcsKhCWKS5hv27DChW
	 /azsnjNpNNsiR1rep6PXOdJgtEsmEODhvvH8iam6EssLkC9zXlkG52SrP9rKORg8Kq
	 mOzWyxvc58WbCcFYv5inQJErJsBxSfGre3nAbpLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0454/1611] cxl/test: Zero out LSA backing memory to avoid leaking to user
Date: Tue, 21 Jul 2026 17:09:30 +0200
Message-ID: <20260721152525.516717334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 4474d5d74faf2a..2b5c78b7a2d9c1 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1701,7 +1701,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	dev_set_drvdata(dev, mdata);
 
-	mdata->lsa = vmalloc(LSA_SIZE);
+	mdata->lsa = vzalloc(LSA_SIZE);
 	if (!mdata->lsa)
 		return -ENOMEM;
 	mdata->fw = vmalloc(FW_SIZE);
-- 
2.53.0



