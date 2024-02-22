Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018BB15531F;
	Thu, 22 Feb 2024 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708623630; cv=none; b=qkfKOg+BqhsuWIS7wfeEEsrsQWNnAsXgNzMsNnyIr1CEPRGkAGjsJCyU4GeBAFYJUWg7MB6IqjIkS6BhAiQw3fVyQpcxL/AW1JgvhEXmUxR/ll23pBWp1RcRzhXBs0KJjpRT7hE7pvJYwBNRs5K8SRAMd7xcD0nqZHZErms+L9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708623630; c=relaxed/simple;
	bh=Lxy35IxJA9zLvTR8+MsDa6Dx8mvc1F85DmPcsyHp79k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueVmUiBuf8AiDYPcjlaRXKBdI1cm1D1PWCK4VtTE2QD0urjd68DTnus2lq9t/wglIQY2Q/IGG/uPmygra0+OEJ2ECK1toZnTMsjyVCxOyuiEPFDIymbYM81ev/UKRu6xHJg6h4IZvBYx9XLggG0OYMRH4n7QAbm5WxcczWGhrpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tq5dStIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tq5dStIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5EC433F1;
	Thu, 22 Feb 2024 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708623629;
	bh=Lxy35IxJA9zLvTR8+MsDa6Dx8mvc1F85DmPcsyHp79k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tq5dStIU8qojXF82Ht4ZCLziIEYJ9yTyQ1u39dSPsT+i+TRzsjEJe6lp2jq94XOY7
	 SJ42lcAUkhry7M4q2cghFNZxC2j/A4Im2Y0Lbqpl+cWNp8/BhexwczuVMqqBUpYidd
	 lCZiWZri4Xx/3qV7GGGOjG/IFHQmZ74GPBHwKa+jvB4BtUkMX0LR4DlsHIuXtxuVRS
	 ZyKtK/HvaizyYhmSmife6wDceovrxEgliDdAjkxQmypLu3MZkPnnvteWfjpfTaRCmj
	 Uo6m94srsPcqpRcXS7hTiKNB+8nPaVqWAE7scFyu3+sDmHNeXL9kkUTTYKfokgF6vq
	 4299yxf883fxw==
Date: Thu, 22 Feb 2024 17:40:22 +0000
From: Will Deacon <will@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 02/17] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <20240222174022.GA9488@willie-the-truck>
References: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 15, 2024 at 05:27:09PM +0000, Robin Murphy wrote:
> On 06/02/2024 3:12 pm, Jason Gunthorpe wrote:
> > +/*
> > + * This can safely directly manipulate the STE memory without a sync sequence
> > + * because the STE table has not been installed in the SMMU yet.
> > + */
> >   static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> 
> This name is long out-of-date - if we're refreshing this area, please rename
> to something relevant to what it actually does, e.g. s/bypass/initial/.
> 
> Although frankly I also think that at this point we should just get rid of
> the disable_bypass parameter altogether - it's been almost entirely
> meaningless since default domain support was added, and any tenuous cases
> for wanting inital STEs to be bypass should probably be using RMRs now
> anyway.

We probably can't drop it for SMMUv2, but I'd be more than happy to do so
on SMMUv3. I think one of the reasons for keeping it in the new driver was
that the Arm Fast Model used to need it for legacy virtio devices that were
downsteam of the SMMU but couldn't advertise F_ACCESS_PLATFORM. Was that
fixed?

Will
