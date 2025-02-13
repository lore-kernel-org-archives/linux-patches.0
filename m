Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768C028A2B7;
	Thu, 13 Feb 2025 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739466232; cv=none; b=UmQhIFZNa7aTm3dw1kW7LSWN4X1+b4wLQARxofopRiUDBB7Kq6trL7GhNEDogXO9D4pb/RstEnkvCsaucgKToFR72+ooTganMSigVeGxul1R3ted17IvwTWDhuFCxfMK0KOmA5ps5iT+kzraBml+QDrMRwnBxm7m8Z1ziomopLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739466232; c=relaxed/simple;
	bh=driKE2zuE93HFLVFfBintq7SezTWpQxGPR2E7DNVQMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=grXXuj4LxiuT9kduMmsyfsChxwirHL+Kg7VOCVq3jkJcZyWULup5Rs23nqZ3o3Q/ar1bIW54DKZyfKpNTkIcAZaqfuguCYpvBFMdrlzb+8clB7TYWqK8WjUWcXs4Vi2Ov04z66BBrdmeYGdQbHJu1pkDo0IlcQ+W1r5nn6nIrww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=a4ZtBepn; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="a4ZtBepn"
Received: from localhost (unknown [167.220.232.230])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0CDC1203D61F;
	Thu, 13 Feb 2025 09:03:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0CDC1203D61F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739466225;
	bh=raGx3ERZ3nkqlnuQgKz41RX1gXr12ZZc1N/Fn0LJYNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4ZtBepnV90+FzDmYPq6USPODlSlerD5ovFsX7aKokI3WGAiQBZPI2JFBy5VN5jSl
	 4n6xjgRF8lHVZiN4YngFxB9GlN6/WwjkDbmIktIhxAsRXMklgnbM867IFWMPqHsFw7
	 Fo2jdcI4Mqe9PfIu6j0M4Scla1H6jj2hX32bPGj0=
Date: Fri, 14 Feb 2025 01:03:43 +0800
From: Yu Zhang <zhangyu1@linux.microsoft.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: jacob.pan@linux.microsoft.com, 
	Easwar Hariharan <eahariha@linux.microsoft.com>, "zhangyu1@microsoft.com" <zhangyu1@microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev, tina.zhang@intel.com
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213094601.GA243081@myrica>

On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
> Hi Jacob,
> 
> On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> > Our code and backend support are still in the early stages, that is why
> > I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> > anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> > @Jean @Eric Do you know?
> 
> As far as I know Tina worked on this most recently:
> https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
> https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/

Thanks a lot for this information, Jean.
IIUC, these patches were trying to add VT-d IO page table support in
virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
does anyone have plan to do the incorporation? 

[1] https://lore.kernel.org/all/0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/

B.R.
Yu
