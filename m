Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9245A1CFEC4;
	Fri,  6 Sep 2024 14:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725631740; cv=none; b=otI63OzsyTKYYNU22uk2vE+eIi6qWEmTm5w0Hyd1K4MgWQOVz18Uz54/QxAL0rME79B8ejHuwnMOhBXFE22BBgyy2n4BIIG75I5j7aGSG0/nlrq7bJweTH63TMSCrqoRBbXnJ9F2UPDqcL2T8pP7rckvxm809zV/K6jZ6ATwjpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725631740; c=relaxed/simple;
	bh=tv+Skcv7zYTt33ybSpFMuvSve7Xp3+8oAkSEA7XyXOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=te7EaJXSiC2fW5y8T40m1wzoXR3PzKJwNB7xqb9Iohp1ArZpYN0nYUnu5I2WsqoKM4PdyqQhf3XfcdCbrFCu2jjsevlP8DFZZnv2Wt+mD4XeYl0SprHWEAFeeOuwW81qJsXt6Sq3muKDZaSGSYUec6W3jDvQs48xkL0lFn2DOn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKVuvlD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKVuvlD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00E7C4CEC4;
	Fri,  6 Sep 2024 14:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725631740;
	bh=tv+Skcv7zYTt33ybSpFMuvSve7Xp3+8oAkSEA7XyXOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gKVuvlD2kt7HjyuLIhHM8J4yDo+MukLXpcI2OHoJG/V79ZQb8Pu41Dp2hBE+QSoUG
	 QWEtNq/0PzPN5ZQaFHScZ2yCNeM6uMi94kMg4NPMHu7HgRYncurOVPPc2S14vr3Kaz
	 hPRTO6Ig9kPmwvh9oCNKFwcGZ8r9hl48tBTBvbGp74lCbrZXIsuK3jli7RFzBuwxAw
	 MtCT9Pz1ixeI2JXi8gI/h+Wrqll6Dt3culk9yJeRI0hocIs/W8u4iNmAQRbtgvM548
	 RxRd5NgKyVa7suFCL8bKJ1MYCbvdhT8rn836bHJDSDY+c6SttZ/R4c6+6Ml2SfXpvW
	 YC5CmdZ3FbTtw==
Date: Fri, 6 Sep 2024 15:08:54 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <20240906140853.GA17187@willie-the-truck>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <20240702145705.GA4135@willie-the-truck>
 <20240709193905.GL107163@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709193905.GL107163@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

Sorry, it's taken me ages to get back to this after applying the series.

On Tue, Jul 09, 2024 at 04:39:05PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 02, 2024 at 03:57:05PM +0100, Will Deacon wrote:
> 
> > > @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> > >  	struct arm_smmu_bond *bond = NULL, *t;
> > >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > >  
> > > +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> > > +
> > >  	mutex_lock(&sva_lock);
> > > -
> > > -	arm_smmu_clear_cd(master, id);
> > 
> > This looks a bit alarming, as you're effectively moving the CD
> > modification outside of the critical section. I assume we're relying on
> > the iommu group mutex to serialise this in the caller? I can't see any
> > consistent locking in the driver for arm_smmu_clear_cd().
> 
> I see Nicolin got this - but yes, sva_lock has nothing to do with
> CD. CD/STE has always been protected by the group_mutex.
> 
> > As an additional patch, perhaps we should consider documenting what each
> > lock in the driver protects and the lock ordering requirements they
> > have?
> 
> There is still a bunch of rework to do here, it may be better to
> complete the rework than to try to document it, but let me know which
> ones you are interested in and I'll write some thing.

I think listing the locks we have in the driver and describing both
what they protect and the ordering between them would be really helpful.

> sva_lock is almost gone, it just locks the IOPF flow on the master
> because we are doing the IOPF flow in the wrong place. The IOPF
> enable/disbale should be done in attach under the group mutex.
> 
> init_mutex will be deleted once the iommu_domain_alloc_paging()
> conversion is done.
> 
> asid_lock.. Is a place holder for the nascent BTM support. It locks
> domain->asid only. The BTM patches make this per-instance instead of
> global. Unfortunately that locking scheme doesn't work 100%, but I
> have a notion how to fix it..
> 
> asid_lock is also going to need some reconsidering when we make the
> domain able to attach to multiple instances which is something iommufd
> wants.
> 
> devices_lock protects the device list only, excluding the special
> nr_ats_masters thing.
> 
> Then the hidden group mutex makes all the ops touching master single
> threaded, and the driver has always quietly relied on this. It
> protects the STE/CD and parts of the master.
> 
> So I think we end up with only the group mutex, asid_lock and
> devices_lock it is OK.
> 
> The order is group -> asid -> devices, which is layed out clearly in
> the attach functions.
> 
> > We've got a few global locks with generic names and after a few
> > rounds of refactoring it's really hard to know who's responsible for
> > what, especially now that we have stale comments referring to
> > arm_smmu_share_asid().
> 
> > We've also grown a number of places where we
> > drop a lock in the callee and immediately re-take it in the caller,
> > which tends to be a source of bugs.
> 
> Do we? Can you point to what you noticed?

As I recall, I just noticed that:

- We have a bunch of comments around 'arm_smmu_asid_lock' that refer
  to arm_smmu_share_asid(), which no longer exists.

- arm_smmu_remove_dev_pasid() drops the asid_lock only to have it retaken
  in the callee via ->attach_dev().

- arm_smmu_attach_dev() takes/drops/re-takes the devices_lock indirectly
  when it calls arm_smmu_attach_prepare() and arm_smmu_attach_commit().

- arm_smmu_attach_dev() takes/drops 'arm_smmu_asid_lock' via
  arm_smmu_domain_finalise()) and then re-takes it before the attach.

Please note, I'm not saying that there's a bug here, just that it would
be easier to work with if we had some documentation and lock ordering
assertions.

Will
