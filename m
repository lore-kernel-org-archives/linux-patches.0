Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7503028BAB6;
	Thu, 17 Jul 2025 10:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752746641; cv=none; b=NLyc8z4ySAYu15ynP/DhHoInZnWOFD8hHiPD10g90nyYjsugfPlgxpxgP293JzgtAQuJ4dpIIf/4lH2JJCN0qIIB4xkWwv2lR+fs2+duYXa8Q65LHaKjULz+KD+jB5cgx9bHqMQQ57BueTOTCDz9QPBXyIHOSI3v9PRvW11/NRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752746641; c=relaxed/simple;
	bh=6AzRmaF/C9gsuE/7Jv4RuErDpIsP6eENFo5ZA0dEHYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kW2iMGD73k9C2Tlt+hj9HsUPZxUiQ/aXLUIPUfgq7iPZrOj58NAhPmLtG9jTT3yRtNuHEPY4Wt3snSkvogDQM/PocHDItnHG7DTZ33cJcEpJsRCuesJ7SWfTi28/0c1jZcCyH0y5EPJeEEgCsoIFKn0WHJpDkkhYzulgCBCTdMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VruvNtP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VruvNtP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1552BC4CEE3;
	Thu, 17 Jul 2025 10:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752746641;
	bh=6AzRmaF/C9gsuE/7Jv4RuErDpIsP6eENFo5ZA0dEHYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VruvNtP9l6HNodqDaZhMDQLMrEGvfpYCVOFcsbVdhTmofToikqqngoX4uoOjbthrv
	 OZs0JPaMOvg5ymjGPW/8dGto5Wgn9g8O6HIuD8U7wY9XsTQ2VboPDFwfvlwZy89LUB
	 v686WW70QQV87Oosmi5nFGqnsgCZZlNEYb3WtobLvcOAHQHbYvFJsQN51IOqGpXe+I
	 3Ytsm08LwT+70ED+rDoXVydRK7pDAp0fhqXwjlHB7YGEZWuLpBiVCwqDxNjo88jB8c
	 3QNAHYzg+GLe+5b0uAdTBz4R1nDwmQZLOu6pkPXCGTElrxXDzNvXC4+7dxj8EUwJsg
	 CTP+mOJT7fF6w==
Date: Thu, 17 Jul 2025 11:03:56 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Ankit.Soni@amd.com
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <aHjKjDunWlpF_aSx@willie-the-truck>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
 <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
 <20250716124929.GA2138968@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716124929.GA2138968@nvidia.com>

Hi Jason, Vasant,

On Wed, Jul 16, 2025 at 09:49:29AM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 12, 2025 at 10:54:00AM +0530, Vasant Hegde wrote:
> > > Adjust dma_max_address() to remove the top VA bit. It now returns:
> > > 
> > > 5 Level:
> > >   Before 0x1ffffffffffffff
> > >   After  0x0ffffffffffffff
> > > 4 Level:
> > >   Before 0xffffffffffff
> > >   After  0x7fffffffffff
> > > 
> > > Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> > > Link: https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
> 
> Will, can you pick this up please? It seems to have been overlooked

Thanks, I had missed this one (I only trawled the list for the two weeks
prior to Joerg going on holiday).

I'll pick it up, but please now that the preceding:

	if (pgtable == PD_MODE_V1)

part now returns:

	PM_LEVEL_SIZE(amd_iommu_hpt_level);

instead of:

	~0ULL;

thanks to 025d1371cc8c ("iommu/amd: Add efr[HATS] max v1 page table
level"). I'm assuming that's fine because this change is about v2, but I
just wanted to highlight it in case there's a potential issue.

Will
