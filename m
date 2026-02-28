Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACDB346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302086; cv=none; b=egFyAFLOj2xmwFRGnjZ8mnCsI6BoU4gqv4uJO4jjDj4VI0I54vBojZfWmNcCJwxu9OeMtt+xleWz4bvjJaBAAVy1USMtEomvOqHQyWn6q/8/xtmLTN6XBMV2mq5jZ+igsG4aE6ejHIV3WDj6XqRjI/vGcw69NQuj165lJYfwk0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302086; c=relaxed/simple;
	bh=3FPiAuskEIOK1rZ+JWR7SED3oDpIc0l85Dhy6msfJW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asN82lPDVOgzq9zsoA3swhPlp3v0/UA3EXokerXjNajY+Ib2c1Radmqf88PRSA7TIRsZP40K5yYakoG4OC4FQ4GFO3mvX5gq/qn/rYQSCbnHnH9IBFT5IhizgZAKaqT43nCis3p1AIW/62SKep5TRL+nsAF1/54UkIhDDzY0CX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1k1S0v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1k1S0v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154D5C19425;
	Sat, 28 Feb 2026 18:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302086;
	bh=3FPiAuskEIOK1rZ+JWR7SED3oDpIc0l85Dhy6msfJW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1k1S0v1GE0q+kFVV10GTaeXeBT3tB22+52oQUdiMYfkXPVQpRSJfJMZq/Fhx3SOH
	 5YYHYbaVpsFS2ko9GzlMQPL412yWiuHPwi/7iD0kRoW8JanN6WaXC04wQNJfgdZ7Fr
	 QzXQbD6a6ZPIWEWfckAR0XIifiqCGzQl2Z/3AE2kihIgMWG6l+5Wju3UfFKqOWIiB/
	 Hy5Eobrnh6+YmSzFrWjHN84mD4pVrLZOq62JKx0GD012b6PjtmIAlKbKZ8Rdt4fwwe
	 tswKFQzt47s8SC17B5ym/PmjVkud1YeP4eL5G1sLmfJBCKM6AV2ImbMariTXsEqxWJ
	 QGxuxwPv9xHEw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/283] soc: qcom: cmd-db: Use devm_memremap() to fix memory leak in cmd_db_dev_probe
Date: Sat, 28 Feb 2026 13:03:31 -0500
Message-ID: <20260228180709.1583486-69-sashal@kernel.org>
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
index ab2418d2fe43a..0c54a9525baf1 100644
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

