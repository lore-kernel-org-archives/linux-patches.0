Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9040536C598
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762882279; cv=none; b=IXSu+ih1DCXvtnWeUiWMjG8wY2o6SR6pkGDMCXubvbe/bKn+8zUiOLRQi/X4Cz6KLAnLnlRwP1nhS7Zf78lxEPqM+JKhLeHwvnKWlV1watQdSSlRK2l0LiNIN8mzEFv+OE06qGEdi8yyDrNBdomcqHLSMDiDFeuF8XO6dvapBP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762882279; c=relaxed/simple;
	bh=zJGfro/vq5i845CwSv5rjPwqNGcl1uf1x5+yxpove2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdPbB1yfwxfwxker6A1ZFfb/IPt46qvf9u8J3pHQDS+356oZJRT3v5YOjcNZVuoW641t8Cwpt0uttlYYMENfZOWUXOFQrKqTI11buVfB5wJu/kt04Gk+7cWpzfcXS2LLk9xUCSoAMDmppzqaISRZ0reim7S4Q3aHTGPOChnz/9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36732497;
	Tue, 11 Nov 2025 09:31:09 -0800 (PST)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D70693F5A1;
	Tue, 11 Nov 2025 09:31:14 -0800 (PST)
Date: Tue, 11 Nov 2025 17:31:12 +0000
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
Message-ID: <aRNy4G0XoREMNs4X@e133380.arm.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
 <aQwHpFEfHGpoaVW9@agluck-desk3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQwHpFEfHGpoaVW9@agluck-desk3>

Hi,

On Wed, Nov 05, 2025 at 06:27:48PM -0800, Luck, Tony wrote:
> On Wed, Nov 05, 2025 at 03:31:07PM -0800, Luck, Tony wrote:
> > > > +
> > > > +	if (!binary_bits) {
> > > > +		seq_printf(m, "%llu.0\n", val);
> > > > +		return;
> > > > +	}
> 
> I can't completely escape a test for !binary_bits. Most of the
> flow works ok (doing nothing, working towards frac == 0 when
> it comes time for the snprintf()).
> 
> But the round-up code:
> 
> 	frac += 1ull << (binary_bits - 1);
> 
> goes badly wrong if binary_bits == 0.
> 
> I could write it like this:
> 
> 
> static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> {
> 	char buf[decplaces[MAX_BINARY_BITS] + 1];
> 	unsigned long long frac = 0;
> 
> 	if (binary_bits) {
> 		/* Mask off the integer part of the fixed-point value. */
> 		frac = val & GENMASK_ULL(binary_bits - 1, 0);
> 
> 		/*
> 		 * Multiply by 10^{desired decimal places}. The integer part of
> 		 * the fixed point value is now almost what is needed.
> 		 */
> 		frac *= int_pow(10ull, decplaces[binary_bits]);

I guess there was already a discussion on whether it is worth
precomputing this multiplier.

int_pow() is not free, but if implemented in the standard way, it
should be pretty fast on 64-bit arches (which is all we care about).

(I've not checked.)

> 		/*
> 		 * Round to nearest by adding a value that would be a "1" in the
> 		 * binary_bits + 1 place.  Integer part of fixed point value is
> 		 * now the needed value.
> 		 */
> 		frac += 1ull << (binary_bits - 1);
> 
> 		/*
> 		 * Extract the integer part of the value. This is the decimal
> 		 * representation of the original fixed-point fractional value.
> 		 */
> 		frac >>= binary_bits;

Looks reasonable.  It's your call whether this is simpler, I guess.

> 	}
> 
> 	/*
> 	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
> 	 * representation will fit into chosen number of decimal places.
> 	 */
> 	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
> 
> 	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);

Can we get rid of buf, actually?

I don't see why we can't just do

	seq_printf(m, "%llu.%0*llu",
		   val >> binary_bits, decplaces[binary_bits], frac);

...?

This avoids having to care about the size of buf.

seq_file's crystal ball knows how to make its buffer large enough.

Cheers
---Dave
