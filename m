Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706602EA164;
	Wed, 22 Oct 2025 05:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761110934; cv=none; b=ZJumkD2y/U41KOagd1uRvJNwZdU2YiZRmyqIDlRQNlKFYjulWWbJE2JMHI43RCUUN/K/FiVsghTqp21ZumW1PLA2SeT6eLxj0IhLYFflu1xL3Eqo3uJWmdN1xJEWWkZ5QEOOjD5aBxugDXyoM2fIRkNs0FhBrbHREFNn9M2mC4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761110934; c=relaxed/simple;
	bh=3Ff1ASD4+Th70oO4lsVjO5rTjRYPN1ABVSR9uE5fR7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lvkI8+vSmN//1upA8qrYekaaOqwbq2DmBk6XTPE9Qn0acHparb/zl/8vxBqbDB5lz58DOYR+R2wqJ7D6T250cASaF7mHe9I0pqYl9n0rPxDbqJ9tyz0C8ebvHW/ghcpru0NBmWl+vslmrhypN50HQlByZPMYc+MS7n2HFxDgMqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FM14vIVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FM14vIVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0A7C4CEE7;
	Wed, 22 Oct 2025 05:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761110933;
	bh=3Ff1ASD4+Th70oO4lsVjO5rTjRYPN1ABVSR9uE5fR7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FM14vIVZxOjSYglNeWLtEEHC/JxTP6WKADZiXeEpooRHBfSgLL7xWxg3sOb153DAq
	 2pZWBHKtdv9BrP51l3fR4tZ1vO+Uln8WBZL+cRDwi9j43/9iL+LN4DoRCxeXHEQ8Td
	 m9xJk81/wmEAOKIg9POnRuKi5sA0uGkVQlCKJfzA=
Date: Wed, 22 Oct 2025 07:28:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Nick Bowler <nbowler@draconx.ca>,
	Douglas Anderson <dianders@chromium.org>,
	Dave Airlie <airlied@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.17 040/159] drm/ast: Blank with VGACR17 sync enable,
 always clear VGACRB6 sync off
Message-ID: <2025102235-pediatric-sandlot-f2de@gregkh>
References: <20251021195043.182511864@linuxfoundation.org>
 <20251021195044.163217433@linuxfoundation.org>
 <499eb508-5f24-4ef4-a2a3-f3d76d89db66@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499eb508-5f24-4ef4-a2a3-f3d76d89db66@leemhuis.info>

On Wed, Oct 22, 2025 at 06:49:21AM +0200, Thorsten Leemhuis wrote:
> On 10/21/25 21:50, Greg Kroah-Hartman wrote:
> > 6.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Thomas Zimmermann <tzimmermann@suse.de>
> > 
> > commit 6f719373b943a955fee6fc2012aed207b65e2854 upstream.
> > 
> > Blank the display by disabling sync pulses with VGACR17<7>. Unblank
> > by reenabling them. This VGA setting should be supported by all Aspeed
> > hardware.
> 
> TWIMC, a regression report about 6.18-rc2 that was bisected to this
> commit just came in:
> 
> https://lore.kernel.org/all/a40caf8e-58ad-4f9c-af7f-54f6f69c29bb@googlemail.com/
> 
> To quote:
> 
> """
> I have encountered a serious (for me) regression with 6.18-rc2 on my
> 2-socket Ivy Bridge Xeon E5-2697 v2 server. After
> booting, my console screen goes blank and stays blank. 6.18-rc1 was
> still fine.
> 
> [...]
> 
> When I revert this from 6.18-rc2, the issue goes away and my console
> screen works again.
> """

Thanks, I'll go drop this patch from the stable queues for now.

greg k-h
