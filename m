Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FEE34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301756; cv=none; b=JeycTX2yEXdFJ7xLPl4j29RSSopCGQpik0OPuWd9ScGuezNs576xDOjn3WFDg/ya5GgoULEGKWZ85ND/xvxAykSdJxAIENSaDd8OJ+cP4NvCZkMbkLvaTbZc/RXxJ4rQN37rvvEdw2kLEbK63ZJbRJ4mk+pY1Acg7nIZG405gZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301756; c=relaxed/simple;
	bh=UmqLmhDQTNue7bZFGm9z2PTLY6PQ5GyMQN2PKEy/T2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GaGrHgSYCcFkySzAxHyEkqO7w0iGDhpPpiQSlnV/v4i6qMN/1VXRVWxb6Bwy3SL7vgHX+yNZt1eGcM8SLmwQ0lyX8WYzN481tIcMc6jufyQzjLr/qH8MQhusHfnnzNYCYxDlsiMPH1pzNfsX02gVmgoyGVuq+d5CvN1bnDdcKDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3sLZNRd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3sLZNRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B090AC19424;
	Sat, 28 Feb 2026 18:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301756;
	bh=UmqLmhDQTNue7bZFGm9z2PTLY6PQ5GyMQN2PKEy/T2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3sLZNRd/La2llK6kNCD4DcmhysDbUgcn3/pqZCd86/IFl6QCcoFYJVvm37s8oWZz
	 qTV09ovwaNY06O27A4m64dLUmD9zReO+g1+rhnzzM8KNVSafk7nW7enZLCx7n97f36
	 v/YfnMi216cTA4lKHq1Dn72tMwmTGvahzvuYawFAifI5cdbGexZ+u6oK1EjgAWBWTW
	 5zUwSOxjUHpgyYgTyW1/qZu1t910Pd56nzjCo4CqXQiUhbv6S3R2ICMLd8KwohA6bD
	 V5gSgNUcbE2dnmbKKeaF4SELdaOMYXxEef5TWQM+c3jbyolLtbHc40qAVoVc+WVJod
	 66calrX/2NyvQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Micha=C5=82=20Grzelak?= <michal.grzelak@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/385] drm/buddy: release free_trees array on buddy mm teardown
Date: Sat, 28 Feb 2026 12:56:22 -0500
Message-ID: <20260228180011.1568201-160-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Michał Grzelak <michal.grzelak@intel.com>

[ Upstream commit 7d0507772406e129329983b8b807e5b499bd74fd ]

During initialization of DRM buddy memory manager at drm_buddy_init,
mm->free_trees array is allocated for both clear and dirty RB trees.
During cleanup happening at drm_buddy_fini it is never freed, leading to
following memory leaks observed on xe module load & unload cycles:

    kmemleak_alloc+0x4a/0x90
    __kmalloc_cache_noprof+0x488/0x800
    drm_buddy_init+0xc2/0x330 [drm_buddy]
    __xe_ttm_vram_mgr_init+0xc3/0x190 [xe]
    xe_ttm_stolen_mgr_init+0xf5/0x9d0 [xe]
    xe_device_probe+0x326/0x9e0 [xe]
    xe_pci_probe+0x39a/0x610 [xe]
    local_pci_probe+0x47/0xb0
    pci_device_probe+0xf3/0x260
    really_probe+0xf1/0x3c0
    __driver_probe_device+0x8c/0x180
    driver_probe_device+0x24/0xd0
    __driver_attach+0x10f/0x220
    bus_for_each_dev+0x7f/0xe0
    driver_attach+0x1e/0x30
    bus_add_driver+0x151/0x290

Deallocate array for free trees when cleaning up buddy memory manager
in the same way as if going through out_free_tree label.

Fixes: d4cd665c98c1 ("drm/buddy: Separate clear and dirty free block trees")
Signed-off-by: Michał Grzelak <michal.grzelak@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Link: https://patch.msgid.link/20251208102714.4008260-2-michal.grzelak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_buddy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index 7debf079c943f..39a1d589df3a4 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -414,6 +414,7 @@ void drm_buddy_fini(struct drm_buddy *mm)
 
 	for_each_free_tree(i)
 		kfree(mm->free_trees[i]);
+	kfree(mm->free_trees);
 	kfree(mm->roots);
 }
 EXPORT_SYMBOL(drm_buddy_fini);
-- 
2.51.0

