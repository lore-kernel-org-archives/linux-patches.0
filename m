Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF27EC4;
	Thu, 13 Feb 2025 05:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739425646; cv=none; b=IpcMzINsPbt5cPefIrS/OyKjcc4hXKVbFFo48m4YWBqPqgs+xRrBkyiVtQJ5KlmNJkG8iRX5IYRqQBW8ZvISLIhIVvCbwkrVmRXxcZA+FhPgMpwnDldQ449hHe2THheuZhPsZ+0e/4Q2RHVsSA96pDwvvDof6NRLx4DsLZICbEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739425646; c=relaxed/simple;
	bh=prolQBF6q3UBJQB4VkPy0upy3Xt7W32yLlCxZItHgdI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OyGriH1TK9P15lnDnPKYMXJubKWv/CNRn0Ql8/t/DRjYT74V9th1IwrcQ7cC64pu5sumX2v2KY5gYyeqfMoYK5eeWxGs+2EdKWSGYYMu23EvcWmfWNwfS+cA5z+FT4te8E5WpfsWR11U8Sd4pBjjxKbbWI8TDsHYwUJkzlJKOL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Z4TBMtMi; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Z4TBMtMi"
Received: from DESKTOP-0403QTC. (unknown [50.53.30.84])
	by linux.microsoft.com (Postfix) with ESMTPSA id 593C5203F3CF;
	Wed, 12 Feb 2025 21:47:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 593C5203F3CF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739425644;
	bh=s5+xYFUSjRfJypY4kS/R9cuXaiW/u4Res3wzREtZc3g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=Z4TBMtMiRv2SfnjJRPFski7UW+GdtCHfSpa6uT5M6Y81GgljaAJS+C24wcteOwFoR
	 fAjoHzLbR3yzXVZ7okgqQd0Ygyle085eUgYsrZl7r9cSI7F94GbnzcwpCgrWbggP07
	 zL1qaUXtneTr0hUG4SvWqb72eLrXEL1RDVBqqT+E=
Date: Wed, 12 Feb 2025 21:47:23 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250212214723.1ebf173e@DESKTOP-0403QTC.>
In-Reply-To: <20250212233053.GV3754072@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
	<3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
	<20250212112235.714b0a14@DESKTOP-0403QTC.>
	<20250212233053.GV3754072@nvidia.com>
Reply-To: jacob.pan@linux.microsoft.com, Easwar Hariharan
 <eahariha@linux.microsoft.com>, "zhangyu1@microsoft.com"
 <zhangyu1@microsoft.com>
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

On Wed, 12 Feb 2025 19:30:53 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 12, 2025 at 11:22:35AM -0800, Jacob Pan wrote:
> 
> > Do you foresee the implementation can leverage your generic iommu_pt
> > work? i.e. for building guest IO page tables. It will add a new
> > flavor (page table based in addition to map/unmap) to
> > viommu_domain_alloc_paging() i think.  
> 
> Yes I do, I think it should be no problem and it will bring the
> missing x86 formats that are currently not available in iopgtbl
> wrappers.
I guess the missing x86 formats are AMDv2 and VT-d S1?

> I'm working toward getting a cut back AMD only series ready to post,
> the other series on the iommu-pages should be the last preperation
> work.
> 
> Certainly I would be happy to help you get it implemented if that is
> your interest.

Yes, that is definitely our interest! We are looking at expanding
hyperv-iommu to include guest DMA remapping support (current code has
IRQ remapping only). This expansion includes paging and sva domains. In
terms of the need for paging domain, I believe it is identical to
virtio-iommu page table extensions.

It would be great if you could help adding/accommodating such usage to
the generic iommu_pt. I think it will be a subset of features as
intended for iommufd. I.e. map/unmap operation.

One difference/simplification than virtio-iommu is that Hyperv-iommu
(backend) does not want to support map/unmap hypercall based paging
domain. IOW, page table based paging domain only, let the guest own S1.

Our code and backend support are still in the early stages, that is why
I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
@Jean @Eric Do you know?

Adding a couple developers from our side. @Yu Zhang @Easwar Hariharan.


