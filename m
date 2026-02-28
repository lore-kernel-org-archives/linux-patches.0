Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E699F35AC36
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302710; cv=none; b=JdRz6VabNGzNl1HI0VFaZ9kqax51NCrq9Gb0PDecqF2KV35L8++NwPmm1U4rhVEGWRXUuYjJmm9Y0XufQvoFAUqex1LGdBt3xPArDnTffuuzB4CSa2YCTeK2qQwAjkqbKUKyoKR/s5DUkGQ3+DAFL6shu6KkEqUY7Cm+5661/5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302710; c=relaxed/simple;
	bh=SRePMaDOdyqwMcrSAz8FbpDew0+b21k+nh3os9VQt9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOC3XUNHKvEEe8wTInahi0DSXLZuOISMfS1UsdR16ZUdxnIhpzNnlc1ujyyPalo5h3Cf41XInKmbawSE6Is2S3ZpR3z0DkrwJyixaOmB5x0eeG6seAyQ79XoNHr0uV+8eJAQdXko76VoMcuZX1DfD9+UJu1OTUZC92gqL1BQ9Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHUe7LwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHUe7LwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BA2C19423;
	Sat, 28 Feb 2026 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302709;
	bh=SRePMaDOdyqwMcrSAz8FbpDew0+b21k+nh3os9VQt9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHUe7LwSiKRc8YNrt39lcGuMELhexkMfveLBdIjf3GqS/Si+6Qe6in249BQCKcfo9
	 4xlBSYbrgukNn9gMkIFQP9E8hlbisdC9rPPD87noH5cv8EsIKbsVx+dqvA8bG7CD6r
	 Apc/+qcyvsRuBhsseXiPd2p1xHmZ/xvLRP0dHi1Bx0UKtr/ehj9qAweqwFstcnUWR4
	 pyz4/dVdyC2bPSCVg1lmiVMflrb6+9LB5yr74n+C4nN7NCEyRjXyFu8OAloMKQLbo/
	 h7bOznEMRx73LZIHEvo6W1UelbhtfFo3U9xwmR+XzoJzT7CZ1WV5YO9POYAHpobJjf
	 rn0ancikD5Z/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/147] iommu/vt-d: Flush cache for PASID table before using it
Date: Sat, 28 Feb 2026 13:16:16 -0500
Message-ID: <20260228181736.1605592-68-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 586b289cf468d..8c973481521e6 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -268,6 +268,9 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -279,10 +282,8 @@ struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
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

