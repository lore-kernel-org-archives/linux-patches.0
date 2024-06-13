Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063391422B5;
	Thu, 13 Jun 2024 11:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278731; cv=none; b=JsX5hmaGcJd3zeK8S3GUCbMJ6/+d6Xc6WBxIFP+1DiE4/rPAQ/hQX+Ig7K/i2WXH4S+mvLf4621xDYLSMnsjkNEFkvOsZ95LVIcbcO47rouh1ouLwg7YGqnCcQLKVQEnSoYElXJZlvpI4J8ogZc8aX4mnUmwya90NyIayJ7HY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278731; c=relaxed/simple;
	bh=7n1F6q8mOGmSlyOW86tcKac6EzwFaSsNlo9RpNWMkaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClFnQqtoBlP5tCDucwa4n8cjYXKCToqULNmF/vQ3wu9NUjbxRfODx8auqRQOY45Fn1fhVhjXUCfrf2Yr+FZfBf52iBVH4y4Q/HVzp9RpbqCZ50IgB2Ggy1+j8udld5ERzpnxHki+CnarnTJUmfJ10UlWdkjuVEHK5CtPaVYezjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2qzo4+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2qzo4+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E630C2BBFC;
	Thu, 13 Jun 2024 11:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278730;
	bh=7n1F6q8mOGmSlyOW86tcKac6EzwFaSsNlo9RpNWMkaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2qzo4+WlotW70Ty8M/wps342kqmfkJ0QO0Tp5vl8b8Uf6vMja4hjnIxUc7pzPx9T
	 ny632W3OqY78nCnisq6sCn0xpG6CdAx7WchemQs5IL0D8v/TOMLoV6RbY06iiNC2xi
	 jXivV9k89gxLOjoxxuQ3iXDxneKMeWQ0QMxSwkgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/213] crypto: ccp - drop platform ifdef checks
Date: Thu, 13 Jun 2024 13:31:08 +0200
Message-ID: <20240613113228.770555341@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b75dc7db2d4a1..8494f7d8912c3 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -42,44 +42,38 @@ static const struct sp_dev_vdata dev_vdata[] = {
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
 
@@ -227,12 +221,8 @@ static int sp_platform_resume(struct platform_device *pdev)
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



