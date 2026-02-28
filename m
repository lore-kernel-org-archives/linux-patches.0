Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AFD38F623
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302132; cv=none; b=JDHPmZGiriMFO+Azktr9+9/ouJLIH2tIMzmzMCOZKK4+xY8NI2g5o5PJTEuQw7ihkniA3q7pQINXoCzoFtPKtCjC56mrFG5o9T0wpWgKzUhDjnXdo0ROHcC/uMeJg0/FMILHMcSTi4lOkupjVH00d6lOwWs/i00kPE4qFF7ZVts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302132; c=relaxed/simple;
	bh=px3BH+gpChuei5n+8twfbfGjr4i6zwn0gorBNR3OxVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od09k/kvWaG4qNAmCbKqYoP99BBl2H7EAbwR+sUmYIyQqUnsudlZ3NXz/dd9647Fj6cIvuc4jXIybx3mY9gWXIbWwkBAE2RaUMEdYT1dLfpsDVvmBV1/rqgtCgAZbNKwG+ewyNUfj2hLrIIhvot42vuwKCjVSSF+IO+q8VZFyV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve70CTkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve70CTkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2BCC116D0;
	Sat, 28 Feb 2026 18:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302132;
	bh=px3BH+gpChuei5n+8twfbfGjr4i6zwn0gorBNR3OxVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve70CTkdnQQfq5zjknJMFEyalofxqJkauuizeY/QegPUjawuRLzbv1OFKJnrLEniG
	 T7Y78Ue2i7s7jVembU/dkxyImeagJzoptk+taajFlKrsfGZ2dbr4/587zni/J7rkdP
	 TZBs+uKRsdJPCgOiHyuvGP/j9tiViUSOmCHZnnQ1bcqE6Zzts86wCYR+Si82sEyG1x
	 c8ZylxIUG/3pi95XrZMbqz7Qk2kdp9ftjgeAW72Ffi7OnZP7Pu50dru8/4KzL5zK9J
	 taolHoElMGbNBgBdCM2x5vAvjVdAZRkM+JQyxONzZfU+LeagZ7fd9Ck+1ed5740Atq
	 yKGo41PnrigVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/283] iommu/vt-d: Flush cache for PASID table before using it
Date: Sat, 28 Feb 2026 13:04:25 -0500
Message-ID: <20260228180709.1583486-123-sashal@kernel.org>
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

From: Dmytro Maluka <dmaluka@chromium.org>

[ Upstream commit 22d169bdd2849fe6bd18c2643742e1c02be6451c ]

When writing the address of a freshly allocated zero-initialized PASID
table to a PASID directory entry, do that after the CPU cache flush for
this PASID table, not before it, to avoid the time window when this
PASID table may be already used by non-coherent IOMMU hardware while
its contents in RAM is still some random old data, not zero-initialized.

Fixes: 194b3348bdbb ("iommu/vt-d: Fix PASID directory pointer coherency")
Signed-off-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20251221123508.37495-1-dmaluka@chromium.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 8faa93cffac45..07c8b0df8e2a8 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -207,6 +207,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -218,10 +221,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			free_pgtable_page(entries);
 			goto retry;
 		}
-		if (!ecap_coherent(info->iommu->ecap)) {
-			clflush_cache_range(entries, VTD_PAGE_SIZE);
+		if (!ecap_coherent(info->iommu->ecap))
 			clflush_cache_range(&dir[dir_index].val, sizeof(*dir));
-		}
 	}
 
 	return &entries[index];
-- 
2.51.0

