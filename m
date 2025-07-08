Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF78F5B;
	Tue,  8 Jul 2025 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992926; cv=none; b=gvUzL7LQFvAbWPEZoCpboR6Rj9JeDZNWvBTvccBwibmFFCdhwkeQjUNNFShRzZBCC89pOngicNcrHHG/1U2c+HQU4Mk6ACw7flAT+Z3g1OKVJGqFIsYwE//XiMIkd3qYHNea7CXPGPAobGGh/6UxuU156ri2aupDglVq9U/iTd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992926; c=relaxed/simple;
	bh=509NGWDV0CNv0luMW+xJKzP5f1PN3ycPgoMSXVSLwoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgSnKuKlBHfO4TSYU+/RtIMHwy7BH97hbYxHefixlRog1FsxLWZrH0Cc2eKmmXUZKp5bIeDGCnWFT11sPzzwMncym88FsDoOQg/lKdUNG9cTwHhpEks5I0VcN6e8Tx1oBruPwgWOE/OUsYdwi1zjc//4D5T5NSZYsy8aUx+GQf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6A0DtVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6A0DtVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D00C4CEED;
	Tue,  8 Jul 2025 16:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992926;
	bh=509NGWDV0CNv0luMW+xJKzP5f1PN3ycPgoMSXVSLwoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6A0DtVmz4qzs1+QxEehFO84QG5k1ZuM28A7e8ZA0Wu9eOXUsFmpxoOfy+BT1QUnj
	 7Wwy9kUWpJN9lOlpDcSUV9LSEyhMp9mEiLSNb+yoboSNIJaknWayPPp4taHRuUVZtZ
	 smigZRFRGYfT8n71IjtYazJc33fH5wZCUTzMQohE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/232] iommu: ipmmu-vmsa: avoid Wformat-security warning
Date: Tue,  8 Jul 2025 18:22:03 +0200
Message-ID: <20250708162244.766153955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iommu/ipmmu-vmsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index ff55b8c307126..ae69691471e9f 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -1087,7 +1087,7 @@ static int ipmmu_probe(struct platform_device *pdev)
 	 * - R-Car Gen3 IPMMU (leaf devices only - skip root IPMMU-MM device)
 	 */
 	if (!mmu->features->has_cache_leaf_nodes || !ipmmu_is_root(mmu)) {
-		ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL,
+		ret = iommu_device_sysfs_add(&mmu->iommu, &pdev->dev, NULL, "%s",
 					     dev_name(&pdev->dev));
 		if (ret)
 			return ret;
-- 
2.39.5



