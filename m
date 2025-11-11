Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75403AA19F
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762881392; cv=none; b=GucYKE5In47KlqlQF5UJ0OKsKNVz0JBxRFMUD8x31KdZLDeZBDhs2xetLv2Eltq/5shgjbFYrxF/S2CORVbHOZ4z5+0RpBiIXBbt4rLOrwdXG4TxaD2uvBYVQOotf4UdvuFwcMxnm+/hkd0GkD98OOFtVv3QXbfbuVZTr0+auYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762881392; c=relaxed/simple;
	bh=7BpA+G0VBdcwsxCosOfG+TMLR7+V50QL5EEuIdXygOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2JCyO60IqPaORvqc/qOOSAeRHtocYVqkoPdm12+O3hHpqRfJ+A7rPJt2wq+ZiyeMMl7sQI1mfiF9/r/Uw6VE/3nJH2m55BthiUecRIJvAiSuux2TnCZslylJaNlbNxhFBx8Um9Z/3LKygxNga6vsQhsULE9fr36i3aomyDk5/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76C71497;
	Tue, 11 Nov 2025 09:16:22 -0800 (PST)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 25E513F5A1;
	Tue, 11 Nov 2025 09:16:28 -0800 (PST)
Date: Tue, 11 Nov 2025 17:16:22 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aRNvZvNnEYFXfZmI@e133380.arm.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQveOz66Pd3R0FfI@agluck-desk3>

Hi Tony,

