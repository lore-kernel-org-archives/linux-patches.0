Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ED3223DEF;
	Wed,  4 Jun 2025 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749033375; cv=none; b=EI8MxrmqVqGqtugFS0ZBeQ8e/JFrgPNySRWb/biMbRg0hWR5p0fLNPgqf72CYdeIR/OHAuHGOhGT2Is6ZQoNz0c44FHAPH0K43T0NbdkTztGQRbf1ijYth9gBPndjIc8Zs1z8Hzuiq+1JSztlHj8rLJLJdmntt/1ianavQgP80s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749033375; c=relaxed/simple;
	bh=PwHv4l1E4QBBgZQgPVj1FI81thF5hicHpJY7/85lMx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iwnMglVeqc5pQKT2cn7GRO2cNyRcK3lxZMnyf14mo2IPzRh/IFzmJfodtBx8lgrCX0rd/kKvwN1d1SLsMfazndZ+z4C8iuA5xfJ7FwpbiD/5nlkDN6sMcSMr9vZJyyzAxuUhWB0oqN+G0wIUdZgs2tErgOa0W2/vLsatMLisT8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sz47unz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sz47unz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385E1C4CEE7;
	Wed,  4 Jun 2025 10:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749033374;
	bh=PwHv4l1E4QBBgZQgPVj1FI81thF5hicHpJY7/85lMx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sz47unz3A1X378Afgfv2K2iBgJTzDgYkSAZtt2UX0Ru1CoDfRyS04HqObPMBVXNvB
	 wY3LlhWmTaOrRIKJMvy1jS5gPBcP9o+e9DAlb5CguYzDQdjiSVuag6/w+0S8Dlzm7d
	 5VfI4OJL0VVQLYsRGRp7Ze2VdSKeL3dyPCcdgzc0=
Date: Wed, 4 Jun 2025 12:36:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <2025060419-gloomily-exclusive-dc3c@gregkh>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
 <20250603203337.GA109929@francesco-nb>
 <2025060408-concur-bubbly-04ea@gregkh>
 <20250604102352.GB31115@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604102352.GB31115@francesco-nb>

On Wed, Jun 04, 2025 at 12:23:52PM +0200, Francesco Dolcini wrote:
> On Wed, Jun 04, 2025 at 10:39:09AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jun 03, 2025 at 10:33:54PM +0200, Francesco Dolcini wrote:
> > > Hello Greg, Sasha
> > > 
> > > On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Jeff Chen <jeff.chen_1@nxp.com>
> > > > 
> > > > [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> > > > 
> > > > This patch addresses an issue where, despite the AP supporting 40MHz
> > > > bandwidth, the connection was limited to 20MHz. Without this fix,
> > > > even if the access point supports 40MHz, the bandwidth after
> > > > connection remains at 20MHz. This issue is not a regression.
> > > > 
> > > > Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> > > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > > Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > 
> > > Can you please drop this patch from any additional stable kernel update?
> > > It seems that on 6.12.y it introduced a regression, we are currently
> > > investigating it and we'll eventually send a revert for 6.12.y.
> > 
> > This is already in the following released kernels:
> > 	6.12.31 6.14.9 6.15
> > I'll be glad to queue up the revert when it hits Linus's tree.  Is that
> > planned anytime soon?
> 
> mainline is not affected, the issues seems specific of the backport on
> 6.12 (6.14 not tested yet), therefore I do not expect any revert in
> Linus tree.

So 6.15 is not an issue either?

> I am looking into the details now, to be sure about my finding, I'll
> confirm you in the next few days.
> 
> If you prefer to not wait, given that this fix was just improving the
> performance of a specific use case, you can just revert from 6.12.y and
> 6.14.y.

And 6.15?  I'd prefer if you submit the revert as that way it can
contain the relevant information about why the revert is only needed
in the stable kernel(s) and not also in Linus's tree.

thanks,

greg k-h
