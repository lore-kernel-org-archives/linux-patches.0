Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF9228E5F4;
	Wed,  4 Jun 2025 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749043725; cv=none; b=jV1eo7FYJXf9LPW7dlM1mIchBHJ7OmnZM7YdBjS/1aHwsVao7/1dpF/FS1MQTOjA3bRn/VYr6myx9dldYMbYeErZwC4Sw6nSqIZVbzav3AWGLiXhbO8bR63m+DTJBjZcETnJcnqXZRASr8mkEv12IYOhLKJyuUA9eCTy/Y82xyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749043725; c=relaxed/simple;
	bh=EtYNXrwdjeQMy5hhXvDN/L4Y98+z7ZeKJjwYdpvwtS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3XnwpSrROMbVFqvEdN8mYoCQ3BRCr1ovCsC7jpzdWLAREeiYDerdf7fYzimHU2vUsV58EFGd6uh1PGlww1mwfIGBL/qQd/nsyKebjW7GgyDX4illTPfLtl1oI701xRn2EbcFqojJPGBo8e2FJsAdlE9jxjnxHQjgHBDWRKJ2DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+MWY6uP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+MWY6uP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1524C4CEE7;
	Wed,  4 Jun 2025 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749043725;
	bh=EtYNXrwdjeQMy5hhXvDN/L4Y98+z7ZeKJjwYdpvwtS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+MWY6uPm2sV7U6/G78GX0MVVufjul6GtlgGc/tW+junQz3A49bZD/XqQljSUEI8e
	 tSa8CrOAQnY9H38VHesjYxnSK1S5vxA+4g1uKJhFGwD/+gTpGodObmQ5CKgy/DQMtB
	 xQInpk/o9C8kUmEXifUkn3gmR9mdgS1tVNJWALTA=
Date: Wed, 4 Jun 2025 15:28:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <2025060427-putdown-rumble-fefb@gregkh>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
 <20250603203337.GA109929@francesco-nb>
 <2025060408-concur-bubbly-04ea@gregkh>
 <20250604102352.GB31115@francesco-nb>
 <2025060419-gloomily-exclusive-dc3c@gregkh>
 <20250604131724.GA273097@francesco-nb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604131724.GA273097@francesco-nb>

On Wed, Jun 04, 2025 at 03:17:24PM +0200, Francesco Dolcini wrote:
> On Wed, Jun 04, 2025 at 12:36:12PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 04, 2025 at 12:23:52PM +0200, Francesco Dolcini wrote:
> > > On Wed, Jun 04, 2025 at 10:39:09AM +0200, Greg Kroah-Hartman wrote:
> > > > On Tue, Jun 03, 2025 at 10:33:54PM +0200, Francesco Dolcini wrote:
> > > > > Hello Greg, Sasha
> > > > > 
> > > > > On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> > > > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > > > 
> > > > > > ------------------
> > > > > > 
> > > > > > From: Jeff Chen <jeff.chen_1@nxp.com>
> > > > > > 
> > > > > > [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> > > > > > 
> > > > > > This patch addresses an issue where, despite the AP supporting 40MHz
> > > > > > bandwidth, the connection was limited to 20MHz. Without this fix,
> > > > > > even if the access point supports 40MHz, the bandwidth after
> > > > > > connection remains at 20MHz. This issue is not a regression.
> > > > > > 
> > > > > > Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> > > > > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > > > > Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> > > > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > 
> > > > > Can you please drop this patch from any additional stable kernel update?
> > > > > It seems that on 6.12.y it introduced a regression, we are currently
> > > > > investigating it and we'll eventually send a revert for 6.12.y.
> > > > 
> > > > This is already in the following released kernels:
> > > > 	6.12.31 6.14.9 6.15
> > > > I'll be glad to queue up the revert when it hits Linus's tree.  Is that
> > > > planned anytime soon?
> > > 
> > > mainline is not affected, the issues seems specific of the backport on
> > > 6.12 (6.14 not tested yet), therefore I do not expect any revert in
> > > Linus tree.
> > 
> > So 6.15 is not an issue either?
> > 
> > > I am looking into the details now, to be sure about my finding, I'll
> > > confirm you in the next few days.
> > > 
> > > If you prefer to not wait, given that this fix was just improving the
> > > performance of a specific use case, you can just revert from 6.12.y and
> > > 6.14.y.
> > 
> > And 6.15?  I'd prefer if you submit the revert as that way it can
> > contain the relevant information about why the revert is only needed
> > in the stable kernel(s) and not also in Linus's tree.
> 
> After more testing I can say that this commit is just broken on
> every tree, I'll send a revert to mainline soon, and after that you
> should get it like any other fix.

Make sure to have a cc: stable on it so that we do get it properly :)

thanks,

greg k-h
