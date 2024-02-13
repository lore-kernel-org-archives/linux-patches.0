Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEA383AE;
	Tue, 13 Feb 2024 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707828902; cv=none; b=tbsqrP/vPPkdG0i7OfdSN1d5eh949qCjegfcH68fGbcI0lePK/8RtUruv6Q64uQe4h9o/M2zqMPB+niTeQwV6GMLPXdgNI2IXEIvvH7U2J0xyrtUQY8tfitPPUKFrPtURQVBKrMDdbBcb5dudX3LcmxBV5t+EMnGAzys+oCgn+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707828902; c=relaxed/simple;
	bh=T0lfLZiER3Zmaj8kolxQlJktrh8vrQ+uoHC1B+ONXbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2D1ubhzknEdfFoLawRDsmjs+k7/yBNmeK+6rMVuR8rhwG+3B1w/p2A2uFRFC10MpcdvJnEBMKrHn3G2ywYHc6asXP5k1xcQD/CcWaky7DX5pfIF6LhBIFUMhK0Nhjxa45i1wV/QznrFb6Zr99l3Q8UX+raL0lK2fbqIg6/TLIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hxj0jH0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hxj0jH0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431CAC433C7;
	Tue, 13 Feb 2024 12:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707828902;
	bh=T0lfLZiER3Zmaj8kolxQlJktrh8vrQ+uoHC1B+ONXbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hxj0jH0Shyn+ZW708VlA2ymlWtyfH9pkwUUbJ6lNcx9mWLt4aKDYZz7ebqP9VJgT3
	 Je3VUn23tCfrT9OdilFW1ILoaKoyRdT163ZCFuhr6v21Y+1irb4zzJpfKX1G6bAwA5
	 H2VyR2j5xCD1uGEqESd9enLPiqzwtU9B0iLvuhn3/k4PjhuVSTl/r1uoM21C0tjPpU
	 wjhEDxus0Ax88pLBUW+1fXEyJ15VcOFm3AEejnovt7rr49RqZW2A/eaX5M9ztUawPy
	 e7iG4H10uA6Jfr0ziziPcR53JRNkxNTFk/azvnhDhPGtGOSV6MbMUACte+JqIAvzMF
	 +jSpz1OdMG9eA==
Date: Tue, 13 Feb 2024 12:54:56 +0000
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
Message-ID: <20240213125456.GA28844@willie-the-truck>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213121850.GH4048826@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Tue, Feb 13, 2024 at 08:18:50AM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 13, 2024 at 11:20:15AM +0000, Will Deacon wrote:
> 
> > Damn, all the surrounding rework has really left this poor code in a bit
> > of a state. 
> 
> That's one way to describe it. There is a reason it took me so many
> patches to align this to the new core APIs :(
> 
> > Could you please respin your fix, but with an additional change
> > to arm_smmu_mmu_notifier_get() so that it returns an error if there is
> > more than one device in the domain, with some of the above in a comment?
> 
> Adding a check is not a comprehensive solution, there are still ways
> userspace can attack this code with iommufd's coming PASID support. It
> certainly doesn't belong in this patch which should be backported.

Ok, then how about avoiding the allocation entirely once the lock is held?
Untested diff below, but you'd call arm_smmu_init_cd_table() from
arm_smmu_sva_set_dev_pasid(). I'd just like to make sure we really do
avoid allocating from atomic context if we end up with a multi-master
domain.

> I can summarize some of these details in a comment for this patch.

Alternatively, we can just revert the offending commits if we're not able
to agree on a simple fix for now. I'd prefer to avoid that though.

Will

--->8

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0ffb1cf17e0b..8ca92639b13a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1019,7 +1019,10 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
        WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static __le64 *
+__arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid,
+                     int (*cd_alloc)(struct arm_smmu_device *,
+                                     struct arm_smmu_l1_ctx_desc *))
 {
        __le64 *l1ptr;
        unsigned int idx;
@@ -1033,7 +1036,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
        idx = ssid >> CTXDESC_SPLIT;
        l1_desc = &cd_table->l1_desc[idx];
        if (!l1_desc->l2ptr) {
-               if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+               if (!cd_alloc || cd_alloc(smmu, l1_desc))
                        return NULL;
 
                l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
@@ -1045,6 +1048,19 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
        return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
 }
 
+static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+{
+       return __arm_smmu_get_cd_ptr(master, ssid, NULL);
+}
+
+int arm_smmu_init_cd_table(struct arm_smmu_master *master, u32 ssid)
+{
+       if (!__arm_smmu_get_cd_ptr(master, ssid, arm_smmu_alloc_cd_leaf_table))
+               return -ENOMEM;
+
+       return 0;
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
                            struct arm_smmu_ctx_desc *cd)
 {

