Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433AEAC5;
	Mon, 15 Apr 2024 14:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191598; cv=none; b=UOFuc1Ys0MCtrgtWXbmDlJk9qfSDj6wwRSdAbkgNWCvVgSC/5IoEbF3oIt41Z+5ODh8AdI5bs4h5e436BG727MCULmFoE3fNW2yveD2wLj1Gxi5rSfDdEerpn0UMf56oMMeXMRvehxyOJXIqU7x5LmGXl2HkcCoOWWAvMC34u3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191598; c=relaxed/simple;
	bh=tccBUkab2QodR3i4Oa0YMZmll8ujrxhdkW/0bdasmlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdVo00mW2NYagjawu47yW/ioxoWslggcgcC6p/p5sg73LLxV+4L6nzs5M9tWwM5UljVvbHPk4KU1S2sQoIZZ8v2A0MYtvbL9uMkkSzBJikJ76HmXlrJ2aIAFfYDu9QAToPVFWz/Dlz8aTis9m8C1ZEywgIhRHZtAHzduIzsmsQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNxVqIXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNxVqIXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F100BC113CC;
	Mon, 15 Apr 2024 14:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191598;
	bh=tccBUkab2QodR3i4Oa0YMZmll8ujrxhdkW/0bdasmlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNxVqIXy1XqfZf0fN7OsBjv6SO18ECzlT+LC3kM4XNEkNkvi7kjXb8IgGBZjfmq31
	 hPJ4MQba7pND/6Y0Uj+N9eSVEJbBBBLpCgFuO1Eygoe/z7agqEGlKY0P1v2rzKQVmt
	 wTV24eXYEM0BW5odGVUoGX4YMbpiPLPtH3t2y/lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/122] cxl/core/regs: Fix usage of map->reg_type in cxl_decode_regblock() before assigned
Date: Mon, 15 Apr 2024 16:19:48 +0200
Message-ID: <20240415141954.069737922@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 5c88a9ccd4c431d58b532e4158b6999a8350062c ]

In the error path, map->reg_type is being used for kernel warning
before its value is setup. Found by code inspection. Exposure to
user is wrong reg_type being emitted via kernel log. Use a local
var for reg_type and retrieve value for usage.

Fixes: 6c7f4f1e51c2 ("cxl/core/regs: Make cxl_map_{component, device}_regs() device generic")
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/regs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index e0fbe964f6f0a..bab4592db647f 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -271,6 +271,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_map_device_regs, CXL);
 static bool cxl_decode_regblock(struct pci_dev *pdev, u32 reg_lo, u32 reg_hi,
 				struct cxl_register_map *map)
 {
+	u8 reg_type = FIELD_GET(CXL_DVSEC_REG_LOCATOR_BLOCK_ID_MASK, reg_lo);
 	int bar = FIELD_GET(CXL_DVSEC_REG_LOCATOR_BIR_MASK, reg_lo);
 	u64 offset = ((u64)reg_hi << 32) |
 		     (reg_lo & CXL_DVSEC_REG_LOCATOR_BLOCK_OFF_LOW_MASK);
@@ -278,11 +279,11 @@ static bool cxl_decode_regblock(struct pci_dev *pdev, u32 reg_lo, u32 reg_hi,
 	if (offset > pci_resource_len(pdev, bar)) {
 		dev_warn(&pdev->dev,
 			 "BAR%d: %pr: too small (offset: %pa, type: %d)\n", bar,
-			 &pdev->resource[bar], &offset, map->reg_type);
+			 &pdev->resource[bar], &offset, reg_type);
 		return false;
 	}
 
-	map->reg_type = FIELD_GET(CXL_DVSEC_REG_LOCATOR_BLOCK_ID_MASK, reg_lo);
+	map->reg_type = reg_type;
 	map->resource = pci_resource_start(pdev, bar) + offset;
 	map->max_size = pci_resource_len(pdev, bar) - offset;
 	return true;
-- 
2.43.0



