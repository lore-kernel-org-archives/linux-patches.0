Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9776820312
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V6P7jNl1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701114629; x=1732650629;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FOWlBJuI1QWETMszMwBkYk25m1g8XF0ebe/+lRpK/Yg=;
  b=V6P7jNl1fDdXYWrUx2nZA+moqV8492eObxqR7/VWYf35QOzet/L5zGEv
   kkWkhdarG8ud88KWEqjU8q3l91PrMeWVqTfCJoHNlrI/0RSucmRXk8Xve
   B6iS5CMGu1q2Ah0zb4jxjMK/f/MJZFBBjkd44/vuuwtMxnkZ9Y4e/OF34
   8oNEqNsbmR5benk52jAaK6+uFLYmk1VgpBk665HgDPjkSIKAfV2PrWdCN
   6P04ZH7rkI+JvDKWmyRNDs5caN5gV0GcCqn46Gg8GXnfgEinNRRxv+r5z
   7MWsNTqogDxNZ25pQcDGsewRQvOqUKh4x7lRYsnfv667KlXeuhbz945A1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="389930692"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="389930692"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 11:50:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="744669420"
X-IronPort-AV: E=Sophos;i="6.04,231,1695711600"; 
   d="scan'208";a="744669420"
Received: from agluck-desk3.sc.intel.com (HELO agluck-desk3) ([172.25.222.74])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 11:50:28 -0800
Date: Mon, 27 Nov 2023 11:50:26 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>,
	Smita.KoralahalliChannabasappa@amd.com, dave.hansen@linux.intel.com,
	x86@kernel.org, linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 2/3] x86/mce: Add per-bank CMCI storm mitigation
Message-ID: <ZWTzAujHdrJ950F3@agluck-desk3>
References: <20230929181626.210782-1-tony.luck@intel.com>
 <20231004183623.17067-1-tony.luck@intel.com>
 <20231004183623.17067-3-tony.luck@intel.com>
 <20231019151211.GHZTFHS3osBIL1IJbF@fat_crate.local>
 <ZTa37L2nlnbok8dz@agluck-desk3>
 <20231114192324.GAZVPJLGZmfJBS181/@fat_crate.local>
 <ZVPu/hX9b7lUkrBY@agluck-desk3>
 <20231121115448.GCZVyaiNkNvb4t2NxB@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121115448.GCZVyaiNkNvb4t2NxB@fat_crate.local>

On Tue, Nov 21, 2023 at 12:54:48PM +0100, Borislav Petkov wrote:
> On Tue, Nov 14, 2023 at 02:04:46PM -0800, Tony Luck wrote:
> > Whichever of the timer and the CMCI happens first will run. Second to
> > arrive will pend the interrupt and be handled when interrupts are
> > enabled as the first completes.
> 
> So I still don't like the timer calling machine_check_poll() and
> cmci_mc_poll_banks() doing the same without any proper synchronization
> between the two.

But it isn't doing the same thing.  The timer calls:

	machine_check_poll(0, this_cpu_ptr(&mce_poll_banks));

and cmci_mc_poll_banks() calls:

	machine_check_poll(0, this_cpu_ptr(&mce_poll_banks));

A bank is either in the bitmap of banks to poll from the timer,
or in one of the per-cpu bitmaps of banks "owned" by that CPU to
be checked when a CMCI occurs. But it can't be in both.

> Yes, when you get a CMCI interrupt, you poll and do the call the storm
> code. Now what happens if the polling runs from softirq context and you
> get a CMCI interrupt at exactly the same time. I.e., is
> machine_check_poll() reentrant and audited properly?

So nothing bad happens. If Linux was polling some set of banks from
the timer and is interrupted by CMCI, the interrupt will check some
disjoint set of banks. All the history tracking code is done per-bank,
so there is no overlap.

> I hope I'm making more sense.

Yes. Totally making sense. I was under the mistaken impression that
the mce timers used TIMER_IRQSAFE and the nested CMCI while processing
a timed poll couldn't happen. So I learned something here too.

I'll think of some comment to add to the history tracking code
to summarize this thread.

-Tony
