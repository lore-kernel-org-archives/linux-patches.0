Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1C126BFF;
	Thu,  1 May 2025 06:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746081647; cv=none; b=Cilq951S8+8B5msBrpV+P0t2Yd3BE+DpfsWKIZWP737SYu8hEh32gYMDT5hoPIQXVvIrzuqvDERC1MLotTE9dNQicVxfvdfP2iHAwimntcS/FI9ifo5LkODTjQrIxV5CHcdooJ+6f9/2UqXTOfn/RexGoGYow5tjLIsYpG7zuAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746081647; c=relaxed/simple;
	bh=VO9EA4oDMPzK6+/Ev6nI9duNORDsGXRBZzqoFHsegrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YGE4h/46AO8IQabDFJ34Y/Apba639vzdHkbb6sB8mJUfPBo3NPg+nsNpOJ/hqUC5bH/rWQ1wq4ocPapIaTH9l+gJKRw/xxZlCSS9AUa8zFZJnlUqbCI309W1/qCl59cMX3Ce3xSYmbEtUs4bbpEMz2uY5aW5Tp8by4iaCWfhHds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J79lP5ZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J79lP5ZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86688C4CEE3;
	Thu,  1 May 2025 06:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746081646;
	bh=VO9EA4oDMPzK6+/Ev6nI9duNORDsGXRBZzqoFHsegrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J79lP5ZSvJaBWWQQg/NVltRCl9QpolSXBqN4iBB4KEuY31S0FoLh5fXs9xfTDDvRn
	 363WFsE8D0Ue67M+Pr8tF+Cg0Fs2ju+cP50Aou9widecEfsDzaNlP6FE6t7n+Phx/C
	 jc6m+Is5RL0a8FwNu/yT3NAT/oTfQpkTeeCj3Y10=
Date: Thu, 1 May 2025 08:40:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 039/167] s390/pci: Support mmap() of PCI resources
 except for ISM devices
Message-ID: <2025050136-doing-childhood-f3e7@gregkh>
References: <20250429161051.743239894@linuxfoundation.org>
 <20250429161053.337884386@linuxfoundation.org>
 <fd60973b1901ad1604e163e4bb3bd188879288fa.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd60973b1901ad1604e163e4bb3bd188879288fa.camel@linux.ibm.com>

