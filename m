Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D704A15FA85;
	Mon, 27 May 2024 19:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837303; cv=none; b=rRLlQ6IWkH0KLl2je9UEDlEJFXTfhhJzv691+okySottmVsI+OdlNiC22S7YyvHXzJCjKjXTP2e1Mp2iSikveE6Tl/D907KkeA90sY3EHLX2fsV2pw6DRP1ogc8EKRLSyC5x1DryDDm8fyjXUk17Nia/jINEp99FThOQDwlZxP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837303; c=relaxed/simple;
	bh=/AIuGzMNWZJHscZ6EpeowurhI1+QyPhqKEWAWQoWDH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iyll+K62oRb0zpehtWdWiGf005s/J6ALda1gxMdO2RqUT/lFfeVvWUhTSpwxwMLNYTBG0xxmAFFuXq1465XeWA9D3NB/zFLJXcF1l1ZnjrU2rL1iM2Tl84w8AUHoi4QhMjZsSq8TUBzHo2nZ6U/QBwlmN+4OBqS5GkZtao4o4XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ic7KjU6h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ic7KjU6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9B0C32781;
	Mon, 27 May 2024 19:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837303;
	bh=/AIuGzMNWZJHscZ6EpeowurhI1+QyPhqKEWAWQoWDH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic7KjU6hl3E9xRDTEpj03IGztWIYysSALmur3ZP5V00hRUun62KXKbB8v+3K6iwD8
	 JvyR6LTdOYSQkcfmurzswDkJe9CVcAeGpIxv3kJaMlKQbwFvFzfxlM6YEyPIewjzll
	 ubSZoaQq/oBcPjNGhOJHPZIXOl3fjgdZXDoBi0P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klara Modin <klarasmodin@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 389/427] iommu/amd: Enable Guest Translation after reading IOMMU feature register
Date: Mon, 27 May 2024 20:57:16 +0200
Message-ID: <20240527185634.765081969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit de111f6b4f6a3010020825d22a068f416bc29c95 ]

Commit 8e0179733172 ("iommu/amd: Enable Guest Translation before
registering devices") moved IOMMU Guest Translation (GT) enablement to
early init path. It does feature check based on Global EFR value (got from
ACPI IVRS table). Later it adjusts EFR value based on IOMMU feature
register (late_iommu_features_init()).

It seems in some systems BIOS doesn't set gloabl EFR value properly.
This is causing mismatch. Hence move IOMMU GT enablement after
late_iommu_features_init() so that it does check based on IOMMU EFR
value.

Fixes: 8e0179733172 ("iommu/amd: Enable Guest Translation before registering devices")
Reported-by: Klara Modin <klarasmodin@gmail.com>
Closes: https://lore.kernel.org/linux-iommu/333e6eb6-361c-4afb-8107-2573324bf689@gmail.com/
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Link: https://lore.kernel.org/r/20240506082039.7575-1-vasant.hegde@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ac6754a85f350..f440ca440d924 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -2097,6 +2097,8 @@ static int __init iommu_init_pci(struct amd_iommu *iommu)
 			amd_iommu_max_glx_val = glxval;
 		else
 			amd_iommu_max_glx_val = min(amd_iommu_max_glx_val, glxval);
+
+		iommu_enable_gt(iommu);
 	}
 
 	if (check_feature(FEATURE_PPR) && alloc_ppr_log(iommu))
@@ -2773,7 +2775,6 @@ static void early_enable_iommu(struct amd_iommu *iommu)
 	iommu_enable_command_buffer(iommu);
 	iommu_enable_event_buffer(iommu);
 	iommu_set_exclusion_range(iommu);
-	iommu_enable_gt(iommu);
 	iommu_enable_ga(iommu);
 	iommu_enable_xt(iommu);
 	iommu_enable_irtcachedis(iommu);
@@ -2830,7 +2831,6 @@ static void early_enable_iommus(void)
 			iommu_disable_irtcachedis(iommu);
 			iommu_enable_command_buffer(iommu);
 			iommu_enable_event_buffer(iommu);
-			iommu_enable_gt(iommu);
 			iommu_enable_ga(iommu);
 			iommu_enable_xt(iommu);
 			iommu_enable_irtcachedis(iommu);
-- 
2.43.0



