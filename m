Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 033C826F2A1
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 14:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353873; cv=none; b=BgO9PkWBdOI3F0jg6vhBnKZ6vttDGr2F100Pw6+HCBFpAlpWQ0A23bjGT7LbDt4Hl+hOqGNOwgO3W27JKKS8NnqC9Yl+ZePl/kc0GBHnd1iYV+1knTRoXftwFpRMv7UNUhJjzGN9i804D403F6A4MKKX91ZvbOo9WYnEkD9TsvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353873; c=relaxed/simple;
	bh=aloNZC+lYx0sTvaPm2rmlqf6ESr4WRivTHN4sJh+6lY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XH/wnWEZ4HGqd82OtHpjBPGGwlJXvS4oRME1NYLCmvsFtGVCNGZBl3sGHFzYHGzUATfypQwSByLDtQZrEZgJe+qcGObNxYtUWGLsvuTiFvwye6fV6+ZpsoVj/okP7wOoa6U8oV5lnzDLgcs0LoYrd4FdMH5GtPEOV20z93lSj6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A1562B;
	Wed,  5 Nov 2025 06:44:17 -0800 (PST)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 36C4B3F694;
	Wed,  5 Nov 2025 06:44:23 -0800 (PST)
Date: Wed, 5 Nov 2025 14:42:18 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Tony Luck <tony.luck@intel.com>
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
Message-ID: <aQtiSmZ14b+U/J4U@e133380.arm.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029162118.40604-13-tony.luck@intel.com>

Hi Tony,

A few drive-by nits from me -- apologies, I hadn't looked at this in a
while.

On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:
> resctrl assumes that all monitor events can be displayed as unsigned
> decimal integers.
> 
> Hardware architecture counters may provide some telemetry events with
> greater precision where the event is not a simple count, but is a
> measurement of some sort (e.g. Joules for energy consumed).
> 
> Add a new argument to resctrl_enable_mon_event() for architecture code
> to inform the file system that the value for a counter is a fixed-point
> value with a specific number of binary places.
> Only allow architecture to use floating point format on events that the
> file system has marked with mon_evt::is_floating_point.
> 
> Display fixed point values with values rounded to an appropriate number
> of decimal places for the precision of the number of binary places
> provided. Add one extra decimal place for every three additional binary

(Is this just informal wording?  If not, it's wrong...)

> places, except for low precision binary values where exact representation
> is possible:
> 
>   1 binary place is 0.0 or 0.5			=> 1 decimal place
>   2 binary places is 0.0, 0.25, 0.5, 0.75	=> 2 decimal places
>   3 binary places is 0.0, 0.125, etc.		=> 3 decimal places

What's the rationale for this special treatment?  I don't see any
previous discussion (apologies if I missed it).

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  include/linux/resctrl.h            |  3 +-
>  fs/resctrl/internal.h              |  8 +++
>  arch/x86/kernel/cpu/resctrl/core.c |  6 +--
>  fs/resctrl/ctrlmondata.c           | 84 ++++++++++++++++++++++++++++++
>  fs/resctrl/monitor.c               | 10 +++-
>  5 files changed, 105 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 702205505dc9..a7e5a546152d 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -409,7 +409,8 @@ u32 resctrl_arch_get_num_closid(struct rdt_resource *r);
>  u32 resctrl_arch_system_num_rmid_idx(void);
>  int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid);
>  
> -void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu);
> +void resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
> +			      unsigned int binary_bits);
>  
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id eventid);
>  
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 40b76eaa33d0..f5189b6771a0 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   *			Only valid if @evtid is an MBM event.
>   * @configurable:	true if the event is configurable
>   * @any_cpu:		true if the event can be read from any CPU
> + * @is_floating_point:	event values are displayed in floating point format

Nit: Maybe rebrand this as is_fixed_point, or is_fractional, or similar?

The print syntax is just a decimal fraction, and the hardware
representation is fixed-point.  Nothing floats.

> + * @binary_bits:	number of fixed-point binary bits from architecture,
> + *			only valid if @is_floating_point is true
>   * @enabled:		true if the event is enabled
>   */
>  struct mon_evt {
> @@ -71,6 +74,8 @@ struct mon_evt {
>  	u32			evt_cfg;
>  	bool			configurable;
>  	bool			any_cpu;
> +	bool			is_floating_point;
> +	unsigned int		binary_bits;
>  	bool			enabled;
>  };
>  
> @@ -79,6 +84,9 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>  #define for_each_mon_event(mevt) for (mevt = &mon_event_all[QOS_FIRST_EVENT];	\
>  				      mevt < &mon_event_all[QOS_NUM_EVENTS]; mevt++)
>  
> +/* Limit for mon_evt::binary_bits */
> +#define MAX_BINARY_BITS	27
> +

Could this be up to 30?