On Wed, Apr 30, 2025 at 05:36:12PM +0200, Niklas Schnelle wrote:
> On Tue, 2025-04-29 at 18:42 +0200, Greg Kroah-Hartman wrote:
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> > 
> > [ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]
> > 
> > So far s390 does not allow mmap() of PCI resources to user-space via the
> > usual mechanisms, though it does use it for RDMA. For the PCI sysfs
> > resource files and /proc/bus/pci it defines neither HAVE_PCI_MMAP nor
> > ARCH_GENERIC_PCI_MMAP_RESOURCE. For vfio-pci s390 previously relied on
> > disabled VFIO_PCI_MMAP and now relies on setting pdev->non_mappable_bars
> > for all devices.
> > 
> > This is partly because access to mapped PCI resources from user-space
> > requires special PCI load/store memory-I/O (MIO) instructions, or the
> > special MMIO syscalls when these are not available. Still, such access is
> > possible and useful not just for RDMA, in fact not being able to mmap() PCI
> > resources has previously caused extra work when testing devices.
> > 
> > One thing that doesn't work with PCI resources mapped to user-space though
> > is the s390 specific virtual ISM device. Not only because the BAR size of
> > 256 TiB prevents mapping the whole BAR but also because access requires use
> > of the legacy PCI instructions which are not accessible to user-space on
> > systems with the newer MIO PCI instructions.
> > 
> > Now with the pdev->non_mappable_bars flag ISM can be excluded from mapping
> > its resources while making this functionality available for all other PCI
> > devices. To this end introduce a minimal implementation of PCI_QUIRKS and
> > use that to set pdev->non_mappable_bars for ISM devices only. Then also set
> > ARCH_GENERIC_PCI_MMAP_RESOURCE to take advantage of the generic
> > implementation of pci_mmap_resource_range() enabling only the newer sysfs
> > mmap() interface. This follows the recommendation in
> > Documentation/PCI/sysfs-pci.rst.
> > 
> > Link: https://lore.kernel.org/r/20250226-vfio_pci_mmap-v7-3-c5c0f1d26efd@linux.ibm.com
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/s390/Kconfig           |  4 +---
> >  arch/s390/include/asm/pci.h |  3 +++
> >  arch/s390/pci/Makefile      |  2 +-
> >  arch/s390/pci/pci_fixup.c   | 23 +++++++++++++++++++++++
> >  drivers/s390/net/ism_drv.c  |  1 -
> >  include/linux/pci_ids.h     |  1 +
> >  6 files changed, 29 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/s390/pci/pci_fixup.c
> > 
> > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > index de575af02ffea..50a4a878bae6d 100644
> > --- a/arch/s390/Kconfig
> > +++ b/arch/s390/Kconfig
> > @@ -38,9 +38,6 @@ config AUDIT_ARCH
> >  config NO_IOPORT_MAP
> >  	def_bool y
> >  
> > -config PCI_QUIRKS
> > -	def_bool n
> > -
> >  config ARCH_SUPPORTS_UPROBES
> >  	def_bool y
> >  
> > @@ -213,6 +210,7 @@ config S390
> >  	select PCI_DOMAINS		if PCI
> >  	select PCI_MSI			if PCI
> >  	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
> > +	select PCI_QUIRKS		if PCI
> >  	select SPARSE_IRQ
> >  	select SWIOTLB
> >  	select SYSCTL_EXCEPTION_TRACE
> > diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> > index 108e732d7b140..a4e9a6ecbd437 100644
> > --- a/arch/s390/include/asm/pci.h
> > +++ b/arch/s390/include/asm/pci.h
> > @@ -11,6 +11,9 @@
> >  #include <asm/pci_insn.h>
> >  #include <asm/sclp.h>
> >  
> > +#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
> > +#define arch_can_pci_mmap_wc()		1
> > +
> >  #define PCIBIOS_MIN_IO		0x1000
> >  #define PCIBIOS_MIN_MEM		0x10000000
> >  
> > diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> > index eeef68901a15c..2f8dd3f688391 100644
> > --- a/arch/s390/pci/Makefile
> > +++ b/arch/s390/pci/Makefile
> > @@ -5,5 +5,5 @@
> >  
> >  obj-$(CONFIG_PCI)	+= pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
> >  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> > -			   pci_bus.o pci_kvm_hook.o pci_report.o
> > +			   pci_bus.o pci_kvm_hook.o pci_report.o pci_fixup.o
> >  obj-$(CONFIG_PCI_IOV)	+= pci_iov.o
> > diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
> > new file mode 100644
> > index 0000000000000..35688b6450983
> > --- /dev/null
> > +++ b/arch/s390/pci/pci_fixup.c
> > @@ -0,0 +1,23 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Exceptions for specific devices,
> > + *
> > + * Copyright IBM Corp. 2025
> > + *
> > + * Author(s):
> > + *   Niklas Schnelle <schnelle@linux.ibm.com>
> > + */
> > +#include <linux/pci.h>
> > +
> > +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> > +{
> > +	/*
> > +	 * ISM's BAR is special. Drivers written for ISM know
> > +	 * how to handle this but others need to be aware of their
> > +	 * special nature e.g. to prevent attempts to mmap() it.
> > +	 */
> > +	pdev->non_mappable_bars = 1;
> > +}
> 
> As already noted by others and for other versions the above will cause
> a build error without also pulling in commit 888bd8322dfc ("s390/pci:
> Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP")

Now dropped, thanks.

greg k-h
