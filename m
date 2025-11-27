Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EE01459FA;
	Thu, 27 Nov 2025 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764249419; cv=none; b=qcBbdrUja8tCQ52cyTxIW3BIAuFGvSTceByn1R0YiGdN9aSt2Tkxxb7IiRt6uv5rIGuhhpnbtzAwLz+i+Iiq7jQUU57xOMLJqCyT+q6NLsthj5iZZbE5lgX4/A7JF/thXaoXZJtVCoWV4hRfhd279Dxi3p47buXLxf73b7W5z5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764249419; c=relaxed/simple;
	bh=SxHzLScJ5aY8sylg3dQDijDUacHVBWCDtkYDLxWaFQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ll7rTe3Jpdr7te6J5Cya+4gIJRpyxAukPK1fPVVDOgLelbHrgWK1ftcK8qhu3MZZ+OMMSbVX7GEhMcSPVrviYt4s0uokhmEWQ3PB70RMleG2UwHdqfdZPPWosM3cmBOrCHYc0zJJflMSqm6CmCGatDdE8V5qAN4tlConIQSYyjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=UPuEDOVJ; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="UPuEDOVJ"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 68FF35C709;
	Thu, 27 Nov 2025 14:16:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764249415;
	bh=SxHzLScJ5aY8sylg3dQDijDUacHVBWCDtkYDLxWaFQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UPuEDOVJBGyMyIg6NVdpmbs9Ir+6vCEXK4HmBLLnkIXzu/7G7rFY5ccqwrPoI3SEj
	 yooOHeUWRdj5kVlwUiUwZN06QZ04WEUq2H3whCSqrV2n3cExLnzY77KPfg0hIxhTig
	 jaUJZb1Fbr67Efp0w6LQ+EjJ3tALemenZIsSk8MUW8i1kC13elqr+MJzBlJw58E6GV
	 +0ZPEZMlhe2eXDKOWuVM+XbFZzkyoE+o77nCgm3vsGBUhg4g8rZNU/77qcW3BbJMhR
	 k0W3y3xHr5uaRclfeN1uRR3Mc/VP0bmLbpbKQ9boId59RUhY5FX2sATMFYvlIsgX80
	 FlGO7l3Xct1ag==
Date: Thu, 27 Nov 2025 14:16:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	kernel test robot <lkp@intel.com>, patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>
Subject: Re: [PATCH] iommupt: Avoid a compiler bug with sw_bit
Message-ID: <xaq53umm2oacl244dqi6fn67hwz2y3oose44dxrwsjjsmx43nj@5qcbdawihp6m>
References: <0-v1-2e3b97d2d9b3+13c-iommupt_swbit_bugon_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-2e3b97d2d9b3+13c-iommupt_swbit_bugon_jgg@nvidia.com>

On Wed, Nov 26, 2025 at 03:21:27PM -0400, Jason Gunthorpe wrote:
> gcc 13, in some cases, gets confused if the __builtin_constant_p() is
> inside the switch. It thinks that bitnr can have the value max+1 and
> fails. Lift the check outside the switch to avoid it.
> 
> Fixes: ef7bfe5bbffd ("iommupt/x86: Support SW bits and permit PT_FEAT_DMA_INCOHERENT")
> Fixes: 5448c1558f60 ("iommupt: Add the Intel VT-d second stage page table format")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202511242012.I7g504Ab-lkp@intel.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/fmt/vtdss.h  | 8 ++++----
>  drivers/iommu/generic_pt/fmt/x86_64.h | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)

Applied, thanks.
