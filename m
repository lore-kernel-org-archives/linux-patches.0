Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C53271830;
	Wed, 12 Feb 2025 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739320916; cv=none; b=JQWHgVqPkKfmJFsiGl8QyqvJkTiUy4kgGu/O19DyOIdTGR/EUkghFV8cbLqYz0R5s+G0CucFZoCyYvAqisH8oog+68twrQ8xVebmLQRB6KBxSOB14jBbor8wCy6UOcFAA1BXs+LhQpkrR3f8nwXniXZpADLbgtovXlPyZKyEih0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739320916; c=relaxed/simple;
	bh=oF6rafIwSNtUENbnoYqYFZV8ow2l7/+0FQKAEsoAenU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQYB6UT7dEDjf8J9Sz6SvsAXuN0/2T72bmrnQeaqunMLQvm9w/7Shq2GymB2yS7E7TPeAkpItQEE1rQg4ZSOE9jSjGTbcyvoLTZcr8oy/U6mGNu0FsHUOac0lOaBL13SI2oWIRiYhd23xzTZmIlrmrBO1eUb/yEWGyqBRmPJ1cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gP9582rY; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gP9582rY"
Received: from DESKTOP-0403QTC. (unknown [20.236.10.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id 983292107AB2;
	Tue, 11 Feb 2025 16:41:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 983292107AB2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739320914;
	bh=te+LgTCfgT6rN9uNEpS9mlNl0cinheDGVI/VHPcuXGs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=gP9582rYDU7I3/iK7VWsbx8JVwe14EFxzbvhg2QOgWjA20IItZcefMeIRkZfaNwD7
	 k/7gcqsF9z2TmStzjtwcJsdI5tr2AkfRtIzX509Q5cEJnx7MWl8gmQ09wf64ucuMqP
	 De9Ow0WFOn/YzEgHz2oAT0Sb0RHsXqrFGHFflHbg=
Date: Tue, 11 Feb 2025 16:41:51 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250211164151.723cfce0@DESKTOP-0403QTC.>
In-Reply-To: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
Reply-To: jacob.pan@linux.microsoft.com
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Jason,

On Fri,  7 Feb 2025 10:46:00 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> virtio-iommu and fsl_pamu are the only two drivers left that still
> rely on ops.domain_alloc()
> 
> Update virtio-iommu to have a global static identity domain, implement
> domain_alloc_paging(), and finalize its domain during allocation
> instead of on first attach.
> 
> As virtio-iommu was the last real iommu driver using domain_alloc()
> update the core code to isolate the remains to fsl_pamu.
> 
> I tested this using qemu x86 7.0.0 and 9.2.0 with a mlx5 VFIO PCI
> device. The kernel behaves the same after this series.
> 
> However, there seem to be some unrelated qemu bugs. 7.0.0 does not
> have working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works with
> an IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It prints:
> 
>  qemu-system-x86_64: iommu has granularity incompatible with target AS
>  qemu-system-x86_64: iommu map to non memory area 80000000
>  qemu-system-x86_64: iommu map to non memory area c0000000
>  qemu-system-x86_64: iommu map to non memory area e0000000
>  qemu-system-x86_64: iommu map to non memory area f0000000
>  qemu-system-x86_64: iommu map to non memory area f8000000
>  qemu-system-x86_64: iommu map to non memory area fc000000
>  qemu-system-x86_64: iommu map to non memory area fe000000
>  qemu-system-x86_64: iommu map to non memory area fe800000
>  qemu-system-x86_64: iommu map to non memory area 0
>  qemu-system-x86_64: iommu map to non memory area fef00000
>  qemu-system-x86_64: iommu map to non memory area ff000000
>  qemu-system-x86_64: iommu has granularity incompatible with target AS
>  qemu-system-x86_64: iommu map to non memory area 200000000
>  qemu-system-x86_64: iommu map to non memory area 400000000
>  qemu-system-x86_64: iommu map to non memory area 800000000
>  qemu-system-x86_64: iommu map to non memory area 1000000000
>  qemu-system-x86_64: iommu map to non memory area 2000000000
>  qemu-system-x86_64: iommu map to non memory area 4000000000

I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.

qemu-system-aarch64: iommu map to non memory area 0                               
qemu-system-aarch64: iommu map to non memory area 8100000                         
qemu-system-aarch64: iommu map to non memory area 8200000                         
qemu-system-aarch64: iommu map to non memory area 8400000                         
qemu-system-aarch64: iommu map to non memory area 8800000                         
qemu-system-aarch64: iommu map to non memory area 0                               
qemu-system-aarch64: iommu map to non memory area 0                               
qemu-system-aarch64: iommu map to non memory area c000000                         
qemu-system-aarch64: iommu map to non memory area 10000000                        
qemu-system-aarch64: iommu map to non memory area 20000000                        
qemu-system-aarch64: iommu has granularity incompatible with target AS            
qemu-system-aarch64: iommu map to non memory area 200000000                       
qemu-system-aarch64: iommu map to non memory area 400000000                       
qemu-system-aarch64: iommu map to non memory area 800000000                       
qemu-system-aarch64: iommu map to non memory area 1000000000                      
qemu-system-aarch64: iommu map to non memory area 2000000000                      
qemu-system-aarch64: iommu map to non memory area 4000000000                      
qemu-system-aarch64: iommu map to non memory area 8000000000                      
qemu-system-aarch64: iommu map to non memory area 10000000000                     
qemu-system-aarch64: iommu map to non memory area 20000000000                     
qemu-system-aarch64: iommu map to non memory area 40000000000                     
qemu-system-aarch64: iommu map to non memory area 80000000000                     
qemu-system-aarch64: iommu map to non memory area 100000000000                    
qemu-system-aarch64: iommu map to non memory area 200000000000                    
qemu-system-aarch64: iommu map to non memory area 400000000000                    
qemu-system-aarch64: iommu map to non memory area 800000000000   

> Jason Gunthorpe (5):
>   iommu/virtio: Break out bypass identity support into a global static
>   iommu: Add domain_alloc_identity()
>   iommu/virtio: Move to domain_alloc_paging()
>   iommu: Do not call domain_alloc() in iommu_sva_domain_alloc()
>   iommu: Hide ops.domain_alloc behind CONFIG_FSL_PAMU
> 
>  drivers/iommu/iommu-sva.c    |  15 ++-
>  drivers/iommu/iommu.c        |  16 +--
>  drivers/iommu/virtio-iommu.c | 200
> +++++++++++++++++++++-------------- include/linux/iommu.h        |
> 10 +- 4 files changed, 141 insertions(+), 100 deletions(-)
> 
> 
> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b

