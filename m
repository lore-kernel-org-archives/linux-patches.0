Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D992F4337
	for <patches@lists.linux.dev>; Thu, 12 Jun 2025 16:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745209; cv=none; b=llqSMbWNFxgOfzWZNaGCrZCawWgtzgTitSHHZdGPLcmHHEskiQD8fBwX35r6F6LNJPtMZvPzbatpQn20snPpYa9NGr8rc6UU24UjAxC1ethWVAdKL3AdCJkxezy4feQFsuthmJna7gasUvhbJspc6mjEMGdqmeXKxBFX8Z85ezw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745209; c=relaxed/simple;
	bh=+tvZzd0kkE2nYV+4N1Ormbpy8ugVT1tsiBVKBZVlzrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0bBVuZkPJ7Megb5JwfI2Izy15eQXPoCH+8FI1vgp6abzrI6OMR6NRl4BqPSJ82UxaKml88h5k2NS4aCwiOaCaZ1/OMMHxRhTKr0sU9c5EEiWylFzBo0zZ4HqhhHx+qGN6GZcV2m57AiJGIjWj12WrVKpb8Wql6DSHDDa/UAV2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59683153B;
	Thu, 12 Jun 2025 09:19:46 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E6193F673;
	Thu, 12 Jun 2025 09:20:04 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:19:55 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v5 14/29] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aEr2OJspONWeWo34@e133380.arm.com>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-15-tony.luck@intel.com>
 <f368c506-c479-4e8b-a5c6-b9bc5bcd5674@intel.com>
 <aEMWhMbLpImmMBrL@agluck-desk3>
 <7d4c739b-3fe2-43e2-9771-6137f15b42f1@intel.com>
 <aEhMWBemtev/f3yf@e133380.arm.com>
 <SJ1PR11MB60833DCE7DF82E40BFB80FA5FC6AA@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB60833DCE7DF82E40BFB80FA5FC6AA@SJ1PR11MB6083.namprd11.prod.outlook.com>

Hi,

On Tue, Jun 10, 2025 at 03:54:35PM +0000, Luck, Tony wrote:
> > Trying to circumvent this...
> >
> > Why do these conversions need to be done in the kernel at all?
> >
> > Can't we just tell userspace the scaling factor and expose the
> > parameter as an integer?
> >
> > In your example, this above value would be exposed as
> >
> >       0b110_0000_0000_0000_0000 / 0b100_0000_0000_0000_0000
> >
> > (=    0x60000 / 0x40000)
> >
> > This has the advantage that the data exchanged with userspace is exact,
> > (so far as the hardware permits, anyway) and there is no unnecessary
> > cost or complexity in the kernel.
> >
> > Since userspace is probably some kind of scripting language, it can do
> > scaling conversions and pretty-print tables more straightforwardly
> > than the kernel can -- if it wants to.  But it can also work in the
> > native representation with no introduction of rounding errors, and do
> > conversions only when necessary rather than every time a value crosses
> > the user/kernel boundary...
> 
> It seems user hostile to print 8974832975 with some info file to explain that
> the scaling factor is 262144. While it may be common to read using some
> special tool, it make life harder for casual scripts.
> 
> Printing that value as 34236.270809 makes it simple for all tools.

The divisor is going to be a power of two or a power of ten in
practice, and I think most technical users are fairly used to looking
at values scaled by those -- so I'm not convinced that this is quite as
bad as you suggest.

The choice of unit in the interface is still arbitrary, and the kernel
is already inconsistent with itself in this area, so I think userspace
is often going to have to do some scaling conversions anyway.

resctrl is not (necessarily) a user interface, but I agree that it is
no bad thing for make the output eyeball-friendly, so long is the cost
of doing so is reasonable.

(Plenty of virtual "text" files exported by the kernel are extremely
cryptic and user-hostile, though.)

> The rounding error from the kernel is insignificant ("true" value is
> 34236.270809173583984375 ... so the error is around five parts
> per trillion).
> 
> Things are worse sampling the Joule values once per-second to convert
> to Watts. But even there the rounding errors from a 1-Watt workload
> are tiny. Worst case you see 0.999999 followed by 2.000001 one second
> later and report as 1.000002 Watts instead of 1.0
> 
> The error bars on the values computed by hardware are enormously
> larger than this. Further compounded by the telemetry update rate
> of 2 millliseconds. Errors from uncertainty in when the value was
> captured are also orders of magnitude higher than kernel rounding
> errors.
> 
> -Tony

If we can make the intermediate interface error-free by construction
and without making life especially hard for anyone, then that means we
can bolt whatever on at each end without having to even think about the
effect on accuracy.

I agree though that the inaccuracies introduced by the interface will
be very marginal, and likely swamped by hardware limitations and timing
skid.

Either way, it's not my call...

Cheers
---Dave
