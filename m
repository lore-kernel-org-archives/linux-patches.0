Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33241375AAD
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301788; cv=none; b=FMtggIeE7fnt4Fz9g82NAbtTV5wONnkke6VkBYAl7RMZM0JNY7wiPWPkHb3FZhlSdXP3LdtRGH6JidKUA280m0yJBaZze3Z8JOo174fVm3o/I/nXQt8k6TIZKGGCmnycf6mY9ubUjkiED5VDQWodiZnh1Gg71knYeBhYWfdddIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301788; c=relaxed/simple;
	bh=ZNx5oV5HfIKoIsP3fHI+R4qcWHL0gOyjYg4Cv2bKBPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFEQElOOg0a3qESTmnZnBkJf51/gqi3N0cwU4MXv+s3mTS3OKhYSp7jlu8B9cgC3v4Q36wMXJtO/Hdcc60dPg7/zp9ry1Newp5sgkh0C7cnSVBpH/QA8+2Fq95SWay87JE7Pf4UVQNS9XHAGRy5SSd87xJgjc0DuNLqZyYPt59A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l7ygI9gE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l7ygI9gE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDFCC19423;
	Sat, 28 Feb 2026 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301788;
	bh=ZNx5oV5HfIKoIsP3fHI+R4qcWHL0gOyjYg4Cv2bKBPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7ygI9gEZ5R175QrGSr3OPqnNeBGacN8iUmp/pzs5QMhiZlh1NCZIysQoWq7k5j8A
	 K7U/pXYjXIhtNudUBIuWZflYYrPVY5SubZ0o1Ck9TSi9Kp8UyoSMKa3223Gm5ONbZj
	 9HATXD9B/9LjaHwYuFAmRudZFR5d/gDhk9KrMulOTfy3srl3oyrzGVlQxMpU50UqoG
	 sonHWzR5YUgzWtA6wOz4HY9G8h3hly8c/cd5H+7yDhYxhNg9ow7BTacCqDPDOUkRmZ
	 b5sUBbhD/si+Vy2oa2HrgeGbYaR0/zXVRiMYV81jE0XnYEcCcTFjfEDIYUiyTw+QpU
	 vtFZhAN8evFhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 197/385] iommu/vt-d: Flush cache for PASID table before using it
Date: Sat, 28 Feb 2026 12:56:59 -0500
Message-ID: <20260228180011.1568201-197-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2e5fa0a232999..2ec76333b6973 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -152,6 +152,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -164,10 +167,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			iommu_free_page(entries);
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

