Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5BD7253F09;
	Wed, 12 Feb 2025 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739379939; cv=none; b=STBkPRvxDONIx+6G4nbHcVjVptZaP6mhnF10g+YCDC7c+gHaRuNiX5F9xaeQ3p3OMcCrndePKybDXQI7pLR7KBdQZX2XOQ+R/1I/c4vTVFzw0nfWihEyagjOUqnT3DgM5cwc5uoR9UPdS+XeUoYfQB9r165e2c6ge93hEWn3NvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739379939; c=relaxed/simple;
	bh=YsudT/6TBnrXzrKQm/Qxe9K/MN4Wek53eMr5xX7Cpl4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tKaIhNMEJP5jPtWeuu0Qs+fvDv0pmgotiJCLkDrHtqEHioOWcHDE4/kBUqyXqH+wE44LaiiKMYL3zUYIsZiZOoxMD9c1DAivZzICGpyWFwiG/e7LaPnGrYQeKiJLYMKj2eZLxLZtAVhj0OiJDahbjF5btY4OmFBY/xUaVBAbKHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=oDk5cFeA; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oDk5cFeA"
Received: from DESKTOP-0403QTC. (unknown [20.236.11.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id D8FA52107AA4;
	Wed, 12 Feb 2025 09:05:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D8FA52107AA4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739379937;
	bh=TW1VMid6dkrWdHmdL4kONKDzLsTVzZ4wZc9lDpBiMvM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=oDk5cFeArxzEJY4PKwww6/XyIqeQP/AuRea73/TYxGQFkQxlRFmZCIdLPDKx3GQXZ
	 uhxdWCatyI2FFZbImorgeaYFaPPmHdLN8qW5gzOadT4OdPfx8UjN72iCURPx2z7yuV
	 K/aN5CIyC6U7ORlTqBUD3BBmjleRQMHu9WK6lXos=
Date: Wed, 12 Feb 2025 09:05:35 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev, Joerg Roedel
 <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250212090535.4973dbaf@DESKTOP-0403QTC.>
In-Reply-To: <20250212115845.GA1627174@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
	<67abee53.170a0220.154671.ae28SMTPIN_ADDED_BROKEN@mx.google.com>
	<20250212115845.GA1627174@myrica>
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

Hi Jean-Philippe,

On Wed, 12 Feb 2025 11:58:45 +0000
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> Hi Jacob,
> 
> On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:
> > > However, there seem to be some unrelated qemu bugs. 7.0.0 does not
> > > have working VIRTIO_IOMMU_F_BYPASS_CONFIG and neither qemu works
> > > with an IDENTITY domain using !VIRTIO_IOMMU_F_BYPASS_CONFIG. It
> > > prints:
> > > 
> > >  qemu-system-x86_64: iommu has granularity incompatible with
> > > target AS qemu-system-x86_64: iommu map to non memory area
> > > 80000000 qemu-system-x86_64: iommu map to non memory area c0000000
> > >  qemu-system-x86_64: iommu map to non memory area e0000000
> > >  qemu-system-x86_64: iommu map to non memory area f0000000
> > >  qemu-system-x86_64: iommu map to non memory area f8000000
> > >  qemu-system-x86_64: iommu map to non memory area fc000000
> > >  qemu-system-x86_64: iommu map to non memory area fe000000
> > >  qemu-system-x86_64: iommu map to non memory area fe800000
> > >  qemu-system-x86_64: iommu map to non memory area 0
> > >  qemu-system-x86_64: iommu map to non memory area fef00000
> > >  qemu-system-x86_64: iommu map to non memory area ff000000
> > >  qemu-system-x86_64: iommu has granularity incompatible with
> > > target AS qemu-system-x86_64: iommu map to non memory area
> > > 200000000 qemu-system-x86_64: iommu map to non memory area
> > > 400000000 qemu-system-x86_64: iommu map to non memory area
> > > 800000000 qemu-system-x86_64: iommu map to non memory area
> > > 1000000000 qemu-system-x86_64: iommu map to non memory area
> > > 2000000000 qemu-system-x86_64: iommu map to non memory area
> > > 4000000000  
> > 
> > I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.
> > 
> > qemu-system-aarch64: iommu map to non memory area 0
> > qemu-system-aarch64: iommu map to non memory area 8100000
> > qemu-system-aarch64: iommu map to non memory area 8200000
> > qemu-system-aarch64: iommu map to non memory area 8400000
> > qemu-system-aarch64: iommu map to non memory area 8800000
> > qemu-system-aarch64: iommu map to non memory area 0
> > qemu-system-aarch64: iommu map to non memory area 0
> > qemu-system-aarch64: iommu map to non memory area c000000
> > qemu-system-aarch64: iommu map to non memory area 10000000
> > qemu-system-aarch64: iommu map to non memory area 20000000
> > qemu-system-aarch64: iommu has granularity incompatible with target
> > AS qemu-system-aarch64: iommu map to non memory area 200000000
> > qemu-system-aarch64: iommu map to non memory area 400000000
> > qemu-system-aarch64: iommu map to non memory area 800000000
> > qemu-system-aarch64: iommu map to non memory area 1000000000
> > qemu-system-aarch64: iommu map to non memory area 2000000000
> > qemu-system-aarch64: iommu map to non memory area 4000000000
> > qemu-system-aarch64: iommu map to non memory area 8000000000
> > qemu-system-aarch64: iommu map to non memory area 10000000000
> > qemu-system-aarch64: iommu map to non memory area 20000000000
> > qemu-system-aarch64: iommu map to non memory area 40000000000
> > qemu-system-aarch64: iommu map to non memory area 80000000000
> > qemu-system-aarch64: iommu map to non memory area 100000000000
> > qemu-system-aarch64: iommu map to non memory area 200000000000
> > qemu-system-aarch64: iommu map to non memory area 400000000000
> > qemu-system-aarch64: iommu map to non memory area 800000000000     
> 
> QEMU v9.0 and v9.1 have reached end of life. Do you also get this
> error with QEMU v9.2.x?
have not tried. will do.

> Are you running an arm64 guest on an x86 host with TCG, or arm64
> guest on arm64 host with KVM?
This is arm64 guest and host.

>  Does reproducing this require
> modifying QEMU or Linux to disable support for F_BYPASS_CONFIG, or
> just passing QEMU/kernel parameters?
I only modified guest code to pretend F_BYPASS_CONFIG is not supported,
 a couple of places like:

-       if (virtio_has_feature(viommu->vdev,
  VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
+       if (!virtio_has_feature(viommu->vdev,
  VIRTIO_IOMMU_F_BYPASS_CONFIG)) {

Is there a QEMU command line option to disable
VIRTIO_IOMMU_F_BYPASS_CONFIG?


