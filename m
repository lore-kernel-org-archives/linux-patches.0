Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E4C331A61;
	Fri,  7 Aug 2026 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114700; cv=none; b=IX//i43xjLA6gPgnvrF7u7fzBQbv9vwkPZ0wdEPnorgs3laO1kOLclGrUIVr3NhzQOg/RdovTC3Ek8ZWh07dLVEmrM87Qj0j2Xf88d2JWt2c2hhOTHyBF5lNIE6kl2cHviRM79o107PTw/dC+aBAatc6bQpTmgwaZ0rvZM44Kx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114700; c=relaxed/simple;
	bh=RfgiCFtuaD0QHBLj62nzIcTa4GXz9Tei2SBzUa15Hcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmI25RvpNe73IDJJWS2H+psVuqElQ9lIqbByEIcNroTy6glbXZBAft2Px+bWIU0l2iLci2NjUnKS3uSEpAf0jCu0GVYZMLpKOnkJOhaSi42hLj7ZsvCZO4Swdf3bfGohgM7Qi60wA0VCDAk9LToZ4tvI0xINXj0RzIbxymfiyg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGpxeFlQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGpxeFlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B641F000E9;
	Fri,  7 Aug 2026 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114699;
	bh=U0I07t82+wjtndi5scDPXx/t3zG7lyFTRNcKy40WyOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGpxeFlQNSFLoaTpo1+oJyHYh3wwsPFrtR1sTuq2UD3hSY6popsTLbkC+EYmfb5z6
	 Y/Ht/jOr4BNX8ZdZ8kLfmFLqrn5FmiFbrsN/8G32qEsnhjEn9EkdSjhIRs8/j9c3Ep
	 fY3waOBWIQwCMgA+Jpk0bjvol0KWRqopsc249g8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/396] iommu/arm-smmu-v3-iommufd: Require exactly one Stream ID for a vDEVICE
Date: Fri,  7 Aug 2026 16:32:58 +0200
Message-ID: <20260807143424.669146998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit c3b8ee84a965058b41275069d4696f37a8b14bf6 ]

arm_vsmmu_vsid_to_sid() maps a guest's vSID to a single physical Stream ID
taken from master->streams[0], assuming a device has exactly one stream. A
device with several streams gets only its first one mapped, so a guest vSID
invalidation cannot reach the others' ATC and IOTLB entries; a device with
none makes master->streams a ZERO_SIZE_PTR, read out of bounds.

Add an arm_vsmmu_vdevice_init() op to reject the vDEVICE with -EOPNOTSUPP
when master->num_streams is not one, rather than mapping it silently.

Fixes: d68beb276ba26 ("iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object")
Link: https://patch.msgid.link/r/b15f2b73520f389f3f57881da2f040e7bdc18876.1783311134.git.nicolinc@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c   | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 9ec5591565083..a52f86454f77d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -285,6 +285,20 @@ static int arm_vsmmu_vsid_to_sid(struct arm_vsmmu *vsmmu, u32 vsid, u32 *sid)
 	return ret;
 }
 
+static int arm_vsmmu_vdevice_init(struct iommufd_vdevice *vdev)
+{
+	struct device *dev = iommufd_vdevice_to_device(vdev);
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	/*
+	 * arm_vsmmu_vsid_to_sid() maps a vSID to master->streams[0] alone, so
+	 * more streams would leave the rest stale and none reads out of bounds.
+	 */
+	if (master->num_streams != 1)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 /* This is basically iommu_viommu_arm_smmuv3_invalidate in u64 for conversion */
 struct arm_vsmmu_invalidation_cmd {
 	union {
@@ -391,6 +405,7 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu,
 static const struct iommufd_viommu_ops arm_vsmmu_ops = {
 	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
+	.vdevice_init = arm_vsmmu_vdevice_init,
 };
 
 size_t arm_smmu_get_viommu_size(struct device *dev,
-- 
2.53.0



