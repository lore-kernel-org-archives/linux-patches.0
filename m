Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6FA126BFF;
	Thu,  1 May 2025 06:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746081667; cv=none; b=rn1EhwLy/xCjGPJz3W9YMe08VL3HJa7g0KfvL5I3QITIi/cUSf6RFBaGXpo6qMMUbiT07MiEn8+hFsAEBKvx38C9uSdVVCsaubAsYB9nBPBNCBoHCSjF6CyoJ4kGVLolO2V9TmTP/bKWAWUtY6swzDWIWtFhdAO/Z32Zujy2ucw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746081667; c=relaxed/simple;
	bh=W48JYejqADIDKPUsukk17y5qY0ej1+aFr6DyKQKoSqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCgjBJo5W0G1e1rb/9maCSLiKyJrwFjua8prvCWLAABTQ9QpYSaCwbEassvShEO875y6701wqxc5RXjUrXNPSNFTiePdk9YgsUvoJVyAkaUVHlsVmnjuRbTewQmipkWhImj71IuZpTMVhu66JKM3bgjTKD1i7wqnpulwnLynmv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lgxZ3CQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lgxZ3CQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5013C4CEE3;
	Thu,  1 May 2025 06:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746081666;
	bh=W48JYejqADIDKPUsukk17y5qY0ej1+aFr6DyKQKoSqQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2lgxZ3CQ/TybZEKo6K4vhrEt2fJryZ7lJEshNb7Q80x5dWe3hSN22VUEC73kiYs/W
	 wWxDeoG6ZUvLk9G4HILRHfz4QWpnyVlQ3Jl0a4msdsSpMgP1l39G1WamD9LYqZBTVC
	 PbKPZRhgGwnms6R240gS1AObWDihTOpJqoMzonhQ=
Date: Thu, 1 May 2025 08:41:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Halil Pasic <pasic@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 038/167] s390/pci: Report PCI error recovery results
 via SCLP
Message-ID: <2025050146-gush-registry-e02c@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <20250429161053.295203006@linuxfoundation.org>
 <b2609f9018e9a9897233ee71be19ac64d6408e07.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2609f9018e9a9897233ee71be19ac64d6408e07.camel@linux.ibm.com>

On Wed, Apr 30, 2025 at 05:33:46PM +0200, Niklas Schnelle wrote:
> On Tue, 2025-04-29 at 18:42 +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> > 
> > [ Upstream commit 4ec6054e7321dc24ebccaa08b3af0d590f5666e6 ]
> > 
> > Add a mechanism with which the status of PCI error recovery runs
> > is reported to the platform. Together with the status supply additional
> > information that may aid in problem determination.
> > 
> > Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> > Stable-dep-of: aa9f168d55dc ("s390/pci: Support mmap() of PCI resources except for ISM devices")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/s390/include/asm/sclp.h |  33 +++++++++++
> >  arch/s390/pci/Makefile       |   2 +-
> >  arch/s390/pci/pci_event.c    |  21 +++++--
> >  arch/s390/pci/pci_report.c   | 111 +++++++++++++++++++++++++++++++++++
> >  arch/s390/pci/pci_report.h   |  16 +++++
> >  drivers/s390/char/sclp.h     |  14 -----
> >  drivers/s390/char/sclp_pci.c |  19 ------
> >  7 files changed, 178 insertions(+), 38 deletions(-)
> >  create mode 100644 arch/s390/pci/pci_report.c
> >  create mode 100644 arch/s390/pci/pci_report.h
> > 
> > diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> > index 9d4c7f71e070f..e64dac00e7bf7 100644
> > --- a/arch/s390/include/asm/sclp.h
> > +++ b/arch/s390/include/asm/sclp.h
> > 
> --- snip ---
> > diff --git a/arch/s390/pci/pci_report.c b/arch/s390/pci/pci_report.c
> > new file mode 100644
> > index 0000000000000..2754c9c161f5b
> > --- /dev/null
> > +++ b/arch/s390/pci/pci_report.c
> > @@ -0,0 +1,111 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright IBM Corp. 2024
> > + *
> > + * Author(s):
> > + *   Niklas Schnelle <schnelle@linux.ibm.com>
> > + *
> > + */
> > +
> > +#define KMSG_COMPONENT "zpci"
> > +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/sprintf.h>
> > 
> 
> This seems to cause a compile error due to missing linux/sprintf.h,
> not sure if that is a good target for a backport? I also don't remember
> running into this during my backports for the enterprise distributions
> so maybe they have that backported.
> 
> Also, this was pulled in as a dependency for commit aa9f168d55dc
> ("s390/pci: Support mmap() of PCI resources except for ISM devices")
> but I'm not sure why that would depend on this? The only thing I can
> think of is the Makefile change to add pci_fixup.c also having
> pci_report.c in it.
> 
> For context I did backports for this for RHEL 10.0, and RHEL 9.6 and it
> was also backported for Ubuntu 25.04 and SLES 16 SP 0. That was for a
> larger series of improving debug information gathering though not as
> dependencies. There I included the following upstream commits:
> 
> 897614f90f7c ("s390/debug: Pass in and enforce output buffer size for format handlers")
> 4c41a48f5f3e ("s390/pci: Add pci_msg debug view to PCI report")
> dc18c81a57e7 ("s390/debug: Add a reverse mode for debug_dump()")
> 5f952dae48d0 ("s390/debug: Add debug_dump() to write debug view to a string buffer")
> 460c52a57f83 ("s390/debug: Split private data alloc/free out of file operations")
> 7832b3047d10 ("s390/debug: Simplify and document debug_next_entry() logic")
> 4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")
> 
> 
> Not sure what the stable policy is on such stuff and if staying in sync
> with the above mentioned distributions for s390 is desirable and/or
> worth the effort.

I've dropped all of the offending s390 patches from the queues now,
thanks.

greg k-h
