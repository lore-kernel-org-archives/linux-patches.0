Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD6259CAC;
	Thu,  1 May 2025 06:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746081432; cv=none; b=RFpc+uCnNSesjlB5M3Sq2D9MaObUBTDfjBQp4yavz0wH0a6MHZBzrVU4g1eQMkSK4hKoyOyBM7ZGMNSLK0R9ypEPxy887xKRkYuzXonpL9CbNHJuntbJ4HXQmP45iGCmrnTAneUSrV021TqCmZOY1Vv150JGqy1GX57fBX5+bQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746081432; c=relaxed/simple;
	bh=tePijnW58siK8jfC+gOUQx2A3UtlITa7rSZs8/zoWDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lh5DKnEotfxQ+PiynCQnqkiqSz0uWCSjCtkkC+xPbBMsGViF9CYa47ry7X00c/P/D+pQnx+MuvVuXLdY1tLTKj6TpmZSvC7eI1l/OSRadyY1T7zrm7uiA5J1ZNqb4P/kz4fqtcrFc6TgL4yxF9nB9RKz9tyOgGHMqiXGbwtsLlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uY3+mrEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uY3+mrEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86923C4CEED;
	Thu,  1 May 2025 06:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746081432;
	bh=tePijnW58siK8jfC+gOUQx2A3UtlITa7rSZs8/zoWDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uY3+mrErd9LNwUusDYsJsGGKD49dtbmFPGwDZDushE4N1jEmhDU7y8rB6nUC6WVeJ
	 Qn24I0pL6k2wQvDtgc78BaL67NQgr8k3EQruWRzczoB5c9i3mNPKPKOVYOD6g49sqW
	 edmDBjxyaneF3QVDo6JnG4PJg2hFRgj4vqGk4US8=
Date: Thu, 1 May 2025 08:37:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 019/311] s390/pci: Support mmap() of PCI resources
 except for ISM devices
Message-ID: <2025050127-floss-tablet-736d@gregkh>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161121.820299536@linuxfoundation.org>
 <c8aba766-7245-486b-a826-a4af74072bed@kernel.org>
 <80d4af6a714848783611447711d6d9fa304bbe05.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d4af6a714848783611447711d6d9fa304bbe05.camel@linux.ibm.com>

On Wed, Apr 30, 2025 at 09:46:00AM +0200, Niklas Schnelle wrote:
> On Wed, 2025-04-30 at 09:41 +0200, Jiri Slaby wrote:
> > On 29. 04. 25, 18:37, Greg Kroah-Hartman wrote:
> > > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Niklas Schnelle <schnelle@linux.ibm.com>
> > > 
> > > [ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]
> > ...
> > > +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> > > +{
> > > +	/*
> > > +	 * ISM's BAR is special. Drivers written for ISM know
> > > +	 * how to handle this but others need to be aware of their
> > > +	 * special nature e.g. to prevent attempts to mmap() it.
> > > +	 */
> > > +	pdev->non_mappable_bars = 1;
> > 
> > I see:
> > arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
> > arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member 
> > named 'non_mappable_bars'
> >     19 |         pdev->non_mappable_bars = 1;
> >        |             ^~
> > 
> > 
> > 
> > 
> > 
> > The above needs at least:
> > commit 888bd8322dfc325dc5ad99184baba4e1fd91082d
> > Author: Niklas Schnelle <schnelle@linux.ibm.com>
> > Date:   Wed Feb 26 13:07:46 2025 +0100
> > 
> >      s390/pci: Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP
> > 
> > thanks,
> 
> Yes, as this didn't originally have a Cc stable / Fixes tag this
> prerequisite doesn't seem to have been pulled in correctly. Besides the
> cited commit 888bd8322dfc ("s390/pci: Introduce pdev->non_mappable_bars
> and replace VFIO_PCI_MMAP") this also needs commit 41a0926e82f4
> ("s390/pci: Fix s390_mmio_read/write syscall page fault handling") for
> correct operation.

I'll just drop this from all queues for now and if it is something that
really needs to be in the stable trees, I'll wait for someone to submit
a working set of backported patches.

thanks,

greg k-h
