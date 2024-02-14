Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727A2604AA;
	Wed, 14 Feb 2024 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707930036; cv=none; b=WqZO/FfpWo1EAuRUNFhtuYTuJoXYO7vR9Xir2YW6IZe2qnNMnbVEVPvGV1O+8rbjQ+VS/ftHrrIF77kKd5gSp9+UbK0pjAZRb5RBvXqTFLqqKYNu9n9TRIGdMNc6l98kNC6z3LhiL3uyriDKTH78etbQgkz5Cck42wg7buN9B6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707930036; c=relaxed/simple;
	bh=Z6rrMvEP6XhNUYQaqN3A0gAvieP0dNhtgVysnYh/Urc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gv2zxeJDDzbZ/U/GS1q6lI9ZD1mcKTS8SNNFIASEGb5vnWS902PSjvwCfoC40yuB11tb389WrF73Qkxf5Kp2+ec23eSopN7956mSguFw/xG77/QBEafQb1NIJb+1B8gx7mXknHUSJuT1EjetMh5gNRr/LCW6vK1bCMuZ6aX72Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6w9jYal; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6w9jYal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165DDC433F1;
	Wed, 14 Feb 2024 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707930035;
	bh=Z6rrMvEP6XhNUYQaqN3A0gAvieP0dNhtgVysnYh/Urc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G6w9jYalv0wMQ79t+8DDbDRceD0QKT/3QiBDvSA3ANWA89srL1EaOGKfAaw+ghBYd
	 DVstHA5FbtvHi/0LOvaqAUE1PCUuFlIpU+CP8o4Y+V+HPxhh4D5jeiaLGAVTytxpO9
	 84HEOgePx6MZsOj3ZczfK/+F2PAKkxUPdlIxHhbrYohi/aWLwk/nS3RDa+D4wm+rPw
	 J3Xh+A+wsMeAhWvoMFI2oB0DKTEkBYXuzgftwA4QBTRXrtt6RpIy/y+Jaj/QPQ/ENQ
	 MJst1BgSiDlcU9oqI7tHqAIRv+Dx6wORESp0CYog3yqGCvowcn+GaWfQpK+B4NRnVp
	 /hyTHDDVF72Wg==
Date: Wed, 14 Feb 2024 17:00:30 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240214170030.GB31927@willie-the-truck>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
 <20240213133045.GA989297@nvidia.com>
 <20240213135627.GD28926@willie-the-truck>
 <20240213140033.GB989297@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213140033.GB989297@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Feb 13, 2024 at 10:00:33AM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2024 at 01:56:28PM +0000, Will Deacon wrote:
> 
> > I can write it as a full patch if you prefer (and I'll need your help to
> > test it), but I was really hoping to continue the discussion so you could
> > spin a v2.
> 
> No worries, I'll take care of it, just need to understand what we have
> agreed.

Cheers. I finished the diff off anyway, as it's basically just merging
the thing I sent with the rest of your patch. What do you reckon?

Will

--->8

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e..128f61a705c7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -588,6 +588,12 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 {
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	/* Pre-allocate the CD leaf table without any locks held */
+	ret = arm_smmu_init_cd_table(master, id);
+	if (ret)
+		return ret;
 
 	mutex_lock(&sva_lock);
 	ret = __arm_smmu_sva_bind(dev, mm);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b..e48f2b46f25e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1019,7 +1019,10 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static __le64 *
+__arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid,
+		      int (*cd_alloc)(struct arm_smmu_device *,
+				      struct arm_smmu_l1_ctx_desc *))
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1033,7 +1036,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	idx = ssid >> CTXDESC_SPLIT;
 	l1_desc = &cd_table->l1_desc[idx];
 	if (!l1_desc->l2ptr) {
-		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+		if (!cd_alloc || cd_alloc(smmu, l1_desc))
 			return NULL;
 
 		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
@@ -1045,6 +1048,19 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
 }
 
+static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+{
+	return __arm_smmu_get_cd_ptr(master, ssid, NULL);
+}
+
+int arm_smmu_init_cd_table(struct arm_smmu_master *master, int ssid)
+{
+	if (!__arm_smmu_get_cd_ptr(master, ssid, arm_smmu_alloc_cd_leaf_table))
+		return -ENOMEM;
+
+	return 0;
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65fb388d5173..cc42cede77bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -748,6 +748,7 @@ extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
+int arm_smmu_init_cd_table(struct arm_smmu_master *smmu_master, int ssid);
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
