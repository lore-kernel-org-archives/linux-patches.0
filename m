Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FE437524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302561; cv=none; b=jWgnfm8aLD8GwFNFPyKScX21VRKhs/XAealcN2Nk9DdJiRlZuiPkSsjN6s7KexwzhHs7JRWz1nln9aX33wKTmQB+oDTim9ng+q9wuTYOZw0ozhPpIX8dRtvVH4WSXrhxmrujTGT4TJtnVc5db9qh92FYHgx49Ui2rrkOSizH6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302561; c=relaxed/simple;
	bh=34Nx6kIswZJsO3rC8rGYfiI2n7jVxCa4GtrJ90uta60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AR0PNQrZI9tiFltN4zgWF/Hns6si7akkcBjKbhE0951Uq/MsEo5xyIIlssR05KsAw7wh3EGke9baoFg2VEARW/7eoSgIXozXj8Dp+IUd7quCG1dsfwzKV5Y9zHD7EFONFDz+XWpPluydjBXwdOFabyuPtwf1sPd2MfhY3zVv+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CoMzty8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CoMzty8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD30C19423;
	Sat, 28 Feb 2026 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302561;
	bh=34Nx6kIswZJsO3rC8rGYfiI2n7jVxCa4GtrJ90uta60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoMzty8Mn6YeZKQ0faOPneS1+erHXjKnT9l4Tr+pGvDeZNT/vaNHcZxF+DOLKQK1q
	 Jmrd7F9v7NjZTu9CLeescOi7CtUlzZrPuDGMx9Yjfd8oO01K8wtR5orsRzn1ZmyAvS
	 86myamRmDp27BMfJeV4oU8H5aUqKMW83hW9iZetPy9Wa+9h8aYeweTJyWi96k3v6ik
	 knkrs0Dt5xT3/TFTeXZHkslHf6dkS7Za1dFVXyaiNaHJ57K1K0CVVrdFzHPvMhFmyv
	 Pnyg4UpfomlZG5WI6oi01n40fwZa+eI/Um3kSrQDRWKyZy7eEruLK2B09uzREQu6tV
	 BNhOcjhyMMg6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/164] iommu/vt-d: Flush cache for PASID table before using it
Date: Sat, 28 Feb 2026 13:13:26 -0500
Message-ID: <20260228181505.1600663-67-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 589b97ff5433c..fd60e7ec625ea 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -268,6 +268,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -279,10 +282,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
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

