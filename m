Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9638F35AC27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302686; cv=none; b=aRLuWeMMX82YffXFHODonW/FSsya7IVuGyMs42BFKUxOM7soWG+4LUx49yntulS9U9tPpcE2+x6AR1XdeDDyd66Voc+qHyZ9qtNNIBrN5381Eme5T5vslYew823Oz3/OrCVMInGTsKEYu5DWQLSZ996b2YzFqHhUdf29p4GjnfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302686; c=relaxed/simple;
	bh=++b7e3q4Gl1ks5wxooQ9685e5HtF9g1z+i2Q3vuS6fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJUhTi9FlNASrwdIbDPp1CVgaDDmPOVN/0cjLzpxox1dVt6LUKJVNhFB+eF9lms5G4dUpTXymtOThHM01Id2Wi2ITH2Zc0BUP0dkJ9DECiz7weaR3kERmY7++FQgU1n3uZCelpciRlToWLjU9y7vGjWptSb4TNZTth+Wr1FdvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uU84d+Sw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uU84d+Sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C6EC116D0;
	Sat, 28 Feb 2026 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302686;
	bh=++b7e3q4Gl1ks5wxooQ9685e5HtF9g1z+i2Q3vuS6fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uU84d+Swi0zIjyxH9dMt411RLAvwzVoqHTMIrReRsAf2vEub3ZDvFvzobL9BsDlTb
	 bpotkBT10CSEEv8zgMN/1/e+SOvcp1Fv96jVz2p24fwCv2PtyW1DLchWcZeK/vERG7
	 3vnKBx0pfBUyUC7XqXVSq8lDow3LyEltAC3dK87tMvPDeLnA0ZhuH6go8/MjZ8JzA3
	 xsPj944VNQhHPcWsHo1wyDDS17ByyCAKke2UmD3BX3NTt06JGzWUP3UUDpQ/GkPnXE
	 Ujqz9uHPnOVlSSzQiDzyvkBPvJjdkv25QR4jGKQIotr+3n6qmfpKrq/n84gr8My8hm
	 vI5Xmc61R+FSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/147] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Sat, 28 Feb 2026 13:15:46 -0500
Message-ID: <20260228181736.1605592-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 006bb28e2a6e5..f9bbd5cab0a05 100644
--- a/drivers/soc/qcom/cmd-db.c
+++ b/drivers/soc/qcom/cmd-db.c
@@ -319,15 +319,16 @@ static int cmd_db_dev_probe(struct platform_device *pdev)
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

