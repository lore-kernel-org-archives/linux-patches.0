Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6077197533;
	Thu,  6 Jun 2024 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683155; cv=none; b=HAwOaNEah54+lMJE/g4ilQ5WP8+NZH/dF91Q5RAow59rFZIQEpt1d5N9+36EEZp3rj65ALQaSbYqCSMLuGHphXPTuQMXTUEg4RM4eDE+qq03eQLV0YugXE0Ori0Q9/ZwiwEBepTq7ZGlJa1V5VTz+5OlD+H0Ed6WXexUiQB7wB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683155; c=relaxed/simple;
	bh=eP+xp2nyasIUm+4p/2ZoRB1FKc9WIU7OWWGQj1Xxq2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SK25yMxaGM2FzEdL2tH9kvLiAUoShWAhsqlf0xqAWoGLylIFXcewB+vvYXZGAdc7/SeZGXE8WU/YyiWaiwRMfsXqnLyDYE3Vfc5wU8tHO1UXIdxjdNHPez2WfU+0P9cXJcu8VMwvvwPZ4g3ZInKruM4agPx+nJo5yeDwUn8Epq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+4/HjW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+4/HjW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866FAC2BD10;
	Thu,  6 Jun 2024 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683155;
	bh=eP+xp2nyasIUm+4p/2ZoRB1FKc9WIU7OWWGQj1Xxq2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+4/HjW71pbf42/awRXPdA3Zi2tfQyNAhKcvzJhlOtYMJ2aepb/QuUcHtOM5L9NUL
	 nlzSCwOPJIHvJGfBC22Z1tPF8BFeCLBc3atht9n2HHVriICJ6yulFtA5zO7uS8Pkb0
	 beYFezaEd0Q7OBvbDyXHQj+CGfR/jQxRoppsQ1SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/744] crypto: ccp - drop platform ifdef checks
Date: Thu,  6 Jun 2024 15:56:12 +0200
Message-ID: <20240606131735.597289718@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7d79a8744f9a6..c43ad7e1acf7e 100644
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
 
@@ -214,12 +208,8 @@ static int sp_platform_resume(struct platform_device *pdev)
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



