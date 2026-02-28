Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F262B36C9EB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302376; cv=none; b=elEuflYSUj9/UvmJZQiTbm23j8HJ2hl6LCPi9tYoeymvmAY2lxxX+zxnxwfJ4cGJ92qrKuw29YGu8l/7Ijk5CxF0u/b7zgWtPGmuEjA387xnm5Bs1oSC16EaByLCaZtuhTb3aDCzuZ5vYgscpJ91cD4VyivzQ81o3uGsenurKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302376; c=relaxed/simple;
	bh=VOqEIs59SO1u+GcfnxLcZSVv+7Y/EFPa/Pb5wlFsKyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3ellLTNbjLMNo+isaMWyt/kjGHpuPJyGx8423oaoIAK2dXet8uFDxeTi1ZMjx9TYzQsfXES/Qwt7v2tqRMqQXQX6I9gHFDplpkCraEKdIMRFAfymTfdpjOkZw+hqen8Fa+ACzbrUX2djsrHt0YeEDaHDTAbHnj5VzZvyuPNCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LGbxCst6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LGbxCst6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35343C19424;
	Sat, 28 Feb 2026 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302375;
	bh=VOqEIs59SO1u+GcfnxLcZSVv+7Y/EFPa/Pb5wlFsKyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGbxCst64+g1tZJTjCZ67bx7FyIUh4EWi0Mey7Ofqtiei6trhOTGdfrTXpaxdKfTf
	 RIn0IzjcXX1XbxRyG3VB5r+QFBR3j2DPHRD6T6ZKgbebcXpFclOiZ/3aBTiAaH69Pc
	 LoW+Pp1ltJSIfUVSdsUqSdoGKnrMvo7WYiE0kbZzOJGhs1DwSqe6/0bidHqzXBxETx
	 9YW6gGqpV+CromZlpE5OUx079gzYWFCKlblJ9D8Lev5hxDm2sa/X5a373R4t39nN8T
	 XOUD0nwGh8m3ShtgteC/W2e6pmTKefO0p1HDHukeiUmBJQmcqC0jOy6KRQzhXeh2Sr
	 ZpwWqHeGy6qXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/232] iommu/vt-d: Flush cache for PASID table before using it
Date: Sat, 28 Feb 2026 13:09:16 -0500
Message-ID: <20260228181127.1592657-103-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 32432d82d7744..9b82676dfd99f 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -205,6 +205,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -216,10 +219,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
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

