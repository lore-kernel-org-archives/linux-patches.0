Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D2158D70;
	Wed, 10 Apr 2024 14:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712760273; cv=none; b=bI3Z3tlcch2bQPb/Ue7RWQKWRcvZEyxRD62iQFjkvsT9thbOks7sAkc2SikLxzQhPNvilVq1p3X78aBl3yYLuzMpwLPkLVVuuMItu3J3ACdJ8SXEV+BKAwLbs+48SzoEO2Gp/XCsn+Ykeoa7+GPteQLDWxffSiCLWZMUGq06y40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712760273; c=relaxed/simple;
	bh=/K5USd0NBdotcljjFwf7xqKH8dXK5hCEaoHws5cvcGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTqeRknBF5Ck9mPlBF4ASmZp95G7Gt2YfNTiOkRO+qIQoUZJwVHnYw5nP3fkTNUvnB05CgFzyEgtagmvXPdCmm3izc5ZibxjPN0ADTt++qWjal25cSar2Znk9Fuc3bRJfZlEYeoKXSI4bbaIF+P1t3b20NqQ+4NkNehmr1AzBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umyEgEWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umyEgEWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7D9C433C7;
	Wed, 10 Apr 2024 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712760273;
	bh=/K5USd0NBdotcljjFwf7xqKH8dXK5hCEaoHws5cvcGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=umyEgEWjX2jEZwX58idH08F8L7TgWw02BUER80VH8LwBKppeGa7sHoJj8kxdfdPjq
	 F5wYa3FIRwltdk3/u1n4HonDPW+ZvSzklIRe1Uj0rDqy4edZb+MuGT/s41Id0HSnKI
	 OjttCfQDAlwncYwpVg9CAHzY6E161dfrist79mi+Uq8OZJ3jM4NIt1v1eg1NlksRPG
	 +wx7EjSGOF1pNGwiJ1PTUX4QC/XqPCc+4oIRHTLfRhrREqSXAUkYh7xZVNknNcVS+u
	 Tn6rwRREbeCBianWr7N+I4fuK3aW+IKdi4m6QjD1uyERL2wo7HcvY+GouaK08ENhlA
	 tfa0sI294ftZw==
Date: Wed, 10 Apr 2024 15:44:25 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>, Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 06/29] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <20240410144425.GA24887@willie-the-truck>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <20240409124007.GA23088@willie-the-truck>
 <20240409235512.GK5383@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409235512.GK5383@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Apr 09, 2024 at 08:55:12PM -0300, Jason Gunthorpe wrote:
> On Tue, Apr 09, 2024 at 01:40:08PM +0100, Will Deacon wrote:
> > On Wed, Mar 27, 2024 at 03:07:52PM -0300, Jason Gunthorpe wrote:
> > > Prepare to put the CD code into the same mechanism. Add an ops indirection
> > > around all the STE specific code and make the worker functions independent
> > > of the entry content being processed.
> > > 
> > > get_used and sync ops are provided to hook the correct code.
> > > 
> > > Signed-off-by: Michael Shavit <mshavit@google.com>
> > > Reviewed-by: Michael Shavit <mshavit@google.com>
> > > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 170 ++++++++++++--------
> > >  1 file changed, 102 insertions(+), 68 deletions(-)
> > 
> > Any chance we can pull the STE testing stuff forward from Michael once
> > we have the entry writing ops indirection, please? It would be nice to
> > land that before adding the CD support, I think.
> 
> Yes, I can. There is a bit more work because the CD testing is still
> not finished, but I can probably do that.
> 
> How about this, I split part 2 into half and the first half ends at
> "iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()" (it
> finishes changing the CD programming to look like the STE). I'll pull
> forward the selftest patch into that series. That is another 9 patches
> from what you have taken so far.
> 
> The second half is all about "building a generic pasid layer".
> 
> Those 8 patches have all been looked at now, so if we pick them up
> soonish we can more easially focus on the latter patches.
> 
> Agree?

Yes, please, that would be really good.

Thanks,

Will
