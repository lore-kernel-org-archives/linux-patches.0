Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993571DF26B;
	Tue,  8 Oct 2024 13:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393462; cv=none; b=oIKJea45HJLF9tyLx09RQdCxqNoc0Mp7193NfHJUbz0nT+oQSKEg1kZ/vrnjPnMHh6p+M7NlPDuaPiqmnpldUylq2ETuhSBLSsv4Qs5HKK/hcOmigRdTWpWOz6M4FH4JttGMcrdaHU+XxQO+1G1Wv8bk7EB9EC+QUfoTsiP84/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393462; c=relaxed/simple;
	bh=O617RhH3SQDdgAwbg7iVWBIrv6z4gNn9t/uo1fqMuGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URT5zqFJKSdVfnYQB9wpLkvLbTQOPjPfwKfhl/KuROrLAYVQC8ufu6r2CpQn0d1353LezzqXX20hw/Rw16/qr8G+f/fgGwMuJsvipLE46xYGhuIY7ldb955O04mJKYl22+zK3qCU2I6mWcDEodJawoHQhDre4M7Ny+aCXivjNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DTwY1i4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DTwY1i4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05999C4CEC7;
	Tue,  8 Oct 2024 13:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393462;
	bh=O617RhH3SQDdgAwbg7iVWBIrv6z4gNn9t/uo1fqMuGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DTwY1i4Ml2IwBHhWTjGDHRZabJcNcCuYGwC4qYkmWKRJP+kduWCp4upnT1sFJ5pGG
	 kkNmCKO1spkvitBu7FqxHt1lxM5bVR/uRBK0w4rPffnkAVcqSeZvIFJ77vbfgcOqmm
	 x8rIYKehwRVmB2DMvKiuAnYqAwWbMy+EiC2Z/soU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/386] iommu/vt-d: Always reserve a domain ID for identity setup
Date: Tue,  8 Oct 2024 14:06:13 +0200
Message-ID: <20241008115634.474484301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 2c13012e09190174614fd6901857a1b8c199e17d ]

We will use a global static identity domain. Reserve a static domain ID
for it.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Link: https://lore.kernel.org/r/20240809055431.36513-4-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9918af222c516..b7317016834cf 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1692,10 +1692,10 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 * entry for first-level or pass-through translation modes should
 	 * be programmed with a domain id different from those used for
 	 * second-level or nested translation. We reserve a domain id for
-	 * this purpose.
+	 * this purpose. This domain id is also used for identity domain
+	 * in legacy mode.
 	 */
-	if (sm_supported(iommu))
-		set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
+	set_bit(FLPT_DEFAULT_DID, iommu->domain_ids);
 
 	return 0;
 }
-- 
2.43.0