On Wed, Nov 05, 2025 at 03:31:07PM -0800, Luck, Tony wrote:
> Hi Dave,
> 
> Thanks for taking time to review. You did unearth one big bug
> and I'm super-grateful for that.
> 
> On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
> > Hi Tony,
> > 
> > A few drive-by nits from me -- apologies, I hadn't looked at this in a
> > while.
> > 
> > On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:
> > > resctrl assumes that all monitor events can be displayed as unsigned
> > > decimal integers.
> > > 
> > > Hardware architecture counters may provide some telemetry events with
> > > greater precision where the event is not a simple count, but is a
> > > measurement of some sort (e.g. Joules for energy consumed).
> > > 
> > > Add a new argument to resctrl_enable_mon_event() for architecture code
> > > to inform the file system that the value for a counter is a fixed-point
> > > value with a specific number of binary places.
> > > Only allow architecture to use floating point format on events that the
> > > file system has marked with mon_evt::is_floating_point.
> > > 
> > > Display fixed point values with values rounded to an appropriate number
> > > of decimal places for the precision of the number of binary places
> > > provided. Add one extra decimal place for every three additional binary
> > 
> > (Is this just informal wording?  If not, it's wrong...)
> 
> Informal. It isn't far off from the table. Once out of the small numbers
> the number of decimal places does increment after each group of three.
> 
> > 
> > > places, except for low precision binary values where exact representation
> > > is possible:
> > > 
> > >   1 binary place is 0.0 or 0.5			=> 1 decimal place
> > >   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
> > >   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places
> > 
> > What's the rationale for this special treatment?  I don't see any
> > previous discussion (apologies if I missed it).
> 
> The strict log10(2) calculations below throw away some precision from
> these cases. I thought that was bad.

It depends what is meant by "precision".

We can't magic up accuracy that isn't present in the counters, just by
including extra digits when formatting.

So long as we format values in such a way that every counter value is
formatted in a unique way, we are as precise as it is possible to be.

If I didn't confuse myself, ceil(binary_bits * log10(2)) is the
smallest number of fractional decimal digits that provide this
guarantee.


(This may seem pedantic -- partly, I was wondering what was so special
about implementations with fewer than 3 binary places that they needed
special treatment -- I think that still hasn't been answered?)

[...]

> > > +/* Limit for mon_evt::binary_bits */
> > > +#define MAX_BINARY_BITS	27
> > > +
> > 
> > Could this be up to 30?
> 
> Yes.
> 
> > (The formatting code relies on the the product of the maximum fraction
> > value with 10^decplaces[] not exceeding a u64, so I think 30 bits
> > fits?  But this only has to be as large as the largest value required
> > by some supported piece of hardware... I didn't go check on that.)
> 
> I only have one data point. The Intel telemetry events are using 18
> binary places.

Ah, right.

[...]

> > > diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> > > index 883be6f0810f..290a959776de 100644
> > > --- a/fs/resctrl/ctrlmondata.c
> > > +++ b/fs/resctrl/ctrlmondata.c

[...]

> > > @@ -597,6 +598,87 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> > >  		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
> > >  }
> > >  
> > > +/*
> > > + * Decimal place precision to use for each number of fixed-point
> > > + * binary bits.
> > > + */
> > > +static unsigned int decplaces[MAX_BINARY_BITS + 1] = {
> > 
> > ^ const
> 
> OK
> 
> > 
> > Also, maybe explicitly initialise
> > 
> > 	[0]  =	1,
> 
> OK (though this might only occur if there is an event that resctrl says
> must be fixed point, with a h/w implementation that provides a simple
> integer).
> 
> > here?  (See print_event_value().)
> > 		
> > > +	[1]  =  1,
> > > +	[2]  =  2,
> > > +	[3]  =  3,
> > > +	[4]  =  3,
> > > +	[5]  =  3,
> > > +	[6]  =  3,
> > > +	[7]  =  3,
> > > +	[8]  =  3,
> > > +	[9]  =  3,
> > > +	[10] =  4,
> > 
> > Why these specific values?
> 
> For 1, 2, 3 binary bits you get an exact decimal representation
> with 1, 2, 3 decimal places. I kept the "3" going from 4 to 9
> bits because it should output at least as many places as 3 bits.
> 
> After that I started stepping every 3 extra bits.
> 
> > ceil(binary_bits * log10(2)) makes sense if we want to expose all
> > available hardware precision with as few digits as possible.
> > 
> > floor(binary_bits * log10(2)) makes sense if we want expose as many
> > digits as possible without advertising spurious precision.
> > 
> > Disregarding the special-casing for binary_bits <= 3, still neither
> > option quite seems to match this list.
> 
> Side-by-side comparion:
> 
> #include <stdio.h>
> #include <math.h>
> 
> static unsigned int tony[] = {
> 	[0]  =  0, [1]  =  1, [2]  =  2, [3]  =  3, [4]  =  3, [5]  =  3,
> 	[6]  =  3, [7]  =  3, [8]  =  3, [9]  =  3, [10] =  4, [11] =  4,
> 	[12] =  4, [13] =  5, [14] =  5, [15] =  5, [16] =  6, [17] =  6,
> 	[18] =  6, [19] =  7, [20] =  7, [21] =  7, [22] =  8, [23] =  8,
> 	[24] =  8, [25] =  9, [26] =  9, [27] =  9
> };
> 
> int main(void)
> {
> 	int binary_bits;
> 	double log10_2 = log10(2.0);
> 
> 	printf("bits:\tceil\tfloor\ttony\n");
> 	for (binary_bits = 0; binary_bits < 28; binary_bits++)
> 		printf("%d:\t%d\t%d\t%d\n",
> 			binary_bits,
> 			(int)ceil(binary_bits * log10_2),
> 			(int)floor(binary_bits * log10_2),
> 			tony[binary_bits]);
> 
> 	return 0;
> }
> 
> bits:	ceil	floor	tony
> 0:	0	0	0
> 1:	1	0	1
> 2:	1	0	2
> 3:	1	0	3
> 4:	2	1	3
> 5:	2	1	3
> 6:	2	1	3
> 7:	3	2	3
> 8:	3	2	3
> 9:	3	2	3
> 10:	4	3	4
> 11:	4	3	4
> 12:	4	3	4
> 13:	4	3	5
> 14:	5	4	5
> 15:	5	4	5
> 16:	5	4	6
> 17:	6	5	6
> 18:	6	5	6
> 19:	6	5	7
> 20:	7	6	7
> 21:	7	6	7
> 22:	7	6	8
> 23:	7	6	8
> 24:	8	7	8
> 25:	8	7	9
> 26:	8	7	9
> 27:	9	8	9
> 
> I'm not a fan of the "floor" option. Looks like it loses precision.  Terrible for

Loses precision, but does not advertise bogus precision precision
beyond the precision in the original value.  (This is why it is not
standard to print doubles with more then 15 significant digits, even
though 17 significant digits are needed for bit-exact reproduction.)

I don't know whether this matters relative to the use cases, but it
would be nice to have some rationale.

> 1-3 binary bits. Also not what I'd like for the bits==18 case that I currently
> care about.
> 
> "ceil" is good for bits > 6. Almost matches my numbers (except I jump
> to one more decimal place one binary bit earlier).
> 
> What do you think of me swapping out the values from 7 upwards for the
> ceil values and documenting that 0..6 are hand-picked, but 7 and up are
> ceil(binary_bits * log10_2)?

If there is sound rationale for hand-picking some values then yes.

I haven't yet been convinced that there is ;)

(The 7 times table could doubtless be made to look nicer by hand-
picking some entries.  But it wouldn't be the 7 times table any more.)

> > Rounding up means that the hardware value can be reconstructed, but
> > only if userspace knows the value of binary_bits.  Should that be
> > exposed?
> 
> I'm not sure I see when users would need to reconstruct the h/w value.
> General use case for these resctrl events is: read1, sleepN, read2 &
> compute rate = (read2 - read1) / N

If userspace can reconstruct the original values, it can do this
calculation more accurately.

Since the values yielded by read1 and read2 might not differ by very
much, the relative error introduced by formatting the values in decimal
_might_ be significant.

(If we include enough decimal digits that there is no error, userspace
will see unexpectedly coarse granularity in the delta read2 - read1.
And this is only practical when the number of fractional bits is small.)


Again, I don't know whether this matters for use cases, but minimising
the number of magic numbers and arbitrary tradeoffs feels like it would
hide fewer potential surprises...

> In the case of the Intel telemetry events there is some jitter around
> the timing of the reads (since events may only be updated every 2ms).
> So the error bars get big if "N" is small. Which all leads me to believe
> that a "good enough" approach to representing the event values will
> be close enough for all use cases.

Probably (and in any case, userspace is likely to be a giant hack
rather than rigorous statistical analysis).

Still, telling the userspace the actual precision the hardware supports
feels easy to do.

(It could be added later on as an extension, though.)

> > > +	[11] =  4,
> > > +	[12] =  4,
> > > +	[13] =  5,
> > > +	[14] =  5,
> > > +	[15] =  5,
> > > +	[16] =  6,
> > > +	[17] =  6,
> > > +	[18] =  6,
> > > +	[19] =  7,
> > > +	[20] =  7,
> > > +	[21] =  7,
> > > +	[22] =  8,
> > > +	[23] =  8,
> > > +	[24] =  8,
> > > +	[25] =  9,
> > > +	[26] =  9,
> > > +	[27] =  9
> > 
> > Documenting the rule for generating these may be a good idea unless we
> > are sure that no more entries will never be added.
> 
> Above proposal - use the ceil function for bits >= 7.
> 
> > > +};
> > > +
> > > +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> > > +{
> > > +	unsigned long long frac;
> > > +	char buf[10];
> > 
> > In place of the magic number 10, how about
> > decplaces[MAX_BINARY_BITS] + 1 ?
> > 
> > (I think the compiler should accept that as an initialiser if the array
> > is const.)
> 
> If the compiler doesn't barf, then OK.
> 
> > > +
> > > +	if (!binary_bits) {
> > > +		seq_printf(m, "%llu.0\n", val);
> > > +		return;
> > > +	}
> > 
> > Can an initialiser for decplaces[0] reduce the special-casing for
> > binary_bits == 0?
> 
> I'll check and see.
> 
> > > +
> > > +	/* Mask off the integer part of the fixed-point value. */
> > > +	frac = val & GENMASK_ULL(binary_bits, 0);
> > 
> > Should this be GENMASK_ULL(binary_bits - 1, 0)?
> 
> Oops. I think you are right.
> 
> > Should we be telling userspace the binary_bits value?  It is not
> > (exactly) deducible from the number of decimal places printed.
> 
> I could add another info file for fixed_point events to display this.
> But I'm not convinced that it would result in users doing anything
> different.
> 
> Assume you just did the "read1, sleepN, read2" and got values of
> 235.617542 and 338.964815, tell me how things would be different
> if an info file said that binary_bits was 17 vs. 19?

It changes the error bars, no?

For 17 bits, ± .00000381 (approx.)
For 19 bits, ± .000000953 (approx.)

(i.e., ± 0.5 times the least-significant bit).

Whether it is important / useful to know this is usecase dependent,
though.

[...]

> > > +	/* Trim trailing zeroes */
> > 
> > Why?
> 
> It felt good. I'm not wedded to this. Maybe saving a few cycles of
> kernel CPU time by dropping this would be good.
> 
> > Would it be better to present the values with consistent precision?
> 
> Humans might notice the difference. Apps reading the file aren't going
> to care.

I noticed ;)  In that, there is explicit code here that seems to have
no function other than to make the output worse (i.e., more
unpredictable and with no obvious gain in usefulness).

If the number of digits is the only clue to the size of the error bars
in the readings, userspace code might well care about this.

> 
> > There's no reason why a telemetry counter should settle for any length
> > of time at a tidy value, so the precision represented by the trailing
> > zeros is always significant.
> 
> But x1 = atof("1.5") and x2 = atof("1.500000") ... can the subsequent
> use of x1 tell that there was less precision that x2?

Exactly.  If knowledge of the error bars is needed, just knowing the
nearest real number to the measured value is insufficient.

But the number of digits is all we seem to be giving userspace to go on
here -- and we're not presenting that in a predictable way, either (?)

Cheers
---Dave
