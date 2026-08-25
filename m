Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E03335E1AE;
	Tue, 25 Aug 2026 17:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787677613; cv=none; b=V1RXACcje6oKSBPWXE+i61xsZaNMd/6wZi0SrKPNb56Dg4gE+xkpwm3oEQHNjmBxG0mpJZhPy1teHRsdJtfeHNXGLHFB2DYrQxB+wBKo7LwtKwHdSO7atxHYBjtwinIHUNRr7D4ejfNDhpX0EXXXySTQcw3QRZx99Jp7/V/l1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787677613; c=relaxed/simple;
	bh=K2A3do+SZHwgw8QrA8Q0rr5phAaPEAJ14n7GMAnwYbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aaPswQaY+ez+lnmfjLLEMkXPlPsIkYbFvw7M3LQCJ4GZ35kVXLKs8Ugvn0+hNWlK05I4vrkvGQTDdp7d18+I3EqteQcGV1V388hBR0AP6u7CWpYzqdmu1D+XAfYjoNBaoY/N7cA31/1vXmEWvADw5JseYpdhW+e6A5QiieDXQ+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TprJ7xxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TprJ7xxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B5B1F000E9;
	Tue, 25 Aug 2026 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787677611;
	bh=bj2g1RQRxCbMBdA5rwuLTDfC67Rmlu8p6CaftxfrFeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TprJ7xxJidQiclhVmzR7uTnPdxnygmo/1eEVQIMmYK1TAkDTTBsmRPf0TX3lxWiMp
	 vxTYeSJM37E0iSXa6xUlrorX5KmCLHR8rZA1L7lY0FjX6GlRIoBDKH4k4adynQ8Y5l
	 0WOQFDAL44Mgl2zv16PVisH4q1OSAoniC4xRusd9NbESz4N6wrGs4hZ/v9Pe3Hl/rD
	 JHh++0H7dgP40e92dBW4flhauaJp/b3BKK29HBx9dAzCRmdzPWFCVOFp2lBVdLY1I5
	 9/GRoEzkY8xTfo5VKkWJ29z5dU4wDrJNZVXMwj2W7b3/YO+PG6gbZZ/+hbXFsaZnPu
	 q2hZBTn9T2E4w==
Date: Tue, 25 Aug 2026 18:06:45 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <ao3LpdSgK7ZBrLza@willie-the-truck>
References: <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
 <20260813180102.GH730363@nvidia.com>
 <an7UNAA1WlEXG23-@willie-the-truck>
 <20260814123417.GB510472@nvidia.com>
 <20260818184338.GF5432@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818184338.GF5432@nvidia.com>

On Tue, Aug 18, 2026 at 03:43:38PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 14, 2026 at 09:34:17AM -0300, Jason Gunthorpe wrote:
> 
> > I'm also wondering if we are even OK with this errata today? The
> > current RIL algorithm also does not guarentee the split up RILs will
> > cover every CONT. This will happen to be true if the input range has
> > certain properties but I have no idea if the SVA path or even the
> > proposed CONT iopgtable change guarentees that.
> 
> I've looked into this and it looks like the current RIL implementation
> does not meet the requirement to solve the errata, and these days SVA
> provides CONT entries from the mm.
> 
> The errata says the RIL command must cover the *entire* CONT group. I
> read this text as meaning two contiguous RILs with a split that is
> inside a CONT group is still vulnerable to this errata. Each CONT
> group must be fully covered by at least one RIL.
> 
> So the algorithm we have today where we take the range and split it
> into many RILs has nothing that prevents the RIL split from landing
> inside a CONT. SVA is not guarenteed to produce ranges with an
> alignment or size that make this algorithm happen to choose aligned
> splits.
> 
> I've prepared an errata fix patch that detects the errata and triggers
> a very simplified version of this single-RIL algorithm only for SVA
> invalidations. That will fix today's kerenel, it is reasonably small
> and can go to -stable.
> 
> I've adjusted this series on top of that to use the double-RIL version
> with no over invalidation that Robin suggested for paging domains and
> single-RIL with over invalidation for SVA domains. This also turned
> out pretty good.
> 
> For the iommupt integration, and enabling CONT for the paging
> domains.. Ugh.
> 
> It seems at least our Spark CPU has this errata and requires CONT
> support to work in paging domains, or it runs into its own isochronous
> HW problems. So the easy answer of disable CONT isn't desirable.
> 
> So.. what I've come up with is a little tweak that still allows the 4k
> granule's 64K CONT to work without any over invalidation, so we can
> turn it on by default. That is enough for spark to work. Everything
> else stays with status quo of no CONT.
> 
> If someone has another smart idea now is the time..

The documentation for 3673557 gives a possible workaround of:

  - When invalidating a contiguous set of page tables, perform the
    invalidation sequence twice. Only the invalidation sequence needs to
    be performed twice, not the SYNC.

and we just merged something very similar from Ashish. Could we use that
for domains that want to use contiguous ptes?

Will
