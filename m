Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2C025EF88;
	Wed, 12 Feb 2025 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386212; cv=none; b=Ix6hMxfzxK0uZFC42Wjvv/+0Bg7MFSXxbnMXlUJBnEyAWmquhRlabiMrOrk4/3+20YtEoyXR9FUvuFishKmXLeN9UC31aHQmsat02C/1ixazOLoWuWLoGEUWa3C9wqiLJbFv2OAf261RS9wQjtwF1ifaXTIYVzsPB/gkS+VZlA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386212; c=relaxed/simple;
	bh=lGlxXkbFy07wbUNZfaE3M07fdK69wC8uPNp3TGFo45M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rLxFL2JSzEBEnFs5nPeqQL4qhu6sun6DOF3h9jF+M6VJHBlmUYI68mfo+dc7YspuiZxwFOVeFlX6seKabv2mUJASjkdhWFmsBWH18Avr9EVDXUjzRZq7/PE/6lGy6y69I1nDPh6J06de4uQKrazafWoEdF7WuQlRXqJhdESJhus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=rPgHeTSM; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="rPgHeTSM"
Received: from DESKTOP-0403QTC. (unknown [20.236.11.29])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6B550203F3C4;
	Wed, 12 Feb 2025 10:50:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6B550203F3C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1739386210;
	bh=GsNREgUQkdRhQmpSXgjlhj2apwo/vmOxAV4p+n55rkM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Reply-To:From;
	b=rPgHeTSM9VYlBQl19pi2YSgKeKL//9CaQJj3SqmDuosXycw0HlXxqwSDBl/sE4R18
	 q2o4DZLIkmlZ9crjdKVYag13xe5klY8FJ8rE2KmwABePR/hPw6c9+DfSfzHuoOWGiE
	 MzVMwhU8UU1QP7wGjY2ZQrgEQ6RVmgdfIvrbpqRc=
Date: Wed, 12 Feb 2025 10:50:08 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, Eric Auger
 <eric.auger@redhat.com>, patches@lists.linux.dev,
 jacob.pan@linux.microsoft.com
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250212105008.3d35ee43@DESKTOP-0403QTC.>
In-Reply-To: <20250212125007.GP3754072@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
	<20250211164151.723cfce0@DESKTOP-0403QTC.>
	<20250212125007.GP3754072@nvidia.com>
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

On Wed, 12 Feb 2025 08:50:07 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:
> 
> > I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.  
> 
> Huh, I figured it worked on ARM..
> 
> There is no requirement that an iommu driver implement identity, this
> is all an optimization. If it doesn't work in alot of cases can we
> just remove it? It would simplfy a lot..
> 
Currently, identity domain type can be set via sysfs. To prevent that,
maybe we need this?

+static int viommu_def_domain_type(struct device *dev)
+{
+  	return IOMMU_DOMAIN_DMA;
+}
+
 static struct iommu_ops viommu_ops = {
        .identity_domain        = &viommu_identity_domain.domain,
        .capable                = viommu_capable,
@@ -1096,6 +1106,7 @@ static struct iommu_ops viommu_ops = {
        .device_group           = viommu_device_group,
        .get_resv_regions       = viommu_get_resv_regions,
        .of_xlate               = viommu_of_xlate,
+       .def_domain_type = viommu_def_domain_type,
        .owner                  = THIS_MODULE,

