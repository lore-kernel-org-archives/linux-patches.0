Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D197D148FE0;
	Thu, 13 Jun 2024 11:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279835; cv=none; b=YfBfui8cz9m2LkpeedJEY9ZQokkY0mYrMtiwLrQcDY1YtU+nk7sGgvMmepcN5qdrYeN9vzV4vozti7rb0FImN792BbIkLyi7KSmA8PZS8GTQ1CmHjA8woD0wjWA/Rid6cYrYe+aR6ML/yGPWmzgFaLu5YltWM90Pj11gUOfY2sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279835; c=relaxed/simple;
	bh=gqVjQN33rpq8zk33NnYTA9kXq2myhpAjfXqjVa/5Lg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/GaQBOMTG5bOJGv21uX+Gj+OJwULOOaqJ/D/sVoQiFGYQ8Co2apuuraVlZvaxZx6Bp/5VT76XHJPn3CrMaReHIb/MmvYHN/d6p9x/SWROdj8nswY+wTqMgz+7NRg1AvjWFVIvggRhyL1nm49xJEOUMAvc5pSRkHkCZ+HU2P17k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yB7/DJr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yB7/DJr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B867C2BBFC;
	Thu, 13 Jun 2024 11:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279835;
	bh=gqVjQN33rpq8zk33NnYTA9kXq2myhpAjfXqjVa/5Lg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yB7/DJr5weqGALuXw0GnbS9xbU52LxZQKV8K15qnMO0cPKO2byjw9583TKHNRlKNP
	 0ijUloJoVH4wOzoiMJW5o51a3dJqU4YZDPb/sglOQUPZpGzspHupE+05IRemXX6FEB
	 72yziD7DLHgkwQmOxZbl/r89OmYatSO2dGAxM/Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/202] crypto: ccp - drop platform ifdef checks
Date: Thu, 13 Jun 2024 13:32:00 +0200
Message-ID: <20240613113228.625021791@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 42c2d7d02977ef09d434b1f5b354f5bc6c1027ab ]

When both ACPI and OF are disabled, the dev_vdata variable is unused:

drivers/crypto/ccp/sp-platform.c:33:34: error: unused variable 'dev_vdata' [-Werror,-Wunused-const-variable]

This is not a useful configuration, and there is not much point in saving
a few bytes when only one of the two is enabled, so just remove all
these ifdef checks and rely on of_match_node() and acpi_match_device()
returning NULL when these subsystems are disabled.

Fixes: 6c5063434098 ("crypto: ccp - Add ACPI support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sp-platform.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 831aac1393a2f..d7a226b9d6221 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -39,44 +39,38 @@ static const struct sp_dev_vdata dev_vdata[] = {
 	},
 };
 
-#ifdef CONFIG_ACPI
 static const struct acpi_device_id sp_acpi_match[] = {
 	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
-#endif
 
-#ifdef CONFIG_OF
 static const struct of_device_id sp_of_match[] = {
 	{ .compatible = "amd,ccp-seattle-v1a",
 	  .data = (const void *)&dev_vdata[0] },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, sp_of_match);
-#endif
 
 static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
 {
-#ifdef CONFIG_OF
 	const struct of_device_id *match;
 
 	match = of_match_node(sp_of_match, pdev->dev.of_node);
 	if (match && match->data)
 		return (struct sp_dev_vdata *)match->data;
-#endif
+
 	return NULL;
 }
 
 static struct sp_dev_vdata *sp_get_acpi_version(struct platform_device *pdev)
 {
-#ifdef CONFIG_ACPI
 	const struct acpi_device_id *match;
 
 	match = acpi_match_device(sp_acpi_match, &pdev->dev);
 	if (match && match->driver_data)
 		return (struct sp_dev_vdata *)match->driver_data;
-#endif
+
 	return NULL;
 }
 
@@ -222,12 +216,8 @@ static int sp_platform_resume(struct platform_device *pdev)
 static struct platform_driver sp_platform_driver = {
 	.driver = {
 		.name = "ccp",
-#ifdef CONFIG_ACPI
 		.acpi_match_table = sp_acpi_match,
-#endif
-#ifdef CONFIG_OF
 		.of_match_table = sp_of_match,
-#endif
 	},
 	.probe = sp_platform_probe,
 	.remove = sp_platform_remove,
-- 
2.43.0



