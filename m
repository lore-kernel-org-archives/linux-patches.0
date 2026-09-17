Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3066653CA99;
	Thu, 17 Sep 2026 13:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652704; cv=none; b=AeNF0QXFBns4xeJqDyCrz/1wdsUvMbytbbIm4lVUigqcZbjXk9hSJi8t3I8CCSX5hfV/y/BBeIjIc68crMUGM0KWZ8ofLtinI2BcmBztmTgpy8fK/lipKB82wowM6+GP2hDRnWmufZTKXLpYPUdb3FfO4tYmp5imBAj94dfDCCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652704; c=relaxed/simple;
	bh=a63yqjDsU+Ju0Dd2MSl0oirysxus25zeMjdwfMjs9oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmItkoJ9wx+yNIwtjUCpvI2X63m93Rtrl+Q6PRFG67liMto8n5xcRLewPrKQ06Y7Je3XYlt37eyqzc11GqPPyguNw0epWzXyAg8JJPwtmnR1SGMP8FYsQEUC5GcqAZa5ysJkP5tiAw1cIQrb1xbNeV+aCvJp8BkU3omvXPfXrPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5wqlYrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5wqlYrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADDD1F000FF;
	Thu, 17 Sep 2026 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789652690;
	bh=OJ1YBU1o9gYgwxqrw/AyHHgH2Affehx//QdayYEDSAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c5wqlYrt78pFIu7OzZO4uJUZxsJJ+Gg0omy58hfcWQdqzHj3S7oVy9IBzbenqV+7R
	 p0dcDHEUewbBrt9Mc6zZL5Y0NSDYM3kNYN0CRbGhwcz+dbeMjCm6KHQpaghsNhIiJ3
	 XGJIqyMuWH8m0DH44QdqWsKwSiIJRrCVHmEfA/wxE9RaZ3HGxYIcJjpJDMWUBQb+OT
	 pl+p0++veWsSpbdBZvoO4wzBw5RLsE688yBuczmvc6x5MxIANNLUipN3OyzkeTIaB/
	 PdX+9SNHF4NPrusyykWBmPvqwKFeg1MWFWupE+KrPdvBy14VExIqmX1mmjGn64D4SM
	 eaAPV+WUvYgJA==
Date: Thu, 17 Sep 2026 14:44:42 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v6 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <aqvuyse0hmNCGJqt@willie-the-truck>
References: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <1-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
 <aquxuBnh6pdxu4-8@J2N7QTR9R3>
 <20260917131601.GY3968357@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917131601.GY3968357@nvidia.com>

On Thu, Sep 17, 2026 at 10:16:01AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 17, 2026 at 10:24:08AM +0100, Mark Rutland wrote:
> > On Wed, Sep 16, 2026 at 09:27:42PM -0300, Jason Gunthorpe wrote:
> > > The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> > > invalidation of a CONT PTE grouping in the SMMU. The recommended work
> > > around is to use a Range Invalidate (RIL) that spans the entire CONT. The
> > > only user of CONT in the kernel right now is through SVA sharing a CPU
> > > page table that contains a CONT created by the mm.
> > 
> > As someone familiar with VMSA, I've never seen "RIL" used to describe a
> > range invalidate and I think using that in the code below is confusing.
> > I *think* "RIL" has come from "SMMUv3.2-RIL", which is the SMMU feature
> > for Range Invalidate *and* Level hint, where "RI" is Range Invalidate,
> > and "L" is Level.
> 
> Yes,
> 
> drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h:#define IDR3_RIL                    (1 << 10)
> 
> Unfortunately I've noticed a couple of places like this where the SMMU
> terminology and VMSA differ a little bit. In these cases we've
> historically choosen the SMMU naming in the SMMU driver to be
> consistent with its spec.. I've definately seen this gets confusing
> when talking to people familiar with the CPU spec and IP.
> 
> I had guessed it ment "Rang InvaLidate", but you are right:
> 
>   RIL, bit [10]
>        Range-based Invalidations and Level hint support for TLBI.
>        The value of this field is an IMPLEMENTATION DEFINED choice of:
> 
> The driver also calls it ARM_SMMU_FEAT_RANGE_INV, but I thought
> range_inv everwhere made some very long names.
> 
> > Can we please spell that out as "range invalidate" or "range op"
> > (matching the arm64 architecture code) rather than "RIL"?
>  
> > That'll be easier to follow, especially as nothing in the code mentions
> > what "RIL" means -- that's only mentioned in this commit message.
> 
> The whole series uses ril as a shorthand for IDR3_RIL, and the spec
> often does the same:
> 
> [25:20] SCALE Range invalidation scale.
> 		  * See below for use of this field in range invalidation.
> 		  * When TG == 0b00 this field is RES0.
> 		  * If SMMU_IDR3.RIL == 0, this field is RES0.
>                          ^^^^^^^^^^^
> 
> So I'm certainly sympathetic, but I don't know we should diverge the
> driver from the language in it's own spec.
> 
> Do you have a recommendation for a suitable short name? It is
> meaningful work to rename everything in this series.. Will?

I think that using RANGE_INV / range_inv would be more consistent with
the existing code, but IDR3_RIL should remain as-is because it maps
directly to the spec.

If we can do that without churning the driver (looks like we can), then
it's probably worth it, but I wouldn't be keen on churning existing code
for things like this.

Will
