Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF15F1C2420;
	Tue,  8 Oct 2024 12:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391703; cv=none; b=Ed1pu1KEKisPfCUPoRN/Pr88kCuxFWYU5py9vwEUzJ9LU/AMvEyflUmvzJVpk0FpEFKJ0IUOivEi46eaYEZ9vzvWrDnZBBdOM3EoH4HAM27dURVAo1KKCSlTMJb7yd1hwx5hEUgzVCTxoNQh9HwBbY9afnkX7Vln2KzpVDah83Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391703; c=relaxed/simple;
	bh=zKo5Udw2CLipUBXcO4Cz4nkR/uGgrgYBAqxcl2nR13c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcMzYKniQOaufAGn6dH/DD9Pgl/+9Aha6GTcEUp37GD1OMkp8hhSzNVMVtNQsLiBR7XjpUc2czjtotDlOS8UTBmfplZYyypnAJow4MY9p8KwIlgb7t4Fg3/T2IZcDQ1ix0RObumFxBecgqnIPUxVkkjLYe1zUPwz/r+Fq5ujPKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vuk+6p7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vuk+6p7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1192AC4CEC7;
	Tue,  8 Oct 2024 12:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391703;
	bh=zKo5Udw2CLipUBXcO4Cz4nkR/uGgrgYBAqxcl2nR13c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vuk+6p7bZivxYAAZlBrkyxI7zvvmg3Nj6aA1JtJt634dUT91EfUJ4uqNlGtwWC6AC
	 ZzPZ82POQ94FOI6dpIrPX8AKNDx6pDsLMj62vNIj0T6TKVsWOPKxhwSmDuqB2iSvP4
	 En7mIDxABNx2M9SRbslJ7XWkGW/3v5wstAYW5/L4=
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
Subject: [PATCH 6.11 197/558] iommu/vt-d: Always reserve a domain ID for identity setup
Date: Tue,  8 Oct 2024 14:03:47 +0200
Message-ID: <20241008115710.102289448@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4aa070cf56e70..e3e513cabc86a 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1447,10 +1447,10 @@ static int iommu_init_domains(struct intel_iommu *iommu)
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