(The formatting code relies on the the product of the maximum fraction
value with 10^decplaces[] not exceeding a u64, so I think 30 bits
fits?  But this only has to be as large as the largest value required
by some supported piece of hardware... I didn't go check on that.)

>  /**
>   * struct mon_data - Monitoring details for each event file.
>   * @list:            Member of the global @mon_data_kn_priv_list list.
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 78ad493dcc01..c435319552be 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -893,15 +893,15 @@ static __init bool get_rdt_mon_resources(void)
>  	bool ret = false;
>  
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
> -		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_TOTAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_TOTAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_CQM_MBM_LOCAL)) {
> -		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false);
> +		resctrl_enable_mon_event(QOS_L3_MBM_LOCAL_EVENT_ID, false, 0);
>  		ret = true;
>  	}
>  	if (rdt_cpu_has(X86_FEATURE_ABMC))
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 883be6f0810f..290a959776de 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -17,6 +17,7 @@
>  
>  #include <linux/cpu.h>
>  #include <linux/kernfs.h>
> +#include <linux/math.h>
>  #include <linux/seq_file.h>
>  #include <linux/slab.h>
>  #include <linux/tick.h>
> @@ -597,6 +598,87 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		resctrl_arch_mon_ctx_free(r, evt->evtid, rr->arch_mon_ctx);
>  }
>  
> +/*
> + * Decimal place precision to use for each number of fixed-point
> + * binary bits.
> + */
> +static unsigned int decplaces[MAX_BINARY_BITS + 1] = {

^ const


Also, maybe explicitly initialise

	[0]  =	1,

here?  (See print_event_value().)
		
> +	[1]  =  1,
> +	[2]  =  2,
> +	[3]  =  3,
> +	[4]  =  3,
> +	[5]  =  3,
> +	[6]  =  3,
> +	[7]  =  3,
> +	[8]  =  3,
> +	[9]  =  3,
> +	[10] =  4,

Why these specific values?

ceil(binary_bits * log10(2)) makes sense if we want to expose all
available hardware precision with as few digits as possible.

floor(binary_bits * log10(2)) makes sense if we want expose as many
digits as possible without advertising spurious precision.

Disregarding the special-casing for binary_bits <= 3, still neither
option quite seems to match this list.


Rounding up means that the hardware value can be reconstructed, but
only if userspace knows the value of binary_bits.  Should that be
exposed?

> +	[11] =  4,
> +	[12] =  4,
> +	[13] =  5,
> +	[14] =  5,
> +	[15] =  5,
> +	[16] =  6,
> +	[17] =  6,
> +	[18] =  6,
> +	[19] =  7,
> +	[20] =  7,
> +	[21] =  7,
> +	[22] =  8,
> +	[23] =  8,
> +	[24] =  8,
> +	[25] =  9,
> +	[26] =  9,
> +	[27] =  9

Documenting the rule for generating these may be a good idea unless we
are sure that no more entries will never be added.

> +};
> +
> +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> +{
> +	unsigned long long frac;
> +	char buf[10];

In place of the magic number 10, how about
decplaces[MAX_BINARY_BITS] + 1 ?

(I think the compiler should accept that as an initialiser if the array
is const.)

> +
> +	if (!binary_bits) {
> +		seq_printf(m, "%llu.0\n", val);
> +		return;
> +	}

Can an initialiser for decplaces[0] reduce the special-casing for
binary_bits == 0?

> +
> +	/* Mask off the integer part of the fixed-point value. */
> +	frac = val & GENMASK_ULL(binary_bits, 0);

Should this be GENMASK_ULL(binary_bits - 1, 0)?

Should we be telling userspace the binary_bits value?  It is not
(exactly) deducible from the number of decimal places printed.

It depends on the use cases and what the code is trying to achieve, but
this does not seem to be described in detail, unless I've missed it
somewhere.

> +
> +	/*
> +	 * Multiply by 10^{desired decimal places}. The integer part of
> +	 * the fixed point value is now almost what is needed.
> +	 */
> +	frac *= int_pow(10ull, decplaces[binary_bits]);
> +
> +	/*
> +	 * Round to nearest by adding a value that would be a "1" in the
> +	 * binary_bits + 1 place.  Integer part of fixed point value is
> +	 * now the needed value.
> +	 */
> +	frac += 1ull << (binary_bits - 1);
> +
> +	/*
> +	 * Extract the integer part of the value. This is the decimal
> +	 * representation of the original fixed-point fractional value.
> +	 */
> +	frac >>= binary_bits;
> +
> +	/*
> +	 * "frac" is now in the range [0 .. 10^decplaces).  I.e. string
> +	 * representation will fit into chosen number of decimal places.
> +	 */
> +	snprintf(buf, sizeof(buf), "%0*llu", decplaces[binary_bits], frac);
> +
> +	/* Trim trailing zeroes */

Why?

Would it be better to present the values with consistent precision?

There's no reason why a telemetry counter should settle for any length
of time at a tidy value, so the precision represented by the trailing
zeros is always significant.

The hardware precision doesn't go up and down depending on the precise
value of the counter...

> +	for (int i = decplaces[binary_bits] - 1; i > 0; i--) {
> +		if (buf[i] != '0')
> +			break;
> +		buf[i] = '\0';
> +	}
> +	seq_printf(m, "%llu.%s\n", val >> binary_bits, buf);
> +}
> +

[...]

Cheers
---Dave
