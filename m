Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC132306B3E;
	Fri,  5 Sep 2025 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084153; cv=none; b=ole/Tw04teg6VbvsOPQcS7cjF30osNeJR7wT52jw7kMAzyQiD7gJqOnzpgWv3SnbeopJB+akiPiXqoYr9q1T6RfRdG2rJrbyb0BGfwk+pFepp2dkEEE0DwFMDSMQQeUMDd9StsEigGWjSoSW+Gs0dvVYn7/hshqlqhRoj7PkKG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084153; c=relaxed/simple;
	bh=I7ml6xJZ4Om5HnN19piLwI7G8H+aa9i/WG4hvv15vl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzpJjOx7Kxjnl9Q1W1rLViWtglxCyhqlgT93fD2dBWsXkBDOSR24qY0mhX0w4nVotsftvJ34prSIpYlgh3h6HTkLdtkKpz8ZQ3xDy0OPJ668xXTWA1B9ocwFAskUkDPEuNzhRqo+Lxxe7kl6SLjp8bM89AFpJqneBMlqW11fchg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwGf4Hg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwGf4Hg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6928C4CEF1;
	Fri,  5 Sep 2025 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757084153;
	bh=I7ml6xJZ4Om5HnN19piLwI7G8H+aa9i/WG4hvv15vl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uwGf4Hg/a1jC+V9Fs3rFsNph9GmL1uuDo/ajy9VYUeOmwlmDGYl2LiiHK3Wzjzh6+
	 lmT3Fa+injfqpAQSa37baIuL9Wrqo/XG/lixYWVwkswCj6Eld0NqyqUmP89A/j4faB
	 cwstGDfkKtIcPLQnoanec9S5am+9eh3kMD1abD1k=
Date: Fri, 5 Sep 2025 16:55:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 139/142] Revert "drm/dp: Change AUX DPCD probe
 address from DPCD_REV to LANE0_1_STATUS"
Message-ID: <2025090530-germicide-protozoan-8d0b@gregkh>
References: <20250902131948.154194162@linuxfoundation.org>
 <20250902131953.603872091@linuxfoundation.org>
 <aLoJG4Tq4nNwFLu6@ideak-desk>
 <2025090551-setup-crescent-a670@gregkh>
 <aLrpfoemc6jCFNVO@ideak-desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLrpfoemc6jCFNVO@ideak-desk>

On Fri, Sep 05, 2025 at 04:45:34PM +0300, Imre Deak wrote:
> On Fri, Sep 05, 2025 at 07:07:40AM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Sep 05, 2025 at 12:48:11AM +0300, Imre Deak wrote:
> > > Hi Greg,
> > > 
> > > On Tue, Sep 02, 2025 at 03:20:41PM +0200, Greg Kroah-Hartman wrote:
> > > > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > Thanks for queuing this and the corresponding reverts for the other
> > > stable trees. This one patch doesn't match what I sent, the address
> > > should be changed to DP_TRAINING_PATTERN_SET not to DP_DPCD_REV, see
> > > [1]. I still think that's the correct thing to do here conforming to the
> > > DP Standard and matching what the upstream kernel does, also solving a
> > > link training issue for a DP2.0 docking station.
> > > 
> > > The reverts queued for the other stable trees are correct, since for
> > > now I do not want to change the behavior in those (i.e. those trees
> > > should continue to use the DP_DPCD_REV register matching what's been the
> > > case since the DPCD probing was introduced).
> > 
> > Ick, why were the values different for different branches? That feels
> > wrong, and is why I missed that.
> 
> The requirement for changing the DPCD probe address was only
> introduced/clarified by a recent DP Standard version (with the
> introducation of LTTPR / UHBR link rates), so in the DRM code this got
> changed only in v6.16.0. However, this change revealed a bug in the
> firmwares of an eDP panel and Thunderbolt host, which also had to be
> fixed/worked around. The only such remaining issue is the latter one
> tracked at [1], which is now fixed by [2].
> 
> Based on all the above I still would like to keep the change only in the
> v6.16 tree and not backport it to earlier stable trees, until having
> more confidence that the change doesn't cause an issue for any sink
> device.
> 
> > Can you just send a fix-up patch for the one I got wrong?
> 
> Ok, I can send a patch for v6.16.y on top of what is already queued
> there.

It's already in a release :)

thanks,

greg k-h
