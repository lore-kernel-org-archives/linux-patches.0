Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E8EF9C1
	for <patches@lists.linux.dev>; Fri,  9 May 2025 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746809000; cv=none; b=eubIJb8mmm7C3+AVz6pbCpyZD1FGu+C526XP/MuM8WUgjJkfl7x70hlExddoFnMf5WvR0ejkLZCWu0D6x0g8Gem2gUXhTg8UtJQOVJj9Ud8Pfcs7lQgSsYziKUMrk+xYZzpp/HnumkD5kZg/GYK3QwyEehuGN6QmE5oxA6rjlPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746809000; c=relaxed/simple;
	bh=ZXQKMYDJsw6I0LVk+NW1H0FwRmbkk1DOz3/fUm64324=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J0kLhFkDeNQF2tx1mOJuQ/fdppQ4Et8IEy8wKHyil5lgQH9qm5/QgD7BNou51y3B2UJg9H0UIB7veFOADSDXS4P4ykYJVoGBlD1gIOqFaoXi1IFDZ8RbbpYunRbghHPFQBKSys0bTdjIfs5/uhRzDqIXDRUbuojA+vZ0IIaz8xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E0D21AC1;
	Fri,  9 May 2025 09:43:06 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D08B3F5A1;
	Fri,  9 May 2025 09:43:15 -0700 (PDT)
Date: Fri, 9 May 2025 17:43:12 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Peter Newman <peternewman@google.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 13/31] fs/resctrl: Add support for additional monitor
 event display formats
Message-ID: <aB4woCcnPC5Mz7cf@e133380.arm.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-14-tony.luck@intel.com>
 <4aa0904d-9332-4796-90d6-d858711fc611@intel.com>
 <aB0T_Ep2lJzfwjv5@agluck-desk3>
 <2a19f63a-f9b4-4632-bca2-2f64f6fed57b@intel.com>
 <aB3nGDzW6pNNkYTB@e133380.arm.com>
 <CALPaoCjzrGMTEYmTpH=9o_=N24apE0U057p6Mt6Knt9PoyFmzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALPaoCjzrGMTEYmTpH=9o_=N24apE0U057p6Mt6Knt9PoyFmzw@mail.gmail.com>

Hi,

On Fri, May 09, 2025 at 04:46:30PM +0200, Peter Newman wrote:
> Hi Dave,
> 
> On Fri, May 9, 2025 at 1:29 PM Dave Martin <Dave.Martin@arm.com> wrote:

[...]

> > For example: scaling memory bandwidth percentages for MPAM is a
> > nuisance because the hardware uses fixed-point values scaled by a power
> > of 2, not by 100: the two scales can never match up anywhere except at
> > multiples of 25%, leading to irregular increments when rounded to an
> > integer percentage value and uncertainty about what the bandwidth_gran
> > parameter means.  Round-trip conversions between the two
> > representations become error-prone due to repeated rounding -- this
> > proved quite fiddly to get right.  Precision beyond 1% increments may
> > also be available in the hardware, but is not accessible through the
> > resctrl interface.
> 
> Google users got annoyed with these rounding errors very quickly and
> asked me to change the MBA interface to the raw, fixed-point value
> used by the MPAM register interface. (but at least shifted down, since
> the MBW_MIN/MAX fields are left-justified)

That's interesting.

Do you find a need to do things like step the bandwidth allocation for
a control group?  So, as part of a tuning regime, the bandwidth value
is read out, stepped to the next distinct hardware value and written
back in?

That kind of thing does not map in a convenient way onto the current
interface, although fire-and-forget programming of a predetermined
percentage works fine.

Extending my model outline, a 6-bit MPAM MBW_PART implementation might
be described by:

	min: 1
	max: 64
	step size: 1
	multiplier: 1
	divisor: 64

How easy / difficult do you think it would be for userspace to work
with this, if resctrlfs were to expose the raw control (minus the
ignored bits) with that metadata?

Needless to say, the max and divisor values would dependent on the
hardware and possibly other factors.  They would be fixed for the
lifetime of a single resctrl instance at the very least.

> > For backwards compatibility we probably shouldn't change that
> > particular interface, but if we can avoid new instances of the same
> > kind of problem then that would be a benefit: i.e., explicitly tell
> > userspace how to scale a given parameter.
> 
> MBA is not programmed by percentage on AMD, so I'm not sure why this
> is considered necessary for backwards compatibility.

I presumed scripts (or pre-tuned data fed through them) are in practice
pretty platform-specific, so that it will upset people if the interface
changes between kernel versions at least on a given hardware family.

The divergence between AMD and Intel in this area is unfortunate, but
absolute and proportional bandwidth measures do not really seem to be
interchangeable -- so a truly unified interface may not be easy to
achieve either.

Having two control names in the interface might work, say:

	MBP: proportion of total available memory bandwidth (%)

	MBA: absolute memory bandwidth (B/s)

Then just expose the one that the hardware implements natively (while
still exposing MB as a backwards compatible alias if necessary).

Cheers
---Dave
