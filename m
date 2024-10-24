Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B971F1D2207;
	Thu, 24 Oct 2024 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729775158; cv=none; b=RssKTclWXD1QOup+aZa6xfbQ3krDhTjmvuw6jxVuji9gt7envU3+bWRDYt9/cV69dXkRm237XbjbLhIbDHjmzEI7JlGzNuXAdvtWgnpqOvtsthY8IkqvOKeU63QqT+JQ/Q4FM9W4w3gkpS3Fh0IK9lb8dpvYjozMBi2TLrZLkCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729775158; c=relaxed/simple;
	bh=QXk1V7bH3HsTPiuM9A5Py2vZdwbkg6MWH803SOVsaJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Luouainol4BgqxoS6fzxCrlwz7s806PxGy4dnS9hO98QofzjWvdJkdcYWN8gSvFfdpIfcjJ7Iuxc+RiYD4pFkktpKczav/G0gweXqSQ1mptGu2DtcdZYMcZ1JTBIlID4KKe+DJ8W0I/QMMTTv9cGNXDmnkimBGkbnzd/mcqnVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vy1Wn4fL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vy1Wn4fL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79411C4CEC7;
	Thu, 24 Oct 2024 13:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729775158;
	bh=QXk1V7bH3HsTPiuM9A5Py2vZdwbkg6MWH803SOVsaJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vy1Wn4fLlykC16tJY9EfRKt3126lvfGKufGOM2l0XlojP1032MOTW502xrrPTywyV
	 7Y69l4ulKnMB3iVxDKBaWdiHt+3LGuqNttl8YRItkAI3MzFSIvjfDjADzGcwCu4QPo
	 oVMqArtpEcrXEoIT+Noe46x2BFsVNjtLtp+5vmkOIr1A4jwvVZnTmW3Nqqo9rnI4mA
	 N0P0leVPPbKzcS+U68XbM42bL1qeS0CFMha/ha1PQk+vXDdznGF5M0aEQmPY51S8iy
	 EI5eUEGub5heUuD/638YAHa/pS8V/4jbNgLRfJBpGxVjOwrQweu0clK9gwGog1w3XI
	 Wziem035r2IIA==
Date: Thu, 24 Oct 2024 14:05:53 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
Message-ID: <20241024130550.GE30704@willie-the-truck>
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jason,

On Fri, Oct 18, 2024 at 02:19:26PM -0300, Jason Gunthorpe wrote:
> Of the page table implementations (AMD v1/2, VT-D SS, ARM32, DART)
> arm_lpae is unique in how it handles partial unmap of large IOPTEs.
> 
> All other drivers will unmap the large IOPTE and return it's length.  For
> example if a 2M IOPTE is present and the first 4K is requested to be
> unmapped then unmap will remove the whole 2M and report 2M as the result.
> 
> arm_lpae instead replaces the IOPTE with a table of smaller IOPTEs, unmaps
> the 4K and returns 4k. This is actually an illegal/non-hitless operation
> on at least SMMUv3 because of the BBM level 0 rules.
> 
> Long ago VFIO could trigger a path like this, today I know of no user of
> this functionality.
> 
> Given it doesn't work fully correctly on SMMUv3 and would create
> portability problems if any user depends on it, remove the unique support
> in arm_lpae and align with the expected iommu interface.
> 
> Outside the iommu users, this will potentially effect io_pgtable users of
> ARM_32_LPAE_S1, ARM_32_LPAE_S2, ARM_64_LPAE_S1, ARM_64_LPAE_S2, and
> ARM_MALI_LPAE formats.
> 
> Cc: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: Steven Price <steven.price@arm.com>
> Cc: Liviu Dudau <liviu.dudau@arm.com>
> Cc: dri-devel@lists.freedesktop.org
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/io-pgtable-arm.c | 72 +++-------------------------------
>  1 file changed, 6 insertions(+), 66 deletions(-)

I'd love to drop this, but I'm sure it was needed when I added it :/

My recollection is hazy, but I seem to remember VFIO using the largest
page sizes in the IOMMU 'pgsize_bitmap' for map() requests but then
using the smallest page size for unmap() requests, so you'd end up
cracking block mappings when tearing down a VM with assigne devices.

Is this what you're referring to when you say?

  > Long ago VFIO could trigger a path like this, today I know of no user of
  > this functionality.

If so, please can you provide a reference to the patch that moved VFIO
off that problematic behaviour?

Thanks!

Will
