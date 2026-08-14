Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6F42AFB0;
	Fri, 14 Aug 2026 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786696769; cv=none; b=etb17oSms+AXCcJeG9E9ruJl7C9yCqQcLv5+/EU91Ud3Gm+Edl1sOgLFP02XfxyS8xyowK2jP5EvXDDPpxuuqqJfzLUqcq9OyoCEyMjZuUnpRo/bLW/FLg6Awg7E7THY/zRIoaPrlAD9xlD8cOTPXYMfWaOXDocNkmFylX31bNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786696769; c=relaxed/simple;
	bh=H1lN3SEt95SuO+eCYyw/ozQN/NC+W1q1UK/uRXeotis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXKMExyPFaNgwpj1MkBcXDkTbT1mGHo3gAIONlarg9tC1CcItK3DF206fmy2Y/Ea35NEYvkAfPHnPU4l9OqqIr0zupQpW648bdHLQ7Bsks4XBQ5EsHpks/1ASJC0EherN6YXnfxs/CjpwEmZ1Fm+wCjXtbUt/MObIfwyh+/aqkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMBdxflz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMBdxflz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D51F00A3A;
	Fri, 14 Aug 2026 08:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786696762;
	bh=wWjwvjvKbePNx0gNHqW9UR/9cgD08zGtWqMf6sP/Lac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SMBdxflzfEbnjJvs+dI9E7KCIpssTpXBiuGSwNu6Mh9A308UAjxnlztClwBaTBsWO
	 P6+xEvHg0JesRpxVO7qZhCkZ5M+lDWfrjTtff+DDwUHJJKB9S5uBYVrLxlEHVL2Nph
	 BLkFHVHyYd8gqLsWVhWZAqjIJD/lBgAuE6GPYgJQe5EfciJ8P7k4wBb6fW2/mFxaPF
	 MGG0Me/NJRaHZ5PoF+ypQXw9CsbA5EazChQJWkoH7++EsgXY/rQbPSCmENkqXkN/qu
	 ZRzF0l09pi9WIylEwKEMXFiEwnH+2ffUwFg7IxEzCW6Bfl+d+7TOk7Hj21efUGY1QJ
	 HXsdKcAueiccQ==
Date: Fri, 14 Aug 2026 09:39:16 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <an7UNAA1WlEXG23-@willie-the-truck>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
 <20260813180102.GH730363@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813180102.GH730363@nvidia.com>

On Thu, Aug 13, 2026 at 03:01:02PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 13, 2026 at 06:25:59PM +0100, Robin Murphy wrote:
> > > > Yes, those exist, but again, they are already facing these problems if
> > > > running without RIL.
> > > 
> > > Yes, but my point is that those typically support RIL and that change
> > > regresses them.
> > 
> > Not even that - the main concern is over-invalidation of adjacent in-use
> > buffers due to rounding up; non-RIL absolutely does not have that issue and
> > never has.
> 
> It certainly does! SMMUv3 got an invalidate all path a while back
> because doing single for >> MB's of IOVA effectively soft lockups the
> system - especially with SVA.
> 
> We set the cut off at ~2M which matches when the CPU goes to
> invalidate all. That's 512 commands max of single TBLIs before we just
> dump the entire TLB. That's a huge over invalidation.
> 
> > Note that with RIL, even precise invalidation should only actually need at
> > most two commands (excepting absurd off-the-scale sizes) - the trick is to
> > consider that they can overlap.
> 
> Oh that's really interesting, I never thought about doing it like
> that. It is way better than the algorithm that is there right now.
> 
> Let me try it, it seems like it would make everyone happy.

I was planning to reply yesterday saying something like "Robin previously
mentioned this one neat trick...", but I didn't get round to it. So yeah,
if we can implement that, I think we can have one range invalidation
algorithm to rule them all.

Will
