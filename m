Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442C3278E71;
	Mon, 16 Jun 2025 10:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750068190; cv=none; b=uU/PAoW//ODD/9QHh98gL9xgPbKsX0fJ1CAj1NZRGgCVtmw1vgUPAsD+OSU9FShPQ9Rqn03gjB/I7FR3WwdwFR8IAm3k6B4l2VE+KNwZpkUYfojc4JaN5jz0alRnLBHttdz9DComBHdLAmtlyDQHlygi/NoOarFgOGsiV40HVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750068190; c=relaxed/simple;
	bh=XQM8j714x8CB0+wIsMuEuOxZKpbd7ep9EJ8KDVn9O04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MspZ6jFnuxd1VpgE+walzLfOWFJIh0Icc/Cn3Ja1VaJj8MZgwzZgFR98YCM+uV2SDJTjLMghluvWO0WBE7EHOz4OeascCPgMd/1mGkozhXpzVXyTRwqRJ2wSeKBV8/HBYVbj57ScZdLVxDaiyBuPMtstZqCCfZTohurMnlHf7lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bjo78z/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bjo78z/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1DDC4CEEA;
	Mon, 16 Jun 2025 10:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750068189;
	bh=XQM8j714x8CB0+wIsMuEuOxZKpbd7ep9EJ8KDVn9O04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bjo78z/unMglag+thKwfukBAUjd4ObIDnwtDCbACbFN5dFlqSZb7v2YHP8Ec096Xz
	 3bBI17L+F4CO4kHNuVKN4tT+N3y5D96977CfynimipzSkpa684O1LZf8Tpd8b3uXfH
	 VjyIiqTLkKw0ooqWiFAab1+KWJAr5v0cdg1farxLQL2LQG3yXIKkAPYh1W1dX9/ga7
	 jaEmX0vtnKB6tc/p+4nOfiX5AMUCLhbfPMmMgV3qM2RDzSnlJsw0r+EPs9u4X0rXfd
	 gRIEN/qyLYZiLxAYWFv8B/s11wE2NTm2iv3Fjv3cL2qiaYUZ8LYvqLelF9dj8magUt
	 O/gxT9SFf8NjQ==
Date: Mon, 16 Jun 2025 11:03:04 +0100
From: Will Deacon <will@kernel.org>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 10/14] iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with
 arm_vsmmu_init
Message-ID: <20250616100303.GA17132@willie-the-truck>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Jun 13, 2025 at 11:35:22PM -0700, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced.
> 
> Sanitize the inputs and report the size of struct arm_vsmmu on success, in
> arm_smmu_get_viommu_size().
> 
> Place the type sanity at the last, becase there will be soon an impl level
> get_viommu_size op, which will require the same sanity tests prior. It can
> simply insert a piece of code in front of the IOMMU_VIOMMU_TYPE_ARM_SMMUV3
> sanity.
> 
> The core will ensure the viommu_type is set to the core vIOMMU object, and
> pass in the same dev pointer, so arm_vsmmu_init() won't need to repeat the
> same sanity tests but to simply init the arm_vsmmu struct.
> 
> Remove the arm_vsmmu_alloc, completing the replacement.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 11 +++--
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 46 ++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +-
>  3 files changed, 32 insertions(+), 28 deletions(-)

Acked-by: Will Deacon <will@kernel.org>

Will
