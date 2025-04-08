Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1439ACF;
	Tue,  8 Apr 2025 15:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125440; cv=none; b=owWZVF8e5Fbt3ZzFAhrvMZNO8uVUWhmyEwCpluKT1dnsJOCVOuw6aDQll58M3gzW2XSuJZcEok2rj45udUvoqoR6+9050upEvz2y2ovhJTT0komMEFxOCxFww3tlEfiiHK2+YX5CgdFE8HvkenIrhcFQxWIWDq7WywH43VnBpxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125440; c=relaxed/simple;
	bh=Cbk8yQdeNcynyL1Yih8/JtDEVER4O9CgHZ+Aj2VIEU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dmihpJD/tcjl8ecmWJR0+Ve7tigPpVaB0rVI+usoR88M37E2ffnBl8P6LgN3lf4Kpw2PxPD1xbdHTJcgzk4lVUGwbnSqTw8kRd+tZKivNmPnEzjHGaw41G+YWIe0QmeABjk/mQJT23NdkG66cFxeTOrfvp4uLZkqXxYgOsKjIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1bHWR3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1bHWR3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7276C4CEE5;
	Tue,  8 Apr 2025 15:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125440;
	bh=Cbk8yQdeNcynyL1Yih8/JtDEVER4O9CgHZ+Aj2VIEU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1bHWR3xAIwyGf3raCvN0tmvYmNi5ywmxe/ZCzEYA/3Q8MmIQMMxf/D7mnTZkRh/3
	 d3+aoZVup34v7F1MgPIwkzEWlB3ox5UJndB35BjMQPA9PUzh6jnCr4J24k3k8rODUh
	 rkpZDjmSluty2s59jYyppNPyj2iY6KR0cFQlmC54=
Date: Tue, 8 Apr 2025 17:15:46 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vishal Annapurve <vannapurve@google.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ryan Afranji <afranji@google.com>,
	Andy Lutomirski <luto@kernel.org>, Brian Gerst <brgerst@gmail.com>,
	Juergen Gross <jgross@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 6.13 444/499] x86/tdx: Fix arch_safe_halt() execution for
 TDX VMs
Message-ID: <2025040829-surgical-saddlebag-56fa@gregkh>
References: <20250408104851.256868745@linuxfoundation.org>
 <20250408104902.301772019@linuxfoundation.org>
 <CAGtprH_Sm7ycECq_p+Qz3tMK0y10qenJ=DFiw-kKNn3d9YwPaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH_Sm7ycECq_p+Qz3tMK0y10qenJ=DFiw-kKNn3d9YwPaQ@mail.gmail.com>

On Tue, Apr 08, 2025 at 05:55:57AM -0700, Vishal Annapurve wrote:
> On Tue, Apr 8, 2025 at 5:29 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Vishal Annapurve <vannapurve@google.com>
> >
> > commit 9f98a4f4e7216dbe366010b4cdcab6b220f229c4 upstream.
> >
> > Direct HLT instruction execution causes #VEs for TDX VMs which is routed
> > to hypervisor via TDCALL. If HLT is executed in STI-shadow, resulting #VE
> > handler will enable interrupts before TDCALL is routed to hypervisor
> > leading to missed wakeup events, as current TDX spec doesn't expose
> > interruptibility state information to allow #VE handler to selectively
> > enable interrupts.
> >
> > Commit bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
> > prevented the idle routines from executing HLT instruction in STI-shadow.
> > But it missed the paravirt routine which can be reached via this path
> > as an example:
> >
> >         kvm_wait()       =>
> >         safe_halt()      =>
> >         raw_safe_halt()  =>
> >         arch_safe_halt() =>
> >         irq.safe_halt()  =>
> >         pv_native_safe_halt()
> >
> > To reliably handle arch_safe_halt() for TDX VMs, introduce explicit
> > dependency on CONFIG_PARAVIRT and override paravirt halt()/safe_halt()
> > routines with TDX-safe versions that execute direct TDCALL and needed
> > interrupt flag updates. Executing direct TDCALL brings in additional
> > benefit of avoiding HLT related #VEs altogether.
> >
> > As tested by Ryan Afranji:
> >
> >   "Tested with the specjbb2015 benchmark. It has heavy lock contention which leads
> >    to many halt calls. TDX VMs suffered a poor score before this patchset.
> >
> >    Verified the major performance improvement with this patchset applied."
> >
> > Fixes: bfe6ed0c6727 ("x86/tdx: Add HLT support for TDX guests")
> > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Tested-by: Ryan Afranji <afranji@google.com>
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Brian Gerst <brgerst@gmail.com>
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/r/20250228014416.3925664-3-vannapurve@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/x86/Kconfig           |    1 +
> >  arch/x86/coco/tdx/tdx.c    |   26 +++++++++++++++++++++++++-
> >  arch/x86/include/asm/tdx.h |    4 ++--
> >  arch/x86/kernel/process.c  |    2 +-
> >  4 files changed, 29 insertions(+), 4 deletions(-)
> >
> 
> Hi Greg,
> 
> This patch depends on commit 22cc5ca5de52 ("x86/paravirt: Move halt
> paravirt calls under CONFIG_PARAVIRT"). I will respond to the other
> thread with a patch for commit 22cc5ca5de52 after resolving conflicts.

That commit is already in this series, do I need to add it again? :)

thanks,

greg k-h
