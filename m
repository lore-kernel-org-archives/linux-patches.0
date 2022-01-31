Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1F2CA1
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 18:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643654991; x=1675190991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8D2BH2C555PohOIaLdNhmx7HXgDMK6RxsyeCx7PYZgE=;
  b=RDHaTJo4yx7NWZjfdszMO4i864ZMnnyCr2ec9yRVtn2g6fz117oaoQru
   vZbSR+FN5UMCvdWK4ZTpzyOhp/OVi35slRe8hOf9Q1kPAEGWw1ryV6DGv
   SsEhrb5XtYufTNOtPvKUdEfMJfN/U6TEfT1glkIXdGGqT3Hcb7Cf6iltw
   g8SYbBl/zRFTxj5IlJoi0IF2u26U/soKwBL507cPVTqXFrSUlQ0wnGtDz
   zFJiKSmR74sWyJZRVdkEbUBrNDBEhvNGyV2VKxVTVooQu62wrijpwzTLa
   srSX5DYd7ecsPi9JS6LScPrgI902dXgoPqzJVOH1F9RyhN0vWY2Dcc+ME
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="228188714"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="228188714"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:49:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="522759048"
Received: from agluck-desk2.sc.intel.com (HELO agluck-desk2.amr.corp.intel.com) ([10.3.52.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 10:49:33 -0800
Date: Mon, 31 Jan 2022 10:49:32 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number)
 updates
Message-ID: <YfgvPD6AUPIwQgyf@agluck-desk2.amr.corp.intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <YffWtTq2y6K8+gHF@zn.tnic>
 <YfgbCFNeNEkypCmC@agluck-desk2.amr.corp.intel.com>
 <YfgoBgwgfoiKkPa9@zn.tnic>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfgoBgwgfoiKkPa9@zn.tnic>

On Mon, Jan 31, 2022 at 07:18:46PM +0100, Borislav Petkov wrote:
> On Mon, Jan 31, 2022 at 09:23:20AM -0800, Luck, Tony wrote:
> > I'm worried that some future thing might reverse that and have
> > a "package" id for each die in a multi-die package which still
> > appears as a single node. That would distort the meaning of "package",
> > so it isn't supposed to happen. But if it did, Linux would be stuck
> > just reporting one of the "package" ids.
> 
> Hmm, so we write that we don't really care about the physical socket in
> software:
> 
> Documentation/x86/topology.rst:
> "The kernel does not care about the concept of physical sockets because
> a socket has no relevance to software. It's an electromechanical
> component. In the past a socket always contained a single package
> (see below), but with the advent of Multi Chip Modules (MCM) a socket
> can hold more than one package. So there might be still references to
> sockets in the code, but they are of historical nature and should be
> cleaned up."
> 
> and the PPIN is a physical socket property. So there's no proper way for
> us to tie to anything that represents the physical socket.
> 
> So, the use case you're imagining would be, what?
> 
> The FRU code glue would go:
> 
> "I got an MCE on CPU X...
> 
> Lemme see which PPIN is it:
> 
> # cat /sys/devices/system/cpu/cpuX/topology/ppin
> BLA
> 
> ah ok, lemme report it:
> 
> You just had an MCE on CPU X, socket BLA"
> 
> Something like that?

Yes. We also have a new thing (patches coming soon) other than MCE
that would follow that same flow. So in general it is: "problem with CPU X,
go read the ppin file for that CPU to file the report".  For the new
thing, only root can trigger it, so not a problem for root to create
the report.

> But that FRU glue software would have to run as root so that it reads
> the ppin sysfs file.
> 
> But we don't want to expose that processor serial number to !root users
> so we're forcing the people to run the FRU thing as root.
> 
> This feels like this guy here:
> 
> https://c.tenor.com/fDZOE4okO3EAAAAC/homer-simpsons.gif

I think any paranoia about having a user readable "serial number"
should be gone by now. Those wacky web folks found a dozen different ways
to track your every move on the internet so that adverts for whatever
you just searched for will follow you for days. It seems highly
unlikely that browser writers will bother reading ppin and adding it
to cookies.

But I didn't want to get distracted by that, so made the file mode 0400.

-Tony
