Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F003596F5;
	Mon, 19 Jan 2026 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820821; cv=none; b=OjescNpzXahoP7IO4QWT6u79UW/01JuEWuGUomcT9r6OB5rLrKtdB2ys8qcshhgwl+Oi2wRpCUPoOr+45gWgoKUvn4tZWOyAFV+Re87pDhg0Ta/2e5n/h6WduIr29UGs9swHQIQr+tpCHU/n7u9dTEvvr8ANPNOu+yznl6LdVP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820821; c=relaxed/simple;
	bh=OCujz5nQkL3cJPuBj9J95UR+WlqoJFTz+Gb363AHfvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyUAEoQK9ZMoRzCdt/QtyP94lci/VOtOHnQX0TPjgrD3xUGes+yaygeHK+AgQJYRYNrcx4s6vSa7XGYu9hlt3PAvwD0WtKlzfFqjCJtJToCrYgiwh44zrI7ch/pHLxwPPkT0ZWVKO6NBcySWDwtTAnmOYb1/Oci51BJn0lQcoSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXfTm+Jv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXfTm+Jv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039DEC116C6;
	Mon, 19 Jan 2026 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768820820;
	bh=OCujz5nQkL3cJPuBj9J95UR+WlqoJFTz+Gb363AHfvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXfTm+Jvd2f4nR2q+/MGi87J29y9MrvOf0JUBVhFShYETcV9XFvzNuLGRsiAtFjGd
	 A4cHw9k6GfRFtVUNNStuQYATe9HHG1aCFf8qciipSJnGBElvqUbhktwsVCJfsMYL7n
	 M8CrNdYBF7kA9IOl2I1uDio7cIZs2/aaDpHXalvg=
Date: Mon, 19 Jan 2026 12:06:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>, Duoming Zhou <duoming@zju.edu.cn>
Subject: Re: [PATCH 5.10 234/451] usb: phy: fsl-usb: Fix use-after-free in
 delayed work during device removal
Message-ID: <2026011936-outlying-unwoven-6e0a@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164239.360073394@linuxfoundation.org>
 <d147f0eb71f9cefbfb7605e95d98564d7f0ed346.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d147f0eb71f9cefbfb7605e95d98564d7f0ed346.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 10:19:58PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:47 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Duoming Zhou <duoming@zju.edu.cn>
> > 
> > commit 41ca62e3e21e48c2903b3b45e232cf4f2ff7434f upstream.
> > 
> > The delayed work item otg_event is initialized in fsl_otg_conf() and
> > scheduled under two conditions:
> > 1. When a host controller binds to the OTG controller.
> > 2. When the USB ID pin state changes (cable insertion/removal).
> > 
> > A race condition occurs when the device is removed via fsl_otg_remove():
> > the fsl_otg instance may be freed while the delayed work is still pending
> > or executing. This leads to use-after-free when the work function
> > fsl_otg_event() accesses the already freed memory.
> > 
> > The problematic scenario:
> > 
> > (detach thread)            | (delayed work)
> > fsl_otg_remove()           |
> >   kfree(fsl_otg_dev) //FREE| fsl_otg_event()
> >                            |   og = container_of(...) //USE
> >                            |   og-> //USE
> > 
> > Fix this by calling disable_delayed_work_sync() in fsl_otg_remove()
> > before deallocating the fsl_otg structure. This ensures the delayed work
> > is properly canceled and completes execution prior to memory deallocation.
> [...]
> 
> The disable_delayed_work_sync() function was only added in 6.10 and has
> not (yet) been backported anywhere.
> 
> So for older branches, either this fix needs to be changed to use
> cancel_delayed_work_sync() (which I suspect requires reordering some of
> the cleanup, to be safe) or disable_delayed_work_sync() needs to be
> backported first.

As no build tests seem to be picking this up, odds are no one uses it :)

I've dropped this now, thanks!

greg k-h
