Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0893D3B8;
	Tue, 24 Jun 2025 10:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750759479; cv=none; b=iXVa/o0MghuUbk/s1HTbC4nL+IBkdO0BvxyxqtATNOSb1QZXSwWZgH0ZiIjFKEOHOLcL4pieA6uV3MneD4IxFT54i9dsYZt4WaU1zIdTLJtOGu7QfNVFWUH29i+v735YNdypb+wpRVOUTq+xisifMWUOw49u+fEuyMUQWOm7H6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750759479; c=relaxed/simple;
	bh=YMpGGigS+jsJdPAGO1HD/9MIH+SZvb3wRXK0m0I2N4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k9MySFd53npk9ohGxra/fLfQrC6OvwaGpwnZ0PaReKeza5I7ikG/wTalqsfmfGSUegsJiYxXqVRVF9nYw0xTwfSWCdimWv8Qk9mM9wBnC3YiiMM0R51pgp58N1zi0bRTODWratN0Qb+z7Rux/dRBAmr2xamF4+HGjj7OKfF+gTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOZVwjFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOZVwjFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CFDC4CEE3;
	Tue, 24 Jun 2025 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750759477;
	bh=YMpGGigS+jsJdPAGO1HD/9MIH+SZvb3wRXK0m0I2N4Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HOZVwjFVaUbkdH0HaHOG2PS3itUAwe4tBnkCe3BJ0JkCe1+8lrdDkkOj3tD8Xz1tt
	 pCySeDTVkYjcH7UhWRe9ch0NF/OhFpwIQxvnX7nDmB58QU8BW3Ojgn7sOBeWt6n27m
	 G1rlc+vPRh1yI/u1UZ3GugYRZRuZemIGOTiDMDb4=
Date: Tue, 24 Jun 2025 11:04:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>, Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 293/592] drm/amd/display: Fix VUpdate offset
 calculations for dcn401
Message-ID: <2025062419-persuaded-exponent-9751@gregkh>
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130707.344185926@linuxfoundation.org>
 <391fce59-2eaf-42ad-80b1-05142ffa9684@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <391fce59-2eaf-42ad-80b1-05142ffa9684@kernel.org>

On Tue, Jun 24, 2025 at 09:25:11AM +0200, Jiri Slaby wrote:
> On 23. 06. 25, 15:04, Greg Kroah-Hartman wrote:
> > 6.15-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Dillon Varone <dillon.varone@amd.com>
> > 
> > [ Upstream commit fe45e2af4a22e569b35b7f45eb9f040f6fbef94f ]
> > 
> > [WHY&HOW]
> > DCN401 uses a different structure to store the VStartup offset used to
> > calculate the VUpdate position, so adjust the calculations to use this
> > value.
> 
> This one was reverted upstream by:
> commit 0fc9635a801f6ba3a03ad2de6d46f4f3e2fdfed6
> Author: Dillon Varone <Dillon.Varone@amd.com>
> Date:   Fri Mar 28 12:56:39 2025 -0400
> 
>     Revert "drm/amd/display: Fix VUpdate offset calculations for dcn401"
> 
>     This reverts commit fe45e2af4a22e569b35b7f45eb9f040f6fbef94f.
> 
>     Reason for revert: it causes stuttering in some usecases.
> 

Thanks for pointing it out, now applied.

greg k-h
