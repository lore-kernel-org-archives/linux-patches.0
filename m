Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA2D2ECE83;
	Tue, 17 Jun 2025 16:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176748; cv=none; b=doligC0Ch7pqCsp8bp6wqy4o1OB/SziwN9r9V4wqA+9/0vDIbzHJTLU0PwUKM9BrgDiaq0gePl20XNODNpXvgUe75J7UzvYlnkO4p16PvffoloYWHbZf5lD5M2zJHnLgmBlHlkG1M75QsAfbnU5eMcvX9IiDDJ023c8r1XYnwo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176748; c=relaxed/simple;
	bh=W15U66n+rWrWb6lNIpFOm5P/ZUpplSmPXR6Zek0OpLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3Se9tx27gB211n9qv2F14R6KJgB25X7+SXboKB1iXMtapeE7BrfbR9FBlET0V6iOKwR/wLAAOmWTLY1spNsp1JcDaGfTPKad6JlBBgHP0BQO2a7qZCUk86zcRh9lVr3M2COopyb6qpDhR1IuiuJIXWS0vtM66TXY4OC3rMNK60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxN8Qc1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxN8Qc1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0351C4CEE3;
	Tue, 17 Jun 2025 16:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176748;
	bh=W15U66n+rWrWb6lNIpFOm5P/ZUpplSmPXR6Zek0OpLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxN8Qc1OvTc3ZpNi5CSREM34ZF3QzPriCHeEpp888qPPjqLtjAww6TLVYPuOn7Q2Y
	 74F13bjzhVpgt6+51OyPe/2AKeX7GpT4I1O58hHqPqNkEp35ABwYsAnhXGeg9z2Kpg
	 0yY9FUiIJG1r6y3dnCgUueJJfeG0QdtNYzbZ6ZI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 222/780] iommu: ipmmu-vmsa: avoid Wformat-security warning
Date: Tue, 17 Jun 2025 17:18:50 +0200
Message-ID: <20250617152500.496468916@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 33647d0be323f9e2f27cd1e86de5cfd965cec654 ]

iommu_device_sysfs_add() requires a constant format string, otherwise
a W=1 build produces a warning:

drivers/iommu/ipmmu-vmsa.c:1093:62: error: format string is not a string literal (potentially insecure) [-Werror,-Wformat-security]
 1093 |         ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL, dev_name(&pdev->dev));
      |                                                                     ^~~~~~~~~~~~~~~~~~~~
drivers/iommu/ipmmu-vmsa.c:1093:62: note: treat the string as an argument to avoid this
 1093 |         ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL, dev_name(&pdev->dev));
      |                                                                     ^
      |                                                                     "%s",

This was an old bug but I saw it now because the code was changed as part
of commit d9d3cede4167 ("iommu/ipmmu-vmsa: Register in a sensible order").

Fixes: 7af9a5fdb9e0 ("iommu/ipmmu-vmsa: Use iommu_device_sysfs_add()/remove()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250423164006.2661372-1-arnd@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/ipmmu-vmsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index e424b279a8cd9..90341b24a8115 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -1090,7 +1090,8 @@ static int ipmmu_probe(struct platform_device *pdev)
 	if (mmu->features->has_cache_leaf_nodes && ipmmu_is_root(mmu))
 		return 0;
 
-	ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL, dev_name(&pdev->dev));
+	ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL, "%s",
+				     dev_name(&pdev->dev));
 	if (ret)
 		return ret;
 
-- 
2.39.5



