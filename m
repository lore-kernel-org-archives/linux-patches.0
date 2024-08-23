Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4C5139D00;
	Fri, 23 Aug 2024 09:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724405182; cv=none; b=W0FydMU6oaQf+bskG8YQeucbnD6VMBhR/nxkcewV5HlmK40tALwMRyUnfz70acY1JBhjpJ4B4dUiHKuY9P15zvOPm01H/cpW3d8YVzpmXvk9YREwIf7rVT0Zd1JeyuoEZqnMRh4N9zqiev4W+N4tyVhcTqjLdy5roRRRB5tKcG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724405182; c=relaxed/simple;
	bh=nYdQx0Bw/1qWJ09AkSNXnvSA6gUvryz0Ptb4Fn/grqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kcxzZD8pa2uUJTjshLJjzdPmsAhgt/b91Np3Ff7YJRn5B9by/7yHzVpD+RiOEWpFxh79qbnlbSPbwHthX796dw+DK0fMa2CUrO/YTwBvUANEIb8gx3Z10GIYXttPm+hD3Vqqg+qa5fb302iGY1BtBVVJK5f0wJFhQzcAKQ+2uag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=f9CXvZJF; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="f9CXvZJF"
Received: from 8bytes.org (pd9fe9dd8.dip0.t-ipconnect.de [217.254.157.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id ED9C72A7BA5;
	Fri, 23 Aug 2024 11:26:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1724405179;
	bh=nYdQx0Bw/1qWJ09AkSNXnvSA6gUvryz0Ptb4Fn/grqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f9CXvZJFwxdZ76Ubga0+l8FYomrFMgTCZsVuMslZBZdegkglVmODIEdst/KF4g97v
	 M0Onn+ushP3URtZLsvb9wfq+Rp038RnAyO7wRDRf9nZMHTif9sMSnD8vs+4eWcEnAT
	 g9piXcBLnKjyh6WDYwwzAjGdgB+Z/E26nr+KhHUf7Fn2qwT4kNy59Yo9wfNA/1V4nP
	 LE/hXxvXzXj7ub7zlXX+EL67wKHCsL4Hi/kgpf/U5VKXYWl0dSbK4tgViUNFwUmq00
	 DzybJhIUbbWBru9hZ2FxveHTTj//CUk9jHieg3FEAEVSWhx2bmvx6U7scUwfM47xU9
	 25LTiEcSL2jhA==
Date: Fri, 23 Aug 2024 11:26:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH 01/14] iommu/amd: Move allocation of the top table into
 v1_alloc_pgtable
Message-ID: <ZshVuebDjRH5qdvF@8bytes.org>
References: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
 <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>

On Wed, Aug 21, 2024 at 02:37:07PM -0300, Jason Gunthorpe wrote:
> All the page table memory should be allocated/free within the io_pgtable
> struct. The v2 path is already doing this, make it consistent.
> 
> It is hard to see but the free of the root in protection_domain_free() is
> a NOP on the success path because v1_free_pgtable() does
> amd_iommu_domain_clr_pt_root().
> 
> The root memory is already freed because free_sub_pt() put it on the
> freelist. The free path in protection_domain_free() is only used during
> error unwind of protection_domain_alloc().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/io_pgtable.c |  8 ++++++--
>  drivers/iommu/amd/iommu.c      | 21 ++-------------------
>  2 files changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
> index 1074ee25064d06..05aed3cb46f1bf 100644
> --- a/drivers/iommu/amd/io_pgtable.c
> +++ b/drivers/iommu/amd/io_pgtable.c
> @@ -574,20 +574,24 @@ static void v1_free_pgtable(struct io_pgtable *iop)
>  	       pgtable->mode > PAGE_MODE_6_LEVEL);
>  
>  	free_sub_pt(pgtable->root, pgtable->mode, &freelist);
> +	iommu_put_pages_list(&freelist);

You are freeing pages here before the IOMMU and device TLBs are flushed,
no?

>  
>  	/* Update data structure */
>  	amd_iommu_domain_clr_pt_root(dom);
>  
>  	/* Make changes visible to IOMMUs */
>  	amd_iommu_domain_update(dom);
> -
> -	iommu_put_pages_list(&freelist);
>  }

Regards,

	Joerg
