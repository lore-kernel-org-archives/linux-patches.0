Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2334252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301711; cv=none; b=fjqXnsAAptIjN7EgLEJM027gTLPvVlapCqNpEDGWBzP+PIxnOjth+iqXtIuX7PuuGQt0u8bOf+LIAr43Hx0YmeJWa31aCx0+JkfZzxsG5MFNYOdj7H6S3nspJFYopxOxEij45Vb904soRs6PTKhoeMvYZOt6Fj5WmY0LXnLz5TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301711; c=relaxed/simple;
	bh=gMr+H+1VK2Cmt3aSmk/qwnImV8FSf3IWWqlTNnDiKTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0N1aB/m48ZL+o2WXowAdzYVFJgHTo/7b4Pn+KWCCxiw5VAggqm7mlh2e8YyIvktKDGVd41gO2pJdEjEvptpLrhb5WcG9Sb2czp5trm93IosnftA5/I8xoPhxBQSiTbtMLvVEEIs7xY9EJwjwkJN6oSk6hnWqPwQ7oAI3AIAJMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBrCdrBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBrCdrBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E70C116D0;
	Sat, 28 Feb 2026 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301711;
	bh=gMr+H+1VK2Cmt3aSmk/qwnImV8FSf3IWWqlTNnDiKTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBrCdrBVMoH3AdcNZiNCU6dwUuZzODChUIEKlY1TiQzEHHsHgy3bxNJthNUhpdmhm
	 /UoFftlvKibu6yFHTuMwmBReNDCRRHkIzGdX9e11ScWIy6oo0XHp8oapUdI/pklsma
	 5olYcxooWYIo1PiP9qtbhkCCrdsPO4534ef/48+tC0GzFPdGWYcPauhuP19kL1CcY5
	 BGn1T6PrOdYRjMJYzsPtTp+zCC96zG82Llwo8K1F6s7HcQpciGQZCDI8C1cCZYRzOc
	 shq+N4oqJrhzDFvxFc61MKbkfEiyodGS2eEpHVZE9v0CM/crQ2E/gdy5hyitlvhutB
	 GfdvP55PdXkeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/385] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Sat, 28 Feb 2026 12:55:28 -0500
Message-ID: <20260228180011.1568201-106-sashal@kernel.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 0da7824734d8d83e6a844dd0207f071cb0c50cf4 ]

If cmd_db_magic_matches() fails after memremap() succeeds, the function
returns -EINVAL without unmapping the memory region, causing a
potential resource leak.

Switch to devm_memremap to automatically manage the map resource.

Fixes: 312416d9171a ("drivers: qcom: add command DB driver")
Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251216013933.773-1-vulab@iscas.ac.cn
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/cmd-db.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/qcom/cmd-db.c b/drivers/soc/qcom/cmd-db.c
index ae66c2623d250..84a75d8c4b702 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -349,15 +349,16 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	cmd_db_header = memremap(rmem->base, rmem->size, MEMREMAP_WC);
-	if (!cmd_db_header) {
-		ret = -ENOMEM;
+	cmd_db_header = devm_memremap(&pdev->dev, rmem->base, rmem->size, MEMREMAP_WC);
+	if (IS_ERR(cmd_db_header)) {
+		ret = PTR_ERR(cmd_db_header);
 		cmd_db_header = NULL;
 		return ret;
 	}
 
 	if (!cmd_db_magic_matches(cmd_db_header)) {
 		dev_err(&pdev->dev, "Invalid Command DB Magic\n");
+		cmd_db_header = NULL;
 		return -EINVAL;
 	}
 
-- 
2.51.0

