Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C383346FDB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302339; cv=none; b=hTBOCYFxJzqCFS5mA/4i3VmJqZqertnlMiAajNaYT48KsVFDnDeUqNoKueTAQCe/4bD6zsdssUu03GERSu9BVTQVIGoIu6xg3j6drj0jDhIpF3m/0JNQTJndwE/DC8p8+tcLic4Zuc0pcx6bKVhhmsQqbi+Ah6xJT6ZjyfOeOyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302339; c=relaxed/simple;
	bh=b2656q9LAZG/a1g7EZCgxoAiwX51pHKJc4Qy+7muudo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkY+LOtUTrQypHkKONO4xkSlwEMrz+SljOn0IzqTzC5/+YESfKM0vjKVf+YOfBBhQ6JtWUtQBH2NLg8W5yWnuq8uk48OLraJYITR1oGxvIVBWiZHvOQyNJlzE418L8E8fPWE0RDVJ0QAMCrOeGKK86Uywo1bSgdLKByECx1bIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OU9OVMNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OU9OVMNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9445C19424;
	Sat, 28 Feb 2026 18:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302339;
	bh=b2656q9LAZG/a1g7EZCgxoAiwX51pHKJc4Qy+7muudo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU9OVMNXHNWxCw8bJAcUHyJ1drk3XvPBp0e7N4mrGvyvGwfwSuGWBzPrw1TNXX2VO
	 etQ3ZjOT3ktLW0d9gY5svwKwl5Ltgkm7ZkYp9nwJLkRBxlcRTcZrrRsMHLr4cVmgx9
	 wSngvqZPkO5Vdu3IjDpMGSHuXQAf4Jv3/3VYuRANFv0zRc6UaTVJW0a5mtd64ANC34
	 hek/hE4SLlx2QyA+3p++ilUOhbvJiulQF5WxzT/FaBpZgvxKNVpo5Znf9u4Z15nuTT
	 SYrsLILxZthWpIf6iW8Mm3YAUmNolp39ncfqv4o+dyWBP3jZR8BRKZpWzHbTDeALc/
	 uEfNqoEtzORBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/232] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Sat, 28 Feb 2026 13:08:34 -0500
Message-ID: <20260228181127.1592657-61-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 81ddbcd253d92..0b0766a79b19c 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -354,15 +354,16 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
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

