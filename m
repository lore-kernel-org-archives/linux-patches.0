Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA8B39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302540; cv=none; b=DUdcRwkPeDYHSr4oUJ5lCuMj2rMw/1dXGlcXNu9+atXEGYcIgqJDYrIWMIODoc4QBoSI2BJH9WpqTHKWsD4+roUCgEHioRSGMvswdUD+XL7xfU5PaphWBO4WTUBZ/llWr5lY1gWeSxriGXAXrtpSTmTE0VNR9ezMUz97QNB4Egs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302540; c=relaxed/simple;
	bh=fcOSjGMNm1DjiQ24JNDPwHG+5dzy8DFSqnVUT8hmPWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bn2H2HXNMsQyROXJi3XLLxJD7ey34sItNeKuybt3LsezC9E6PD/0rRwoP62Li2spsZ88AOdBbWI3cGZV75I0t9/RkIx35r5bH2ZefW8pBJJ8EAt6UGC4GIQeLOucEBQjaDqNdUR1FOId4uH4QMd23U8EDuhi/bpYFY3W75iKveg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uxrnKcF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uxrnKcF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC84C19424;
	Sat, 28 Feb 2026 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302540;
	bh=fcOSjGMNm1DjiQ24JNDPwHG+5dzy8DFSqnVUT8hmPWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxrnKcF94q9BLL6RjndRXNslH+sXvrD4J300y1YPNd9B6hi6DFae9Z9ZNSZOnGeUy
	 ahDEhhTjqiq5AZDp6p5vg9ibL4DjcjaOVnh7DH77OC5XZ51PRvR1lFMQe61c+AKHcF
	 L+lvRfcetYBanqA+0Q+uYaf7qACaiwielrz4uqOaK9f5Scr/awNzEJaxtiDhPMUNf/
	 ru1gq3QazuRrPbffCedRBDn6V91PvM8/4VAkul63dq07ctTcToNw5BWEKOtwwIyajk
	 IGRlNfGdU5MkZFg93IGFmW1grGrKqjWc8uG4aV7E0fnlmRUMSuKj53/bvQfV8Jx5pl
	 GkFcHkrUEBMmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/164] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Sat, 28 Feb 2026 13:13:00 -0500
Message-ID: <20260228181505.1600663-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 6cb5e3956fc52..7854f49611cd7 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -350,15 +350,16 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
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

