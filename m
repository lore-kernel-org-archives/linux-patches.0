Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AABE815B971;
	Wed, 19 Feb 2025 09:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957965; cv=none; b=W6qkFoWkEXEwN/ncqrZDsk4TCRLeTa468LkfySfekTYDdptQA4ZoPydxAoFDK2va9FuVJeB+f4+qyTyFjcFhmUCohEk2JfGE3C+s9B6nxnwYXGN8BdiqKqOUUDTh/Dh95ttfqwYC0tgGRIyrh46HChKUQADBa98MREOdRpdSFbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957965; c=relaxed/simple;
	bh=tJqjSoz3iLD6kaQWTxNewmIgpE2tGXmtWnyve+uIREU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StzgrbxggTtvxC+tPIqCTIanMQTsZi8yVVXjEVqa3riVf5qpCJ3vfobVua7r+qBSlz0MLK4YmUpt2kr13QCwGfVQHpPDzurg2TgN+LWHA+H8+/cNDF4FcFXl8AJ7dVKytW7ytBHX1vIxG2u2buerdMDsqV/tuILt5im0UIJOEIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=OU+H026F; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="OU+H026F"
Received: from localhost (unknown [167.220.255.121])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6EF0720376F6;
	Wed, 19 Feb 2025 01:39:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6EF0720376F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739957963;
	bh=K5oyS3pxMbCPBq4OvXI2KxKTpaHciFt4mQwhLdmxf60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OU+H026FmO5m/NBCd3s2yffKiMHKHN6DYn4Kr3Nw2xEvY/MgLWZDklEWjafD0lvpe
	 GhW9h8fYbN7EZGnKR5Y2j73UWJ949YD+je2uPgRsQFB0+VBzlyfIuSepFxxObwXGQr
	 eB1OKHHfF0sIuE/jpgrP0A3VSa6XACeWultZZsHY=
Date: Wed, 19 Feb 2025 17:39:19 +0800
From: Yu Zhang <zhangyu1@linux.microsoft.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: jacob.pan@linux.microsoft.com, 
	Easwar Hariharan <eahariha@linux.microsoft.com>, "zhangyu1@microsoft.com" <zhangyu1@microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev, tina.zhang@intel.com
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213180919.GC243081@myrica>

On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
> On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
> > On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
> > > Hi Jacob,
> > > 
> > > On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> > > > Our code and backend support are still in the early stages, that is why
> > > > I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> > > > anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> > > > @Jean @Eric Do you know?
> > > 
> > > As far as I know Tina worked on this most recently:
> > > https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
> > > https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
> > 
> > Thanks a lot for this information, Jean.
> > IIUC, these patches were trying to add VT-d IO page table support in
> > virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
> > does anyone have plan to do the incorporation? 
> 
> I'm not aware of anyone working on this at the moment. Something you will
> need for a portable pviommu is a library that manages PASID tables rather
> than page tables [1], because the Arm SMMUv3 arch only support assigning
> PASID tables to the guest. Alternatively you could implement opaque PASID
> table allocation via host calls, letting the guest allocate GPA space and
> the host manage the PASID table, but that idea didn't seem very popular at
> the time.

Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
the guest manage the PASID table, and then assigning it directly to the
backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
my understanding is the PASID table shall be managed by host. By "that
idea didn't seem very popular", do you mean that people also want the 
ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
managed by the guest). If yes, why? 
> 
> Thanks,
> Jean
> 
> [1] https://lore.kernel.org/all/20210115121342.15093-1-vivek.gautam@arm.com/
> 

B.R.
Yu
