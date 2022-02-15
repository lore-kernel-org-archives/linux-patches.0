Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9551B68
	for <patches@lists.linux.dev>; Tue, 15 Feb 2022 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644963755; x=1676499755;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fyM9BdY2VLSsQXK310mGQhW+fXu4Axlzng/tIkJ9TZo=;
  b=fBRrW4m+rxEEkUIZnEjUeMxnPx5z3t/0SlmhKRnWg4EQqcpy/0j1IaZY
   Hvyrp/+FTt64v74yiLwtKyI7Q3xtDOBvsPYh7BWSTIHiPXFThJdINhiGP
   Mwy8WQ7eCtolD1w0CYMw9h/5TUo2DEnnhO+2HkIUtXQZ23bahBddpD9Uc
   OrUXInytCeuYkAe35vzyvVyis3xRBiuPyHQdXNvXFH1ZPhbBDA6wYn2zh
   Qi1wGuQJiYzV19pJZ9japEVnNBmsit++FtdC3x2JvpIwgj+0AQNMmKuwb
   GSiT2DSe9XPbuXxdAlEd+PWQxbEtkJ2ZPstFGfMfAB9gQB6R1pIuv54Ap
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250668579"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="250668579"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 14:22:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="636163020"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 14:22:34 -0800
Date: Tue, 15 Feb 2022 14:22:33 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jue Wang <juew@google.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] x86/mce: Add workaround for SKX/CLX/CPX spurious machine
 checks
Message-ID: <YgwnqTc8FGG3orcE@agluck-desk3.sc.intel.com>
References: <CAPcxDJ7nriZEJHF6dMPR7tQ+dGuueyRjw1NC+4CbjxiAT_S+ZA@mail.gmail.com>
 <20220208150945.266978-1-juew@google.com>
 <Ygwka++3eipjQzB2@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygwka++3eipjQzB2@zn.tnic>

On Tue, Feb 15, 2022 at 11:08:43PM +0100, Borislav Petkov wrote:
> > This is still better than the OS crashes on MCEs raised on an
> > irrelevant process due to 'rep movs*' accesses in a kernel context,
> > e.g., copy_page.
> 
> Wait a minute: so the MCE will happen for a piece of buffer that REP;
> MOVS *wasn't* supposed to copy.

Yes. That's why this is a "spurious" MCE. The "REP; MOVS" does
a fetch beyond the source range. If there is poison there, BOOM,
MCE :-(

> So why are we even disabling fast strings operations? Why aren't we
> simply ignoring this MCE with a warn in dmesg since, reportedly, we can
> recover safely?

This early in do_machine check we don't know whether this was from
a over enthusistic REP;MOVS fetch, or a "normal" machine check.
I don't think there is an easy way to tell the difference.

Since that "extra fetch" is part of the fast string mode, the workaround
is to disable fast strings and return. Now that will mean that fast
strings gets disabled for machine checks that had nothing to do with
this quirk. But this does provide a good-enough workaround.

> What about the MCE broadcasting synchronization? This is bypassing
> everything. There's mce_exception_count which counts stuff too.

The first check:

	if ((mcgstatus & MCG_STATUS_LMCES) 

is for "is this a local machine check"? So no broadcast sync
needed. But that needs a comment.

-Tony
