Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E2618B0A;
	Wed, 25 Feb 2026 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983255; cv=none; b=AZ3/VCGnU/fKMYW9b4IitPai/5ZOYWBORylyEKe0SC4ef2uxsCdJLiX35Tk6ptJMaNbHWuZgj+I08O+1z+waDz4ebOhAnPa6nA/JrrplxyOLBxdkrj/RKSVn0MFF7h2rVKebEvQEImnDAHDOT5EJy3mEf/HJcbxrMb/ObJwPtl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983255; c=relaxed/simple;
	bh=Fo6pmeA5rCJXyG8lFijFY+p9H3Pe/VE1uS/Xwu52qPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InohxbkZjvcrVINSdlJ+d3xz/STFOQXEb1OZcMJcUcEa7+s4DKiSbWLft/MBCYZtO5r80adZ8+YzlDRTXx35Wt6jB5HdtU8K4darnP5b0Z1vxNv6iZ5j/e7RLArARMb78LJ28r1SLfrzpwbjnLIJreXQBfO4P6Ny8CZAG06u1Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W16JqE5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W16JqE5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13725C116D0;
	Wed, 25 Feb 2026 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983255;
	bh=Fo6pmeA5rCJXyG8lFijFY+p9H3Pe/VE1uS/Xwu52qPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W16JqE5JVg+dmjmZIb4HEv23c1xaijfEOFDB41w3gEm6eMbMC9QdLajPclxXldFM3
	 5WLnnjLHDPMJVlPMFcMNXFICwpuzniGsLDJOjxA+Qs2QnyGNblCG/OoIsqBsBkiudU
	 a2DsHiHJr21+0IsD5MkC0Kp1N3kpEKXkRWgdWWwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 354/781] iommu/vt-d: Flush cache for PASID table before using it
Date: Tue, 24 Feb 2026 17:17:43 -0800
Message-ID: <20260225012408.369271282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 3e2255057079c..77b9b147ab50e 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -153,6 +153,9 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 		if (!entries)
 			return NULL;
 
+		if (!ecap_coherent(info->iommu->ecap))
+			clflush_cache_range(entries, VTD_PAGE_SIZE);
+
 		/*
 		 * The pasid directory table entry won't be freed after
 		 * allocation. No worry about the race with free and
@@ -165,10 +168,8 @@ static struct pasid_entry *intel_pasid_get_entry(struct device *dev, u32 pasid)
 			iommu_free_pages(entries);
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



