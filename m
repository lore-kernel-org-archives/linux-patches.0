Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873312032A;
	Sat, 27 Apr 2024 14:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714226722; cv=none; b=C6rNfROKoeOcBNkSs44g7mVbFvqWxVy6SXhjXQlPEGKlPiNfwmAp390KwnkC/Vftnwbbf8L7va48rAvWTDFPiA+n+elkocA7eYpVVXrsyBAslC8jSVRlwrhhISms16DQNMWJBXc88Sn3Rd6lWKKDsLWk1snTPGnzbH6FNsXnPoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714226722; c=relaxed/simple;
	bh=ARwERYBqY9ZeD4dVU/tasyGymV1kSEYAZAxk5mB94I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6XIsckDALYil79UPjKYhoWhnG69ZSIVNSmlJk1zOrZE8s+KNR1fpuQUdOKqgb9nTG7LR7RgqPJb+UZi+1Q1u9FdBMFB5S2v7csem1oQ8Yo/pSExoUBVgE+iDCw3spbgVORgDXIAH2pA/Jb9fIL3Weiq8bg0OhSOg3IedEeKcA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHS0Ma/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHS0Ma/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70016C113CE;
	Sat, 27 Apr 2024 14:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714226722;
	bh=ARwERYBqY9ZeD4dVU/tasyGymV1kSEYAZAxk5mB94I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MHS0Ma/ZjxiLbTMvxX0vLWYLdZLgqTpo1xf86zPtclb4lnFGNRima4sBNViyUozgb
	 cQNtBD/L1xim7bLHklixIoowK2+N/LAPB9hlJyQrIH83yTb0hW+fnd5QyM+s/XoAzV
	 sEsr9+YzaBEB4lBK7XhzVbJfE1NyDUtHl3Wj+SOo=
Date: Sat, 27 Apr 2024 16:05:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 073/158] usb: pci-quirks: handle HAS_IOPORT
 dependency for AMD quirk
Message-ID: <2024042701--c90a@gregkh>
References: <20240423213855.696477232@linuxfoundation.org>
 <20240423213858.137949890@linuxfoundation.org>
 <b1808bf4-a115-45d5-af18-35a0d71061a1@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1808bf4-a115-45d5-af18-35a0d71061a1@app.fastmail.com>

On Wed, Apr 24, 2024 at 08:27:39AM +0200, Arnd Bergmann wrote:
> On Tue, Apr 23, 2024, at 23:38, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> >
> > [ Upstream commit 52e24f8c0a102ac76649c6b71224fadcc82bd5da ]
> >
> > In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> > not being declared. In the pci-quirks case the I/O port acceses are
> > used in the quirks for several AMD south bridges, Add a config option
> > for the AMD quirks to depend on HAS_IOPORT and #ifdef the quirk code.
> >
> > Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Arnd Bergmann <arnd@kernel.org>
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > Link: https://lore.kernel.org/r/20230911125653.1393895-3-schnelle@linux.ibm.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/usb/Kconfig           | 10 ++++++++++
> >  drivers/usb/core/hcd-pci.c    |  3 +--
> >  drivers/usb/host/pci-quirks.c |  2 ++
> >  drivers/usb/host/pci-quirks.h | 30 ++++++++++++++++++++++--------
> >  include/linux/usb/hcd.h       | 17 +++++++++++++++++
> >  5 files changed, 52 insertions(+), 10 deletions(-)
> 
> There is no harm in backporting this one to 6.6, but there
> is no need either since it is only a preparation for the coming
> changes to asm/io.h.
> 
> Like the PCI quirks patch, I wouldn't backport it at all.
> If you do want to keep it, be careful about backporting it
> to older kernels, as it depends on fcbfe8121a45 ("Kconfig:
> introduce HAS_IOPORT option and select it as necessary") from
> linux-6.4.

Agreed, I've dropped all of these now, thanks.

greg k-h
