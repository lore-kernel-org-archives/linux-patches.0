Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 773751D6DC5;
	Wed, 19 Feb 2025 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739963508; cv=none; b=Jrap8TxnPigTaSWQkys/vRJX2BwkC70I+VB0zQywtxVPRT3/TpJFj0dS5QNdXpY/2xOmORVOIRum01r7WHTu4KrhJwPUXJSPZxKRblxum8nxRnzY9n3jdWtLTOwaOuUXhQpQnMqIfXS+qHxDygMH6uQhaiGh/jQ1gyKdjwM2ThI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739963508; c=relaxed/simple;
	bh=P/QXVOHnKUXYAuGa7Zt43Uh/TJ4agr7FaxPqqsvGR3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttlTX4YZbomK2a2UX7btNw7HfFMCE08Pu47f2s5wg1IO0fcIgrMPrcJ0UojQg65WsiiLaa1xQ+/UnVDbyJ6T9H9gkOlJ+PCN0xngbWd0rXVz5pSbpz4rXJ70KfRviQeUBX/Q9G95qYSdj4jtbvXQXf8YWBSSmPMNvryAPngP5Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=WjfYoCF2; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="WjfYoCF2"
Received: from localhost (unknown [167.220.255.121])
	by linux.microsoft.com (Postfix) with ESMTPSA id 51ABD20376F9;
	Wed, 19 Feb 2025 03:11:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 51ABD20376F9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739963506;
	bh=246fIDKW3H0fAdd9jV3xEJkXBQHcypW1qTL/m0O/yJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WjfYoCF2Aq9p/0kZ44k1pc10cYbzsF1fdnRAmP/j9C9NJvxkdBkl+OBGLIfhPaZ5y
	 n/fxKThaslwA6zfq8wUPyO3plBTK8RIw2Slp2n9HJCQBS4G+g4pvNH9IbBZga9eH4F
	 +JPdDKyKRkibSA/ydjxV1d2DwgJV/0pfy68RQVyA=
Date: Wed, 19 Feb 2025 19:11:43 +0800
From: Yu Zhang <zhangyu1@linux.microsoft.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: jacob.pan@linux.microsoft.com, 
	Easwar Hariharan <eahariha@linux.microsoft.com>, "zhangyu1@microsoft.com" <zhangyu1@microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <jdyb4bxo5miiybkjbmnkszlcx5vwik7lqa5kgx4ptsage6tlu7@axsub4six2uu>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
 <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
 <20250219103518.GA513544@myrica>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219103518.GA513544@myrica>

On Wed, Feb 19, 2025 at 10:35:18AM +0000, Jean-Philippe Brucker wrote:
> On Wed, Feb 19, 2025 at 05:39:19PM +0800, Yu Zhang wrote:
> > On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
> > > On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
> > > > On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
> > > > > Hi Jacob,
> > > > > 
> > > > > On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> > > > > > Our code and backend support are still in the early stages, that is why
> > > > > > I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> > > > > > anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> > > > > > @Jean @Eric Do you know?
> > > > > 
> > > > > As far as I know Tina worked on this most recently:
> > > > > https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
> > > > > https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
> > > > 
> > > > Thanks a lot for this information, Jean.
> > > > IIUC, these patches were trying to add VT-d IO page table support in
> > > > virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
> > > > does anyone have plan to do the incorporation? 
> > > 
> > > I'm not aware of anyone working on this at the moment. Something you will
> > > need for a portable pviommu is a library that manages PASID tables rather
> > > than page tables [1], because the Arm SMMUv3 arch only support assigning
> > > PASID tables to the guest. Alternatively you could implement opaque PASID
> > > table allocation via host calls, letting the guest allocate GPA space and
> > > the host manage the PASID table, but that idea didn't seem very popular at
> > > the time.
> > 
> > Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
> > the guest manage the PASID table, and then assigning it directly to the
> > backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
> > my understanding is the PASID table shall be managed by host. By "that
> > idea didn't seem very popular", do you mean that people also want the 
> > ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
> > managed by the guest). If yes, why? 
> 
> No, the proposal for managing the PASID table in the host was done before
> the VT-d architecture added Scalable mode, so at the time they also had to
> assign whole PASID tables to the guest and weren't keen on managing it in
> the host. I believe in revision 3 (2018) the architecture added support
> for Scalable mode and the ability to manage PASID tables in the host.
> 
> Nowadays it wouldn't make sense for a pvIOMMU to manage the VT-d PASID
> tables in the guest, because as I understand it there is no demand for
> supporting the legacy mode address translation of VT-d.

Thanks, Jean. Yeah, my understanding is that old revisions of VT-d looks
more like the ARM SMMUv3. But with scalable mode introduced, there's no
need for a pvIOMMU to allocate a guest version PASID table on VT-d.

So my question becomes: why do we need a library that manages PASID
tables in the guest? To also support AMD IOMMU besides ARM SMMUv3(
I saw your spec proposed both ATTACH_TABLE request for AMD GCR3 table
and ATTACH_TABLE request for AMD page table, but don't know which one
is more preferred in practice)?

B.R.
Yu



> 
> Thanks,
> Jean
