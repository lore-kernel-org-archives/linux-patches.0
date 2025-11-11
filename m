Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215BB2EB87E
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762881752; cv=none; b=IxtSPeDMNaFmHyfDmwOjyeK4Bd2jeIl3JL4sq4yupYcGkUqYNJJDU+i5h5I1Pwl1q1YONFD25Fxu1GjR/PtU9vMcEg+oXmw5kkMl/eYjz2qIKBr3zYe7WaeYz5NJTDRndH0Pjt9EMXrn0HUMUeVXk5+zHy6WplBebraXcfZ9a84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762881752; c=relaxed/simple;
	bh=ta0mJzAGxbzIX3XT4Gy2fuZ4gIp1f723cm4yWE5IwCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGHjfNBcFbelZCUin0pjz3F1FxN0SgyDJzaHTqb7ZHcICPzvAsECzeGKGuD81KfYOCYg+idqr4x+nr5mCstf+vqVs/DOuDKdlo4nfKQToXVXiov3TFvmO+7aCyhJD9TXAeWSGAb+mawsxyBFVNqy3kYh8mn3xS64WCUOisYgLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2AB6497;
	Tue, 11 Nov 2025 09:22:22 -0800 (PST)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EB0C3F5A1;
	Tue, 11 Nov 2025 09:22:28 -0800 (PST)
Date: Tue, 11 Nov 2025 17:22:25 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aRNw0cugfo/UGsJ4@e133380.arm.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
 <aQveOz66Pd3R0FfI@agluck-desk3>
 <3bf7f52c-80e2-470a-9225-36077a37d7d0@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bf7f52c-80e2-470a-9225-36077a37d7d0@intel.com>

Hi,

On Wed, Nov 05, 2025 at 04:09:28PM -0800, Reinette Chatre wrote:
> Hi Dave and Tony,
> 
> On 11/5/25 3:31 PM, Luck, Tony wrote:
> > On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
> >> On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:
> 
> ...
> 
> >>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> >>> index 40b76eaa33d0..f5189b6771a0 100644
> >>> --- a/fs/resctrl/internal.h
> >>> +++ b/fs/resctrl/internal.h
> >>> @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
> >>>   *			Only valid if @evtid is an MBM event.
> >>>   * @configurable:	true if the event is configurable
> >>>   * @any_cpu:		true if the event can be read from any CPU
> >>> + * @is_floating_point:	event values are displayed in floating point format
> >>
> >> Nit: Maybe rebrand this as is_fixed_point, or is_fractional, or similar?
> >>
> >> The print syntax is just a decimal fraction, and the hardware
> >> representation is fixed-point.  Nothing floats.
> > 
> > You are right. I can change from is_floating_point to is_fixed_point.
> > 
> 
> This is a fs property though, not hardware, and highlights that the value is displayed in
> floating point format which is the closest resctrl has to establish a "contract" with user
> space on what format user space can expect when reading the data as backed with a
> matching update to resctrl.rst for the events that have this hardcoded by the fs.
> Whether an architecture uses fixed point format or some other mechanism to determine the
> value eventually exposed to user space is unique to the architecture. 

Sure, getting the docmuentation right is the most important thing,
while the internal name for this property is not ABI.

(I don't strongly object to "is_floating_point", even if we expose this
in the filesystem, so long as we document carefully what it means.)

Cheers
---Dave
