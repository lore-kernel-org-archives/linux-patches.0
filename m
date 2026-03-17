Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C403C3BFB;
	Tue, 17 Mar 2026 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773752287; cv=none; b=bD+LxlxjGbQBzGpClCM2zGx0IALGg7QCugnUrKWRgATfqriPdoTgrV2GFf4XRdzTfvUWy0A45CDApRT2giWko6hUpZXEAIHLOTRORXU38SiIGyc4cuDRO5OnXou7EJTdegMRcmM3rLkJEBuV7A+eybTy5m4xWUxqfbDVs5W9L98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773752287; c=relaxed/simple;
	bh=9/uo9pkdjaiyCRV4F24AuW12EWeVepIUAq+b4QEN54k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o88MdULxIHNyb2l3yXAqH461DpIkb4hLhs9/73gUpfB/hRbSiiz0ER7GS4LGKVZLBEnDYWoVyT5TClpSnr3RNY49vx+JcdmpYSDmEk01GDpJl8MeqnZ/2mUq4of+dJM37kUbIjYG/adtesnlZeGXhlLIK7cK/eSfs8tNX6sI3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=BkA0fEKb; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="BkA0fEKb"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 1E64B1A527B;
	Tue, 17 Mar 2026 13:58:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1773752285;
	bh=9/uo9pkdjaiyCRV4F24AuW12EWeVepIUAq+b4QEN54k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BkA0fEKbn4NpVHfREskn/Jx0rEZuzKwlRIH0shji5VkycZU0stcYtrq4Xzc7o/TsP
	 pAYPqeWP1mSBlnft5T5NGl65schhErNm27qfhRwNDpVyRsC4Pt8y13/i+xB4aDesw0
	 T8q6PTSfL0EbPvTiP4Ejh8A2Km2pXzTm5BlmLochzeAjYlIRzuBFQWKlOLdihAkrFV
	 H6vuAr++ZtuZYoXwInzrp55kLqpUWYnS3fJzv78ldjDlUKEYoWzp44CPm65/FgSIWf
	 tP8DHm7URml++h4HMSb2LeXZg/J1FHkvwyTkQGKwhs6zjSQEMRMVTZdqbryeBj3AyP
	 xFprgXdUNs+yw==
Date: Tue, 17 Mar 2026 13:58:04 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev, 
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v3 0/2] Let iommupt manage changes in page size internally
Message-ID: <mmdfnhx7ji7v74rnbpn6j4faiefanseisjgfikt6rwlbjgli6y@ilyt5vis4cdu>
References: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>

On Fri, Feb 27, 2026 at 03:30:09PM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (2):
>   iommupt: Directly call iommupt's unmap_range()
>   iommupt: Avoid rewalking during map
> 
>  drivers/iommu/generic_pt/iommu_pt.h         | 162 +++++++++++---------
>  drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
>  drivers/iommu/generic_pt/pt_iter.h          |  22 +++
>  drivers/iommu/iommu.c                       |  66 ++++++--
>  include/linux/generic_pt/iommu.h            |  69 +++++++--
>  include/linux/iommu.h                       |   1 +
>  6 files changed, 231 insertions(+), 101 deletions(-)

Applied, thanks.
